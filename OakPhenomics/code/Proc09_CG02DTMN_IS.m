clc; clear;

Path_PHE01LV1 ='../input/';
Path_CG02DTMN ='../output/09_CG02DTMN_IS/';

mkdir(Path_CG02DTMN);

File_IS02TMN=dir([Path_PHE01LV1,'IS_TMean_2004-2020.csv']);
File_MetaData=dir([Path_PHE01LV1,'MetaData_TMean.csv']);

   
    % read daily data
    FileName  = File_IS02TMN.name;   
    TableInt = readtable([Path_PHE01LV1,FileName]); 

    FileName  = File_MetaData.name;   
    TableProp = readtable([Path_PHE01LV1,FileName]); 

    % write to .mat
    SiteYear = TableInt.year;
    SiteTmn = TableInt(:,[4:5,10,13,15,18,20,22,24:25]);
    SiteTmn = table2array(SiteTmn);
    SiteCode = TableProp([1:2,7,10,12,15,17,19,21:22],3);
    SiteElev = TableProp([1:2,7,10,12,15,17,19,21:22],9);
    SiteMon = TableInt.Mon;
    save([Path_CG02DTMN,'CGDTMN.mat'],'-regexp','^Site*');
  


