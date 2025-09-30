clc; clear;

Path_IS01YR4 ='../output/04_IS01YR4/';
Path_IS02DTMN ='../output/06_IS02DTMN/';
Path_ISPHE2TMN ='../output/22_ISCGDD2TMN/';

mkdir(Path_ISPHE2TMN);

load([Path_IS01YR4,strcat('ISmn_QueVP_A20052021.mat')]);
load([Path_IS02DTMN,'ISDTMN.mat']);
 
    SpecCode = {'Quercus petraea and Fagus sylvatica','Quercus petraea'};
    Spec_Code = ismember(SiteSpec,SpecCode);
    SpecIndex = find(Spec_Code ==1);
    
    QueTmn = SiteTmn(:,SpecIndex); 
    QueDTmn = [];

for Year = 2004 : 2020
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    
    TempDTmn = QueTmn(Index,:); 
    if length(TempDTmn) >365
       TempDTmn(366,:) = []; 
    else
    end
      
    QueDTmn(:,:,Year - 2003) = TempDTmn; %  2004-2020
   
end


QueLUDOY = QueLUmn(1,:,:);
QueLUDOY = reshape(QueLUDOY,[],17);  % 2005-2021;

% same years
QueLUDOY = QueLUDOY(:,1:16); % 2005-2020


% 已有：QueDTmn (逐日温度)，物候数据 QueLUDOY (day of year of leaf unfolding)

BaseTemp = 5;   % 基准温度
nSite = size(QueDTmn,2);
nYear = size(QueLUDOY,2); % 2005–2020 共16年

QueCDD = nan(nSite,nYear);
QueGDD = nan(nSite,nYear);


for y = 1:nYear
    Year = 2004 + y;        % 对应温度数组的索引
    LU_DOY = QueLUDOY(:,y); % 每个站点的叶展DOY
    
    for s = 1:nSite
        if isnan(LU_DOY(s)), continue; end
        
        % ---- GDD: 当年1月1日–LU ----
        TempThisYear = squeeze(QueDTmn(:,s,y+1)); % y+1 因为温度是2004–2020
        Doy = round(LU_DOY(s));
        GDDvals = TempThisYear(1:Doy) - BaseTemp;
        GDDvals(GDDvals < 0) = 0;
        QueGDD(s,y) = sum(GDDvals,'omitnan');
        
        % ---- CDD: 前一年11月1日–12月31日 + 当年1月1日–LU ----
        TempPrevYear = squeeze(QueDTmn(:,s,y)); % 前一年
        TempThisYear = squeeze(QueDTmn(:,s,y+1));
        
        TempCDD = [TempPrevYear(305:365); TempThisYear(1:Doy)];  % Nov.1
        QueCDD(s,y) = sum(TempCDD < BaseTemp,'omitnan');  % 低于5℃天数
    end
end

save([Path_ISPHE2TMN,'IS_QueCDDGDD_20052020.mat'],'QueCDD','QueGDD');
