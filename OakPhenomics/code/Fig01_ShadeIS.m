addpath(genpath('./'));


clc; clear;

Path_Figure  = '../figure/';
Path_IS01YR4 ='../output/04_IS01YR4/';

%% Que --- LU
load([Path_IS01YR4,strcat('ISmn_QueVP_A20052021.mat')]);
LuzLUmn =QueLUmn(:,1:9,:); 
LuzLCmn =QueLCmn(:,1:9,:);
LuzGSLmn =QueGSLmn(:,1:9,:);

OsaLUmn =QueLUmn(:,10:14,:);
OsaLCmn =QueLCmn(:,10:14,:);
OsaGSLmn =QueGSLmn(:,10:14,:);

YearCode = {'2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'};
% Color = [   0.2980 0.0000 0.4510;
%             0.6900 0.8390 0.9180;
%             0.8820 0.7450 0.9020;
%             1.0000 0.7960 0.4390;
%             0.9720 0.6580 0.6310;
%             0.7450 0.1530 0.2080;
%             0.9333,0.1843,0.2078;
%             0.8039 0.7176 0.6196;
%             0.1800 0.5450 0.3410;
%             0.3880 0.3650 0.6470;
%             0.4509 0.6941 0.8823;
%             0.4117 0.3490 0.8039;
%             0 0.5098 0.5647;
%             0.6627 0.3921 0.5137;
%             0.75686 0.80392 0.75686;
%             0 0.5451 0.5451;
%             0 0 0.5451];
           
Color = [
    % --- 蓝色系 ---
    0.0000, 0.2706, 0.5294;   % 深青蓝（替换深蓝）
    0.2980, 0.0000, 0.4510;   % 靛蓝
    0.3880, 0.3650, 0.6470;   % 蓝紫
    0.4117, 0.3490, 0.8039;   % 紫蓝
    0.4509, 0.6941, 0.8823;   % 天蓝
    0.6900, 0.8390, 0.9180;   % 淡蓝

    % --- 绿色系 ---
    0.0000, 0.5451, 0.5451;   % 青绿
    0.1800, 0.5450, 0.3410;   % 深绿
    0.7569, 0.8039, 0.7569;   % 浅绿灰

    % --- 红色系 ---
    0.7450, 0.1530, 0.2080;   % 深红
    0.9333, 0.1843, 0.2078;   % 鲜红
    0.9720, 0.6580, 0.6310;   % 浅红

    % --- 紫色系 ---
    0.8820, 0.7450, 0.9020;   % 淡紫

    % --- 橙黄色系 ---
    0.8509, 0.5803, 0.1686; 
    1.0000, 0.7960, 0.4390;   % 浅橙黄

    % --- 棕色系 ---
    0.6627, 0.3921, 0.5137;   % 棕紫
    0.6000, 0.3059, 0.2157;   % 深棕红（替换灰棕）
];

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on;


for I_Year=1:numel(YearCode)

    XData=LuzLUmn(3,:,I_Year);
%     XData=[131,387,427,627,803,1082,1235,1349,1630];
    YData=LuzLUmn(1,:,I_Year);
    ZData=LuzLUmn(2,:,I_Year);
    
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);

    SXData=QueLUmn(3,:,I_Year);
%     SXData =[131,387,427,627,803,1082,1235,1349,1630,259,422,841,1194,1614];
    SYData = QueLUmn(1,:,I_Year);
    p = polyfit(SXData,SYData,1);
%     yfit = polyval(p,XData);
%     Slope = plot(XData,yfit,'-','color',Color(I_Year,:),'LineWidth',2);
   
    SlopeLU(I_Year,1) = round(p(1,1),2); 
    R2LU(I_Year,1) = round(rsquare(SXData,SYData),2);
    [Th,TP,TSTATS]=ttest2(SXData,SYData,0.001);    
    PLU(I_Year,1) = TP;
    
end
hold on;


for I_Year=1:numel(YearCode)

    XData=OsaLUmn(3,:,I_Year);
%     XData=[259,422,841,1194,1614];
    YData=OsaLUmn(1,:,I_Year);
    ZData=OsaLUmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);

end

I = ~isnan(SXData) & ~isnan(SYData); 
YEmn = SXData(I); LUmn = SYData(I);

    pIS = polyfit(YEmn,LUmn,1);
    yfitIS = polyval(pIS,YEmn);
    SlopeIS = plot(YEmn,yfitIS,'-k','LineWidth',3);
   [h,SIG,CI,STATS]=ttest2(YEmn,LUmn); 

set(gca,'xlim',[0 1700],'ylim',[80 180],'xtick',0:400:1600,'Fontsize',24,'ytick',80:20:180,'Fontsize',24,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

% Hlegend = legend([H.mainLine],YearCode,'FontWeight','bold','FontSize',18);
% set(Hlegend,'Units','Pixels','Position',[520 280 200 50],'Box','off');


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueIS.tif']);close(Fig);

% Luz-- LC

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on; 

for I_Year=1:numel(YearCode)

%     XData=LuzLCmn(3,:,I_Year);
    XData=[131,387,427,627,803,1082,1235,1349,1630];
    YData=LuzLCmn(1,:,I_Year);
    ZData=LuzLCmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);

%     SXData = QueLCmn(3,:,I_Year);
    SXData =[131,387,427,627,803,1082,1235,1349,1630,259,422,841,1194,1614];
    SYData = QueLCmn(1,:,I_Year);
    p = polyfit(SXData,SYData,1);
    
    SlopeLC(I_Year,1) = round(p(1,1),2); 
    R2LC(I_Year,1) = round(rsquare(SXData,SYData),2);
    [Th,TP,TSTATS]=ttest2(SXData,SYData,0.001);    
    PLC(I_Year,1) = TP;

end
hold on;

for I_Year=1:numel(YearCode)

%     XData=OsaLCmn(3,:,I_Year);
    XData=[259,422,841,1194,1614];
    YData=OsaLCmn(1,:,I_Year);
    ZData=OsaLCmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);

    
end
    SXData =[131,387,427,627,803,1082,1235,1349,1630,259,422,841,1194,1614];
    SYData = nanmean(QueLCmn,3);
    SYData = SYData(1,:);
    
I = ~isnan(SXData) & ~isnan(SYData); 
YEmn = SXData(I); LCmn = SYData(I);

    pIS = polyfit(YEmn,LCmn,1);
    yfitIS = polyval(pIS,YEmn);
    SlopeIS = plot(YEmn,yfitIS,'-k','LineWidth',3);
   [h,SIG,CI,STATS]=ttest2(YEmn,LCmn); 

set(gca,'xlim',[0 1700],'ylim',[220 350],'xtick',0:400:1600,'Fontsize',24,'ytick',220:20:350,'Fontsize',24,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueIS.tif']);close(Fig);

% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 420 420]);box on;hold on;

for I_Year=1:numel(YearCode)

%     XData=LuzGSLmn(3,:,I_Year);
    XData=[131,387,427,627,803,1082,1235,1349,1630];
    YData=LuzGSLmn(1,:,I_Year);
    ZData=LuzGSLmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);

%     SXData = QueGSLmn(3,:,I_Year);
    SXData =[131,387,427,627,803,1082,1235,1349,1630,259,422,841,1194,1614];
    SYData = QueGSLmn(1,:,I_Year);
    p = polyfit(SXData,SYData,1);
    
    SlopeGSL(I_Year,1) = round(p(1,1),2); 
    R2GSL(I_Year,1) = round(rsquare(SXData,SYData),2);
    [Th,TP,TSTATS]=ttest2(SXData,SYData,0.001);    
    PGSL(I_Year,1) = TP;
    
end
hold on;

for I_Year=1:numel(YearCode)

%     XData=OsaGSLmn(3,:,I_Year);
    XData=[259,422,841,1194,1614];
    YData=OsaGSLmn(1,:,I_Year);
    ZData=OsaGSLmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',2);

end

set(gca,'xlim',[0 1700],'ylim',[80 270],'xtick',0:400:1600,'Fontsize',24,'ytick',80:30:270,'Fontsize',24,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',26);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLQueIS.tif']);close(Fig);



