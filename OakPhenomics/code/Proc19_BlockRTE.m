addpath(genpath('./'));

clc;clear;
Path_PHE01LV2 ='../output/01_PHE01LV2/';
Path_BlockRTE ='../output/19_BlockRTE/';


load([Path_PHE01LV2,'NormRTE.mat']);

mkdir(Path_BlockRTE);
    
    TraitCode = {'Gap'};
    Gap_Code = ismember(SiteTrait,TraitCode);
    Gap_Index = find(Gap_Code ==1);
   
    TreeCode = {'Quercus'};
    Tree_Code = ismember(TreeSpecie,TreeCode);
    Tree_Index = find(Tree_Code ==1);

    I_Index = intersect(Tree_Index,Gap_Index);
    
    RTEBloc =  SiteBloc(I_Index);
    RTEYear =  SiteYear(I_Index);
    RTEElev =  SiteElev(I_Index);
    RTELU =  TreeLU(I_Index);
    RTELC =  TreeLC(I_Index);
    RTEGSL =  TreeGSL(I_Index);
    
    save([Path_BlockRTE,strcat('BlockRTE.A20072012.mat')],'-regexp','^RTE*');  