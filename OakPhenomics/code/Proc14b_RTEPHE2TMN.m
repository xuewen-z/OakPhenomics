clc; clear;

Path_RTE01YR4 ='../output/03_RTE01YR4/';
Path_RTE02YTMN ='../output/13_RTE02YTMN/';
Path_RTEPHE2TMN ='../output/14b_RTEPHE2TMN/';

mkdir(Path_RTEPHE2TMN);

load([Path_RTE01YR4,strcat('RTEmn_QueGap_A20072012.mat')]);
load([Path_RTE02YTMN,'RTEYTMN_A20072012.mat']);

for I_Year = 1:6 

    TemLU = QueLUmn(:,:,I_Year); 
    TemLU(3,:) = SiteYTmn(I_Year,:);
    TemLU(6,:) = SiteYTmn(I_Year,:);
    TemLU(9,:) = SiteYTmn(I_Year,:);
    QueLUmn(:,:,I_Year) = TemLU;

    TemLC = QueLCmn(:,:,I_Year); 
    TemLC(3,:) = SiteYTmn(I_Year,:);
    TemLC(6,:) = SiteYTmn(I_Year,:);
    TemLC(9,:) = SiteYTmn(I_Year,:);
    QueLCmn(:,:,I_Year) = TemLC;

    TemGSL = QueGSLmn(:,:,I_Year); 
    TemGSL(3,:) = SiteYTmn(I_Year,:);
    TemGSL(6,:) = SiteYTmn(I_Year,:);
    TemGSL(9,:) = SiteYTmn(I_Year,:);
    QueGSLmn(:,:,I_Year) = TemGSL;

end
    QueYTmn = SiteYTmn;
    

save([Path_RTEPHE2TMN,'RTEPHE2TMN_A20072012.mat'],'-regexp','^Que*');

