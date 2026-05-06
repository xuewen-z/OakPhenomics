
clc; clear;


Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_CG02YTMN ='../output/10_CG02YTMN_IS/';
% Path_CG02YTMN ='../output/10_CG02YTMN_IS/';
Path_BlockYr ='../output/17_BlockCG/';
Path_MixLMod ='../output/18_MixLModCG/';

% mkdir(Path_MixLMod);


load([Path_CG02YTMN,'CGYTMN_A20042020.mat']);

MLMYTmn = SiteYTmn(11:15,:);  % 19年 phenology 为NAN
MLMATmn = SiteATmn(11:15,:);  % 19年 phenology 为NAN
MLMSTmn = SiteSTmn(11:15,:);  % 19年 phenology 为NAN

     CGLU = [];
     CGLC = [];
     CGGSL = [];
     CGYTmn = [];
     CGATmn = [];
     CGSTmn = [];
     CGElev = [];
     CGBloc = [];
     CGYear = [];
     CGValy = [];
     
for Year = 2014:2018
    YearName = num2str(Year);
    
    load([Path_BlockYr,strcat('CGBlock',YearName,'.mat')]);
    load([Path_PHE01LV3,strcat('CG',YearName,'.mat')]);
    
    I_Empty = {'O1Q20-1 B1','O1Q20-2 B1','O1Q20-7 B1','O1Q20-8 B1','O1Q20-8 B2',...
    'O1Q20-1 B2','O1Q20-9 B2','O1Q20-1 B4','O1Q20-3 B4','O1Q20-4 B4','O1Q20-6 B4',...
    'O1Q20-7 B4','O1Q20-1 B5','O1Q20-2 B5','O1Q20-3 B5','O1Q20-8 B5',...
    'O8Qvrac-6 B1','O8Qvrac-7 B1','O8Qvrac-9 B1','O8Qvrac-2 B2','O8Qvrac-2 B3','O8Qvrac-3 B3',...
    'O8Qvrac-4 B4','O8Qvrac-5 B4','O8Qvrac-6 B5','O8Qvrac-12 B5','O8Qvrac-14 B5',...
    'O4Qvrac-6 B2','O4Qvrac-4 B2','O4Qvrac-6 B1','O4Qvrac-5 B1','O4Qvrac-4 B1','O4Qvrac-3 B1','O4Qvrac-1 B1',...
    'O4Qvrac-6 B4','O4Qvrac-4 B4','O4Qvrac-3 B4','O4Qvrac-2 B4','O4Qvrac-1 B5','O4Qvrac-3 B5','O4Qvrac-9 B5',...
    'O4Qvrac-10 B5','O4Qvrac-16 B5','O4Qvrac-15 B5','O4Qvrac-13 B5','O4Qvrac-12 B5','O4Qvrac-70 B5',...
    'O4Qvrac-20 B5','O4Qvrac-22 B5','O4Qvrac-27 B5','O4Qvrac-29 B5','O4Qvrac-68 B5',...
    'O4Qvrac-32 B5','O4Qvrac-35 B5','O4Qvrac-38 B5','O4Qvrac-39 B5','O4Qvrac-41 B5',...
    'O4Qvrac-42 B5','O4Qvrac-44 B5','O4Qvrac-45 B5','O4Qvrac-49 B5','O4Qvrac-50 B5',...
    'O4Qvrac-56 B5','O4Qvrac-57 B5','O4Qvrac-61 B5','O4Qvrac-62 B5','O4Qvrac-66 B5',...
    'O16Q6-1 B5','L8Q9-2 B5','L8Q9-1 B5','L3QAvrac-4 B2','O4Qvrac-7 B3','O4Qvrac-24 B5',...
    'O4Qvrac-37 B5','O8Qvrac-5 B3','O4Qvrac-7 B5','O4Qvrac-6 B5','O4Qvrac-3 B3','O4Qvrac-5 B5','O4Qvrac-63 B5'};

    EmptyInd = find(ismember(YrID,I_Empty));
    YrID(EmptyInd) = [];
    YrLU(EmptyInd) = [];
    YrLC(EmptyInd) = [];
    YrGSL(EmptyInd) = [];
    
    Num =size(YrID,1);
    Index = zeros(Num, 1);
   
    for i =1:Num
        row = ismember(MLMID,YrID(i));
        Ind = find(row==1);
        Index(i) = Ind;
    end
    
     TreeID = MLMID(Index);
     TreeBloc = MLMBloc(Index);
     TreeElev = MLMElev(Index);
     TreeValy = MLMVal(Index);
     TreeProv = MLMStat(Index);     
     TreeYear = repmat(Year,numel(Index),1);
     TreeYTmn = repmat(MLMYTmn(Year-2013,:),numel(Index),1);
     TreeATmn = repmat(MLMATmn(Year-2013,:),numel(Index),1);
     TreeSTmn = repmat(MLMSTmn(Year-2013,:),numel(Index),1);
     TreeLU = YrLU;
     TreeLC = YrLC;
     TreeGSL = YrGSL;
     
     CGLU = [CGLU;TreeLU];
     CGLC = [CGLC;TreeLC];
     CGGSL = [CGGSL;TreeGSL];
     CGYTmn = [CGYTmn;TreeYTmn];
     CGATmn = [CGATmn;TreeATmn];
     CGSTmn = [CGSTmn;TreeSTmn];
     CGElev = [CGElev;TreeElev];
     CGBloc = [CGBloc;TreeBloc];
     CGYear = [CGYear;TreeYear];
     CGValy = [CGValy;TreeValy];

end

    save([Path_MixLMod,strcat('MixModCG.A20142018.mat')],'-regexp','^CG*');  
