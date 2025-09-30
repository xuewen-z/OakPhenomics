clc; clear;

% 路径
Path_PHE01LV2 ='../output/01_PHE01LV2/';
Path_RTEPHE2TMN ='../output/14_RTEPHE2TMN/';
Path_RTE_ShiftOut = '../output/15c_TreeRTETS/';
mkdir(Path_RTE_ShiftOut);

% 加载数据
load([Path_PHE01LV2,'NormRTE.mat']);  % 包含 TreeLU, LC, GSL, SiteYear, SiteBloc, TreeProv
load([Path_RTEPHE2TMN,'RTEPHE2TMN_A20072012.mat']);  % 包含 QueLUmn, QueLCmn, QueGSLmn

% 年份信息
Years = [2007, 2008, 2010, 2011, 2012];
YearIdx = [1, 2, 3, 4, 5];
NumYears = numel(Years);

% 高程列表
ElevList = [400, 800, 1200];
NumElev = numel(ElevList);

% 初始化结果
LU_Slopes = nan(NumElev, NumYears);
LC_Slopes = nan(NumElev, NumYears);
GSL_Slopes = nan(NumElev, NumYears);

for e = 1:NumElev
    elev = ElevList(e);

    for y = 1:NumYears
        year = Years(y);
        Yidx = YearIdx(y);

        % 找出该高程、该年的所有树
        I_tree = SiteYear == year & TreeProv == elev;
        BlocList = unique(SiteBloc(I_tree));
        NumBloc = numel(BlocList);

        LU_vals = nan(NumBloc,1);
        LC_vals = nan(NumBloc,1);
        GSL_vals = nan(NumBloc,1);
        Ta_vals_LU = nan(NumBloc,1);
        Ta_vals_LC = nan(NumBloc,1);
        Ta_vals_GSL = nan(NumBloc,1);

        for b = 1:NumBloc
            bloc = BlocList(b);
            I = SiteYear == year & TreeProv == elev & SiteBloc == bloc;

            LU_vals(b) = nanmean(TreeLU(I));
            LC_vals(b) = nanmean(TreeLC(I));
            GSL_vals(b) = nanmean(TreeGSL(I));

            % 使用每个地块的温度
            Ta_vals_LU(b) = QueLUmn(bloc, Yidx);
            Ta_vals_LC(b) = QueLCmn(bloc, Yidx);
            Ta_vals_GSL(b) = QueGSLmn(bloc, Yidx);
        end

        % 回归：LU
        valid = ~isnan(Ta_vals_LU) & ~isnan(LU_vals);
        if sum(valid) >= 2
            p = polyfit(Ta_vals_LU(valid), LU_vals(valid), 1);
            LU_Slopes(e,y) = p(1);
        end

        % 回归：LC
        valid = ~isnan(Ta_vals_LC) & ~isnan(LC_vals);
        if sum(valid) >= 2
            p = polyfit(Ta_vals_LC(valid), LC_vals(valid), 1);
            LC_Slopes(e,y) = p(1);
        end

        % 回归：GSL
        valid = ~isnan(Ta_vals_GSL) & ~isnan(GSL_vals);
        if sum(valid) >= 2
            p = polyfit(Ta_vals_GSL(valid), GSL_vals(valid), 1);
            GSL_Slopes(e,y) = p(1);
        end
    end
end


%% 平均和标准差计算
LUmean = nanmean(LU_Slopes, 1);        % 3 个高程的平均（每年）
LUstd  = nanstd(LU_Slopes, 0, 1);      % 标准差（每年）

LCmean = nanmean(LC_Slopes, 1);        % 3 个高程的平均（每年）
LCstd  = nanstd(LC_Slopes, 0, 1);      % 标准差（每年）

GSLmean = nanmean(GSL_Slopes, 1);        % 3 个高程的平均（每年）
GSLstd  = nanstd(GSL_Slopes, 0, 1);      % 标准差（每年）



% 保存
save([Path_RTE_ShiftOut,'RTE_SensitivityTS.mat'], ...
    'Years', 'LUmean','LUstd','LCmean', 'LCstd',...
    'GSLmean','GSLstd');



