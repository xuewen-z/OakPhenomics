clc; clear;

Path_PHE01LV1 ='../input/';
Path_CG02DTMN ='../output/09_CG02DTMN_CG/';
Path_CG02YTMN ='../output/10_CG02YTMN_CG/';

% mkdir(Path_CG02YTMN);

load([Path_CG02DTMN,'CGDTMN.mat']);
   
SiteYTmn =[];
SiteSTmn =[];
SiteATmn =[];

for Year = 2009 : 2019
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    TempMTmn = SiteMon(Index,:);
    SprIndex = find(TempMTmn == 2|TempMTmn == 3|TempMTmn==4|TempMTmn==5);
    AutIndex = find(TempMTmn == 9|TempMTmn ==10|TempMTmn==11);
%     LaFrost = find(TempMTmn == 4);
%     ErFrost = find(TempMTmn == 9);
    
    TempDTmn = SiteDTmn(Index,:); 
    SprDTmn = TempDTmn(SprIndex,:);
    AutDTmn = TempDTmn(AutIndex,:);
%     LatFDTmn = TempDTmn(LaFrost,:);
%     ErlFDTmn = TempDTmn(ErFrost,:);

    TempYTmn = nanmean(TempDTmn,1);

    SiteSTmn(Year - 2008,:) = nanmean(SprDTmn);
    SiteATmn(Year - 2008,:) = nanmean(AutDTmn);
    SiteYTmn(Year - 2008,:) = TempYTmn;
%     SiteLTmn(Year - 2008,:) = nanmean(LatFDTmn(11:20));
%     SiteETmn(Year - 2008,:) = nanmean(ErlFDTmn(1:10));

end
    SiteYear = unique(SiteYear);
    save([Path_CG02YTMN,'CGYTMN_A20092019.mat'],'-regexp','^Site*');   
    
% % Early/Late Frost    
%     
% for Year = 2009 : 2019
%     YearName = num2str(Year);
%     
%     Index = find(SiteYear == Year);
%     TempMTmn = SiteMon(Index,:);
% 
% 
%     TempDTmn = SiteDTmn(Index,:); 
% 
%     
% end


