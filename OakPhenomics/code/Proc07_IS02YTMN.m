clc; clear;

Path_PHE01LV1 ='../input/';
Path_IS02DTMN ='../output/06_IS02DTMN/';
Path_IS02YTMN ='../output/07_IS02YTMN/';

mkdir(Path_IS02YTMN);

load([Path_IS02DTMN,'ISDTMN.mat']);
   
SiteYTmn =[];
SiteSTmn =[];
SiteATmn =[];

for Year = 2004 : 2020
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    TempMTmn = SiteMon(Index,:);
    SprIndex = find(TempMTmn == 2|TempMTmn == 3|TempMTmn==4|TempMTmn==5);
    SumIndex = find(TempMTmn == 6|TempMTmn == 7|TempMTmn==8);
    AutIndex = find(TempMTmn == 9|TempMTmn ==10|TempMTmn==11);

    TempDTmn = SiteTmn(Index,:); 
    TempYTmn = nanmean(TempDTmn,1);
    SprDTmn = TempDTmn(SprIndex,:);
    SumDTmn = TempDTmn(SumIndex,:);
    AutDTmn = TempDTmn(AutIndex,:);
     

    SiteYTmn(Year - 2003,:) = TempYTmn;
    SiteSTmn(Year - 2003,:) = nanmean(SprDTmn);
    SiteSuTmn(Year - 2003,:) = nanmean(SumDTmn);
    SiteATmn(Year - 2003,:) = nanmean(AutDTmn);
    
end
    SiteYear = unique(SiteYear);

    SpecCode = {'Quercus petraea and Fagus sylvatica','Quercus petraea'};
    Spec_Code = ismember(SiteSpec,SpecCode);
    SpecIndex = find(Spec_Code ==1);
    
    QueYTmn = SiteYTmn(:,SpecIndex)'; 
    QueElev = SiteElev(:,SpecIndex)'; 
    QueSTmn = SiteSTmn(:,SpecIndex)'; 
    QueSuTmn = SiteSuTmn(:,SpecIndex)'; 
    QueATmn = SiteATmn(:,SpecIndex)'; 
    QueCode = SiteCode(:,SpecIndex)'; 
    QueYear = SiteYear';
    
    SpecCode = {'Fagus sylvatica'};
    Spec_Code = ismember(SiteSpec,SpecCode);
    SpecIndex = find(Spec_Code ==1);
    
    FagElev = SiteElev(:,SpecIndex)'; 
    FagYTmn = SiteYTmn(:,SpecIndex)'; 
    FagSTmn = SiteSTmn(:,SpecIndex)'; 
    FagSuTmn = SiteSuTmn(:,SpecIndex)'; 
    FagATmn = SiteATmn(:,SpecIndex)'; 
    FagCode = SiteCode(:,SpecIndex)'; 
    FagYear = SiteYear';

    save([Path_IS02YTMN,'ISYTMN_A20042020.mat'],'-regexp','^Que*','^Fag*');
  

