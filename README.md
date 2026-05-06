**Overview**
This package contains the input data and MATLAB scripts used to reproduce the analyses presented in the study. The analyses include data preprocessing, linear regressions, and generalized linear mixed models (GLMMs).

**File Structure**
**Data (.csv / .xlsx)**
IS_Pheno_2005-2015.csv, IS_Pheno_2016-2021.csv: In situ phenology observations
IS_TMean_2004-2020.csv: In situ temperature data
CG_Pheno_*.csv: Common garden phenology datasets
CG_TMean_2009-2019.csv: Common garden temperature data
RTE_PHENO_*.xlsx/.csv: Reciprocal transplant phenology datasets
RTE_Block.csv, CG_Block.csv: Block information for experiments
MetaData_Pyrenees.xlsx, MetaData_TMean.csv: Metadata files

**Scripts (.m)**
Proc01_*.m – Proc23_*.m: Data preprocessing and statistical analyses. Run sequentially in numerical order.

**Software**
MATLAB (R2024a or later)
Statistics and Machine Learning Toolbox

**Instructions**
1.Place all input data files in the MATLAB working directory.
2.Run the scripts sequentially from Proc01_*.m to Proc23_*.m.
3.The scripts perform data cleaning, linear regression, and GLMM analyses.
4.Additional scripts (MixLMod*.m) are used for model comparison and evaluation of heterogeneity.
5.Results are displayed in the MATLAB workspace or exported as files.
