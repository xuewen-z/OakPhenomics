clc; clear;

Path_PHE01LV1 ='../input/';
Path_IS02DTMN ='../output/06_IS02DTMN/';

mkdir(Path_IS02DTMN);

File_IS02TMN=dir([Path_PHE01LV1,'IS_TMean_2004-2020.csv']);
File_MetaData=dir([Path_PHE01LV1,'MetaData_TMean.csv']);

   
    % read daily data
    FileName  = File_IS02TMN.name;   
    TableInt = readtable([Path_PHE01LV1,FileName]); 

    FileName  = File_MetaData.name;   
    TableProp = readtable([Path_PHE01LV1,FileName]); 

    % write to .mat
    SiteYear = TableInt.year;
    SiteTmn = TableInt(:,4:28);
    SiteTmn = table2array(SiteTmn);
    SiteCode = (TableProp.CodeSite)';
    SiteSpec = (TableProp.species)';
    SiteElev = (TableProp.Elevation)';
    SiteMon = TableInt.Mon;
    
    save([Path_IS02DTMN,'ISDTMN.mat'],'-regexp','^Site*');
  


