

addpath(genpath('./'));

clc;clear;
Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_IS01YR4 ='../output/04_IS01YR4/';

% mkdir(Path_IS01YR4);

% initiallized
QueLUmn = [];
QueLCmn = [];
QueGSLmn = [];
    
for Year = 2005:2021
    YearName = num2str(Year);
      
    load([Path_PHE01LV3,strcat('IS',YearName,'.mat')]);

    IQueLU = YrLU;
    IQueLC = YrLC;
    IQueGSL = YrGSL;
    IQueElev = YrElev;
    IQueProv = YrProv;
   

    % initiallized
    IQueLUmn = [];
    IQueLCmn = [];
    IQueGSLmn = [];
    
    ProvCode = {'L1','L3','L4','L6','L8','L10','L12','L13','L16','O1','O4','O8','O12','O16'};
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
    
        QueLUmn(:,:,Year-2004) = IQueLUmn;
        QueLCmn(:,:,Year-2004) = IQueLCmn;
        QueGSLmn(:,:,Year-2004) = IQueGSLmn;
   
              
        disp(['Done with ',YearName]);

end

        save([Path_IS01YR4,strcat('ISmn_QueVP_A20052021.mat')],'-regexp','^Que*');


% initiallized
% FagLUmn = [];
% FagLCmn = [];
% FagGSLmn = [];
%     
% for Year = 2005 : 2015
%     YearName = num2str(Year);
%       
%     load([Path_PHE01LV3,strcat('IS',YearName,'.mat')]);
%    
%     VallCode = {'Ossau'};
%     Vall_Code = ismember(YrVall,VallCode);
%     Vall_Index = find(Vall_Code ==1);
% 
%     IFagLU = YrLU;
%     IFagLC = YrLC;
%     IFagGSL = YrGSL;
%     IFagElev = YrElev;
%     IFagProv = YrProv;
%    
% 
%     % initiallized
%     IFagLUmn = [];
%     IFagLCmn = [];
%     IFagGSLmn = [];
%     
%     ProvCode = {'O1','O4','O8','O12','O16'};
%     for I_Site=1:numel(ProvCode)
%         I_Code=strcmp(IFagProv,ProvCode(I_Site));
%         
%         ElevNum = unique(IFagElev(I_Code));
%         
%         if isempty(ElevNum) == 1 
%             ElevNum =nan;
%         end
%                
%         % LU
%         Temp_FagLUmn =  nanmean(IFagLU(I_Code));
%         Temp_FagLUsd =  nanstd(IFagLU(I_Code));
%         
%         % LC
%         Temp_FagLCmn =  nanmean(IFagLC(I_Code));
%         Temp_FagLCsd =  nanstd(IFagLC(I_Code));
%         
%         % GSL
%         Temp_FagGSLmn =  nanmean(IFagGSL(I_Code));
%         Temp_FagGSLsd =  nanstd(IFagGSL(I_Code));
% 
%         
%         
%         IFagLUmn(:,I_Site) = [Temp_FagLUmn;Temp_FagLUsd;ElevNum];  
%         IFagLCmn(:,I_Site) = [Temp_FagLCmn;Temp_FagLCsd;ElevNum];  
%         IFagGSLmn(:,I_Site) = [Temp_FagGSLmn;Temp_FagGSLsd;ElevNum];
%    
%        
%     end
%     
%         FagLUmn(:,:,Year-2004) = IFagLUmn;
%         FagLCmn(:,:,Year-2004) = IFagLCmn;
%         FagGSLmn(:,:,Year-2004) = IFagGSLmn;
%    
%               
%         disp(['Done with ',YearName]);
% 
% end
% 
%         save([Path_IS01YR4,strcat('ISmn_FagVP_A20052015.mat')],'-regexp','^Fag*');

%Fig test
%     Fig = figure;
%     errorbar(FagLUmn(3,:,1),FagLUmn(1,:,1),FagLUmn(2,:,1),'or');hold on;
%     errorbar(FagLUmn(3,:,2),FagLUmn(1,:,2),FagLUmn(2,:,2),'ob');
%     errorbar(FagLUmn(3,:,3),FagLUmn(1,:,3),FagLUmn(2,:,3),'og');
 
    
