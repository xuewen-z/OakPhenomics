clc; clear;

Path_PHE01LV1 ='../input/';
Path_PHE01LV2 ='../output/01_PHE01LV2/';

% rmdir(Path_VE01LV2);
% mkdir(Path_PHE01LV2);

File_RTE01LV1=dir([Path_PHE01LV1,'RTE_PHENO_2007-2012.csv']);

% parfor I_File=1:numel(File_VE01LV1)
for I_File=1
    
    % read daily data
    FileYear  = split(File_RTE01LV1(I_File).name,'_');
    FileYear  = FileYear{3};
    BgnYear   = str2double(FileYear(1:4));
    EndYear   = str2double(FileYear(end-3:end));
    
    FileName  = File_RTE01LV1(I_File).name;   
    TableInt = readtable([Path_PHE01LV1,FileName]);
   

% write to .mat

    SiteTrID = TableInt.ID;
    SiteTrait = TableInt.Traitement;
    SiteYear = TableInt.Year;
    SiteElev = TableInt.Elevation; 

    SiteBloc = TableInt.X; 
    TreeSpecie = TableInt.Species;
    TreeProv = TableInt.Provenance;
    TreeLU = TableInt.LU;
    TreeLC = TableInt.LC;
    TreeGSL = TreeLC - TreeLU;
    
    save([Path_PHE01LV2,'NormRTE.mat'],'-regexp','^Site*','^Tree*');
  

end
 
%% IS
TableOut=readtable([Path_PHE01LV1,'IS_Pheno_2005-2015.csv']);
TableOut1=readtable([Path_PHE01LV1,'IS_Pheno_2016-2021.csv']);

% write to .mat
    SiteName = [TableOut.SiteName;TableOut1.SiteName];
    VallName = [TableOut.Valley;TableOut1.Valley];
    SiteYear = [TableOut.Year;TableOut1.Year];
    SiteElev = [TableOut.Elevation;TableOut1.Elevation];
    SiteProv = [TableOut.Prove;TableOut1.Prove];
    SiteLU = [TableOut.LU;TableOut1.LU];
    SiteLC = [TableOut.LC;nan(2881,1)];
    SiteGSL = [TableOut.GS;nan(2881,1)];
    
save([Path_PHE01LV2,'NormIS.mat'],'-regexp','^Site*','^Vall*');


%% CG
TableOut = readtable([Path_PHE01LV1,'CG_Pheno_2009-2015.csv']);
TableOut1 = readtable([Path_PHE01LV1,'CG_Pheno_2016-2021.csv']);
    
    SiteName = [TableOut.SiteName;TableOut1.SiteName];
    VallName = [TableOut.Valley;TableOut1.Valley];
    SiteTrID = [TableOut.ID;TableOut1.ID];
%     SiteMother = TableOut.Mother;
    
    SiteYear = [TableOut.Year;TableOut1.Year];
    SiteElev = [TableOut.Elevation;TableOut1.Elevation];
    SiteProv = [TableOut.Prove;TableOut1.Prove];
    SiteLU = [TableOut.LU;TableOut1.LU];
    SiteLC = [TableOut.LC;TableOut1.LS];
    SiteGSL = [TableOut.GS;TableOut1.GS];
    
    save([Path_PHE01LV2,'NormCG.mat'],'-regexp','^Site*','^Vall*');

    disp(['Done with All']);

