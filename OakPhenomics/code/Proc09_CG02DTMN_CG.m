clc; clear;

Path_PHE01LV1 ='../input/';
Path_CG02DTMN ='../output/09_CG02DTMN_CG/';

mkdir(Path_CG02DTMN);

File_CG02TMN=dir([Path_PHE01LV1,'CG_TMean_2009-2019.csv']);

for I_File=1
    
    % read daily data
    FileYear  = split(File_CG02TMN(I_File).name,'_');    
    FileName  = File_CG02TMN(I_File).name;   
    TableInt = readtable([Path_PHE01LV1,FileName]); 

% write to .mat

    SiteYear = TableInt.Year;
    SiteDTmn = TableInt.Toul;
    SiteMon = TableInt.Month;
    save([Path_CG02DTMN,'CGDTMN.mat'],'-regexp','^Site*');
  

end
 
