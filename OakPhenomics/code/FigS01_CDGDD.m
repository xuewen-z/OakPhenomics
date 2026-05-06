addpath(genpath('./'));


clc; clear;

Path_Figure  = '../figure/';
Path_ISPHE2TMN ='../output/08_ISPHE2TMN/';
Path_ISCGD2TMN ='../output/S01_ISCGDD2TMN/';

%% Que ---  CDD 
load([Path_ISPHE2TMN,'ISPHE2TMN_A20052020.mat']);
load([Path_ISCGD2TMN,'IS_QueCDDGDD_20052020.mat']);

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

    XData=QueCDD(:,I_Year);
    YData=QueLUmn(:,I_Year);
    ZData=QueLUstd(:,I_Year);

    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1); 
    SlopeLU(I_Year,1) = round(p(1,1),2); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;
    %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);

end
    StdSlopeLU = nanstd(SlopeLU); 
    XData = QueCDD(:);
    YData = QueLUmn(:);

    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LUmn = YData(I); 
   

    mdl = fitlm(YTmn, LUmn);  % 拟合线性模型
    disp(mdl); 
       
    Slope = mdl.Coefficients.Estimate(2);  

    % 在图中显示（两行）
    text(0.08, 0.10, [sprintf('Slope = %.2f', Slope),', p<0.001'],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

       % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % 绘制置信区间 (±0.5*CI，如果你只想显示±0.5倍区间)
    plot(xfit, yfit + 0.5*(yci(:,2)-yfit), '--k', 'LineWidth', 1);
    plot(xfit, yfit - 0.5*(yfit - yci(:,1)), '--k', 'LineWidth', 1);



set(gca,'xlim',[0 160],'ylim',[50 180],'xtick',0:50:155,'Fontsize',20,'ytick',60:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Chilling days of sites (days)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

text('String',' a) ',...
    'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',24);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'QueISCDD.tif']);close(Fig);




% GDD

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on;


for I_Year=1:numel(YearCode)

    XData=QueGDD(:,I_Year);
    YData=QueLUmn(:,I_Year);
    ZData=QueLUstd(:,I_Year);

    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1); 
    SlopeLU(I_Year,1) = round(p(1,1),2); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;
    %     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);

end
    StdSlopeLU = nanstd(SlopeLU); 
    XData = QueGDD(:);
    YData = QueLUmn(:);

    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LUmn = YData(I); 
    

    mdl = fitlm(YTmn, LUmn);  % 拟合线性模型
    disp(mdl); 
    Slope = mdl.Coefficients.Estimate(2);  

    % 在图中显示（两行）
    text(0.08, 0.10, [sprintf('Slope = %.2f', Slope),', p<0.001'],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

       % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % 绘制置信区间 (±0.5*CI，如果你只想显示±0.5倍区间)
    plot(xfit, yfit + 0.5*(yci(:,2)-yfit), '--k', 'LineWidth', 1);
    plot(xfit, yfit - 0.5*(yfit - yci(:,1)), '--k', 'LineWidth', 1);


text('String',' b) ',...
    'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',24);

   
set(gca,'xlim',[50 500],'ylim',[50 180],'xtick',100:100:500,'Fontsize',20,'ytick',60:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Growing degree days of sites (°C·days)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'QueISGDD.tif']);close(Fig);



% Que-- LS -- Spring & Summer Tmn

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on; 

for I_Year=1:numel(YearCode)

    XData=QueSTmn(:,I_Year);
    YData=QueLCmn(:,I_Year);
    ZData=QueLCstd(:,I_Year);
    
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1);
    SlopeLC(I_Year,1) = p(1,1); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;

end
    StdSlopeLC = nanstd(SlopeLC); 


    XData = QueSTmn(:);
    YData = QueLCmn(:);
    
    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LCmn = YData(I);

  
    mdl = fitlm(YTmn, LCmn);  % 拟合线性模型
    disp(mdl); 
    Slope = mdl.Coefficients.Estimate(2);  

    % 在图中显示（两行）
    text(0.08, 0.10, [sprintf('Slope = %.2f', Slope),', p<0.001'],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    


    % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % 绘制置信区间 (±0.5*CI，如果你只想显示±0.5倍区间)
    plot(xfit, yfit + 0.5*(yci(:,2)-yfit), '--k', 'LineWidth', 1);
    plot(xfit, yfit - 0.5*(yfit - yci(:,1)), '--k', 'LineWidth', 1);


set(gca,'xlim',[2 14],'ylim',[240 340],'xtick',2:4:15,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean spring Ta of sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

text('String',' c) ',...
    'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',24);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'QueSprTmn.tif']);close(Fig);

% Que-- LS -- Summer Tmn

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on; 

for I_Year=1:numel(YearCode)

    XData=QueSuTmn(:,I_Year);
    YData=QueLCmn(:,I_Year);
    ZData=QueLCstd(:,I_Year);
    
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1);
    SlopeLC(I_Year,1) = p(1,1); 
    R2(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;

end
    StdSlopeLC = nanstd(SlopeLC); 


    XData = QueSuTmn(:);
    YData = QueLCmn(:);
    
    I = ~isnan(XData) & ~isnan(YData); 
    YTmn = XData(I); LCmn = YData(I);

    
    mdl = fitlm(YTmn, LCmn);  % 拟合线性模型
    disp(mdl); 
    Slope = mdl.Coefficients.Estimate(2);  

    % 在图中显示（两行）
    text(0.08, 0.10, [sprintf('Slope = %.2f', Slope),', p<0.001'],...
        'Units','Normalized','FontSize',18, ...
        'FontWeight','bold','FontName','Times New Roman','Color','k');
    

    % 生成平滑的 X 用于画拟合曲线
    xfit = linspace(min(YTmn), max(YTmn), 100)';
    [yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);  % 95%置信区间

    % 绘制拟合线
    plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

    % 绘制置信区间 (±0.5*CI，如果你只想显示±0.5倍区间)
    plot(xfit, yfit + 0.5*(yci(:,2)-yfit), '--k', 'LineWidth', 1);
    plot(xfit, yfit - 0.5*(yfit - yci(:,1)), '--k', 'LineWidth', 1);




set(gca,'xlim',[12 23],'ylim',[240 340],'xtick',10:3:22,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Mean summer Ta of sites (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);



text('String',' d) ',...
    'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',24);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'QueSumerTmn.tif']);close(Fig);




% Union --- Que
Fig1=imread([Path_Figure,'QueISCDD.tif']);
Fig2=imread([Path_Figure,'QueISGDD.tif']);
Fig3=imread([Path_Figure,'QueSprTmn.tif']);
Fig4=imread([Path_Figure,'QueSumerTmn.tif']);

Fig5=cat(1,cat(2,Fig1,Fig2));
Fig6=cat(1,cat(2,Fig3,Fig4));


Fig=cat(1,cat(2,Fig5),cat(2,Fig6));
Fig=imresize(Fig,2244/size(Fig,2));
imwrite(Fig,[Path_Figure,'QueCovereffect.tif'],'Compression','LZW','Resolution',300);

%% Combine

delete([Path_Figure,'QueISCDD.tif']);
delete([Path_Figure,'QueISGDD.tif']);
delete([Path_Figure,'QueSprTmn.tif']);
delete([Path_Figure,'QueSumerTmn.tif']);
