clc; clear;

Path_Figure  = '../figure/';
Path_RTE01YR4 ='../output/03_RTE01YR4/';

%% Que --- LU
load([Path_RTE01YR4,strcat('RTEmn_QueGap_A20072012.mat')]);

YearCode = {'2007','2008','2009','2010','2011','2012'};
Color = [   0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333,0.1843,0.2078;
            0.8039 0.7176 0.6196];


Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on;


for I_Year=1:numel(YearCode)

%     XData=QueLUmn(3,:,I_Year);
    XData =[131,488,833,1190,1533];
    YData=QueLUmn(1,:,I_Year);
    ZData=QueLUmn(2,:,I_Year);
   
%     XData1=QueLUmn(6,:,I_Year);
    XData1 =[131,488,833,1190,1533];
    YData1=QueLUmn(4,:,I_Year);
    ZData1=QueLUmn(5,:,I_Year);
    
%     XData2=QueLUmn(9,:,I_Year);
    XData2 =[131,488,833,1190,1533];
    YData2=QueLUmn(7,:,I_Year);
    ZData2=QueLUmn(8,:,I_Year);

%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

    p = polyfit(XData,YData,1);  
    SlopeLU(I_Year,1) = round(p(1,1),3); 
    R2LU(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLU(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeLU1(I_Year,1) = round(p1(1,1),3); 
    R2LU1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PLU1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeLU2(I_Year,1) = round(p2(1,1),3); 
    R2LU2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PLU2(I_Year,1) = TP;
    
end    
           
QueLUAvg = nanmean(QueLUmn,3);
QueLCAvg = nanmean(QueLCmn,3);
QueGSLAvg = nanmean(QueGSLmn,3);

pRTE = polyfit(XData,QueLUAvg(1,:),1);
yfitRTE = polyval(pRTE,XData);
Slope = plot(XData,yfitRTE,'-','color',[0.3098,0.3098,0.3098],'LineWidth',2); hold on;

pRTE1 = polyfit(XData1,QueLUAvg(4,:),1);
yfitRTE1 = polyval(pRTE1,XData1);
Slope = plot(XData1,yfitRTE1,'-','color',[0.5098,0.5098,0.5098],'LineWidth',2); hold on;

pRTE2 = polyfit(XData2,QueLUAvg(7,:),1);
yfitRTE2 = polyval(pRTE2,XData2);
Slope = plot(XData2,yfitRTE2,'-','color',[0.7098,0.7098,0.7098],'LineWidth',2); hold on;

set(gca,'xlim',[0 1700],'ylim',[80 180],'xtick',0:400:1600,'Fontsize',20,'ytick',80:20:180,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% Hlegend = legend([H.mainLine],YearCode,'FontWeight','bold','FontSize',18);
% set(Hlegend,'Units','Pixels','Position',[480 280 200 50],'Box','off');


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueVE.tif']);close(Fig);

% Que-- LC

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on; 

for I_Year=1:numel(YearCode)

    XData=[131,488,833,1190,1533];
    YData=QueLCmn(1,:,I_Year);
    ZData=QueLCmn(2,:,I_Year);
    
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
   
    XData1=[131,488,833,1190,1533];
    YData1=QueLCmn(4,:,I_Year);
    ZData1=QueLCmn(5,:,I_Year);
    
    XData2=[131,488,833,1190,1533];
    YData2=QueLCmn(7,:,I_Year);
    ZData2=QueLCmn(8,:,I_Year);

%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
  
    p = polyfit(XData,YData,1);  
    SlopeLC(I_Year,1) = round(p(1,1),3); 
    R2LC(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PLC(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeLC1(I_Year,1) = round(p1(1,1),3); 
    R2LC1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PLC1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeLC2(I_Year,1) = round(p2(1,1),3); 
    R2LC2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PLC2(I_Year,1) = TP;
end
    
pRTE = polyfit(XData,QueLCAvg(1,:),1);
yfitRTE = polyval(pRTE,XData);
Slope = plot(XData,yfitRTE,'-','color',[0.3098,0.3098,0.3098],'LineWidth',2); hold on;

pRTE1 = polyfit(XData1,QueLCAvg(4,:),1);
yfitRTE1 = polyval(pRTE1,XData1);
Slope = plot(XData1,yfitRTE1,'-','color',[0.5098,0.5098,0.5098],'LineWidth',2); hold on;

pRTE2 = polyfit(XData2,QueLCAvg(7,:),1);
yfitRTE2 = polyval(pRTE2,XData2);
Slope = plot(XData2,yfitRTE2,'-','color',[0.7098,0.7098,0.7098],'LineWidth',2); hold on;


set(gca,'xlim',[0 1700],'ylim',[240 350],'xtick',0:400:1600,'Fontsize',20,'ytick',220:20:350,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% text('String','  Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueVE.tif']);close(Fig);

% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[100 80 460 460]);box on;hold on;

for I_Year=1:numel(YearCode)

    XData=[131,488,833,1190,1533];
    YData=QueGSLmn(1,:,I_Year);
    ZData=QueGSLmn(2,:,I_Year);
           
%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-r','Color',Color(I_Year,:),'LineWidth',4},'transparent',1);
   
    XData1=[131,488,833,1190,1533];
    YData1=QueGSLmn(4,:,I_Year);
    ZData1=QueGSLmn(5,:,I_Year);
    
    XData2=[131,488,833,1190,1533];
    YData2=QueGSLmn(7,:,I_Year);
    ZData2=QueGSLmn(8,:,I_Year);

%     H(I_Year)=shadedErrorBar(XData(:),YData(:),ZData(:),'lineprops',{'-ro','MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',2},'transparent',1);
    H(I_Year) = errorbar(XData(:),YData(:),ZData(:),'o','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H1(I_Year) = errorbar(XData1(:),YData1(:),ZData1(:),'^','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;
    H2(I_Year) = errorbar(XData2(:),YData2(:),ZData2(:),'s','MarkerSize',10,'MarkerFaceColor',Color(I_Year,:),'Color',Color(I_Year,:),'LineWidth',1.5);hold on;

 
    p = polyfit(XData,YData,1);  
    SlopeGSL(I_Year,1) = round(p(1,1),3); 
    R2GSL(I_Year,1) = round(rsquare(XData,YData),2);
    [Th,TP,TSTATS]=ttest2(XData,YData,0.001);    
    PGSL(I_Year,1) = TP;
 
    p1 = polyfit(XData1,YData1,1);  
    SlopeGSL1(I_Year,1) = round(p1(1,1),3); 
    R2GSL1(I_Year,1) = round(rsquare(XData1,YData1),2);
    [Th,TP,TSTATS]=ttest2(XData1,YData1,0.001);    
    PGSL1(I_Year,1) = TP;

    p2 = polyfit(XData2,YData2,1);  
    SlopeGSL2(I_Year,1) = round(p2(1,1),3); 
    R2GSL2(I_Year,1) = round(rsquare(XData2,YData2),2);
    [Th,TP,TSTATS]=ttest2(XData2,YData2,0.001);    
    PGSL2(I_Year,1) = TP;    

end

    
pRTE = polyfit(XData,QueGSLAvg(1,:),1);
yfitRTE = polyval(pRTE,XData);
Slope = plot(XData,yfitRTE,'-','color',[0.3098,0.3098,0.3098],'LineWidth',2); hold on;

pRTE1 = polyfit(XData1,QueGSLAvg(4,:),1);
yfitRTE1 = polyval(pRTE1,XData1);
Slope = plot(XData1,yfitRTE1,'-','color',[0.5098,0.5098,0.5098],'LineWidth',2); hold on;

pRTE2 = polyfit(XData2,QueGSLAvg(7,:),1);
yfitRTE2 = polyval(pRTE2,XData2);
Slope = plot(XData2,yfitRTE2,'-','color',[0.7098,0.7098,0.7098],'LineWidth',2); hold on;

set(gca,'xlim',[0 1700],'ylim',[80 270],'xtick',0:400:1600,'Fontsize',20,'ytick',80:30:270,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Elevation (m)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
% 
% text('String',' Quercus petraea  ',...
%     'Units','Normalized','Position',[0.05 0.90],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLQueVE.tif']);close(Fig);


% %% combine
% Fig1=imread([Path_Figure,'LUQueGapVE.tif']);
% Fig2=imread([Path_Figure,'LCQueGapVE.tif']);
% Fig3=imread([Path_Figure,'GSLQueGapVE.tif']);
% 
% Fig=cat(1,cat(2,Fig1),cat(2,Fig2),cat(2,Fig3));
% Fig=imresize(Fig,2244/size(Fig,2));
% imwrite(Fig,[Path_Figure,'QueVE.tif'],'Compression','LZW','Resolution',300);
% 
% delete([Path_Figure,'LUQueGapVE.tif']);
% delete([Path_Figure,'LCQueGapVE.tif']);
% delete([Path_Figure,'GSLQueGapVE.tif']);

