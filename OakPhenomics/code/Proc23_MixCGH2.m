clc; clear;

Path_MixLMod = '../output/18_MixLModCG/';
Path_MixModSlope = '../output/23_MixCGH2/';

if ~exist(Path_MixModSlope, 'dir')
    mkdir(Path_MixModSlope);
end

load([Path_MixLMod, 'MixModCG.A20142018.mat']);
load([Path_MixLMod, 'MixModCGTmn.A20142018.mat']);

% 构建表格
Table = table(CGLU, CGLC, CGGSL, CGYTmn, CGATmn, CGSTmn, ...
              CGYear, CGBloc, CGID, CGProv, CGMother);

Table.CGYear = categorical(Table.CGYear);
Table.CGBloc = categorical(Table.CGBloc);
Table.CGID   = categorical(Table.CGID);
Table.CGProv = categorical(Table.CGProv);
Table.CGMother = categorical(Table.CGMother);

Table = rmmissing(Table);

disp(['数据行数: ', num2str(height(Table))]);
disp(['种源数量: ', num2str(length(unique(Table.CGProv)))]);
disp(['家系(Mother)数量: ', num2str(length(unique(Table.CGMother)))]);
disp(['个体(ID)数量: ', num2str(length(unique(Table.CGID)))]);

% =========================================================
% 修正后的遗传力计算函数
% =========================================================
function [h2, se_h2, var_A, var_total, model, varTable] = estimateHeritability(data, traitName, traitCol, tempCol)
    
    % 修正：正确的嵌套语法 + 保留种源主效应
    % (1|CGProv) + (1|CGProv:CGMother) 表示 Mother 嵌套在 Prov 内
    formula = sprintf('%s ~ 1 + %s + (1|CGProv) + (1|CGProv:CGMother) + (1|CGID) + (1|CGBloc) + (1|CGYear)', ...
        traitCol, tempCol);
    
    fprintf('\n===== 计算 %s 的遗传力（修正模型）=====\n', traitName);
    fprintf('模型公式: %s\n', formula);
    
    model = fitlme(data, formula);
    
    % 动态提取方差组分
    [~, ~, stats] = covarianceParameters(model);
    
    var_prov = 0;
    var_mother_nested = 0;
    var_ID = 0;
    var_block = 0;
    var_year = 0;
    
    for i = 1:length(stats)
        groupName = stats{i}.Group;
        variance = stats{i}.Estimate;
        
        switch groupName
            case 'CGProv'
                var_prov = variance;
            case 'CGProv:CGMother'
                var_mother_nested = variance;
            case 'CGID'
                var_ID = variance;
            case 'CGBloc'
                var_block = variance;
            case 'CGYear'
                var_year = variance;
        end
    end
    
    var_res = model.MSE;
    
    % 固定效应方差
    y_fixed = predict(model, data, 'Conditional', false);
    var_fixed = var(y_fixed);
    
    % 总表型方差
    var_total = var_prov + var_mother_nested + var_ID + var_block + var_year + var_fixed + var_res;
    
    % 加性遗传方差（半同胞）
    var_A = 4 * var_mother_nested;
    
    % 狭义遗传力
    h2 = var_A / var_total;
    
    % 限制 h2 在 [0, 1] 范围内
    h2 = max(0, min(1, h2));
    
    % 近似标准误
    se_h2 = sqrt(2) * (var_mother_nested / var_total);
    
    varTable = table(...
        {traitName}, ...
        var_prov,   var_prov/var_total, ...
        var_mother_nested, var_mother_nested/var_total, ...
        var_A,      var_A/var_total, ...
        var_ID,     var_ID/var_total, ...
        var_block,  var_block/var_total, ...
        var_year,   var_year/var_total, ...
        var_fixed,  var_fixed/var_total, ...
        var_res,    var_res/var_total, ...
        'VariableNames', {'Trait', ...
        'Var_Prov', 'Prop_Prov', ...
        'Var_Mother_Nested', 'Prop_Mother', ...
        'Var_Additive', 'Prop_Additive', ...
        'Var_ID', 'Prop_ID', ...
        'Var_Block', 'Prop_Block', ...
        'Var_Year', 'Prop_Year', ...
        'Var_Fixed', 'Prop_Fixed', ...
        'Var_Residual', 'Prop_Residual'});
    
    fprintf('\n===== 方差组分（修正模型）=====\n');
    fprintf('种源方差(Prov):           %.4f (%.2f%%)\n', var_prov, var_prov/var_total*100);
    fprintf('种源内家系方差(Mother):   %.4f (%.2f%%)\n', var_mother_nested, var_mother_nested/var_total*100);
    fprintf('加性遗传方差(σ²_A):       %.4f (%.2f%%)\n', var_A, var_A/var_total*100);
    fprintf('个体永久环境方差(ID):     %.4f (%.2f%%)\n', var_ID, var_ID/var_total*100);
    fprintf('区组方差(Block):          %.4f (%.2f%%)\n', var_block, var_block/var_total*100);
    fprintf('年份方差(Year):           %.4f (%.2f%%)\n', var_year, var_year/var_total*100);
    fprintf('固定效应方差(温度):       %.4f (%.2f%%)\n', var_fixed, var_fixed/var_total*100);
    fprintf('残差方差(Residual):       %.4f (%.2f%%)\n', var_res, var_res/var_total*100);
    fprintf('总表型方差:               %.4f\n', var_total);
    fprintf('\n>>> 狭义遗传力 h² = %.4f (SE ≈ %.4f)\n', h2, se_h2);
end

% =========================================================
% 计算三个性状
% =========================================================
[h2_LU, se_LU, varA_LU, varTotal_LU, model_LU, table_LU] = ...
    estimateHeritability(Table, 'Leaf Unfolding', 'CGLU', 'CGSTmn');

[h2_LC, se_LC, varA_LC, varTotal_LC, model_LC, table_LC] = ...
    estimateHeritability(Table, 'Leaf Senescence', 'CGLC', 'CGATmn');

[h2_GS, se_GS, varA_GS, varTotal_GS, model_GS, table_GS] = ...
    estimateHeritability(Table, 'Growing Season Length', 'CGGSL', 'CGYTmn');

% =========================================================
% 汇总结果
% =========================================================
h2_summary = table(...
    {'Leaf Unfolding'; 'Leaf Senescence'; 'Growing Season Length'}, ...
    [h2_LU; h2_LC; h2_GS], ...
    [se_LU; se_LC; se_GS], ...
    [varA_LU; varA_LC; varA_GS], ...
    [varTotal_LU; varTotal_LC; varTotal_GS], ...
    'VariableNames', {'Trait', 'h2', 'h2_SE', 'Var_Additive', 'Var_Total'});

disp(' ');
disp('==========================================================');
disp('                   遗传力计算结果汇总');
disp('==========================================================');
disp(h2_summary);

save([Path_MixModSlope, 'CG_Heritability_Corrected.mat'], ...
    'h2_summary', 'table_LU', 'table_LC', 'table_GS', ...
    'model_LU', 'model_LC', 'model_GS');

disp(' ');
disp(['结果已保存至: ', Path_MixModSlope, 'CG_Heritability_Corrected.mat']);