%function RL_thicknessAtNodes(bdf,CMM,shareFolder)
% find interpolated thickness at each node xy-position and save to xlsx

X = vertcat(bdf.GRID.X);
% RLdelta_CMM = 'FFS_Files\FrontFS_RL_Thickness_FigureFit.xlsx';
% CMM.RLthick = xlsread(RLdelta_CMM);
trl3_matchnodeloc = interpZ(X,CMM.RLthick,'linear');
Xt = [X(:,1:2) trl3_matchnodeloc];
xlswrite([shareFolder '\FFS_RL_ThicknessMap.xlsx'],Xt)

% end