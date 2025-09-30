

clc;clear;

addpath(genpath('./'));

Path_PHE01LV2 ='../output/01_PHE01LV2/';
Path_PHE01LV3 ='../output/02_PHE01LV3/';

% mkdir(Path_PHE01LV3);

%% RTE

load([Path_PHE01LV2,'NormRTE.mat']);

BgnYear = min(SiteYear(:));
EndYear = max(SiteYear(:));

for Year = BgnYear : EndYear
    YearName = num2str(Year);
   
    Year_Inx = ismember(SiteYear,Year);
    YrID = SiteTrID(Year_Inx);
    YrTrait = SiteTrait(Year_Inx);
    YrTree = TreeSpecie(Year_Inx);
    YrBloc = SiteBloc(Year_Inx);
    YrElev = SiteElev(Year_Inx);
    YrProv = TreeProv(Year_Inx);
    YrLU = TreeLU(Year_Inx);
    YrLC = TreeLC(Year_Inx);
    YrGSL = TreeGSL(Year_Inx);
        
    
    save([Path_PHE01LV3,strcat('RTE',YearName,'.mat')],'-regexp','^Yr*');
        
    disp(['Done with ',YearName]);

end

%% IS

load([Path_PHE01LV2,'NormIS.mat']);

BgnYear = min(SiteYear(:));
EndYear = max(SiteYear(:));


for Year = BgnYear : EndYear
%     Year = 2019;
    YearName = num2str(Year);
   
    Year_Inx = ismember(SiteYear,Year);
    YrSite = SiteName(Year_Inx);
    YrVall = VallName(Year_Inx);

    YrElev = SiteElev(Year_Inx);
    YrProv = SiteProv(Year_Inx);
    YrLU = SiteLU(Year_Inx);
    YrLC = SiteLC(Year_Inx);
    YrGSL = SiteGSL(Year_Inx);
        
    
    save([Path_PHE01LV3,strcat('IS',YearName,'.mat')],'-regexp','^Yr*');
        
    disp(['Done with ',YearName]);

end


%% CG

load([Path_PHE01LV2,'NormCG.mat']);

BgnYear = min(SiteYear(:));
EndYear = max(SiteYear(:));

for Year = BgnYear : EndYear
    %     Year = 2019;
    YearName = num2str(Year);
   
    Year_Inx = ismember(SiteYear,Year);
    YrSite = SiteName(Year_Inx);
    YrVall = VallName(Year_Inx);
    YrTrID = SiteTrID(Year_Inx);
%     YrMom = SiteMother(Year_Inx);
    YrElev = SiteElev(Year_Inx);
    YrProv = SiteProv(Year_Inx);
    YrLU = SiteLU(Year_Inx);
    YrLC = SiteLC(Year_Inx);
    YrGSL = SiteGSL(Year_Inx);
        
    
    save([Path_PHE01LV3,strcat('CG',YearName,'.mat')],'-regexp','^Yr*');
        
    disp(['Done with ',YearName]);

end
