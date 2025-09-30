clc; clear;

Path_PHE01LV1 ='../input/';
Path_RTE02DTMN ='../output/12_RTE02DTMN/';

% mkdir(Path_RTE02DTMN);

File_RTE02TMN=dir([Path_PHE01LV1,'IS_TMean_2004-2020.csv']);
    
    % read daily data
    FileName  = File_RTE02TMN.name;   
    TableInt = readtable([Path_PHE01LV1,FileName]); 


    SiteTmn = [TableInt.Lav,TableInt.Lou,TableInt.Sireix,TableInt.Hau,TableInt.Lienz]; ;
    SiteYear = TableInt.year;
    SiteElev = [131,488,833,1190,1533];
    SiteMon = TableInt.Mon;
    
    save([Path_RTE02DTMN,'RTEDTMN.mat'],'-regexp','^Site*');

    