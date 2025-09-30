addpath(genpath('./'));

clc;clear;

Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_ISPHE2TMN ='../output/08_ISPHE2TMN/';
Path_BlockYr ='../output/21_MixModIS/';

% mkdir(Path_MixLModIS);

load([Path_ISPHE2TMN,'ISPHE2TMN_A20052020.mat']);

ISYTmn = [];
ISATmn = [];
ISSTmn = [];
ISLU = [];
ISLC = [];
ISGSL = [];
ISElev = [];
ISVally = [];
ISYear = [];

QueYTmn=QueYTmn';
QueYTmn([4,9,16],:)=nan; % No phenology
QueATmn=QueATmn';
QueATmn([4,9,16],:)=nan; % No phenology
QueSTmn=QueSTmn';
QueSTmn([4,9,16],:)=nan; % No phenology

for Year = 2005 : 2020
    YearName = num2str(Year);
   
    load([Path_PHE01LV3,strcat('IS',YearName,'.mat')]);
    
    YTmnTemp = QueYTmn(Year - 2004,:);
  
    BlocYTmn = nan(size(YrProv));
    BlocYTmn(find(strcmp(YrProv,'L1'))) = YTmnTemp(1,1); 
    BlocYTmn(find(strcmp(YrProv,'L3'))) = YTmnTemp(1,2); 
    BlocYTmn(find(strcmp(YrProv,'L4'))) = YTmnTemp(1,3);
    BlocYTmn(find(strcmp(YrProv,'L6'))) = YTmnTemp(1,4);
    BlocYTmn(find(strcmp(YrProv,'L8')))  = YTmnTemp(1,5);
    BlocYTmn(find(strcmp(YrProv,'L10'))) = YTmnTemp(1,6);
    BlocYTmn(find(strcmp(YrProv,'L12'))) = YTmnTemp(1,7);
    BlocYTmn(find(strcmp(YrProv,'L13'))) = YTmnTemp(1,8);
    BlocYTmn(find(strcmp(YrProv,'L16'))) = YTmnTemp(1,9);
    BlocYTmn(find(strcmp(YrProv,'O1'))) = YTmnTemp(1,10);
    BlocYTmn(find(strcmp(YrProv,'O4'))) = YTmnTemp(1,11);
    BlocYTmn(find(strcmp(YrProv,'O8'))) = YTmnTemp(1,12);
    BlocYTmn(find(strcmp(YrProv,'O12'))) = YTmnTemp(1,13);
    BlocYTmn(find(strcmp(YrProv,'O16'))) = YTmnTemp(1,14);
    
    % 
    ATmnTemp = QueATmn(Year - 2004,:);
  
    BlocATmn = nan(size(YrProv));
    BlocATmn(find(strcmp(YrProv,'L1'))) = ATmnTemp(1,1); 
    BlocATmn(find(strcmp(YrProv,'L3'))) = ATmnTemp(1,2); 
    BlocATmn(find(strcmp(YrProv,'L4'))) = ATmnTemp(1,3);
    BlocATmn(find(strcmp(YrProv,'L6'))) = ATmnTemp(1,4);
    BlocATmn(find(strcmp(YrProv,'L8')))  = ATmnTemp(1,5);
    BlocATmn(find(strcmp(YrProv,'L10'))) = ATmnTemp(1,6);
    BlocATmn(find(strcmp(YrProv,'L12'))) = ATmnTemp(1,7);
    BlocATmn(find(strcmp(YrProv,'L13'))) = ATmnTemp(1,8);
    BlocATmn(find(strcmp(YrProv,'L16'))) = ATmnTemp(1,9);
    BlocATmn(find(strcmp(YrProv,'O1'))) = ATmnTemp(1,10);
    BlocATmn(find(strcmp(YrProv,'O4'))) = ATmnTemp(1,11);
    BlocATmn(find(strcmp(YrProv,'O8'))) = ATmnTemp(1,12);
    BlocATmn(find(strcmp(YrProv,'O12'))) = ATmnTemp(1,13);
    BlocATmn(find(strcmp(YrProv,'O16'))) = ATmnTemp(1,14);
    
    % 
    STmnTemp = QueSTmn(Year - 2004,:);
  
    BlocSTmn = nan(size(YrProv));
    BlocSTmn(find(strcmp(YrProv,'L1'))) = STmnTemp(1,1); 
    BlocSTmn(find(strcmp(YrProv,'L3'))) = STmnTemp(1,2); 
    BlocSTmn(find(strcmp(YrProv,'L4'))) = STmnTemp(1,3);
    BlocSTmn(find(strcmp(YrProv,'L6'))) = STmnTemp(1,4);
    BlocSTmn(find(strcmp(YrProv,'L8')))  = STmnTemp(1,5);
    BlocSTmn(find(strcmp(YrProv,'L10'))) = STmnTemp(1,6);
    BlocSTmn(find(strcmp(YrProv,'L12'))) = STmnTemp(1,7);
    BlocSTmn(find(strcmp(YrProv,'L13'))) = STmnTemp(1,8);
    BlocSTmn(find(strcmp(YrProv,'L16'))) = STmnTemp(1,9);
    BlocSTmn(find(strcmp(YrProv,'O1'))) = STmnTemp(1,10);
    BlocSTmn(find(strcmp(YrProv,'O4'))) = STmnTemp(1,11);
    BlocSTmn(find(strcmp(YrProv,'O8'))) = STmnTemp(1,12);
    BlocSTmn(find(strcmp(YrProv,'O12'))) = STmnTemp(1,13);
    BlocSTmn(find(strcmp(YrProv,'O16'))) = STmnTemp(1,14);
    

    ISYTmn = [ISYTmn;BlocYTmn];
    ISATmn = [ISATmn;BlocATmn];
    ISSTmn = [ISSTmn;BlocSTmn];
    ISLU = [ISLU;YrLU];
    ISLC = [ISLC;YrLC];
    ISGSL = [ISGSL;YrGSL];
    ISElev = [ISElev;YrElev];
    ISVally = [ISVally;YrVall];
    ISYear = [ISYear;repmat(Year,numel(YrLU),1)];
end

    save([Path_BlockYr,strcat('MixModIS.A20052020.mat')],'-regexp','^IS*');  