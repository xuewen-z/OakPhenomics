
clc; clear;

Path_MixLMod ='../output/18_MixLModCG/';
Path_MixLModRTE ='../output/20_MixModRTE/';
Path_BlockYr ='../output/21_MixModIS/';
Path_MixModSlope ='../output/22_MixModSlope/';


mkdir(Path_MixModSlope);

load([Path_MixLMod,'MixModCG.A20142018.mat']);
load([Path_MixLMod,'MixModCGTmn.A20142018.mat']);
load([Path_MixLModRTE,'MixModRTE.A20072012.mat']);
load([Path_BlockYr,'MixModIS.A20052020.mat']);


 
% IS
% Table = table(ISLU,ISLC,ISGSL,ISElev,ISVally,ISYear);
% 
% LU_IS = fitlme(Table,'ISLU ~1 + ISElev + (1|ISVally) + (1|ISYear)','Exclude',3013); 
% LC_IS = fitlme(Table,'ISLC ~1 + ISElev + (1|ISVally) + (1|ISYear)','Exclude',3013);
% GSL_IS = fitlme(Table,'ISGSL ~1 + ISElev + (1|ISVally) + (1|ISYear)','Exclude',3013); 
% 
% ISSlope =[LU_IS.Coefficients; LC_IS.Coefficients; GSL_IS.Coefficients];
% ISR2 = [LU_IS.Rsquared;LC_IS.Rsquared;GSL_IS.Rsquared];
% 
% LU_IS = fitlme(Table,'ISLU ~1 + ISElev'); 
% LC_IS = fitlme(Table,'ISLC ~1 + ISElev');
% GSL_IS = fitlme(Table,'ISGSL ~1 + ISElev'); 
% 
% 
% 
% 
% % CG
% Table = table(CGLU,CGLC,CGGSL,CGYTmn,CGElev,CGValy,CGYear,CGBloc);
% 
% LU_CG = fitlme(Table,'CGLU ~1 + CGElev + (1|CGBloc) + (1|CGValy) + (1|CGYear)'); 
% LC_CG = fitlme(Table,'CGLC ~1 + CGElev + (1|CGBloc) + (1|CGValy) + (1|CGYear)'); 
% GSL_CG = fitlme(Table,'CGGSL ~1 + CGElev + (1|CGBloc) + (1|CGValy) + (1|CGYear)'); 
% 
% CGSlope =[LU_CG.Coefficients; LC_CG.Coefficients; GSL_CG.Coefficients];
% CGR2 = [LU_CG.Rsquared;LC_CG.Rsquared;GSL_CG.Rsquared];
%  
% LU_CG = fitlme(Table,'CGLU ~1 + CGElev' ); 
% LC_CG = fitlme(Table,'CGLC ~1 + CGElev'); 
% GSL_CG = fitlme(Table,'CGGSL ~1 + CGElev'); 
% 
% 
% % RTE
% Table = table(RTELU,RTELC,RTEGSL,RTEYTmn,RTEElev,RTEYear,RTEBloc);
% 
% LU_RTE = fitlme(Table,'RTELU ~1 + RTEElev + (1|RTEBloc) + (1|RTEYear)'); 
% LC_RTE = fitlme(Table,'RTELC ~1 + RTEElev + (1|RTEBloc) + (1|RTEYear)'); 
% GSL_RTE = fitlme(Table,'RTEGSL ~1 + RTEElev + (1|RTEBloc) + (1|RTEYear)'); 
% 
% RTESlope =[LU_RTE.Coefficients; LC_RTE.Coefficients; GSL_RTE.Coefficients];
% RTER2 = [LU_RTE.Rsquared;LC_RTE.Rsquared;GSL_RTE.Rsquared];
%  
% LU_RTE = fitlme(Table,'RTELU ~1 + RTEElev'); 
% LC_RTE = fitlme(Table,'RTELC ~1 + RTEElev'); 
% GSL_RTE = fitlme(Table,'RTEGSL ~1 + RTEElev'); 


%% Temperature 

% IS
Table = table(ISLU,ISLC,ISGSL,ISYTmn,ISSTmn,ISATmn,ISVally,ISYear,ISID);

LU_IS = fitlme(Table,'ISLU ~1 + ISSTmn + (1|ISVally) + (1|ISYear) + (1|ISID)'); 
LC_IS = fitlme(Table,'ISLC ~1 + ISATmn + (1|ISVally) + (1|ISYear) + (1|ISID)');
GSL_IS = fitlme(Table,'ISGSL ~1 + ISYTmn + (1|ISVally) + (1|ISYear) + (1|ISID)'); 

SlopeIS = [LU_IS.Coefficients; LC_IS.Coefficients; GSL_IS.Coefficients];
ISRc2 = [LU_IS.Rsquared;LC_IS.Rsquared;GSL_IS.Rsquared];
 
LU_IS = fitlme(Table,'ISLU ~1 + ISSTmn'); 
LC_IS = fitlme(Table,'ISLC ~1 + ISATmn');
GSL_IS = fitlme(Table,'ISGSL ~1 + ISYTmn'); 
ISRm2 = [LU_IS.Rsquared;LC_IS.Rsquared;GSL_IS.Rsquared];


% CG
Table = table(CGLU,CGLC,CGGSL,CGYTmn,CGSTmn,CGATmn,CGElev,CGValy,CGYear,CGBloc,CGID,CGProv);

LU_CG = fitlme(Table,'CGLU ~1 + CGSTmn + (1|CGBloc) + (1|CGValy) + (1|CGYear)+ (1|CGID)'); 
LC_CG = fitlme(Table,'CGLC ~1 + CGATmn + (1|CGBloc) + (1|CGValy) + (1|CGYear)+ (1|CGID)'); 
GSL_CG = fitlme(Table,'CGGSL ~1 + CGYTmn + (1|CGBloc) + (1|CGValy) + (1|CGYear)+ (1|CGID)'); 

SlopeCG =[LU_CG.Coefficients; LC_CG.Coefficients; GSL_CG.Coefficients];
CGRc2 = [LU_CG.Rsquared;LC_CG.Rsquared;GSL_CG.Rsquared];
 


% 1. 获取随机效应的协方差参数
[~, ~, stats] = covarianceParameters(LU_CG);

% 2. 提取 ID 产生的方差 (这是遗传变异的代理)
% stats 表格中 Group 为 'CGID' 的 Estimate 值
varID = stats{strcmp(stats.Group,'CGID'), 'Estimate'};

% 3. 提取其他随机效应方差
varBlock  = stats{strcmp(stats.Group,'CGBloc'), 'Estimate'};
varValley = stats{strcmp(stats.Group,'CGValy'), 'Estimate'};
varYear   = stats{strcmp(stats.Group,'CGYear'), 'Estimate'};

% 4. 提取残差方差 (Residual variance)
varResid = LU_CG.MSE; 

% 5. 计算总方差 (Total Variance)
varTotal = varID + varBlock + varValley + varYear + varResid;

% 6. 计算广义遗传力 H2
H2 = varID / varTotal;

fprintf('Leaf Unfolding 的广义遗传力 H2 = %.3f\n', H2);


LU_CG = fitlme(Table,'CGLU ~1 + CGSTmn' ); 
LC_CG = fitlme(Table,'CGLC ~1 + CGATmn'); 
GSL_CG = fitlme(Table,'CGGSL ~1 + CGYTmn'); 
CGRm2 = [LU_CG.Rsquared;LC_CG.Rsquared;GSL_CG.Rsquared];


% RTE
Table = table(RTELU,RTELC,RTEGSL,RTEYTmn,RTESTmn,RTEATmn,RTEYear,RTEBloc,RTEIDall);

LU_RTE = fitlme(Table,'RTELU ~1 + RTESTmn + (1|RTEBloc) + (1|RTEYear)+ (1|RTEIDall)'); 
LC_RTE = fitlme(Table,'RTELC ~1 + RTEATmn + (1|RTEBloc) + (1|RTEYear)+ (1|RTEIDall)'); 
GSL_RTE = fitlme(Table,'RTEGSL ~1 + RTEYTmn + (1|RTEBloc) + (1|RTEYear)+ (1|RTEIDall)'); 

SlopeRTE =[LU_RTE.Coefficients; LC_RTE.Coefficients; GSL_RTE.Coefficients];
RTER2 = [LU_RTE.Rsquared;LC_RTE.Rsquared;GSL_RTE.Rsquared];
 
LU_RTE = fitlme(Table,'RTELU ~1 + RTESTmn'); 
LC_RTE = fitlme(Table,'RTELC ~1 + RTEATmn'); 
GSL_RTE = fitlme(Table,'RTEGSL ~1 + RTEYTmn'); 

RTER2 = [LU_RTE.Rsquared;LC_RTE.Rsquared;GSL_RTE.Rsquared];

save([Path_MixModSlope,strcat('SlopeMixmod.mat')],'-regexp','^Slope*');
