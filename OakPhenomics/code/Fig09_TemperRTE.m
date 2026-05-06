clc; clear;

Path_Figure  = '../figure/';
Path_RTEPHE2TMN ='../output/14_RTEPHE2TMN/';

load([Path_RTEPHE2TMN,'RTEPHE2TMN_A20072012.mat']);

%% Que --- LU

YearCode = {'2007','2008','2009','2010','2011','2012'};
Color = [   0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333,0.1843,0.2078;
            0.8039 0.7176 0.6196];
           
QueLUAvg = nanmean(QueLUmn,3);
QueLCAvg = nanmean(QueLCmn,3);
QueGSLAvg = nanmean(QueGSLmn,3);


Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[110 90 420 420]);box on;hold on;


for I_Year=1:numel(YearCode)

    XData=QueLUmn(3,:,I_Year);
    YData=QueLUmn(1,:,I_Year);
    ZData=QueLUmn(2,:,I_Year);
   
    XData1=QueLUmn(6,:,I_Year);
    YData1=QueLUmn(4,:,I_Year);
    ZData1=QueLUmn(5,:,I_Year);
    
    XData2=QueLUmn(9,:,I_Year);
    YData2=QueLUmn(7,:,I_Year);
    ZData2=QueLUmn(8,:,I_Year);

  H(I_Year)  = scatter(XData(:),  YData(:), 80, 'o', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H1(I_Year) = scatter(XData1(:), YData1(:), 80, '^', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H2(I_Year) = scatter(XData2(:), YData2(:), 80, 's', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

    p = polyfit(XData,YData,1);  
    SlopeLU(I_Year,1) = round(p(1,1),2); 
    R2LU(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeLU1(I_Year,1) = round(p1(1,1),2); 
    R2LU1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PLU1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeLU2(I_Year,1) = round(p2(1,1),2); 
    R2LU2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PLU2(I_Year,1) = TP;
    
end
    SlopeLU4 = nanmean([SlopeLU,SlopeLU1,SlopeLU2],2); 
    StdSlopeLU = nanstd(SlopeLU4); 

% Slope  
YRTE1 = QueLUAvg(1,:);
YRTE2 = QueLUAvg(4,:);
YRTE3 = QueLUAvg(7,:);
XRTETmn = QueLUAvg(3,:); 
ZSTD1 = QueLUAvg(2,:);
ZSTD2 = QueLUAvg(5,:);
ZSTD3 = QueLUAvg(8,:);
YRTE = nanmean([YRTE1;YRTE2;YRTE3],1);

    mdl = fitlm(XRTETmn,YRTE);  % 拟合线性模型
    disp(mdl); 

  % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(XRTETmn), max(XRTETmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % RTE1

    mdl1 = fitlm(XRTETmn,YRTE1);  % 拟合线性模型
   

    R2 = mdl1.Rsquared.Ordinary;  
    Pvalue = mdl1.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl1.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.4, 0.9, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    % RTE2

    mdl2 = fitlm(XRTETmn,YRTE2);  % 拟合线性模型
   
    R2 = mdl2.Rsquared.Ordinary;  
    Pvalue = mdl2.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl2.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.83, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

      
    % RTE3

    mdl3 = fitlm(XRTETmn,YRTE3);  % 拟合线性模型
   
    R2 = mdl3.Rsquared.Ordinary;  
    Pvalue = mdl3.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl3.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.76, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
   
set(gca,'xlim',[0 15],'ylim',[70 180],'xtick',1:4:15,'Fontsize',20,'ytick',80:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean spring Ta of planting sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueVETmn.tif']);close(Fig);

% Que-- LC
Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[110 90 420 420]);box on;hold on;

for I_Year=1:numel(YearCode)

    XData=QueLCmn(3,:,I_Year);
    YData=QueLCmn(1,:,I_Year);
    ZData=QueLCmn(2,:,I_Year);
    
    XData1=QueLCmn(6,:,I_Year);
    YData1=QueLCmn(4,:,I_Year);
    ZData1=QueLCmn(5,:,I_Year);
    
    XData2=QueLCmn(9,:,I_Year);
    YData2=QueLCmn(7,:,I_Year);
    ZData2=QueLCmn(8,:,I_Year);

  H(I_Year)  = scatter(XData(:),  YData(:), 80, 'o', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H1(I_Year) = scatter(XData1(:), YData1(:), 80, '^', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H2(I_Year) = scatter(XData2(:), YData2(:), 80, 's', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

    p = polyfit(XData,YData,1);  
    SlopeLC(I_Year,1) = round(p(1,1),2); 
    R2LC(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeLC1(I_Year,1) = round(p1(1,1),2); 
    R2LC1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PLC1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeLC2(I_Year,1) = round(p2(1,1),2); 
    R2LC2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PLC2(I_Year,1) = TP;    
    
end
        SlopeLC4 = nanmean([SlopeLC,SlopeLC1,SlopeLC2],2); 
        StdSlopeLC = nanstd(SlopeLC4); 

YRTE1 = QueLCAvg(1,:);
YRTE2 = QueLCAvg(4,:);
YRTE3 = QueLCAvg(7,:);
XRTETmn = QueLCAvg(3,:); 
ZSTD1 = QueLCAvg(2,:);
ZSTD2 = QueLCAvg(5,:);
ZSTD3 = QueLCAvg(8,:);
YRTE = nanmean([YRTE1;YRTE2;YRTE3],1);


    mdl = fitlm(XRTETmn,YRTE);  % 拟合线性模型
    disp(mdl); 

  % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(XRTETmn), max(XRTETmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % RTE1

    mdl1 = fitlm(XRTETmn,YRTE1);  % 拟合线性模型
   

    R2 = mdl1.Rsquared.Ordinary;  
    Pvalue = mdl1.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl1.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.4, 0.9, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    % RTE2

    mdl2 = fitlm(XRTETmn,YRTE2);  % 拟合线性模型
   
    R2 = mdl2.Rsquared.Ordinary;  
    Pvalue = mdl2.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl2.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.83, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

      
    % RTE3

    mdl3 = fitlm(XRTETmn,YRTE3);  % 拟合线性模型
   
    R2 = mdl3.Rsquared.Ordinary;  
    Pvalue = mdl3.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl3.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.76, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
set(gca,'xlim',[4 16],'ylim',[240 340],'xtick',4:4:18,'Fontsize',20,'ytick',220:20:360,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean autumn Ta of planting sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueVETmn.tif']);close(Fig);




% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[110 90 420 420]);box on;hold on;

for I_Year=1:numel(YearCode)

    XData=QueGSLmn(3,:,I_Year);
    YData=QueGSLmn(1,:,I_Year);
    ZData=QueGSLmn(2,:,I_Year);
           
H(I_Year)  = scatter(XData(:),  YData(:), 80, 'o', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H1(I_Year) = scatter(XData1(:), YData1(:), 80, '^', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

H2(I_Year) = scatter(XData2(:), YData2(:), 80, 's', ...
    'MarkerFaceColor', Color(I_Year,:), ...
    'MarkerEdgeColor', Color(I_Year,:), ...
    'LineWidth', 1.5); hold on;

    XData1=QueGSLmn(6,:,I_Year);
    YData1=QueGSLmn(4,:,I_Year);
    ZData1=QueGSLmn(5,:,I_Year);
    
    XData2=QueGSLmn(9,:,I_Year);
    YData2=QueGSLmn(7,:,I_Year);
    ZData2=QueGSLmn(8,:,I_Year);


    p = polyfit(XData,YData,1);  
    SlopeGSL(I_Year,1) = round(p(1,1),2); 
    R2GSL(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PGSL(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeGSL1(I_Year,1) = round(p1(1,1),2); 
    R2GSL1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PGSL1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeGSL2(I_Year,1) = round(p2(1,1),2); 
    R2GSL2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PGSL2(I_Year,1) = TP;  
end
    SlopeGSL4 = nanmean([SlopeGSL,SlopeGSL1,SlopeGSL2],2); 
    StdSlopeGSL = nanstd(SlopeGSL4); 

YRTE1 = QueGSLAvg(1,:);
YRTE2 = QueGSLAvg(4,:);
YRTE3 = QueGSLAvg(7,:);
XRTETmn = QueGSLAvg(3,:); 
ZSTD1 = QueGSLAvg(2,:);
ZSTD2 = QueGSLAvg(5,:);
ZSTD3 = QueGSLAvg(8,:);
YRTE = nanmean([YRTE1;YRTE2;YRTE3],1);
    
    mdl = fitlm(XRTETmn,YRTE);  % 拟合线性模型
    disp(mdl); 

  % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(XRTETmn), max(XRTETmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制置信区间阴影
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % RTE1

    mdl1 = fitlm(XRTETmn,YRTE1);  % 拟合线性模型
   

    R2 = mdl1.Rsquared.Ordinary;  
    Pvalue = mdl1.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl1.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.001
        p_text = 'p < 0.001';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end
    
    % 在图中显示（两行）
    text(0.4, 0.9, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    
    % RTE2

    mdl2 = fitlm(XRTETmn,YRTE2);  % 拟合线性模型
   
    R2 = mdl2.Rsquared.Ordinary;  
    Pvalue = mdl2.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl2.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.05
        p_text = 'p < 0.05';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.83, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

      
    % RTE3

    mdl3 = fitlm(XRTETmn,YRTE3);  % 拟合线性模型
   
    R2 = mdl3.Rsquared.Ordinary;  
    Pvalue = mdl3.Coefficients.pValue(2);  % 斜率对应的 p 值
    Slope = mdl3.Coefficients.Estimate(2);  

    % 格式化 P 值
    if Pvalue < 0.05
        p_text = 'p < 0.05';
    elseif Pvalue < 0.01
        p_text = 'p < 0.01';
    else
        p_text = sprintf('p = %.3f', Pvalue);
    end

   text(0.4, 0.76, [sprintf('Slope = %.2f', Slope), ',',p_text],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

set(gca,'xlim',[4 16],'ylim',[100 250],'xtick',4:4:16,'Fontsize',20,'ytick',100:30:250,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean annual Ta of planting sites (°C) '],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLQueVETmn.tif']);close(Fig);


%% combine
% Fig1=imread([Path_Figure,'LUQueVETmn.tif']);
% Fig2=imread([Path_Figure,'LCQueVETmn.tif']);
% Fig3=imread([Path_Figure,'GSLQueVETmn.tif']);
% 
% Fig=cat(1,cat(2,Fig1),cat(2,Fig2),cat(2,Fig3));
% Fig=imresize(Fig,2244/size(Fig,2));
% imwrite(Fig,[Path_Figure,'QueVETmn.tif'],'Compression','LZW','Resolution',300);
% 
% delete([Path_Figure,'LUQueVETmn.tif']);
% delete([Path_Figure,'LCQueVETmn.tif']);
% delete([Path_Figure,'GSLQueVETmn.tif']);

% YearCode = {'2007','2008','2009','2010','2011','2012'};
% Color = [   0.8820 0.7450 0.9020;
%             1.0000 0.7960 0.4390;
%             0.9720 0.6580 0.6310;
%             0.7450 0.1530 0.2080;
%             0.9333,0.1843,0.2078;
%             0.8039 0.7176 0.6196];
% 
% 
% Fig=figure;set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',20);
% set(gca,'Units','Pixels','Position',[60 90 420 420]);box on;hold on;
% 
% 
% for I_Year=1:numel(YearCode)
% 
%     XData=FagLUmn(3,:,I_Year);
%     YData=FagLUmn(1,:,I_Year);
%     ZData=FagLUmn(2,:,I_Year);
%    
%     XData1=FagLUmn(6,:,I_Year);
%     YData1=FagLUmn(4,:,I_Year);
%     ZData1=FagLUmn(5,:,I_Year);
%     
%     XData2=FagLUmn(9,:,I_Year);
%     YData2=FagLUmn(7,:,I_Year);
%     ZData2=FagLUmn(8,:,I_Year);
% 
% %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
%     H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'-o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'-^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'-s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
% 
% end
% %     H = plot(XData(:),YData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
% %     H1 = plot(XData1(:),YData1(:),'^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);
% %     H2 = plot(XData2(:),YData2(:),'s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);
%     
% set(gca,'xlim',[4 16],'ylim',[80 180],'xtick',4:4:16,'Fontsize',20,'ytick',80:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
% ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% xlabel(['Temperature (℃)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String',' Fagus sylvatica with Gap ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% 
% pause(5); set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',14);  
% 
% print(Fig,'-dtiff','-r300',[Path_Figure,'LUFagGapVE.tif']);close(Fig);
% 
% % Fag-- LC
% 
% Fig=figure;set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',20);
% set(gca,'Units','Pixels','Position',[60 90 420 420]);box on;hold on; 
% 
% for I_Year=1:numel(YearCode)
% 
%     XData=FagLCmn(3,:,I_Year);
%     YData=FagLCmn(1,:,I_Year);
%     ZData=FagLCmn(2,:,I_Year);
%     
%    H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
%    
%     XData1=FagLCmn(6,:,I_Year);
%     YData1=FagLCmn(4,:,I_Year);
%     ZData1=FagLCmn(5,:,I_Year);
%     
%     XData2=FagLCmn(9,:,I_Year);
%     YData2=FagLCmn(7,:,I_Year);
%     ZData2=FagLCmn(8,:,I_Year);
% 
% %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
%     H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'-o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'-^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'-s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
% 
% end
% 
% set(gca,'xlim',[4 16],'ylim',[220 350],'xtick',4:4:16,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
% ylabel(['Senecence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% xlabel(['Temperature (℃)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String',' Fagus sylvatica ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% pause(5); set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',14);  
% 
% print(Fig,'-dtiff','-r300',[Path_Figure,'LCFagGapVE.tif']);close(Fig);
% 
% % GSL
% 
% Fig=figure;set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',20);
% set(gca,'Units','Pixels','Position',[60 90 420 420]);box on;hold on;
% 
% for I_Year=1:numel(YearCode)
% 
%     XData=FagGSLmn(3,:,I_Year);
%     YData=FagGSLmn(1,:,I_Year);
%     ZData=FagGSLmn(2,:,I_Year);
%            
% %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
%    
%     XData1=FagGSLmn(6,:,I_Year);
%     YData1=FagGSLmn(4,:,I_Year);
%     ZData1=FagGSLmn(5,:,I_Year);
%     
%     XData2=FagGSLmn(9,:,I_Year);
%     YData2=FagGSLmn(7,:,I_Year);
%     ZData2=FagGSLmn(8,:,I_Year);
% 
% %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
%     H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'-o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'-^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'-s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
% 
% 
% end
% 
% set(gca,'xlim',[4 16],'ylim',[80 270],'xtick',4:4:16,'Fontsize',20,'ytick',80:30:270,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
% ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% xlabel(['Temperature (℃)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String','Fagus sylvatica  ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% pause(5); set(gcf,'position',[100 100 550 550],'defaultAxesFontSize',14);  
% 
% print(Fig,'-dtiff','-r300',[Path_Figure,'GSLFagGapVE.tif']);close(Fig);
