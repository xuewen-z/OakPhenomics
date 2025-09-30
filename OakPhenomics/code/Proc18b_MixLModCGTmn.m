addpath(genpath('./'));

clc;clear;


Path_CG02YTMN ='../output/10_CG02YTMN_IS/';
Path_MixLMod ='../output/18_MixLModCG/';

% mkdir(Path_MixLModCG);

load([Path_CG02YTMN,'CGYTMN_A20042020.mat']);
load([Path_MixLMod,'MixModCG.A20142018.mat']);

CGYTmn = [];
CGATmn = [];
CGSTmn = [];
SiteYTmn = SiteYTmn(11:15,:);
SiteATmn = SiteATmn(11:15,:);
SiteSTmn = SiteSTmn(11:15,:);

for Year = 2014 : 2018
    
    Index = find(CGYear == Year);
    YTmnTemp = SiteYTmn(Year - 2013,:);
    ElevTemp = CGElev(Index);
    BlocYTmn = ElevTemp;
    BlocYTmn(BlocYTmn==131) = YTmnTemp(1,1);
    BlocYTmn(BlocYTmn==387) = YTmnTemp(1,2);
    BlocYTmn(BlocYTmn==803) = YTmnTemp(1,3);
    BlocYTmn(BlocYTmn==1235) = YTmnTemp(1,4);
    BlocYTmn(BlocYTmn==1630) = YTmnTemp(1,5);
    BlocYTmn(BlocYTmn==259) = YTmnTemp(1,6);
    BlocYTmn(BlocYTmn==422) = YTmnTemp(1,7);
    BlocYTmn(BlocYTmn==841) = YTmnTemp(1,8);
    BlocYTmn(BlocYTmn==1194) = YTmnTemp(1,9);
    BlocYTmn(BlocYTmn==1614) = YTmnTemp(1,10);
    
    STmnTemp = SiteSTmn(Year - 2013,:);
    BlocSTmn = ElevTemp;
    BlocSTmn(BlocSTmn==131) = STmnTemp(1,1);
    BlocSTmn(BlocSTmn==387) = STmnTemp(1,2);
    BlocSTmn(BlocSTmn==803) = STmnTemp(1,3);
    BlocSTmn(BlocSTmn==1235) = STmnTemp(1,4);
    BlocSTmn(BlocSTmn==1630) = STmnTemp(1,5);
    BlocSTmn(BlocSTmn==259) = STmnTemp(1,6);
    BlocSTmn(BlocSTmn==422) = STmnTemp(1,7);
    BlocSTmn(BlocSTmn==841) = STmnTemp(1,8);
    BlocSTmn(BlocSTmn==1194) = STmnTemp(1,9);
    BlocSTmn(BlocSTmn==1614) = STmnTemp(1,10);
    
        
    ATmnTemp = SiteATmn(Year - 2013,:);
    ElevTemp = CGElev(Index);
    BlocATmn = ElevTemp;
    BlocATmn(BlocATmn==131) = ATmnTemp(1,1);
    BlocATmn(BlocATmn==387) = ATmnTemp(1,2);
    BlocATmn(BlocATmn==803) = ATmnTemp(1,3);
    BlocATmn(BlocATmn==1235) = ATmnTemp(1,4);
    BlocATmn(BlocATmn==1630) = ATmnTemp(1,5);
    BlocATmn(BlocATmn==259) = ATmnTemp(1,6);
    BlocATmn(BlocATmn==422) = ATmnTemp(1,7);
    BlocATmn(BlocATmn==841) = ATmnTemp(1,8);
    BlocATmn(BlocATmn==1194) = ATmnTemp(1,9);
    BlocATmn(BlocATmn==1614) = ATmnTemp(1,10);
    
    CGYTmn = [CGYTmn;BlocYTmn];
    CGATmn = [CGATmn;BlocATmn];
    CGSTmn = [CGSTmn;BlocSTmn];

end

    save([Path_MixLMod,strcat('MixModCGTmn.A20142018.mat')],'-regexp','^CG*');  