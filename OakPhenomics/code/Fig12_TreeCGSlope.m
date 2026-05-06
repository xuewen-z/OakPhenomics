
clc;clear;

addpath(genpath('./'));

Path_Figure  = '../figure/';
Path_Tree03CG ='../output/15_Tree03CG/';

load([Path_Tree03CG,'TreeCGTmn.A2009.2021.mat']);

TColor = [  0.2980 0.0000 0.4510;
            0.6900 0.8390 0.9180;
            0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333,0.1843,0.2078;
            0.8039 0.7176 0.6196;
            0.1800 0.5450 0.3410;
            0.3880 0.3650 0.6470;];

Color = repmat(TColor,[343,1]);

% LU
Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 450 420]);box on;hold on;
TreeLU(TreeLU>150)=nan;

    for I_Tree = 1: numel(TreeLU(:,1))
        XData = TreeSTmn(1,:);
        YData = TreeLU(I_Tree,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);
    
    plot(XData(:),YData(:),'o','Color',Color(I_Tree,:),'LineWidth',1);
    hold on;

   
        pCG = polyfit(XData,YData,1);
        yfitCG = polyval(pCG,XData);
        SlopeCG = plot(XData,yfitCG,'-','Color',Color(I_Tree,:),'LineWidth',2); 

     

    end
    
   
set(gca,'xlim',[8 15],'ylim',[70 150],'xtick',8:2:15,'Fontsize',20,'ytick',70:20:150,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Leaf unfolding (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Spring mean Ta in CG (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% Hlegend = legend([H],YearCode,'FontSize',18);
% set(Hlegend,'Units','Pixels','Position',[520 280 200 50],'Box','off');


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'TreeLUTmn.tif']);close(Fig);

% Slope-Elevation
Fig=figure;set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 520 420]);box on;hold on;

% 基于 kernel density + fill 实现 "split violin plot"

TreeLUSlope_Gaves = TreeLUSlope(:,1:795);
TreeLUElev_Gaves = TreeLUElev(:,1:795);
TreeLUSlope_Ossau = TreeLUSlope(:,796:2790);
TreeLUElev_Ossau = TreeLUElev(:,796:2790);

elevGroups = [200, 400, 800, 1200, 1600];
binEdges = [100, 300, 600, 1000, 1400, 1800];
groupLabels = {'200','400','800','1200','1600'};

[~, bin_Gaves] = histc(TreeLUElev_Gaves, binEdges);
[~, bin_Ossau] = histc(TreeLUElev_Ossau, binEdges);

for i = 1:5
    % 获取每组数据
    vals_G = TreeLUSlope_Gaves(bin_Gaves == i);
    vals_O = TreeLUSlope_Ossau(bin_Ossau == i);

    % 保证列向量 & 去 NaN
    vals_G = vals_G(~isnan(vals_G));
    vals_O = vals_O(~isnan(vals_O));

    % KDE估计 + 标准化密度
    if ~isempty(vals_G)
        [fG, uG] = ksdensity(vals_G);
        fG = fG / max(fG) * 0.3;
        fill(i - fG, uG, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r'); % 左侧Gaves
        plot(i - 0.25, mean(vals_G), 'rv', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    end
    if ~isempty(vals_O)
        [fO, uO] = ksdensity(vals_O);
        fO = fO / max(fO) * 0.3;
        fill(i + fO, uO, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b'); % 右侧Ossau
        plot(i + 0.25, mean(vals_O), 'bv', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    end
end

set(gca,'ylim',[-5, 3],'ytick',-4:2:4, ...
    'xlim',[0.5, 5.5],'xtick',1:1:5,'FontWeight','bold','Fontname','Times New Roman','fontsize',20); 

xticklabels(groupLabels);

xlabel('Elevation (m)','FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
ylabel('∂leaf unfoldind / ∂Ta (days/℃)','FontWeight','bold','Fontname','Times New Roman','Fontsize',18);

% % 创建不可见的 dummy 对象用于 legend
% h1 = fill(nan, nan, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r');
% h2 = fill(nan, nan, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b');
% 
% L = legend([h1, h2], {'Gaves', 'Ossau'});
% set(L,'Box','off','FontSize', 16,'Units','Normalized',...
%     'Position',[0.5 0.85 0.1 0.1],'Orientation','horizon','ItemTokenSize', [16, 6]);

box on;
pause(5); set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUSlopElev.tif']);close(Fig);


% LC
Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 450 420]);box on;hold on;

% INX= find(isnan(TreeLC(:,1)));
% TreeLC(INX,:)=[];
 
    for I_Tree = 1: numel(TreeLC(:,1))
        XData = TreeATmn(1,:);
        YData = TreeLC(I_Tree,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);
    
    plot(XData(:),YData(:),'o','Color',Color(I_Tree,:),'LineWidth',1);hold on;
    pCG = polyfit(XData,YData,1);
    yfitCG = polyval(pCG,XData);
    SlopeCG = plot(XData,yfitCG,'-','Color',Color(I_Tree,:),'LineWidth',2); 
    
    end
   
set(gca,'xlim',[14.5 16.7],'ylim',[250 380],'xtick',14:0.5:16.7,'Fontsize',20,'ytick',80:30:380,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Senescence (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Autumn mean Ta in CG (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'TreeLCTmn.tif']);close(Fig);

%% --------------------------------------------------------------%%%

% Slope-Elevation
Fig=figure;set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 520 420]);box on;hold on;

% 基于 kernel density + fill 实现 "split violin plot"

TreeLCSlope_Gaves = TreeLCSlope(:,1:622);
TreeLCElev_Gaves = TreeLCElev(:,1:622);
TreeLCSlope_Ossau = TreeLCSlope(:,623:1976);
TreeLCElev_Ossau = TreeLCElev(:,623:1976);

elevGroups = [200, 400, 800, 1200, 1600];
binEdges = [100, 300, 600, 1000, 1400, 1800];
groupLabels = {'200','400','800','1200','1600'};

[~, bin_Gaves] = histc(TreeLCElev_Gaves, binEdges);
[~, bin_Ossau] = histc(TreeLCElev_Ossau, binEdges);

for i = 1:5
    % 获取每组数据
    vals_G = TreeLCSlope_Gaves(bin_Gaves == i);
    vals_O = TreeLCSlope_Ossau(bin_Ossau == i);

    % 保证列向量 & 去 NaN
    vals_G = vals_G(~isnan(vals_G));
    vals_O = vals_O(~isnan(vals_O));

    % KDE估计 + 标准化密度
    if ~isempty(vals_G)
        [fG, uG] = ksdensity(vals_G);
        fG = fG / max(fG) * 0.3;
        fill(i - fG, uG, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r'); % 左侧Gaves
        plot(i - 0.25, mean(vals_G), 'rv', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    end
    if ~isempty(vals_O)
        [fO, uO] = ksdensity(vals_O);
        fO = fO / max(fO) * 0.3;
        fill(i + fO, uO, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b'); % 右侧Ossau
        plot(i + 0.25, mean(vals_O), 'bv', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    end
end

set(gca,'ylim',[-40, 50],'ytick',-40:20:50, ...
    'xlim',[0.5, 5.5],'xtick',1:1:5,'FontWeight','bold','Fontname','Times New Roman','fontsize',20); 

xticklabels(groupLabels);

xlabel('Elevation (m)','FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
ylabel('∂senescence / ∂Ta (days/℃)','FontWeight','bold','FontWeight','bold','Fontname','Times New Roman','Fontsize',18);

% 创建不可见的 dummy 对象用于 legend
h1 = fill(nan, nan, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r');
h2 = fill(nan, nan, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b');

L = legend([h1, h2], {'Gaves', 'Ossau'});
set(L,'Box','off','FontSize', 16,'Units','Normalized',...
    'Position',[0.5 0.85 0.1 0.1],'Orientation','horizon','ItemTokenSize', [16, 6]);

box on;

pause(5); set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCSlopElev.tif']);close(Fig);

% GSL

Fig=figure;set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20);
set(gca,'Units','Pixels','Position',[120 90 450 420]);box on;hold on;


    for I_Tree = 1: numel(TreeGSL(:,1))
        XData = TreeYTmn(I_Tree,:);
        YData = TreeGSL(I_Tree,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);
    
    plot(XData(:),YData(:),'o','Color',Color(I_Tree,:),'LineWidth',1);hold on;
    pCG = polyfit(XData,YData,1);
    yfitCG = polyval(pCG,XData);
    SlopeCG = plot(XData,yfitCG,'-','Color',Color(I_Tree,:),'LineWidth',2); 
       
    end
    
   
set(gca,'xlim',[12.5 16],'ylim',[130 250],'xtick',12:1:16,'Fontsize',20,'ytick',130:30:380,'Fontsize',20,'FontWeight','bold','Fontname','Times New Roman'); 
ylabel(['Growing season length (DOY)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
xlabel(['Annual mean Ta in CG (°C)'],'FontWeight','bold','Fontname','Times New Roman','Fontsize',20);

% text('String',' Quercus petraea ',...
%     'Units','Normalized','Position',[0.05 0.90],'Fontname','Times New Roman','Fontsize',20);


pause(5); set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'TreeGSLTmn.tif']);close(Fig);


% Slope-Elevation
Fig=figure;set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 520 420]);box on;hold on;

% 基于 kernel density + fill 实现 "split violin plot"

TreeGSLSlope_Gaves = TreeGSLSlope(:,1:603);
TreeGSLElev_Gaves = TreeGSLElev(:,1:603);
TreeGSLSlope_Ossau = TreeGSLSlope(:,604:1925);
TreeGSLElev_Ossau = TreeGSLElev(:,604:1925);

elevGroups = [200, 400, 800, 1200, 1600];
binEdges = [100, 300, 600, 1000, 1400, 1800];
groupLabels = {'200','400','800','1200','1600'};

[~, bin_Gaves] = histc(TreeGSLElev_Gaves, binEdges);
[~, bin_Ossau] = histc(TreeGSLElev_Ossau, binEdges);

for i = 1:5
    % 获取每组数据
    vals_G = TreeGSLSlope_Gaves(bin_Gaves == i);
    vals_O = TreeGSLSlope_Ossau(bin_Ossau == i);

    % 保证列向量 & 去 NaN
    vals_G = vals_G(~isnan(vals_G));
    vals_O = vals_O(~isnan(vals_O));

    % KDE估计 + 标准化密度
    if ~isempty(vals_G)
        [fG, uG] = ksdensity(vals_G);
        fG = fG / max(fG) * 0.3;
        fill(i - fG, uG, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r'); % 左侧Gaves
        plot(i - 0.25, mean(vals_G), 'rv', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    end
    if ~isempty(vals_O)
        [fO, uO] = ksdensity(vals_O);
        fO = fO / max(fO) * 0.3;
        fill(i + fO, uO, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b'); % 右侧Ossau
        plot(i + 0.25, mean(vals_O), 'bv', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    end
end

set(gca,'ylim',[-25, 35],'ytick',-20:10:30, ...
    'xlim',[0.5, 5.5],'xtick',1:1:5,'FontWeight','bold','Fontname','Times New Roman','fontsize',20); 

xticklabels(groupLabels);

xlabel('Elevation (m)','FontWeight','bold','Fontname','Times New Roman','Fontsize',20);
ylabel('∂growing season length / ∂Ta (days/℃)','FontWeight','bold','Fontname','Times New Roman','Fontsize',18);

% % 创建不可见的 dummy 对象用于 legend
% h1 = fill(nan, nan, [1 0.4 0.4], 'FaceAlpha', 0.6, 'EdgeColor', 'r');
% h2 = fill(nan, nan, [0.2, 0.4, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'b');
% 
% L = legend([h1, h2], {'Gaves', 'Ossau'});
% set(L,'Box','off','FontSize', 16,'Units','Normalized',...
%     'Position',[0.5 0.85 0.1 0.1],'Orientation','horizon','ItemTokenSize', [16, 6]);

box on;
pause(5); set(gcf,'position',[100 100 700 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'GSLSlopElev.tif']);close(Fig);

%% Combine
Fig1=imread([Path_Figure,'TreeLUTmn.tif']);
Fig2=imread([Path_Figure,'TreeLCTmn.tif']);
Fig3=imread([Path_Figure,'TreeGSLTmn.tif']);

Fig4=cat(1,cat(2,Fig1,Fig2,Fig3));
Fig4=imresize(Fig4,2244/size(Fig4,2));
imwrite(Fig4,[Path_Figure,'TreeCGTmn.tif'],'Compression','LZW','Resolution',300);

%% Combine
Fig1=imread([Path_Figure,'LUSlopElev.tif']);
Fig2=imread([Path_Figure,'LCSlopElev.tif']);
Fig3=imread([Path_Figure,'GSLSlopElev.tif']);

Fig5=cat(1,cat(2,Fig1,Fig2,Fig3));
Fig5=imresize(Fig5,2244/size(Fig5,2));

% Fig=cat(1,cat(2,Fig4),cat(2,Fig5));
% Fig=imresize(Fig,2244/size(Fig,2));

imwrite(Fig5,[Path_Figure,'SloElev.tif'],'Compression','LZW','Resolution',300);

delete([Path_Figure,'LUSlopElev.tif']);
delete([Path_Figure,'LCSlopElev.tif']);
delete([Path_Figure,'GSLSlopElev.tif']);
delete([Path_Figure,'TreeLUTmn.tif']);
delete([Path_Figure,'TreeLCTmn.tif']);
delete([Path_Figure,'TreeGSLTmn.tif']);

        