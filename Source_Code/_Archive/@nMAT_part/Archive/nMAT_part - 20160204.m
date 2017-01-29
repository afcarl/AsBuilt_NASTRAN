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
        CMMfile;    % Excel file with CMM data
        CMMdata;    % CMM coordinate data
%         CMM_SI;     % CMM data scattered interpolant
    end
    
    methods
        function obj = nMAT_part(datObj,gLim,eLim,mFile,varargin)
            if nargin == 1
                gLim = [100001,149699];
                eLim = [100001,149320];
                mFile = 'FS_Front_profile.xlsx';
            end
            gRange = obj.findRange(vertcat(datObj.G.ID),gLim);
            eRange = obj.findRange(vertcat(datObj.G.ID),eLim);
            obj.G = datObj.G(ismember(vertcat(datObj.G.ID),gRange));
            obj.nG = obj.G;
%             [~, ieDesired, ~] = intersect(vertcat(datObj.E.EID),eRange);
            obj.E = datObj.E(ismember(vertcat(datObj.E.EID),eRange));
            obj.nE = obj.E;
            obj.CMMfile = mFile;
            obj.CMMdata = xlsread(mFile);
%             obj.CMM_SI = scatteredInterpolant(obj.CMMdata(:,1:2),obj.CMMdata(:,3),'linear');
            obj.findZcoord('linear');
%             obj.G.U = deal([obj.G.X(1),obj.G.X(2),obj.CMM_SI(obj.G.X(1),obj.G.X(2))]);
        end
        
        function obj = findZcoord(obj,intMethod)
            % find z-coord with interpolated CMM data
            % intMethod = interpolation method
            gPoints = vertcat(obj.G.X);
            sI = scatteredInterpolant(obj.CMMdata(:,1:2),obj.CMMdata(:,3),intMethod);
            Zq = sI(gPoints(:,1),gPoints(:,2));
%             [obj.G.U] = deal(obj.G.X);
            for i = 1:length(Zq)
                obj.nG(i).X(3) = Zq(i);
            end
        end
        
        function obj = updateThickness(obj,intMethod)
            % update element thickness with interpolated CMM data at the
            % centroids of the element nodes
            % intMethod = interpolation method
            cPoints = vertcat(obj.E.C);
            sI = scatteredInterpolant(obj.CMMdata(:,1:2),obj.CMMdata(:,3),intMethod);
            Tq = sI(cPoints(:,1),cPoints(:,2));
%             [obj.G.U] = deal(obj.G.X);
            for i = 1:length(Tq)
                obj.E(i).T = Tq(i);
            end
        end
    end
    
    methods (Static)
        function outData = findRange(inData,limits)
            lowLim = find(not(inData-limits(1)));
            uppLim = find(not(inData-limits(2)));
            outData = inData(lowLim:uppLim);
        end
        
        
            
            
    end
end
