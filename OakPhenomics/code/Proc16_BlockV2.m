
clc; clear;

Path_BlockV1 ='../input/';
Path_BlockV2 ='../output/16_BlockV2/';

mkdir(Path_BlockV2);

TableOut=readtable([Path_BlockV1,'CG_Block.csv']);

SiteYear = TableOut.Year;
SiteStat = TableOut.Station;
SiteElev = TableOut.Alt;
SiteVally = TableOut.Valley;
SiteBlock = TableOut.Bloc_Toul;
SiteID = TableOut.ID;

save([Path_BlockV2,'BlockCG.mat'],'-regexp','^Site*');

TableOut=readtable([Path_BlockV1,'RTE_Block.csv']);
SiteSpec = TableOut.Species;
SiteStat = TableOut.Station;
SiteElev = TableOut.Alt;
SiteVally = TableOut.Valley;
SiteBlock = TableOut.Bloc;
SiteID = TableOut.Code;

save([Path_BlockV2,'BlockRTE.mat'],'-regexp','^Site*');
