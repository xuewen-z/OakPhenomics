clc; clear;

Path_MixLModRTE ='../output/20_MixModRTE/';
load([Path_MixLModRTE,'MixModRTE.A20072012.mat']);

%===============================
% 构建表
%===============================
Table = table(RTELU,RTELC,RTEGSL,RTEYTmn,RTESTmn,RTEATmn,RTEYear,RTEBloc,RTEIDall,RTEProv,RTESite);

% 转为分类变量
Table.RTEYear  = categorical(Table.RTEYear);
Table.RTEBloc  = categorical(Table.RTEBloc);
Table.RTEIDall = categorical(Table.RTEIDall);
Table.RTEProv  = categorical(Table.RTEProv);
Table.RTESite  = categorical(Table.RTESite);

%===============================
% 额外做 RTE 方差分解模型
% 包含 provenance, site, provenance × site
%===============================
LU_RTE_vp  = fitlme(Table,'RTELU  ~ 1 + RTESTmn + (1|RTEProv) + (1|RTESite) + (1|RTEProv:RTESite) + (1|RTEBloc) + (1|RTEYear) + (1|RTEIDall)');
LC_RTE_vp  = fitlme(Table,'RTELC  ~ 1 + RTEATmn + (1|RTEProv) + (1|RTESite) + (1|RTEProv:RTESite) + (1|RTEBloc) + (1|RTEYear) + (1|RTEIDall)');
GSL_RTE_vp = fitlme(Table,'RTEGSL ~ 1 + RTEYTmn + (1|RTEProv) + (1|RTESite) + (1|RTEProv:RTESite) + (1|RTEBloc) + (1|RTEYear) + (1|RTEIDall)');

%===============================
% 提取各随机项占比
% 顺序严格对应：
% (1|RTEProv) + (1|RTESite) + (1|RTEProv:RTESite) + (1|RTEBloc) + (1|RTEYear) + (1|RTEIDall)
%===============================
[LU_varTable,  LU_summary]  = getRTEVariancePartition(LU_RTE_vp,  'Leaf unfolding');
[LC_varTable,  LC_summary]  = getRTEVariancePartition(LC_RTE_vp,  'Leaf senescence');
[GSL_varTable, GSL_summary] = getRTEVariancePartition(GSL_RTE_vp, 'Growing season length');

disp('===== Variance partition for LU =====');
disp(LU_varTable);
disp('===== Variance partition for LS =====');
disp(LC_varTable);
disp('===== Variance partition for GSL =====');
disp(GSL_varTable);

% 汇总表
RTESummary = table( ...
    {'Leaf unfolding'; 'Leaf senescence'; 'Growing season length'}, ...
    [LU_summary.Prov_Prop; LC_summary.Prov_Prop; GSL_summary.Prov_Prop], ...
    [LU_summary.Site_Prop; LC_summary.Site_Prop; GSL_summary.Site_Prop], ...
    [LU_summary.ProvSite_Prop; LC_summary.ProvSite_Prop; GSL_summary.ProvSite_Prop], ...
    [LU_summary.Block_Prop; LC_summary.Block_Prop; GSL_summary.Block_Prop], ...
    [LU_summary.Year_Prop; LC_summary.Year_Prop; GSL_summary.Year_Prop], ...
    [LU_summary.ID_Prop; LC_summary.ID_Prop; GSL_summary.ID_Prop], ...
    [LU_summary.Residual_Prop; LC_summary.Residual_Prop; GSL_summary.Residual_Prop], ...
    'VariableNames', {'Trait','Prov_Prop','Site_Prop','ProvSite_Prop','Block_Prop','Year_Prop','ID_Prop','Residual_Prop'});

disp('===== RTE variance partition summary =====');
disp(RTESummary);

save('../output/23_MixModSlope/RTE_ProvSiteVariancePartition.mat', ...
    'LU_RTE_vp','LC_RTE_vp','GSL_RTE_vp', ...
    'LU_varTable','LC_varTable','GSL_varTable','RTESummary');

%=========================================================
% 函数：提取 provenance / site / provenance:site / block / year / ID / residual 占比
%=========================================================
function [varTable, out] = getRTEVariancePartition(lmeModel, traitName)

    cp = covarianceParameters(lmeModel);

    % 你的 MATLAB 版本下 cp 是 n×1 cell，每个 cell 是一个数值
    var_prov     = cp{1};
    var_site     = cp{2};
    var_provsite = cp{3};
    var_block    = cp{4};
    var_year     = cp{5};
    var_id       = cp{6};
    var_res      = lmeModel.MSE;

    total_var = var_prov + var_site + var_provsite + var_block + var_year + var_id + var_res;

    out.Prov_Prop     = var_prov     / total_var;
    out.Site_Prop     = var_site     / total_var;
    out.ProvSite_Prop = var_provsite / total_var;
    out.Block_Prop    = var_block    / total_var;
    out.Year_Prop     = var_year     / total_var;
    out.ID_Prop       = var_id       / total_var;
    out.Residual_Prop = var_res      / total_var;

    varTable = table( ...
        string(traitName), ...
        var_prov,     out.Prov_Prop, ...
        var_site,     out.Site_Prop, ...
        var_provsite, out.ProvSite_Prop, ...
        var_block,    out.Block_Prop, ...
        var_year,     out.Year_Prop, ...
        var_id,       out.ID_Prop, ...
        var_res,      out.Residual_Prop, ...
        'VariableNames', { ...
        'Trait', ...
        'Var_Prov','Prov_Prop', ...
        'Var_Site','Site_Prop', ...
        'Var_ProvSite','ProvSite_Prop', ...
        'Var_Block','Block_Prop', ...
        'Var_Year','Year_Prop', ...
        'Var_ID','ID_Prop', ...
        'Var_Residual','Residual_Prop'});
end