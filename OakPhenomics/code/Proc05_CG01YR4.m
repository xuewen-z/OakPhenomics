

addpath(genpath('./'));

clc;clear;
Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_CG01YR4 ='../output/05_CG01YR4/';

% mkdir(Path_CG01YR4);

% initiallized
LuzLUmn = [];
LuzLCmn = [];
LuzGSLmn = [];
    
for Year = 2009 : 2021
    YearName = num2str(Year);
      
    load([Path_PHE01LV3,strcat('CG',YearName,'.mat')]);
   
    VallCode = {'Luz'};
    Vall_Code = ismember(YrVall,VallCode);
    Vall_Index = find(Vall_Code ==1);

    ILuzLU = YrLU(Vall_Index,:);
    ILuzLC = YrLC(Vall_Index,:);
    ILuzGSL = YrGSL(Vall_Index,:);
    ILuzElev = YrElev(Vall_Index,:);
    ILuzProv = YrProv(Vall_Index,:);
%     ILuzCoGa = YrCoGa(Vall_Index,:);
   

    % initiallized
    ILuzLUmn = [];
    ILuzLCmn = [];
    ILuzGSLmn = [];
    
    ProvCode = {'L1','L3','L8','L12','L16'};
    for I_Site=1:numel(ProvCode)
        I_Code=strcmp(ILuzProv,ProvCode(I_Site));
        
        ElevNum = unique(ILuzElev(I_Code));
        
        if isempty(ElevNum) == 1 
            ElevNum =nan;
        end
               
        % LU
        Temp_LuzLUmn =  nanmean(ILuzLU(I_Code));
        Temp_LuzLUsd =  nanstd(ILuzLU(I_Code));
        
        % LC
        Temp_LuzLCmn =  nanmean(ILuzLC(I_Code));
        Temp_LuzLCsd =  nanstd(ILuzLC(I_Code));
        
        % GSL
        Temp_LuzGSLmn =  nanmean(ILuzGSL(I_Code));
        Temp_LuzGSLsd =  nanstd(ILuzGSL(I_Code));

        
        
        ILuzLUmn(:,I_Site) = [Temp_LuzLUmn;Temp_LuzLUsd;ElevNum];  
        ILuzLCmn(:,I_Site) = [Temp_LuzLCmn;Temp_LuzLCsd;ElevNum];  
        ILuzGSLmn(:,I_Site) = [Temp_LuzGSLmn;Temp_LuzGSLsd;ElevNum];
   
       
    end
    
        LuzLUmn(:,:,Year-2008) = ILuzLUmn;
        LuzLCmn(:,:,Year-2008) = ILuzLCmn;
        LuzGSLmn(:,:,Year-2008) = ILuzGSLmn;
   
              
        disp(['Done with ',YearName]);

end

        save([Path_CG01YR4,strcat('CGmn_LuzVG_A20092021.mat')],'-regexp','^Luz*');


 
% initiallized
OsaLUmn = [];
OsaLCmn = [];
OsaGSLmn = [];
    
for Year = 2009 : 2021
    YearName = num2str(Year);
      
    load([Path_PHE01LV3,strcat('CG',YearName,'.mat')]);
   
    VallCode = {'Ossau'};
    Vall_Code = ismember(YrVall,VallCode);
    Vall_Index = find(Vall_Code ==1);

    IOsaLU = YrLU(Vall_Index,:);
    IOsaLC = YrLC(Vall_Index,:);
    IOsaGSL = YrGSL(Vall_Index,:);
    IOsaElev = YrElev(Vall_Index,:);
    IOsaProv = YrProv(Vall_Index,:);
%     IOsaCoGa = YrCoGa(Vall_Index,:);


    % initiallized
    IOsaLUmn = [];
    IOsaLCmn = [];
    IOsaGSLmn = [];
    
    ProvCode = {'O1','O4','O8','O12','O16'};
    for I_Site=1:numel(ProvCode)
        I_Code=strcmp(IOsaProv,ProvCode(I_Site));
        
        ElevNum = unique(IOsaElev(I_Code));
        
        if isempty(ElevNum) == 1 
            ElevNum =nan;
        end
               
        % LU
        Temp_OsaLUmn =  nanmean(IOsaLU(I_Code));
        Temp_OsaLUsd =  nanstd(IOsaLU(I_Code));
        
        % LC
        Temp_OsaLCmn =  nanmean(IOsaLC(I_Code));
        Temp_OsaLCsd =  nanstd(IOsaLC(I_Code));
        
        % GSL
        Temp_OsaGSLmn =  nanmean(IOsaGSL(I_Code));
        Temp_OsaGSLsd =  nanstd(IOsaGSL(I_Code));

        
        
        IOsaLUmn(:,I_Site) = [Temp_OsaLUmn;Temp_OsaLUsd;ElevNum];  
        IOsaLCmn(:,I_Site) = [Temp_OsaLCmn;Temp_OsaLCsd;ElevNum];  
        IOsaGSLmn(:,I_Site) = [Temp_OsaGSLmn;Temp_OsaGSLsd;ElevNum];
   
       
    end
    
        OsaLUmn(:,:,Year-2008) = IOsaLUmn;
        OsaLCmn(:,:,Year-2008) = IOsaLCmn;
        OsaGSLmn(:,:,Year-2008) = IOsaGSLmn;
   
              
        disp(['Done with ',YearName]);

end

        save([Path_CG01YR4,strcat('CGmn_OsaVG_A20092021.mat')],'-regexp','^Osa*');
       
        
%Fig test
%     Fig = figure;
%     errorbar(LuzLUmn(3,:,1),LuzLUmn(1,:,1),LuzLUmn(2,:,1),'or');hold on;
%     errorbar(LuzLUmn(3,:,2),LuzLUmn(1,:,2),LuzLUmn(2,:,2),'ob');
%     errorbar(LuzLUmn(3,:,3),LuzLUmn(1,:,3),LuzLUmn(2,:,3),'og');
 
%     Fig = figure;
%     errorbar(LuzLCmn(3,:),LuzLCmn(1,:),LuzLCmn(2,:),'or');hold on;
%     errorbar(LuzLCmn(3,:),LuzLCmn(4,:),LuzLCmn(5,:),'ob');
%     errorbar(LuzLCmn(3,:),LuzLCmn(7,:),LuzLCmn(8,:),'og');
% 
%     Fig = figure;
%     errorbar(LuzGSLmn(3,:),LuzGSLmn(1,:),LuzGSLmn(2,:),'or');hold on;
%     errorbar(LuzGSLmn(3,:),LuzGSLmn(4,:),LuzGSLmn(5,:),'ob');
%     errorbar(LuzGSLmn(3,:),LuzGSLmn(7,:),LuzGSLmn(8,:),'og');

    
