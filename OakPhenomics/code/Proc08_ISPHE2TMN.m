clc; clear;

Path_IS01YR4 ='../output/04_IS01YR4/';
Path_IS02YTMN ='../output/07_IS02YTMN/';
Path_ISPHE2TMN ='../output/08_ISPHE2TMN/';

% mkdir(Path_ISPHE2TMN);

load([Path_IS01YR4,strcat('ISmn_QueVP_A20052021.mat')]);
load([Path_IS02YTMN,'ISYTMN_A20042020.mat']);


QueLUstd = reshape(QueLUmn(2,:,1:16),[],16);
QueLCstd = reshape(QueLCmn(2,:,1:16),[],16);
QueGSLstd = reshape(QueGSLmn(2,:,1:16),[],16);
QueLUmn = reshape(QueLUmn(1,:,1:16),[],16);
QueLCmn = reshape(QueLCmn(1,:,1:16),[],16);
QueGSLmn = reshape(QueGSLmn(1,:,1:16),[],16);
% QueElevPHE =QueElev;

QueYTmn = QueYTmn(:,[2:17]);
QueSTmn = QueSTmn(:,[2:17]);
QueSuTmn = QueSuTmn(:,[2:17]);
QueATmn = QueATmn(:,[2:17]);


% scatter(QueYTmn(:,1),QueGSLmn(:,1));

save([Path_ISPHE2TMN,'ISPHE2TMN_A20052020.mat'],'-regexp','^Que*');

