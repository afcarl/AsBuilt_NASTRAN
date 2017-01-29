% This is the main script for modifying bdf files with CMM data and uses
% structs to store and process data
% clear; close all; clc;

if ~exist('oldFS_BDF')
    clear; close all; clc;
    shareFolder  = '\\corp\gs\ROC\DFSroot\E475\99-Personal_Folders\Bean\MATLAB_Script\FrontFS_Data';
    oldFS_BDF    = 'Small_Files\SmallTest.bdf';
    FSprof_CMM   = [shareFolder '\SN011_S1_0_S2_0_CC_020116.xlsx'];
    FSdelta_CMM  = [shareFolder '\SN011_CC_FS_Thickness_3feb16.xlsx'];
    RLdelta_CMM  = [shareFolder '\FrontFS_RL_Thickness_FigureFit.xlsx'];
    newFS_BDF    = 'Small_Files\SmallTestNew.bdf';
    wsPath       = 'Small_Files\SmallTest_bdf.mat';
    rlFlag       = true;
end

if ~exist('savedBDF')
    savedBDF = [];
end

%% initiate structs
bdf = struct('charArray',[]);
CMM = struct('profile',[],'thickness',[]);

%% Read bdf and parse into card objects
if ~isempty(savedBDF)
    load(savedBDF)
else
    bdf.charArray = readBDF(oldFS_BDF);
    bdf = parseCards(bdf);
end
disp('bdf data read')

%% Read CMM data
CMM.FSprofile = xlsread(FSprof_CMM);
CMM.FSthick = xlsread(FSdelta_CMM);
CMM.RLthick = xlsread(RLdelta_CMM);
disp('CMM data read')

%% Update Z-position of grid objects
intMethod = 'linear';
oldX = vertcat(bdf.GRID.X);
newX3 = interpZ(oldX,CMM.FSprofile,intMethod);
newX = [oldX(:,1:2) newX3];
msg1 = ['Updating Z-positions of nodes. Please Wait'];
h1 = waitbar(0,'Writing Modified bdf');
n = length(newX);
for i = 1:n
    [bdf.GRID(i).X] = newX(i,:);
    waitbar(i/n)
end
close(h1)
disp('Z-positions of nodes updated')

%% Update property and material information using thickness measurements
% add grid point location data to element object (xyz and centroid)
nMAT.cardClass.matchGP(bdf);

if isfield(bdf,'CTRIA3')
    tlam3 = num2cell(interpZ(vertcat(bdf.CTRIA3.C),CMM.FSthick,intMethod));
    [bdf.CTRIA3(:).tLam] = tlam3{:};
    trl3  = num2cell(interpZ(vertcat(bdf.CTRIA3.C),CMM.RLthick,intMethod));
    [bdf.CTRIA3(:).tRL] = trl3{:};
    
    for i = 1:length(bdf.CTRIA3)
        % create new pair of laminate materials (MAT8) based on thickness
        mid = bdf.MAT8(end).MID+1;
        bdf.MAT8(end+1) = nMAT.nasCard.MAT8class(bdf.CTRIA3(i).tLam,'K13C',mid);
        bdf.MAT8(end+1) = bdf.MAT8(1);
        bdf.MAT8(end) = nMAT.nasCard.MAT8class(bdf.CTRIA3(i).tLam,'Boron',mid+1);
        %% create new PCOMP card for each element with scaled thicknesses
        % update PID in each CTRIA3 card to match new PCOMP card
        pid = bdf.PCOMP(end).PID+1;
        bdf.CTRIA3(i).PID = pid;
        bdf.PCOMP(end+1) = nMAT.nasCard.PCOMPclass(bdf.PCOMP(1),bdf.CTRIA3(i),pid,mid);
    end
end

if isfield(bdf,'CQUAD4')
    tlam4 = num2cell(interpZ(vertcat(bdf.CQUAD4.C),CMM.FSthick,intMethod));
    [bdf.CQUAD4(:).tLam] = tlam4{:};
    trl4  = num2cell(interpZ(vertcat(bdf.CQUAD4.C),CMM.RLthick,intMethod));
    [bdf.CQUAD4(:).tRL] = trl4{:};
    
    for i = 1:length(bdf.CQUAD4)
    %     bdf.CTRIA3(i).T = tLam(i);
        % create new pair of laminate materials (MAT8) based on thickness
        mid = bdf.MAT8(end).MID+1;
        bdf.MAT8(end+1) = nMAT.nasCard.MAT8class(bdf.CQUAD4(i).tLam,'K13C',mid);
        bdf.MAT8(end+1) = bdf.MAT8(1);
        bdf.MAT8(end) = nMAT.nasCard.MAT8class(bdf.CQUAD4(i).tLam,'Boron',mid+1);
        %% create new PCOMP card for each element with scaled thicknesses
        % update PID in each CQUAD4 card to match new PCOMP card
        pid = bdf.PCOMP(end).PID+1;
        bdf.CQUAD4(i).PID = pid;
        bdf.PCOMP(end+1) = nMAT.nasCard.PCOMPclass(bdf.PCOMP(1),bdf.CQUAD4(i),pid,mid);
    end
end

disp('New PCOMP and MAT8 objects created')

%% Save workspace
save(wsPath,'bdf')
disp('bdf Saved')

%% Write new bdf
newFID = fopen(newFS_BDF,'wt');
% write BEGIN BULK on the first line
fprintf(newFID, 'BEGIN BULK\n');

% write CORD2R entries
% nMAT.cardClass.writeFieldNum(newFID);
for i = 1:length(bdf.CORD2R);
    bdf.CORD2R.writeCard(bdf.CORD2R(i),newFID)
end
% write MAT1 entries
for i = 1:length(bdf.MAT1);
    bdf.MAT1.writeCard(bdf.MAT1(i),newFID)
end
% write PCOMP entries with respective MAT8 entries
for i = 1:length(bdf.PCOMP);
    bdf.PCOMP.writeCard(bdf.PCOMP(i),newFID,rlFlag)
    % write 2 MAT8 entries
    i1 = 2*i - 1; i2 = i1 + 1;
    bdf.MAT8.writeCard(bdf.MAT8(i1),newFID)
    bdf.MAT8.writeCard(bdf.MAT8(i2),newFID)    
end
% % write PSOLID entries
% for i = 1:length(bdf.PSOLID);
%     bdf.PSOLID.writeCard(bdf.PSOLID(i),newFID)
% end
% % write MAT8 entries
% for i = 1:length(bdf.MAT8);
%     bdf.MAT8.writeCard(bdf.MAT8(i),newFID)
% end
% write GRID entries
for i = 1:length(bdf.GRID);
    bdf.GRID.writeCard(bdf.GRID(i),newFID)
end
% write CQUAD4 entries
if isfield(bdf,'CQUAD4')
for i = 1:length(bdf.CQUAD4);
    bdf.CQUAD4.writeCard(bdf.CQUAD4(i),newFID,rlFlag)
end
end
% write CTRIA3 entries
for i = 1:length(bdf.CTRIA3);
    bdf.CTRIA3.writeCard(bdf.CTRIA3(i),newFID,rlFlag)
end
fclose(newFID);
disp('New .bdf file written')



% %% copy bdf to shared folder
% if ~isempty(shareFolder)
%     copyfile(newFS_BDF,shareFolder)
% end
% disp('New .bdf file copied to shared folder')

%% Plot data
% % old profile
% oldH = surf_from_scatter(oldX);
% % new profile
% newH = surf_from_scatter(newX);
% % profile difference
% difX = [oldX(:,1) oldX(:,2) newX(:,3)-oldX(:,3)];
% difH = surf_from_scatter(difX);

%% use sigfit to remove tip/tilt




