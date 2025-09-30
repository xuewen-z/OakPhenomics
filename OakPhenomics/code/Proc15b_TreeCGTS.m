
clc;clear;

addpath(genpath('./'));

Path_Figure  = '../figure/';
Path_PHE01LV2 ='../output/01_PHE01LV2/';
Path_CGPHE2TMN ='../output/11_CGPHE2TMN_CG/';
Path_TreeCGTS ='../output/15b_TreeCGTS/';

mkdir(Path_TreeCGTS);

load([Path_PHE01LV2,'NormCG.mat']);
load([Path_CGPHE2TMN,'CG2PHENTMN_A20092019.mat']); % 包含：QueSTmn（春季温度）

% 定义种源代码及对应海拔
ProvCode = {'L1','L3','L8','L12','L16','O1','O4','O8','O12','O16'};

%% --- 分析每年 LU 对温度的敏感性变化（2009–2018） ---

Years = 2009:2018;  % 分析年份
NumYears = numel(Years);
NumProv = numel(ProvCode);

% Step 1: 统计每年每个种源的 LU 均值
TreeCode = unique(SiteTrID);
NumTrees = numel(TreeCode);
TreeLU = nan(NumTrees, 13);  %19 20 nodata
TreeProv = strings(NumTrees,1);

MeanLU = nan(NumProv, NumYears);  % 每年每个种源的平均LU
TempSTmn = QueSTmn(:,1:10);        % 只取2009–2018年（10列）



for iTree = 1:NumTrees
    I_Tree = strcmp(SiteTrID, TreeCode{iTree});
    YearIdx = SiteYear(I_Tree,:) - 2008; % 2009–2021 => 列索引 1–13
    TreeLU(iTree, YearIdx) = SiteLU(I_Tree,:);
    TreeProv(iTree) = unique(SiteProv(I_Tree,:));
end

% 去掉19,20和2021年
TreeLU(:,11:13) = [];

for y = 1:NumYears
    for p = 1:NumProv
        I_prov = strcmp(TreeProv, ProvCode{p});
        LU_year = TreeLU(I_prov, y); % 当前年份，该种源下所有树的LU
        MeanLU(p, y) = nanmean(LU_year);
       
    end
end


% Step 2: 每年拟合 LU vs 温度
LUSlopes = nan(1, NumYears);  % 存储每年的斜率
LUIntercept = nan(1, NumYears); % 可选：截距
R2_values = nan(1, NumYears);   % 可选：拟合优度

TempSTmn = TempSTmn';

for y = 1:NumYears
    X = TempSTmn(:,y);     % 当年每个种源的温度
    Y = MeanLU(:,y);       % 当年每个种源的平均LU

    valid = ~isnan(X) & ~isnan(Y);
    if sum(valid) >= 2
        p = polyfit(X(valid), Y(valid), 1);
        LUSlopes(y) = p(1);        % 斜率
        LUIntercept(y) = p(2);     % 截距
        
        % 可选：拟合优度 R²
        Y_fit = polyval(p, X(valid));
        SS_res = sum((Y(valid) - Y_fit).^2);
        SS_tot = sum((Y(valid) - mean(Y(valid))).^2);
        R2_values(y) = 1 - SS_res / SS_tot;
    end
end

% Step 3: 可视化时间序列
Fig = figure;
set(gcf, 'Position', [100 100 700 550], 'Color', 'w');

% 设置坐标轴位置与样式
set(gca, 'Units', 'Pixels', 'Position', [120 90 520 420], ...
    'FontSize', 16, 'LineWidth', 1.5);
box on; hold on;

% 配色与样式设置
dotColor = [0.2 0.6 0.9];   
fitColor = [0.1, 0.1, 0.1];   

% 绘制散点
plot(Years, LUSlopes, 'o', ...
    'MarkerSize', 10, 'MarkerFaceColor', dotColor, ...
    'MarkerEdgeColor', dotColor, 'LineWidth', 1.8);

% 拟合线性趋势线
p_fit = polyfit(Years, LUSlopes, 1);
y_fit = polyval(p_fit, Years);
plot(Years, y_fit, '--', 'Color', fitColor, 'LineWidth', 2);

% 拟合信息输出
mdl = fitlm(Years, LUSlopes);
disp(mdl);

% 坐标轴与标签
xlabel('Year', 'FontSize', 16);
ylabel('\partial leaf unfolding / \partial Ta (days/°C)', 'FontSize', 16);

% 轴范围设置
ylim([-1.8 -0.6]);
yticks(-1.8:0.4:-0.6);
xlim([2008.5 2018.5]);
xticks(2009:2:2018);
box on;
pause(5); set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUSlopCGTS.tif']);close(Fig);

