clc; clear;

Path_PHE01LV1 ='../input/';
Path_CG02DTMN ='../output/09_CG02DTMN_IS/';
Path_CG02YTMN ='../output/10_CG02YTMN_IS/';

mkdir(Path_CG02YTMN);

load([Path_CG02DTMN,'CGDTMN.mat']);
   
SiteYTmn =[];
SiteSTmn =[];
SiteATmn =[];

for Year = 2004 : 2020
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    
    TempMTmn = SiteMon(Index,:);
    SprIndex = find(TempMTmn == 2|TempMTmn == 3|TempMTmn==4|TempMTmn==5);
    AutIndex = find(TempMTmn == 9|TempMTmn ==10|TempMTmn==11);

    TempDTmn = SiteTmn(Index,:); 
    TempYTmn = nanmean(TempDTmn,1);
    SprDTmn = TempDTmn(SprIndex,:);
    AutDTmn = TempDTmn(AutIndex,:);
    
    SiteYTmn(Year - 2003,:) = TempYTmn;
    SiteSTmn(Year - 2003,:) = nanmean(SprDTmn);
    SiteATmn(Year - 2003,:) = nanmean(AutDTmn);
    
end
    SiteYear = unique(SiteYear);

    save([Path_CG02YTMN,'CGYTMN_A20042020.mat'],'-regexp','^Site*');
  

