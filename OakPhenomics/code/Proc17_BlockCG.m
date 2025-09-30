
clc; clear;

Path_BlockV2 ='../output/16_BlockV2/';
Path_BlockYr ='../output/17_BlockCG/';

mkdir(Path_BlockYr);

load([Path_BlockV2,'BlockCG.mat']);
   
for Year = 2014 : 2019
    YearName = num2str(Year);
    
    Index = find(SiteYear == Year);
    TempBlock = SiteBlock(Index,:); 
    MLMBloc = TempBlock;
 
    TempElev = SiteElev(Index,:); 
    MLMElev = TempElev;

    TempVally = SiteVally(Index,:); 
    MLMVal = TempVally;

    TempID = SiteID(Index,:); 
    MLMID = TempID;

    TempStat = SiteStat(Index,:); 
    MLMStat = TempStat;

    save([Path_BlockYr,strcat('CGBlock',YearName,'.mat')],'-regexp','^MLM*');  
   
    disp(['Done', YearName])
end

