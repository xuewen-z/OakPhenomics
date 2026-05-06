clc; clear;
addpath(genpath('./'));

Path_Figure = '../figure/';
Path_RTEPHE2TMN = '../output/14_RTEPHE2TMN/';
Path_RTEPHE2PHOTO = '../output/R02_RTEPHE2PHOTO/';

if ~exist(Path_RTEPHE2PHOTO, 'dir')
    mkdir(Path_RTEPHE2PHOTO);
end

load([Path_RTEPHE2TMN, 'RTEPHE2TMN_A20072012.mat']);

%% Years and colors
YearList = 2007:2012;
YearCode = {'2007','2008','2009','2010','2011','2012'};
nYear = numel(YearList);

Color = [   0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333 0.1843 0.2078;
            0.8039 0.7176 0.6196];

%% RTE target-site latitudes
% Site order should match columns of QueLUmn / QueLCmn:
% Lav, Lourdes, Sireix, Haugarou, Lienz

RTE_Lat = [
    43 + 45/60;   % Lav, Laveyron
    43 +  5/60;   % Lou, Lourdes
    42 + 58/60;   % Sireix
    43 +  0/60;   % Haugarou
    42 + 53/60    % Lienz
];

RTE_Elev = [131, 488, 833, 1190, 1533];
nSite = numel(RTE_Lat);

%% Calculate RTE target-site photoperiod
% Feb-May for leaf unfolding
% Sep-Nov for leaf senescence

SitePhoto_FebMay = nan(nYear, nSite);
SitePhoto_SepNov = nan(nYear, nSite);

for I_Year = 1:nYear
    yy = YearList(I_Year);

    for I_Site = 1:nSite
        SitePhoto_FebMay(I_Year, I_Site) = meanPhotoperiod(RTE_Lat(I_Site), yy, 2, 1, 5, 31);
        SitePhoto_SepNov(I_Year, I_Site) = meanPhotoperiod(RTE_Lat(I_Site), yy, 9, 1, 11, 30);
    end
end

%% Insert photoperiod into environmental rows
% Rows 1,4,7 = phenology means for 400, 800, 1200 m origins
% Rows 2,5,8 = standard deviations
% Rows 3,6,9 = environmental variable rows

QueLUPHOTO = QueLUmn;
QueLCPHOTO = QueLCmn;

for I_Year = 1:nYear

    TemLU = QueLUPHOTO(:,:,I_Year);
    TemLU(3,:) = SitePhoto_FebMay(I_Year,:);
    TemLU(6,:) = SitePhoto_FebMay(I_Year,:);
    TemLU(9,:) = SitePhoto_FebMay(I_Year,:);
    QueLUPHOTO(:,:,I_Year) = TemLU;

    TemLC = QueLCPHOTO(:,:,I_Year);
    TemLC(3,:) = SitePhoto_SepNov(I_Year,:);
    TemLC(6,:) = SitePhoto_SepNov(I_Year,:);
    TemLC(9,:) = SitePhoto_SepNov(I_Year,:);
    QueLCPHOTO(:,:,I_Year) = TemLC;

end

save([Path_RTEPHE2PHOTO, 'RTEPHE2PHOTO_A20072012.mat'], ...
    'QueLUPHOTO', 'QueLCPHOTO', ...
    'SitePhoto_FebMay', 'SitePhoto_SepNov', ...
    'RTE_Lat', 'RTE_Elev', 'YearList');

%% ============================================================
%  Que --- LU vs Feb-May photoperiod
% ============================================================

Fig = figure;
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[100 90 420 420]);
box on; hold on;

SlopeLU  = nan(nYear,1);
SlopeLU1 = nan(nYear,1);
SlopeLU2 = nan(nYear,1);
PLU  = nan(nYear,1);
PLU1 = nan(nYear,1);
PLU2 = nan(nYear,1);

Xall = [];
Yall = [];

for I_Year = 1:nYear

    XData  = QueLUPHOTO(3,:,I_Year);
    YData  = QueLUPHOTO(1,:,I_Year);

    XData1 = QueLUPHOTO(6,:,I_Year);
    YData1 = QueLUPHOTO(4,:,I_Year);

    XData2 = QueLUPHOTO(9,:,I_Year);
    YData2 = QueLUPHOTO(7,:,I_Year);

    % Scatter points: markers indicate provenance origin
    H(I_Year) = scatter(XData(:), YData(:), 80, 'o', ...
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

    % Annual regressions by provenance origin, saved only
    mdl0 = fitlm(XData(:), YData(:));
    SlopeLU(I_Year,1) = round(mdl0.Coefficients.Estimate(2),2);
    PLU(I_Year,1) = mdl0.Coefficients.pValue(2);

    mdl1 = fitlm(XData1(:), YData1(:));
    SlopeLU1(I_Year,1) = round(mdl1.Coefficients.Estimate(2),2);
    PLU1(I_Year,1) = mdl1.Coefficients.pValue(2);

    mdl2 = fitlm(XData2(:), YData2(:));
    SlopeLU2(I_Year,1) = round(mdl2.Coefficients.Estimate(2),2);
    PLU2(I_Year,1) = mdl2.Coefficients.pValue(2);

    % Collect all points for pooled regression
    Xall = [Xall; XData(:); XData1(:); XData2(:)];
    Yall = [Yall; YData(:); YData1(:); YData2(:)];

end

I = ~isnan(Xall) & ~isnan(Yall);
X = Xall(I);
Y = Yall(I);

mdl = fitlm(X, Y);
disp(mdl);

xfit = linspace(min(X), max(X), 100)';
[yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);

fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
    [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

Pvalue = mdl.Coefficients.pValue(2);
Slope = mdl.Coefficients.Estimate(2);

if Pvalue < 0.001
    p_text = 'p < 0.001';
elseif Pvalue < 0.01
    p_text = 'p < 0.01';
elseif Pvalue < 0.05
    p_text = 'p < 0.05';
else
    p_text = sprintf('p = %.3f', Pvalue);
end

text(0.08, 0.18, sprintf('Slope = %.2f', Slope), ...
    'Units','Normalized', ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'FontName','Times New Roman', ...
    'Color','k');

text(0.08, 0.10, p_text, ...
    'Units','Normalized', ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'FontName','Times New Roman', ...
    'Color','k');

xrange = max(X) - min(X);

set(gca, ...
    'xlim',[min(X)-0.05*xrange max(X)+0.05*xrange], ...
    'ylim',[70 180], ...
    'Fontsize',18, ...
    'ytick',80:20:180, ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman'); 

ylabel('Leaf unfolding (DOY)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

xlabel('Mean Feb-May photoperiod of planting sites (h)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

pause(5);
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueRTEPhotoperiod_FebMay.tif']);
close(Fig);

%% ============================================================
%  Que --- LC vs Sep-Nov photoperiod
% ============================================================

Fig = figure;
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[100 90 420 420]);
box on; hold on;

SlopeLC  = nan(nYear,1);
SlopeLC1 = nan(nYear,1);
SlopeLC2 = nan(nYear,1);
PLC  = nan(nYear,1);
PLC1 = nan(nYear,1);
PLC2 = nan(nYear,1);

Xall = [];
Yall = [];

for I_Year = 1:nYear

    XData  = QueLCPHOTO(3,:,I_Year);
    YData  = QueLCPHOTO(1,:,I_Year);

    XData1 = QueLCPHOTO(6,:,I_Year);
    YData1 = QueLCPHOTO(4,:,I_Year);

    XData2 = QueLCPHOTO(9,:,I_Year);
    YData2 = QueLCPHOTO(7,:,I_Year);

    % Scatter points: markers indicate provenance origin
    H(I_Year) = scatter(XData(:), YData(:), 80, 'o', ...
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

    % Annual regressions by provenance origin, saved only
    mdl0 = fitlm(XData(:), YData(:));
    SlopeLC(I_Year,1) = round(mdl0.Coefficients.Estimate(2),2);
    PLC(I_Year,1) = mdl0.Coefficients.pValue(2);

    mdl1 = fitlm(XData1(:), YData1(:));
    SlopeLC1(I_Year,1) = round(mdl1.Coefficients.Estimate(2),2);
    PLC1(I_Year,1) = mdl1.Coefficients.pValue(2);

    mdl2 = fitlm(XData2(:), YData2(:));
    SlopeLC2(I_Year,1) = round(mdl2.Coefficients.Estimate(2),2);
    PLC2(I_Year,1) = mdl2.Coefficients.pValue(2);

    % Collect all points for pooled regression
    Xall = [Xall; XData(:); XData1(:); XData2(:)];
    Yall = [Yall; YData(:); YData1(:); YData2(:)];

end

I = ~isnan(Xall) & ~isnan(Yall);
X = Xall(I);
Y = Yall(I);

mdl = fitlm(X, Y);
disp(mdl);

xfit = linspace(min(X), max(X), 100)';
[yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);

fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
    [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); hold on;

plot(xfit, yfit, '-k', 'LineWidth', 2); hold on;

Pvalue = mdl.Coefficients.pValue(2);
Slope = mdl.Coefficients.Estimate(2);

if Pvalue < 0.001
    p_text = 'p < 0.001';
elseif Pvalue < 0.01
    p_text = 'p < 0.01';
elseif Pvalue < 0.05
    p_text = 'p < 0.05';
else
    p_text = sprintf('p = %.3f', Pvalue);
end

text(0.08, 0.18, sprintf('Slope = %.2f', Slope), ...
    'Units','Normalized', ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'FontName','Times New Roman', ...
    'Color','k');

text(0.08, 0.10, p_text, ...
    'Units','Normalized', ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'FontName','Times New Roman', ...
    'Color','k');

xrange = max(X) - min(X);

set(gca, ...
    'xlim',[min(X)-0.05*xrange max(X)+0.05*xrange], ...
    'ylim',[240 340], ...
    'Fontsize',18, ...
    'ytick',220:20:360, ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman'); 

ylabel('Senescence (DOY)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

xlabel('Mean Sep-Nov photoperiod of planting sites (h)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

pause(5);
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueRTEPhotoperiod_SepNov.tif']);
close(Fig);

%% Save regression summary

T_LU = table(string(YearCode(:)), ...
    SlopeLU(:), PLU(:), ...
    SlopeLU1(:), PLU1(:), ...
    SlopeLU2(:), PLU2(:), ...
    'VariableNames', {'Year','Slope_400m','P_400m','Slope_800m','P_800m','Slope_1200m','P_1200m'});

T_LC = table(string(YearCode(:)), ...
    SlopeLC(:), PLC(:), ...
    SlopeLC1(:), PLC1(:), ...
    SlopeLC2(:), PLC2(:), ...
    'VariableNames', {'Year','Slope_400m','P_400m','Slope_800m','P_800m','Slope_1200m','P_1200m'});

writetable(T_LU, [Path_RTEPHE2PHOTO,'RTE_LU_vs_Photoperiod_FebMay_yearly.csv']);
writetable(T_LC, [Path_RTEPHE2PHOTO,'RTE_LC_vs_Photoperiod_SepNov_yearly.csv']);

save([Path_RTEPHE2PHOTO,'RTE_PHE_vs_PHOTO_A20072012.mat'], ...
    'QueLUPHOTO','QueLCPHOTO', ...
    'SitePhoto_FebMay','SitePhoto_SepNov', ...
    'SlopeLU','PLU','SlopeLU1','PLU1','SlopeLU2','PLU2', ...
    'SlopeLC','PLC','SlopeLC1','PLC1','SlopeLC2','PLC2');

%% Local functions

function L = meanPhotoperiod(latDeg, yearVal, m1, d1, m2, d2)

    dates = (datetime(yearVal,m1,d1):datetime(yearVal,m2,d2))';
    doy = day(dates, "dayofyear");

    Ldaily = daylengthHours(latDeg, doy);
    L = mean(Ldaily, "omitnan");

end

function L = daylengthHours(latDeg, doy)

    lat = deg2rad(latDeg);

    % Solar declination approximation
    decl = 0.409 .* sin((2*pi/365) .* doy - 1.39);

    % Sunset hour angle
    x = -tan(lat) .* tan(decl);
    x(x < -1) = -1;
    x(x > 1) = 1;

    omega = acos(x);

    % Day length in hours
    L = 24 ./ pi .* omega;

end



% Union --- Que
Fig1=imread([Path_Figure,'LUQueISPhotoperiod_FebMay.tif']);
Fig2=imread([Path_Figure,'LCQueISPhotoperiod_SepNov.tif']);
Fig3=imread([Path_Figure,'LUQueRTEPhotoperiod_FebMay.tif']);
Fig4=imread([Path_Figure,'LCQueRTEPhotoperiod_SepNov.tif']);

Fig5=cat(1,cat(2,Fig1,Fig3));
Fig6=cat(1,cat(2,Fig2,Fig4));


Fig=cat(1,cat(2,Fig5),cat(2,Fig6));
Fig=imresize(Fig,2244/size(Fig,2));
imwrite(Fig,[Path_Figure,'QuePHOTO.tif'],'Compression','LZW','Resolution',300);

%% Combine

delete([Path_Figure,'LUQueISPhotoperiod_FebMay.tif']);
delete([Path_Figure,'LCQueISPhotoperiod_SepNov.tif']);
delete([Path_Figure,'LUQueRTEPhotoperiod_FebMay.tif']);
delete([Path_Figure,'LCQueRTEPhotoperiod_SepNov.tif']);
