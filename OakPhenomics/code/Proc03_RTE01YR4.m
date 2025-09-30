

addpath(genpath('./'));

clc;clear;
Path_PHE01LV3 ='../output/02_PHE01LV3/';
Path_RTE01YR4 ='../output/03_RTE01YR4/';

mkdir(Path_RTE01YR4);

% initiallized
% FagLUmn = [];
% FagLCmn = [];
% FagGSLmn = [];
%     
% for Year = 2007 : 2012
%     YearName = num2str(Year);
%       
%     load([Path_PHE01LV3,strcat('RTE',YearName,'.mat')]);
%    
%     TraitCode = {'Shade'};
%     Gap_Code = ismember(YrTrait,TraitCode);
%     Gap_Index = find(Gap_Code ==1);
% 
%     TreeCode = {'Fagus'};
%     Tree_Code = ismember(YrTree,TreeCode);
%     Tree_Index = find(Tree_Code ==1);
% 
%     % initiallized
%     VEFagLUmn = [];
%     VEFagLCmn = [];
%     VEFagGSLmn = [];
%     
%     
%     for ProvCode = 400 : 400: 1200
%         Pro_Code = ismember(YrProv,ProvCode);
%         Pro_Index = find(Pro_Code ==1);
% 
%         I_Index = intersect(intersect(Tree_Index,Pro_Index),Gap_Index);
% 
%         IFagLU = YrLU(I_Index,:);
%         IFagLC = YrLC(I_Index,:);
%         IFagGSL = YrGSL(I_Index,:);
%         IFagElev = YrElev(I_Index,:);
% 
%         ElevCode = {'100','400','800','1200','1600'};
%         
%         for I_Site=1:numel(ElevCode)
%             I_Code=ismember(IFagElev,str2double(ElevCode(I_Site)));
%             ElevNum = str2double(ElevCode(I_Site));
%             
%             % LU
%             Temp_FagLUmn =  nanmean(IFagLU(I_Code));
%             Temp_FagLUsd =  nanstd(IFagLU(I_Code));
% 
%             % LC
%             Temp_FagLCmn =  nanmean(IFagLC(I_Code));
%             Temp_FagLCsd =  nanstd(IFagLC(I_Code));
% 
%             % GSL
%             Temp_FagGSLmn =  nanmean(IFagGSL(I_Code));
%             Temp_FagGSLsd =  nanstd(IFagGSL(I_Code));
% 
%             IFagLUmn(:,I_Site) = [Temp_FagLUmn;Temp_FagLUsd;ElevNum];  
%             IFagLCmn(:,I_Site) = [Temp_FagLCmn;Temp_FagLCsd;ElevNum];  
%             IFagGSLmn(:,I_Site) = [Temp_FagGSLmn;Temp_FagGSLsd;ElevNum];
%             
%         end
%              
%             VEFagLUmn = [VEFagLUmn;IFagLUmn];
%             VEFagLCmn = [VEFagLCmn;IFagLCmn];
%             VEFagGSLmn = [VEFagGSLmn;IFagGSLmn];
%        
%     end
%         FagLUmn(:,:,Year-2006) = VEFagLUmn;
%         FagLCmn(:,:,Year-2006) = VEFagLCmn;
%         FagGSLmn(:,:,Year-2006) = VEFagGSLmn;
%    
%               
%         disp(['Done with ',YearName]);
% 
% end
% 
% %         save([Path_RTE01YR4,strcat('RTEmn_FagGap_A20072012.mat')],'-regexp','^Fag*');
%         save([Path_RTE01YR4,strcat('RTEmn_FagShade_A20072012.mat')],'-regexp','^Fag*');

        
%% QUE
    QueLUmn = [];
    QueLCmn = [];
    QueGSLmn = [];

for Year = 2007 : 2012
    YearName = num2str(Year);
      
    load([Path_PHE01LV3,strcat('RTE',YearName,'.mat')]);
   
    TraitCode = {'Gap'};
    Gap_Code = ismember(YrTrait,TraitCode);
    Gap_Index = find(Gap_Code ==1);

    TreeCode = {'Quercus'};
    Tree_Code = ismember(YrTree,TreeCode);
    Tree_Index = find(Tree_Code ==1);

    % initiallized
    VEQueLUmn = [];
    VEQueLCmn = [];
    VEQueGSLmn = [];
    
    for ProvCode = 400 : 400: 1200
        Pro_Code = ismember(YrProv,ProvCode);
        Pro_Index = find(Pro_Code ==1);

        I_Index = intersect(intersect(Tree_Index,Pro_Index),Gap_Index);

        IQueLU = YrLU(I_Index,:);
        IQueLC = YrLC(I_Index,:);
        IQueGSL = YrGSL(I_Index,:);
        IQueElev = YrElev(I_Index,:);

        ElevCode = {'100','400','800','1200','1600'};
        
        for I_Site=1:numel(ElevCode)
            I_Code=ismember(IQueElev,str2double(ElevCode(I_Site)));
            ElevNum = str2double(ElevCode(I_Site));
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
             
            VEQueLUmn = [VEQueLUmn;IQueLUmn];
            VEQueLCmn = [VEQueLCmn;IQueLCmn];
            VEQueGSLmn = [VEQueGSLmn;IQueGSLmn];
       
    end
        QueLUmn(:,:,Year-2006) = VEQueLUmn;
        QueLCmn(:,:,Year-2006) = VEQueLCmn;
        QueGSLmn(:,:,Year-2006) = VEQueGSLmn;
   
              
        disp(['Done with ',YearName]);

end

%      save([Path_RTE01YR4,strcat('RTEmn_QueGap_A20072012.mat')],'-regexp','^Que*');
     save([Path_RTE01YR4,strcat('RTEmn_QueShade_A20072012.mat')],'-regexp','^Que*');

%Fig test
%     Fig = figure;
%     errorbar(FagLUmn(3,:),FagLUmn(1,:),FagLUmn(2,:),'or');hold on;
%     errorbar(FagLUmn(3,:),FagLUmn(4,:),FagLUmn(5,:),'ob');
%     errorbar(FagLUmn(3,:),FagLUmn(7,:),FagLUmn(8,:),'og');
% 
%     Fig = figure;
%     errorbar(FagLCmn(3,:),FagLCmn(1,:),FagLCmn(2,:),'or');hold on;
%     errorbar(FagLCmn(3,:),FagLCmn(4,:),FagLCmn(5,:),'ob');
%     errorbar(FagLCmn(3,:),FagLCmn(7,:),FagLCmn(8,:),'og');
% 
%     Fig = figure;
%     errorbar(FagGSLmn(3,:),FagGSLmn(1,:),FagGSLmn(2,:),'or');hold on;
%     errorbar(FagGSLmn(3,:),FagGSLmn(4,:),FagGSLmn(5,:),'ob');
%     errorbar(FagGSLmn(3,:),FagGSLmn(7,:),FagGSLmn(8,:),'og');

    
