
clc;clear;

addpath(genpath('./'));

Path_PHE01LV2 ='../output/01_PHE01LV2/';
Path_CGPHE2TMN ='../output/11_CGPHE2TMN_CG/';
Path_Tree03CG ='../output/15_Tree03CG/';

% mkdir(Path_Tree03CG);

load([Path_PHE01LV2,'NormCG.mat']);
load([Path_CGPHE2TMN,'CG2PHENTMN_A20092019.mat']);

TreeCode = unique(SiteTrID);
Num = numel(TreeCode);
ProvElev = [131,387,803,1235,1630,259,422,841,1194,1614];

% initial
TreeLU = nan(Num,13); % numel(TreeCode) Year Num
TreeLC = nan(Num,13);
TreeGSL = nan(Num,13);
TreeYTmn = repmat(QueYTmn(1,:),[Num,1]);
TreeSTmn = repmat(QueSTmn(1,:),[Num,1]);
TreeATmn = repmat(QueATmn(1,:),[Num,1]);
ValidInx =[];


for TreeNum = 1 : numel(TreeCode)
    I_Tree = strcmp(TreeCode(TreeNum),SiteTrID);

    YearNum = SiteYear(I_Tree,:);
         
    TreeID(:,TreeNum) = TreeCode(TreeNum);
    TreeElev(:,TreeNum) = unique(SiteElev(I_Tree,:));
    TreeProv(:,TreeNum) = unique(SiteProv(I_Tree,:));
    TreeLU(TreeNum,YearNum-2008) = SiteLU(I_Tree,:);
    TreeLC(TreeNum,YearNum-2008) = SiteLC(I_Tree,:);
    TreeGSL(TreeNum,YearNum-2008) = SiteGSL(I_Tree,:);
      
        if  numel(SiteLU(I_Tree,:))>5
            ValidInx = [ValidInx;TreeNum];
        else 
        end
        

end

TreeLU(:,11:12)=[];
TreeLU = TreeLU(ValidInx,:); 
LUElev = TreeElev(ValidInx);
LUProv = TreeProv(ValidInx);

% LU
ProvCode = {'L1','L3','L8','L12','L16','O1','O4','O8','O12','O16'};
   
TreeLUSlope = [];
TreeLUElev = [];
TreeLUSlopeMN = [];
CGSlope =[];
CGElev = [];

for I_Site=1:numel(ProvCode)
        I_Code=strcmp(LUProv,ProvCode(I_Site));
    PhenCGLU = TreeLU(I_Code,:); 
    TmnCGLU = repmat(QueSTmn(I_Site,:),[numel(PhenCGLU(:,1)),1]); 
    
    for I_Slope = 1: numel(PhenCGLU(:,1))
        XData = TmnCGLU(I_Slope,:);
        YData = PhenCGLU(I_Slope,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);

    pCG = polyfit(XData,YData,1);
%     yfitCG = polyval(pCG,XData);
%     SlopeCG = plot(XData,yfitCG,'-','color','k','LineWidth',1); hold on;
    
    CGSlope(1,I_Slope) = pCG(1,1); 
    
    end
    
    TreeLUSlope = [TreeLUSlope,CGSlope];
    TreeLUSlopeMN = [TreeLUSlopeMN,nanmean(CGSlope)];
    CGElev = repmat(ProvElev(:,I_Site),[numel(CGSlope(1,:)),1])';
    TreeLUElev = [TreeLUElev,CGElev];
    TreeLUElevMN = ProvElev;
    
end

% LC

Index =[];
for i = 1 : numel(TreeLC(:,1))
     ValidLC =~isnan(TreeLC(i,:));
     
     if numel(find(ValidLC==1)) > 5
     Index =[Index ; i];
     else
     end
end

TreeLC = TreeLC(Index,:); TreeLC(:,11:12)=[];
LCElev = TreeElev(Index);
LCProv = TreeProv(Index);


ProvCode = {'L1','L3','L8','L12','L16','O1','O4','O8','O12','O16'};
   
TreeLCSlope = [];
TreeLCElev = [];
TreeLCSlopeMN = [];
CGSlope = [];
CGElev = [];

for I_Site=1:numel(ProvCode)
        I_Code=strcmp(LCProv,ProvCode(I_Site));
    PhenCGLC = TreeLC(I_Code,:);  
    TmnCGLC = repmat(QueATmn(I_Site,:),[numel(PhenCGLC(:,1)),1]); 
    
    for I_Slope = 1: numel(PhenCGLC(:,1))
        XData = TmnCGLC(I_Slope,:);
        YData = PhenCGLC(I_Slope,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);

    pCG = polyfit(XData,YData,1);
%     yfitCG = polyval(pCG,XData);
%     SlopeCG = plot(XData,yfitCG,'-','color','k','LineWidth',1); hold on;
    
    CGSlope(1,I_Slope) = pCG(1,1); 
    
    end
    
    TreeLCSlope = [TreeLCSlope,CGSlope];
    TreeLCSlopeMN = [TreeLCSlopeMN,nanmean(CGSlope)];
    CGElev = repmat(ProvElev(:,I_Site),[numel(CGSlope(1,:)),1])';
    TreeLCElev = [TreeLCElev,CGElev];
    TreeLCElevMN = ProvElev;
    
end

% GSL

Index =[];
for i = 1 : numel(TreeGSL(:,1))
     ValidGSL =~isnan(TreeGSL(i,:));
     
     if numel(find(ValidGSL==1)) > 5
     Index =[Index ; i];
     else
     end
end

TreeGSL = TreeGSL(Index,:); TreeGSL(:,11:12)=[];
GSLElev = TreeElev(Index);
GSLProv = TreeProv(Index);


ProvCode = {'L1','L3','L8','L12','L16','O1','O4','O8','O12','O16'};

TreeGSLSlope = [];
TreeGSLElev = [];
TreeGSLSlopeMN = [];
CGSlope =[];
CGElev = [];
% TreeCGTmn =[];

for I_Site=1:numel(ProvCode)
        I_Code=strcmp(GSLProv,ProvCode(I_Site));
    PhenCGGSL = TreeGSL(I_Code,:); 
    TmnCGGSL = repmat(QueYTmn(I_Site,:),[numel(PhenCGGSL(:,1)),1]); 
    
    for I_Slope = 1: numel(PhenCGGSL(:,1))
        XData = TmnCGGSL(I_Slope,:);
        YData = PhenCGGSL(I_Slope,:);
        
    I = ~isnan(XData) & ~isnan(YData); 
    XData = XData(I); YData = YData(I);

    pCG = polyfit(XData,YData,1);
    
    CGSlope(1,I_Slope) = pCG(1,1); 
    
    end
    
%     TreeCGTmn = [TreeCGTmn;repmat(QueYTmn(1,:),[numel(CGSlope(1,:)),1])];
    TreeGSLSlope = [TreeGSLSlope,CGSlope];
    TreeGSLSlopeMN = [TreeGSLSlopeMN,nanmean(CGSlope)];
    CGElev = repmat(ProvElev(:,I_Site),[numel(CGSlope(1,:)),1])';
    TreeGSLElev = [TreeGSLElev,CGElev];
    TreeGSLElevMN = ProvElev;
    
end

    save([Path_Tree03CG,'TreeCGTmn.A2009.2021.mat'],'-regexp','^Tree*');
        