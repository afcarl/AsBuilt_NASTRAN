classdef nMAT_part < handle
    %NMAT_PART takes a dat object with all data from a nastran .dat file
    %and user inputs to sort the information into a desired part object
    %
    % at this point, the only delimiters are element and grid ranges. It
    % might be necessary to use PIDs, MIDs, etc. in order to separate
    % part(s) of interest
    
    
    properties
        G;          % Grid struct
        nG;         % Updated grid struct
        E;          % Element struct
        nE;         % Updated element struct
        pCMMfile;    % Excel file with profile CMM data
        pCMMdata;    % profile CMM coordinate data
        tCMMfile;    % Excel file with thickness CMM data
        tCMMdata;    % thickness CMM coordinate data
    end
    
    methods
        function obj = nMAT_part(datObj,gLim,eLim,pFile,tFile,varargin)
            if nargin == 1
%                 mFile = 'FS_Front_profile.xlsx';
%                 gLim = [100001,149699];
%                 eLim = [100001,149320];
                gLim = [100001,137110];
                eLim = [100001,173428];
                pFile = 'SN011_S1_0_S2_0_CC_020116.xlsx';
                tFile = 'SN011_CC_FS_Thickness_3feb16.xlsx';

            end
            gRange = obj.findRange(vertcat(datObj.G.ID),gLim);
            eRange = obj.findRange(vertcat(datObj.E.EID),eLim);
            obj.G = datObj.G(ismember(vertcat(datObj.G.ID),gRange));
            obj.nG = obj.G;
%             [~, ieDesired, ~] = intersect(vertcat(datObj.E.EID),eRange);
            obj.E = datObj.E(ismember(vertcat(datObj.E.EID),eRange));
            obj.nE = obj.E;
            obj.pCMMfile = pFile;
            obj.pCMMdata = xlsread(pFile);
            obj.tCMMfile = tFile;
            obj.tCMMdata = xlsread(tFile);
%             obj.CMM_SI = scatteredInterpolant(obj.CMMdata(:,1:2),obj.CMMdata(:,3),'linear');
            obj.findZcoord('linear');
%             obj.G.U = deal([obj.G.X(1),obj.G.X(2),obj.CMM_SI(obj.G.X(1),obj.G.X(2))]);
%             obj.updateThickness('linear');
        end
        
        function obj = findZcoord(obj,intMethod)
            % find z-coord with interpolated CMM data
            % intMethod = interpolation method
            gPoints = vertcat(obj.G.X);
            sI = scatteredInterpolant(obj.pCMMdata(:,1:2),obj.pCMMdata(:,3),intMethod);
            Zq = sI(gPoints(:,1),gPoints(:,2));
            for i = 1:length(Zq)
                obj.nG(i).X(3) = Zq(i);
            end
        end
%         
%         function obj = updateThickness(obj,intMethod)
%             % update element thickness with interpolated CMM data at the
%             % centroids of the element nodes
%             % intMethod = interpolation method
% %             cPoints = vertcat(obj.E.C);
%             tPoints = vertcat(obj.G.X);
%             sI = scatteredInterpolant(obj.tCMMdata(:,1:2),obj.tCMMdata(:,3),intMethod);
%             Tq = sI(tPoints(:,1),tPoints(:,2));
%             for i = 1:length(Tq)
%                 obj.G(i).T = Tq(i);
%             end
%             for i = 1:length(obj.E)
%                 for j = 1:3
%                     % find the 
%                     obj.E(i).T(j) = obj.G(obj.
%                 end
%             end
%         end
    end
    
    methods (Static)
        function outData = findRange(inData,limits)
            lowLim = find(not(inData-limits(1)));
            uppLim = find(not(inData-limits(2)));
            outData = inData(lowLim:uppLim);
        end
        
        
            
            
    end
end
