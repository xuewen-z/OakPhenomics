clc; clear;

Path_CG01YR4 ='../output/05_CG01YR4/';
Path_CG02YTMN ='../output/10_CG02YTMN_CG/';
Path_CGPHE2TMN ='../output/11_CGPHE2TMN_CG/';

% mkdir(Path_CGPHE2TMN);

load([Path_CG01YR4,strcat('CGmn_LuzVG_A20092021.mat')]);
load([Path_CG01YR4,strcat('CGmn_OsaVG_A20092021.mat')]);
load([Path_CG02YTMN,'CGYTMN_A20092019.mat']);

% QueLUmn = [reshape(LuzLUmn(1,:,:),[],13);reshape(OsaLUmn(1,:,:),[],13)];
% QueLCmn = [reshape(LuzLCmn(1,:,:),[],13);reshape(OsaLCmn(1,:,:),[],13)];
% QueGSLmn = [reshape(LuzGSLmn(1,:,:),[],13);reshape(OsaGSLmn(1,:,:),[],13)];
QueElevPHE = [reshape(LuzLUmn(3,:,:),[],13);reshape(OsaLUmn(3,:,:),[],13)]';
QueElevPHE = QueElevPHE(1,:);

QueSTmn = SiteSTmn';
QueATmn = SiteATmn';
% QueLTmn = SiteLTmn';
% QueETmn = SiteETmn';
QueYTmn = SiteYTmn';
% scatter(QueYTmn(:,1),QueLUmn(:,1));

QueSTmn = repmat(QueSTmn,10,1);
QueATmn = repmat(QueATmn,10,1);
% QueETmn = repmat(QueETmn,10,1);
% QueLTmn = repmat(QueLTmn,10,1);
QueYTmn = repmat(QueYTmn,10,1);

save([Path_CGPHE2TMN,'CG2PHENTMN_A20092019.mat'],'-regexp','^Que*');

