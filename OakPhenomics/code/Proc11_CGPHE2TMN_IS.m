clc; clear;

Path_CG01YR4 ='../output/05_CG01YR4/';
Path_CG02YTMN ='../output/10_CG02YTMN_IS/';
Path_CGPHE2TMN ='../output/11_CGPHE2TMN_IS/';

% mkdir(Path_CGPHE2TMN);

load([Path_CG01YR4,strcat('CGmn_QueVG_A20092021.mat')]);
load([Path_CG02YTMN,'CGYTMN_A20042020.mat']);

QueLUstd = reshape(QueLUmn(2,:,1:12),[],12);
QueLCstd = reshape(QueLCmn(2,:,1:12),[],12);
QueGSLstd = reshape(QueGSLmn(2,:,1:12),[],12);

QueLUmn = reshape(QueLUmn(1,:,1:12),[],12);
QueLCmn = reshape(QueLCmn(1,:,1:12),[],12);
QueGSLmn = reshape(QueGSLmn(1,:,1:12),[],12);
QueProv = SiteElev;
QueCode = SiteCode;

QueYTmn = SiteYTmn([6:17],:)';
QueSTmn = SiteSTmn([6:17],:)';
QueATmn = SiteATmn([6:17],:)';
% scatter(QueYTmn(:,1),QueLUmn(:,1));


save([Path_CGPHE2TMN,'CGPHE2TMN_A20092020.mat'],'-regexp','^Que*');

