addpath(genpath('./'));


clc; clear;

Path_Figure  = '../figure/';
Path_CG01YR4 ='../output/05_CG01YR4/';

%% Que --- LU
load([Path_CG01YR4,strcat('CGmn_QueVG_A20092021.mat')]);

YearCode = {'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021'};
% YearCode = {'2015','2016','2017','2018','2019','2020','2021'};
Color = [   0.9720 0.6580 0.6310;
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
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on;


for I_Year=1:numel(YearCode)

    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData=QueLUmn(1,:,I_Year);
    ZData=QueLUmn(2,:,I_Year);
    
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
%     H(I_Year)=plot(XData(:),YData(:),'o','Color',Color(I_Year,:),'LineWidth',3,'MarkerSize',10);

    p = polyfit(XData,YData,1);    
    SlopeLU(I_Year,1) = round(p(1,1),3); 
    R2LU(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;


end

    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData = nanmean(QueLUmn,3);
    YData = YData(1,:);
    
I = ~isnan(XData) & ~isnan(YData); 
YEmn = XData(I); LUmn = YData(I);

    pCG = polyfit(YEmn,LUmn,1);
    yfitCG = polyval(pCG,YEmn);
    SlopeCG = plot(YEmn,yfitCG,'-k','LineWidth',3);
   [h,SIG,CI,STATS]=ttest2(YEmn,LUmn); 
   
set(gca,'xlim',[0 1700],'ylim',[70 180],'xtick',0:400:1600,'Fontsize',20,'ytick',80:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueCG.tif']);close(Fig);

% Que-- LC

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on;

for I_Year=1:numel(YearCode)

%     XData=QueLCmn(3,:,I_Year);
    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData=QueLCmn(1,:,I_Year);
    ZData=QueLCmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1);    
    SlopeLC(I_Year,1) = round(p(1,1),3); 
    R2LC(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;

end
    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData = nanmean(QueLCmn,3);
    YData = YData(1,:);
    
I = ~isnan(XData) & ~isnan(YData); 
YEmn = XData(I); LCmn = YData(I);

    pCG = polyfit(YEmn,LCmn,1);
    yfitCG = polyval(pCG,YEmn);
    SlopeCG = plot(YEmn,yfitCG,'-k','LineWidth',3);
   [h,SIG,CI,STATS]=ttest2(YEmn,LCmn); 
   
set(gca,'xlim',[0 1700],'ylim',[240 350],'xtick',0:400:1600,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman');
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueCG.tif']);close(Fig);

% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on;

for I_Year=1:numel(YearCode)

%     XData=QueGSLmn(3,:,I_Year);
    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData=QueGSLmn(1,:,I_Year);
    ZData=QueGSLmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1);  
    SlopeGSL(I_Year,1) = round(p(1,1),3); 
    R2GSL(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PGSL(I_Year,1) = TP;
    
end

    XData =[131,387,803,1235,1630,259,422,841,1194,1614];
    YData = nanmean(QueGSLmn,3);
    YData = YData(1,:);
    
I = ~isnan(XData) & ~isnan(YData); 
YEmn = XData(I); GSLmn = YData(I);

    pCG = polyfit(YEmn,GSLmn,1);
    yfitCG = polyval(pCG,YEmn);
    SlopeCG = plot(YEmn,yfitCG,'-k','LineWidth',3);
   [h,SIG,CI,STATS]=ttest2(YEmn,GSLmn); 
   

set(gca,'xlim',[0 1700],'ylim',[80 270],'xtick',0:400:1600,'Fontsize',20,'ytick',80:30:270,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLQueCG.tif']);close(Fig);

