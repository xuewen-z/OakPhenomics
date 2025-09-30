clc; clear;

Path_PHE01LV1 ='../input/';
Path_RTE02DTMN ='../output/12_RTE02DTMN/';
Path_RTE02YTMN ='../output/13_RTE02YTMN/';

% mkdir(Path_RTE02YTMN);

load([Path_RTE02DTMN,'RTEDTMN.mat']);
   
SiteYTmn =[];
SiteSTmn =[];
SiteATmn =[];

for Year = 2007 : 2012
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    TempMTmn = SiteMon(Index,:);
    SprIndex = find(TempMTmn == 2|TempMTmn == 3|TempMTmn==4|TempMTmn==5);
    AutIndex = find(TempMTmn == 9|TempMTmn ==10|TempMTmn==11);

    TempDTmn = SiteTmn(Index,:); 
    TempYTmn = nanmean(TempDTmn,1);
    SprDTmn = TempDTmn(SprIndex,:);
    AutDTmn = TempDTmn(AutIndex,:);

    SiteYTmn(Year - 2006,:) = TempYTmn;
    SiteSTmn(Year - 2006,:) = nanmean(SprDTmn);
    SiteATmn(Year - 2006,:) = nanmean(AutDTmn);
    
end
    SiteYear = unique(SiteYear);

    save([Path_RTE02YTMN,'RTEYTMN_A20072012.mat'],'-regexp','^Site*');
  

