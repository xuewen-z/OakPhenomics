addpath(genpath('./'));

clc; clear;

Path_Figure  = '../figure/';
Path_ISPHE2TMN ='../output/08_ISPHE2TMN/';
Path_ISPHE2PHOTO = '../output/R01_ISPHE2PHOTO/';

if ~exist(Path_ISPHE2PHOTO, 'dir')
    mkdir(Path_ISPHE2PHOTO);
end

%% Load IS phenology data
load([Path_ISPHE2TMN,'ISPHE2TMN_A20052020.mat']);

YearCode = {'2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'};
YearList = 2005:2019;
nYear = numel(YearList);

Color = [   0.2980 0.0000 0.4510;
            0.6900 0.8390 0.9180;
            0.8820 0.7450 0.9020;
            1.0000 0.7960 0.4390;
            0.9720 0.6580 0.6310;
            0.7450 0.1530 0.2080;
            0.9333 0.1843 0.2078;
            0.8039 0.7176 0.6196;
            0.1800 0.5450 0.3410;
            0.3880 0.3650 0.6470;
            0.4509 0.6941 0.8823;
            0.4117 0.3490 0.8039;
            0.0000 0.5098 0.5647;
            0.6627 0.3921 0.5137;
            0.75686 0.80392 0.75686;
            0.0000 0.5451 0.5451;
            0.0000 0.0000 0.5451];

%% IS site latitudes
% IMPORTANT: this order must match the rows of QueLUmn / QueLCmn.

IS_Lat = [
    43 + 45/60;  % Lav
    43 + 15/60;  % Ibos
    43 +  8/60;  % Ade
    42 + 56/60;  % Pier
    42 + 55/60;  % PapQu
    42 + 54/60;  % Bou
    42 + 47/60;  % GB
    42 + 47/60;  % GH
    42 + 52/60;  % Peg
    43 + 13/60;  % JosQu
    43 +  7/60;  % BagQu
    42 + 54/60;  % LH
    42 + 53/60;  % Gab
    42 + 53/60   % Art
];

%% Keep only 2005–2019
QueLUmn = QueLUmn(:,1:nYear);
QueLCmn = QueLCmn(:,1:nYear);

% If matrix is year × site, transpose it
if size(QueLUmn,1) ~= numel(IS_Lat) && size(QueLUmn,2) == numel(IS_Lat)
    QueLUmn = QueLUmn';
    QueLCmn = QueLCmn';
end

if size(QueLUmn,1) ~= numel(IS_Lat)
    error('The number of IS_Lat values does not match the number of phenology-site rows. Please check site order or remove extra rows.');
end

%% Calculate photoperiod matrices
nSite = numel(IS_Lat);

QuePhoto_FebMay = nan(nSite,nYear);
QuePhoto_SepNov = nan(nSite,nYear);

for I_Site = 1:nSite
    for I_Year = 1:nYear
        yy = YearList(I_Year);

        % Spring window for leaf unfolding
        QuePhoto_FebMay(I_Site,I_Year) = meanPhotoperiod(IS_Lat(I_Site), yy, 2, 1, 5, 31);

        % Autumn window for leaf senescence
        QuePhoto_SepNov(I_Site,I_Year) = meanPhotoperiod(IS_Lat(I_Site), yy, 9, 1, 11, 30);
    end
end

save([Path_ISPHE2PHOTO,'ISPHOTO_A20052019.mat'], ...
    'QuePhoto_FebMay','QuePhoto_SepNov','IS_Lat','YearList');

%% Initialize regression outputs
SlopeLU = nan(nYear,1);
PLU     = nan(nYear,1);

SlopeLC = nan(nYear,1);
PLC     = nan(nYear,1);

%% ============================================================
%  Que --- LU vs Feb-May photoperiod
% ============================================================

Fig=figure;
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);
box on; hold on;

for I_Year=1:nYear

    XData = QuePhoto_FebMay(:,I_Year);
    YData = QueLUmn(:,I_Year);

    XData = XData(:);
    YData = YData(:);

    I = ~isnan(XData) & ~isnan(YData);
    X = XData(I);
    Y = YData(I);

    if numel(X) < 3
        continue;
    end

    H(I_Year) = scatter(X, Y, 80, ...
        'MarkerFaceColor', Color(I_Year,:), ...
        'MarkerEdgeColor', Color(I_Year,:), ...
        'LineWidth', 1.5); 
    hold on;

    mdl_yr = fitlm(X,Y);
    SlopeLU(I_Year,1) = round(mdl_yr.Coefficients.Estimate(2),2); 
    PLU(I_Year,1) = mdl_yr.Coefficients.pValue(2);

end

StdSlopeLU = nanstd(SlopeLU); 

XData = QuePhoto_FebMay(:);
YData = QueLUmn(:);

I = ~isnan(XData) & ~isnan(YData); 
YTmn = XData(I); 
LUmn = YData(I); 

mdl = fitlm(YTmn, LUmn);
disp(mdl); 

xfit = linspace(min(YTmn), max(YTmn), 100)';
[yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);

fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
    [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); 
hold on;

plot(xfit, yfit, '-k', 'LineWidth', 2); 
hold on;

xrange = max(YTmn) - min(YTmn);

set(gca, ...
    'xlim',[min(YTmn)-0.05*xrange max(YTmn)+0.05*xrange], ...
    'ylim',[70 180], ...
    'Fontsize',18, ...
    'ytick',60:20:180, ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman'); 

ylabel('Leaf unfolding (DOY)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

xlabel('Mean Feb-May photoperiod (h)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

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

pause(5); 
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LUQueISPhotoperiod_FebMay.tif']);
close(Fig);

%% ============================================================
%  Que --- LC vs Sep-Nov photoperiod
% ============================================================

Fig=figure;
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',20); 
set(gca,'Units','Pixels','Position',[120 90 420 420]);
box on; hold on; 

for I_Year=1:nYear

    XData = QuePhoto_SepNov(:,I_Year);
    YData = QueLCmn(:,I_Year);

    XData = XData(:);
    YData = YData(:);

    I = ~isnan(XData) & ~isnan(YData);
    X = XData(I);
    Y = YData(I);

    if numel(X) < 3
        continue;
    end

    H(I_Year) = scatter(X, Y, 80, ...
        'MarkerFaceColor', Color(I_Year,:), ...
        'MarkerEdgeColor', Color(I_Year,:), ...
        'LineWidth', 1.5); 
    hold on;

    mdl_yr = fitlm(X,Y);
    SlopeLC(I_Year,1) = round(mdl_yr.Coefficients.Estimate(2),2); 
    PLC(I_Year,1) = mdl_yr.Coefficients.pValue(2);

end

StdSlopeLC = nanstd(SlopeLC); 

XData = QuePhoto_SepNov(:);
YData = QueLCmn(:);

I = ~isnan(XData) & ~isnan(YData); 
YTmn = XData(I); 
LCmn = YData(I);

mdl = fitlm(YTmn, LCmn);
disp(mdl); 

xfit = linspace(min(YTmn), max(YTmn), 100)';
[yfit, yci] = predict(mdl, xfit, 'Alpha', 0.05);

fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
    [0.3 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.4); 
hold on;

plot(xfit, yfit, '-k', 'LineWidth', 2); 
hold on;

xrange = max(YTmn) - min(YTmn);

set(gca, ...
    'xlim',[min(YTmn)-0.05*xrange max(YTmn)+0.05*xrange], ...
    'ylim',[240 340], ...
    'Fontsize',18, ...
    'ytick',240:20:340, ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman'); 

ylabel('Senescence (DOY)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

xlabel('Mean Sep-Nov photoperiod (h)', ...
    'FontWeight','bold', ...
    'Fontname','Times New Roman', ...
    'Fontsize',18);

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

pause(5); 
set(gcf,'position',[100 100 600 550],'defaultAxesFontSize',14);  

print(Fig,'-dtiff','-r300',[Path_Figure,'LCQueISPhotoperiod_SepNov.tif']);
close(Fig);

%% Save regression summary

T_LU = table(string(YearCode(:)), SlopeLU(:), PLU(:), ...
    'VariableNames', {'Year','Slope_days_per_hour','P'});

T_LC = table(string(YearCode(:)), SlopeLC(:), PLC(:), ...
    'VariableNames', {'Year','Slope_days_per_hour','P'});

writetable(T_LU, [Path_ISPHE2PHOTO,'IS_LU_vs_Photoperiod_FebMay_yearly.csv']);
writetable(T_LC, [Path_ISPHE2PHOTO,'IS_LC_vs_Photoperiod_SepNov_yearly.csv']);

save([Path_ISPHE2PHOTO,'IS_PHE_vs_PHOTO_A20052019.mat'], ...
    'QuePhoto_FebMay','QuePhoto_SepNov', ...
    'SlopeLU','PLU','SlopeLC','PLC', ...
    'StdSlopeLU','StdSlopeLC');

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

