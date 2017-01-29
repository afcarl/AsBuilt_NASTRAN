% Run Modify_BDF multiple times for different components

clear; close all; clc;

%% Front Face Sheet, CQUAD4 and CTRIA3 Elements
% tic
% shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\FrontFS_Data';
% oldFS_BDF   = 'FFS_Files\SN010_Trimmed_TopFS_29feb16.bdf';
% FSprof_CMM  = 'FFS_Files\SN011_S1_0_S2_0_CC_020116.xlsx';
% FSdelta_CMM = 'FFS_Files\SN011_CC_FS_Thickness_3feb16.xlsx';
% RLdelta_CMM = 'FFS_Files\FrontFS_RL_Thickness_FigureFit.xlsx';
% newFS_BDF   = 'FFS_Files\FFS_Trimmed_Modified.bdf';
% wsPath      = 'FFS_Files\FFS_Trimmed_Workspace.mat';
% rlFlag      = true;
% % savedBDF    = 'Trimmed_bdf.mat';
% Modify_BDF;
% toc

%% Front Face Sheet, with RL in PCOMP
% tic
% shareFolder = [];%'\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\FrontFS_Data';
% oldFS_BDF  = 'FFS_Files\SN011_As-Built_TopFS_2feb16.bdf';
% FSprof_CMM = 'FFS_Files\SN011_S1_0_S2_0_CC_020116.xlsx';
% FSdelta_CMM  = 'FFS_Files\SN011_CC_FS_Thickness_3feb16.xlsx';
% RLdelta_CMM  = 'FFS_Files\FrontFS_RL_Thickness_FigureFit.xlsx';
% newFS_BDF  = 'FFS_Files\FFS_Modified.bdf';
% wsPath = 'FFS_Files\FFS_Workspace.mat';
% rlFlag = true;
% Modify_BDF;
% toc
% clear;

%%
% pause

%% Front Face Sheet, without RL in PCOMP
% shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\FrontFS_Data';
% oldFS_BDF  = 'FFS_Files\SN011_As-Built_TopFS_2feb16.bdf';
% FSprof_CMM = 'FFS_Files\SN011_S1_0_S2_0_CC_020116.xlsx';
% FSdelta_CMM  = 'FFS_Files\SN011_CC_FS_Thickness_3feb16.xlsx';
% RLdelta_CMM  = 'FFS_Files\FrontFS_RL_Thickness_FigureFit.xlsx';
% newFS_BDF  = 'FFS_Files\FFS_Modified_noRLinPCOMP.bdf';
% wsPath = 'FFS_Files\FFS_Workspace_noRLinPCOMP.mat';
% rlFlag = false;
% Modify_BDF;
% clear;

%%
% pause

%% Front Face Sheet, simple thickness change
% shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\FrontFS_Data';
% oldFS_BDF  = 'FFS_Files\SN011_As-Built_TopFS_2feb16.bdf';
% FSprof_CMM = 'FFS_Files\SN011_S1_0_S2_0_CC_020116.xlsx';
% FSdelta_CMM  = 'FFS_Files\SN011_CC_FS_Thickness_Avg_27feb16.xlsx';
% RLdelta_CMM  = 'FFS_Files\FrontFS_RL_Thickness_FigureFit.xlsx';
% newFS_BDF  = 'FFS_Files\FFS_SimpleThicknessChange.bdf';
% wsPath = 'FFS_Files\FFS_SimpleThicknessChange_Workspace.mat';
% rlFlag = true;
% Modify_BDF;
% clear;

%%
% pause

%% Back Face Sheet
% tic
% shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\BackFS_Data';
% oldFS_BDF   = [shareFolder '\SN011_As-Built_BottomFS_24feb16.bdf'];
% FSprof_CMM  = [shareFolder '\SN011_S1_0_S2_0_CV_020116_NegZ_FlipY.xlsx'];
% FSdelta_CMM = [shareFolder '\SN011_CVX_FS_Thickness_24feb16.xlsx'];
% RLdelta_CMM = [shareFolder '\BackFS_RL_Thickness_FigureFit_BadPtsRemoved_FlipY.xlsx'];
% newFS_BDF   = [shareFolder '\BFS_Modified.bdf'];
% wsPath      = 'BFS_Files\BFS_Workspace.mat';
% rlFlag      = true;
% % savedBDF    = 'BFS_Files\BFS_bdf.mat';
% savedBDF    = [];
% Modify_BDF;
% toc

%%
% pause

%% Back Face Sheet, without RL in PCOMP
% shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\BackFS_Data';
% oldFS_BDF   = 'BFS_Files\SN011_As-Built_BottomFS_24feb16.bdf';
% FSprof_CMM  = 'BFS_Files\SN011_S1_0_S2_0_CV_020116_NegZ.xlsx';
% FSdelta_CMM = 'BFS_Files\SN011_CVX_FS_Thickness_24feb16.xlsx';
% RLdelta_CMM = 'BFS_Files\BackFS_RL_Thickness_FigureFit_BadPtsRemoved.xlsx';
% newFS_BDF   = 'BFS_Files\BFS_Modified_noRLinPCOMP.bdf';
% wsPath      = 'BFS_Files\BFS_Workspace_noRLinPCOMP.mat';
% rlFlag      = false;
% Modify_BDF;
% clear;

%%
% pause

%% Back Face Sheet, simple thickness change
tic
shareFolder = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\BackFS_Data';
oldFS_BDF   = [shareFolder '\SN011_As-Built_BottomFS_24feb16.bdf'];
FSprof_CMM  = [shareFolder '\SN011_S1_0_S2_0_CV_020116_NegZ_FlipY.xlsx'];
FSdelta_CMM = [shareFolder '\SN011_CVX_FS_Thickness_Avg_27feb16.xlsx'];
RLdelta_CMM = [shareFolder '\BackFS_RL_Thickness_FigureFit_BadPtsRemoved_FlipY.xlsx'];
newFS_BDF   = [shareFolder '\BFS_SimpleThicknessChange.bdf'];
wsPath      = 'BFS_Files\BFS_SimpleThicknessChange_bdf.mat';
rlFlag      = true;
savedBDF    = 'BFS_Files\BFS_bdf.mat';
% savedBDF    = [];
Modify_BDF;
RL_thicknessAtNodes

% clear;
toc



