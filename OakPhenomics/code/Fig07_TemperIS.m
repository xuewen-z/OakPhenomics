addpath(genpath('./'));


clc; clear;

Path_Figure  = '../figure/';
Path_ISPHE2TMN ='../output/08_ISPHE2TMN/';

%% Que --- LU
load([Path_ISPHE2TMN,'ISPHE2TMN_A20052020.mat']);
% LU 2020 nodata
YearCode = {'2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'};
 
Color = [   0.2980 0.0000 0.4510;
            0.6900 0.8390 0.9180;
            0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333,0.1843,0.2078;
            0.8039 0.7176 0.6196;
            0.1800 0.5450 0.3410;
            0.3880 0.3650 0.6470;
            0.4509 0.6941 0.8823;
            0.4117 0.3490 0.8039;
            0 0.5098 0.5647;
            0.6627 0.3921 0.5137;
            0.75686 0.80392 0.75686;
            0 0.5451 0.5451;
            0 0 0.5451];
                    

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on;


for I_Year=1:numel(YearCode)

    XData=QueSTmn(:,I_Year);
    YData=QueLUmn(:,I_Year);
    ZData=QueLUstd(:,I_Year);

    % H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
      H(I_Year)  = scatter(XData(:), YData(:), 80, 'MarkerFaceColor', Color(I_Year,:), ...
        'MarkerEdgeColor', Color(I_Year,:), 'LineWidth', 1.5);

    p = polyfit(XData,YData,1); 
    SlopeLU(I_Year,1) = round(p(1,1),2); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;
  
end
    StdSlopeLU = nanstd(SlopeLU); 
    XData = QueSTmn(:);
    YData = QueLUmn(:);

    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LUmn = YData(I); 
    
    
    mdl = fitlm(YTmn, LUmn);  % 拟合线性模型
    disp(mdl); 
   
  
    % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;


set(gca,'xlim',[0 15],'ylim',[70 180],'xtick',1:4:15,'Fontsize',20,'ytick',60:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY) '],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean spring Ta of sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

 % 从线性模型提取 R² 和显著性（p 值）
     % 提取 R² 和 p 值
    R2 = mdl.Rsquared.Ordinary;  
    Pvalue = mdl.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.08, 0.18, sprintf('Slope = %.2f', Slope), ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    text(0.08, 0.10, p_text, ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');


% text('String',' a) ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',24);

% Hlegend = legend([H],YearCode,'FontWeight','bold','FontSize',18);
% set(Hlegend,'Units','Pixels','Position',[520 280 200 50],'Box','off');

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueISTmn.tif']);close(Fig);

% Que-- LC

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on; 

for I_Year=1:numel(YearCode)

    XData=QueATmn(:,I_Year);
    YData=QueLCmn(:,I_Year);
    ZData=QueLCstd(:,I_Year);
    
         H(I_Year)  = scatter(XData(:), YData(:), 80, 'MarkerFaceColor', Color(I_Year,:), ...
        'MarkerEdgeColor', Color(I_Year,:), 'LineWidth', 1.5);

    p = polyfit(XData,YData,1);
    SlopeLC(I_Year,1) = p(1,1); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;

end
    StdSlopeLC = nanstd(SlopeLC); 


    XData = QueATmn(:);
    YData = QueLCmn(:);
    
    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LCmn = YData(I);

  
    mdl = fitlm(YTmn, LCmn);  % 拟合线性模型
    disp(mdl); 

    % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;


set(gca,'xlim',[6 18],'ylim',[240 340],'xtick',6:4:18,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean autumn Ta of sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

 % 从线性模型提取 R² 和显著性（p 值）
     % 提取 R² 和 p 值
    R2 = mdl.Rsquared.Ordinary;  
    Pvalue = mdl.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.08, 0.18, sprintf('Slope = %.2f', Slope), ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    text(0.08, 0.10, p_text, ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueISTmn.tif']);close(Fig);

% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on;

for I_Year=1:numel(YearCode)

    XData=QueYTmn(:,I_Year);
    YData=QueGSLmn(:,I_Year);
    ZData=QueGSLstd(:,I_Year);
     
    H(I_Year)  = scatter(XData(:), YData(:), 80, 'MarkerFaceColor', Color(I_Year,:), ...
        'MarkerEdgeColor', Color(I_Year,:), 'LineWidth', 1.5);

    p = polyfit(XData,YData,1);
    SlopeGSL(I_Year,1) = round(p(1,1),2); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData);    
    PGSL(I_Year,1) = TP;
end
    StdSlopeGSL = nanstd(SlopeGSL); 


    XData = QueYTmn(:);
    YData = QueGSLmn(:);
    
    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); GSLmn = YData(I);

   
    mdl = fitlm(YTmn, GSLmn);  % 拟合线性模型
    disp(mdl); 

     % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

set(gca,'xlim',[4 16],'ylim',[100 250],'xtick',0:4:16,'Fontsize',20,'ytick',100:30:250,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean annual Ta of sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

 % 从线性模型提取 R² 和显著性（p 值）
     % 提取 R² 和 p 值
    R2 = mdl.Rsquared.Ordinary;  
    Pvalue = mdl.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.08, 0.18, sprintf('Slope = %.2f', Slope), ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    text(0.08, 0.10, p_text, ...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLQueISTmn.tif']);close(Fig);



