

addpath(genpath('./'));

clc;clear;
Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_CG01YR4 ='../output/05_CG01YR4/';


% initiallized
QueLUmn = [];
QueLCmn = [];
QueGSLmn = [];
    

for Year = 2009 : 2021
    YearName = num2str(Year);
      
    load([Path_PHE01LV3,strcat('CG',YearName,'.mat')]);
   
    IQueLU = YrLU;
    IQueLC = YrLC;
    IQueGSL = YrGSL;
    IQueElev = YrElev;
    IQueProv = YrProv;
%     IQueCoGa = YrCoGa;
   

    % initiallized
    IQueLUmn = [];
    IQueLCmn = [];
    IQueGSLmn = [];
    
    ProvCode = {'L1','L3','L8','L12','L16','O1','O4','O8','O12','O16'};
    for I_Site=1:numel(ProvCode)
        I_Code=strcmp(IQueProv,ProvCode(I_Site));
        
        ElevNum = unique(IQueElev(I_Code));
        
        if isempty(ElevNum) == 1 
            ElevNum =nan;
        end
               
        % LU
        Temp_QueLUmn =  nanmean(IQueLU(I_Code));
        Temp_QueLUsd =  nanstd(IQueLU(I_Code));
        
        % LC
        Temp_QueLCmn =  nanmean(IQueLC(I_Code));
        Temp_QueLCsd =  nanstd(IQueLC(I_Code));
        
        % GSL
        Temp_QueGSLmn =  nanmean(IQueGSL(I_Code));
        Temp_QueGSLsd =  nanstd(IQueGSL(I_Code));

        
        
        IQueLUmn(:,I_Site) = [Temp_QueLUmn;Temp_QueLUsd;ElevNum];  
        IQueLCmn(:,I_Site) = [Temp_QueLCmn;Temp_QueLCsd;ElevNum];  
        IQueGSLmn(:,I_Site) = [Temp_QueGSLmn;Temp_QueGSLsd;ElevNum];
   
       
    end
    
        QueLUmn(:,:,Year-2008) = IQueLUmn;
        QueLCmn(:,:,Year-2008) = IQueLCmn;
        QueGSLmn(:,:,Year-2008) = IQueGSLmn;
   
              
        disp(['Done with ',YearName]);

end

 save([Path_CG01YR4,strcat('CGmn_QueVG_A20092021.mat')],'-regexp','^Que*');

    
