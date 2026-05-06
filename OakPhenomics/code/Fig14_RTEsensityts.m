
addpath(genpath('./'));


clc; clear;

Path_Figure  = '../figure/';
Path_RTE_ShiftOut = '../output/15c_TreeRTETS/';


load([Path_RTE_ShiftOut,'RTE_SensitivityTS.mat']);

% Step 3: 可视化时间序列
Fig = figure;
set(gcf, 'Position', [100 100 700 550], 'Color', 'w');

% 设置坐标轴位置与样式
set(gca, 'Units', 'Pixels', 'Position', [120 90 520 420], ...
    'FontSize', 16, 'FontWeight', 'bold', 'LineWidth', 1.5);
box on; hold on;

% ===============================
% 配置颜色和标记样式
colors = {[0.2 0.6 0.9], [0.95 0.6 0.1], [0.2 0.7 0.3]};  % LU, LS, GSL
markers = {'o', 's', '^'};
labels = {'LU', 'LS', 'GSL'};

% ===============================
% 绘制 LU
valid = ~isnan(LUmean);
TsLU = errorbar(Years, LUmean, LUstd, markers{1}, ...
    'Color', colors{1}, 'LineWidth', 1.8, 'MarkerSize', 8, 'CapSize', 6, ...
    'DisplayName', labels{1});
p = polyfit(Years(valid), LUmean(valid), 1);
LU_fit = polyval(p, Years);
plot(Years, LU_fit, '-', 'Color', colors{1}, 'LineWidth', 2);
% 拟合信息输出
mdl = fitlm(Years, LUmean);
disp(mdl);

% ===============================
% 绘制 LS
valid = ~isnan(LCmean);
TsLS = errorbar(Years, LCmean, LCstd, markers{2}, ...
    'Color', colors{2}, 'LineWidth', 1.8, 'MarkerSize', 8, 'CapSize', 6, ...
    'DisplayName', labels{2});
p = polyfit(Years(valid), LCmean(valid), 1);
LC_fit = polyval(p, Years);
plot(Years, LC_fit, '-', 'Color', colors{2}, 'LineWidth', 2);
% 拟合信息输出
mdl = fitlm(Years, LCmean);
disp(mdl);

% ===============================
% 绘制 GSL
valid = ~isnan(GSLmean);
TsGSL = errorbar(Years, GSLmean, GSLstd, markers{3}, ...
    'Color', colors{3}, 'LineWidth', 1.8, 'MarkerSize', 8, 'CapSize', 6, ...
    'DisplayName', labels{3});
p = polyfit(Years(valid), GSLmean(valid), 1);
GSL_fit = polyval(p, Years);
plot(Years, GSL_fit, '-', 'Color', colors{3}, 'LineWidth', 2);
% 拟合信息输出
mdl = fitlm(Years, GSLmean);
disp(mdl);

% ===============================
% 坐标与图形设置
xticks(2007:2012);
xticklabels(string(2007:2012));
ylabel('Ta sensitivity (days/°C)', 'FontWeight', 'bold');
ylim([-0.05 0.05]);
yticks([-0.04:0.02:0.04]);
xlim([2006.5 2012.5]);
xlabel('Year', 'FontWeight', 'bold');

Hlegend = legend([TsLU,TsLS,TsGSL],{'LU','LS','GSL'},'FontSize',12);
set(Hlegend,'Units','Pixels','Position',[360 450 450 10],'Box','off');

box on;
pause(5); set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LURTETS.tif']);close(Fig);

