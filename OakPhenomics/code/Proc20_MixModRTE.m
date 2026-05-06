addpath(genpath('./'));

clc;clear;


Path_RTE02YTMN ='../output/13_RTE02YTMN/';
Path_BlockRTE ='../output/19_BlockRTE/';
Path_MixModRTE ='../output/20_MixModRTE/';

% mkdir(Path_MixModRTE);

load([Path_BlockRTE,'BlockRTE.A20072012.mat']);
load([Path_RTE02YTMN,'RTEYTMN_A20072012.mat']);

RTEYTmn = [];
RTEATmn = [];
RTESTmn = [];

RTEIDall = [];

for Year = 2007 : 2012
    
    Index = find(RTEYear == Year);
    IDTemp = RTEID(Index);
    RTEIDall = [RTEIDall; IDTemp];


    YTmnTemp = SiteYTmn(Year - 2006,:);
    ElevTemp = RTEElev(Index);
    BlocYTmn = ElevTemp;
    BlocYTmn(BlocYTmn==100) = YTmnTemp(1,1);
    BlocYTmn(BlocYTmn==400) = YTmnTemp(1,2);
    BlocYTmn(BlocYTmn==800) = YTmnTemp(1,3);
    BlocYTmn(BlocYTmn==1200) = YTmnTemp(1,4);
    BlocYTmn(BlocYTmn==1600) = YTmnTemp(1,5);
     
    RTEYTmn = [RTEYTmn;BlocYTmn];
    
    
        
    ATmnTemp = SiteATmn(Year - 2006,:);
    BlocATmn = ElevTemp;
    BlocATmn(BlocATmn==100) = ATmnTemp(1,1);
    BlocATmn(BlocATmn==400) = ATmnTemp(1,2);
    BlocATmn(BlocATmn==800) = ATmnTemp(1,3);
    BlocATmn(BlocATmn==1200) = ATmnTemp(1,4);
    BlocATmn(BlocATmn==1600) = ATmnTemp(1,5);
     
    RTEATmn = [RTEATmn;BlocATmn];

    STmnTemp = SiteSTmn(Year - 2006,:);
    BlocSTmn = ElevTemp;
    BlocSTmn(BlocSTmn==100) = STmnTemp(1,1);
    BlocSTmn(BlocSTmn==400) = STmnTemp(1,2);
    BlocSTmn(BlocSTmn==800) = STmnTemp(1,3);
    BlocSTmn(BlocSTmn==1200) = STmnTemp(1,4);
    BlocSTmn(BlocSTmn==1600) = STmnTemp(1,5);
     
    RTESTmn = [RTESTmn;BlocSTmn];

end

    % RTEID = RTEID_All;
    save([Path_MixModRTE,strcat('MixModRTE.A20072012.mat')],'-regexp','^RTE*');  