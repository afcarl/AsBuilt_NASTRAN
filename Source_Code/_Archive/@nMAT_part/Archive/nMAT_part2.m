classdef nMAT_part2 < handle
    %NMAT_PART2 objects contain all Nastran info for a part in a FEM
    %   Information is extracted from .dat file using given ranges of IDs
    %   and EIDs
    
%%
    properties
        flName;         % file name w/o extension
        ptName;         % part name
        ID_Vec;         % vector of grid IDs
        EID_Vec;        % vector of element EIDs
        elName;         % element type
        nGrid;          % number of grid points per element
        G = struct('ID',[],'CP',[],'X1',[],'X2',[],'X3',[]); % grid data
        E = struct('EID',[],'PID',[],'G',[],'P',[]);         % element data
    end

%%
    methods
        function obj = nMAT_part2(fileName,partName,gridRange,elementRange,varargin)
            if nargin == 0
                fileName = 'Example_r3';
                partName = 'Face Sheet';
                gridRange = 100001:149699;
                elementRange = 100001:149320;
            end
            obj.flName  = fileName;
            obj.ptName  = partName;
            obj.ID_Vec  = gridRange;
            obj.EID_Vec = elementRange;
            obj.getElName()
            obj.readDat()
        end
    end

%%
    methods (Access = private)
        function getElName(obj)
            switch obj.ptName
                case 'Face Sheet'
                    obj.elName = 'CQUAD4';
                    obj.nGrid = 4;
                case 'Replication Layer'
                    obj.elName = 'CHEXA';
                    obj.nGrid = 8;
            end
        end

%%
        function readDat(obj)
%%%%%%%%%%%%% Store the .dat text in a cell arrray
            datFID = fopen([obj.flName '.dat']);
            d = textscan(datFID, '%s', 'delimiter', '\n'); % put each row in cell in array
            datCellArray = d{1,1}(:);                              % simplify
            
%%%%%%%%%%%%% Extract part grid point data
            gi = find(not(cellfun('isempty',strfind(d,'GRID'))));  % index of each row having 'GRID'
            % create cell array with all rows containing GRID data
            GtxtArray = datCellArray(gi(1):gi(end));
            % Extract GRID information (small-field format)
            for ig = 1:numel(GtxtArray)
                ID(ig) = str2double(strtrim(GtxtArray{ig}(9:16)));
                if intersect(ID,obj.ID_Vec);
%                     ind = length(obj.G)+1;
                    obj.G(end+1).ID = str2double(strtrim(GtxtArray{ig}(9:16)));
                    obj.G(end).CP = str2double(strtrim(GtxtArray{ig}(17:24)));
                    obj.G(end).X1 = getValue(strtrim(GtxtArray{ig}(25:32)));
                    obj.G(end).X2 = getValue(strtrim(GtxtArray{ig}(33:40)));
                    obj.G(end).X3 = getValue(strtrim(GtxtArray{ig}(41:48)));
                end
            end
            
            
%%%%%%%%%%%%% Extract element data
%             % CQUAD4 Element Data
%             e1 = find(not(cellfun('isempty',strfind(d,'CQUAD4'))));  % index of each row having CQUAD4 elements
%             E1txtArray = d(e1(1):e1(end));
%             for ie = 1:numel(E1txtArray)
%                 obj.E(ie).EID = str2double(strtrim(E1txtArray{ie}(9:16)));
%                 obj.E(ie).PID = str2double(strtrim(E1txtArray{ie}(17:24)));
%                 for je = 1:4
%                     k = 8*(je-1);
%                     obj.E(ie).G(je) = str2double(strtrim(E1txtArray{ie}(25+k:33+k)));
%                 end
%             end
%             % CHEXA Element Data
%             e2 = find(not(cellfun('isempty',strfind(d,'CHEXA'))));  % index of each row having CHEXA elements
%             E2txtArray = d(e2(1):e2(end)+1);
%             for ie = 1:2:numel(E2txtArray)
%                 obj.E(ie).EID = str2double(strtrim(E2txtArray{ie}(9:16)));
%                 obj.E(ie).PID = str2double(strtrim(E2txtArray{ie}(17:24)));
%                 obj.E(ie).G(1)  = str2double(strtrim(E2txtArray{ie}(25:33)));
%                 obj.E(ie).G(2)  = str2double(strtrim(E2txtArray{ie}(34:41)));
%                 obj.E(ie).G(3)  = str2double(strtrim(E2txtArray{ie}(42:49)));
%                 obj.E(ie).G(4)  = str2double(strtrim(E2txtArray{ie}(50:57)));
%                 obj.E(ie).G(5)  = str2double(strtrim(E2txtArray{ie}(58:65)));
%                 obj.E(ie).G(6)  = str2double(strtrim(E2txtArray{ie}(66:73)));
%                 obj.E(ie).G(7)  = str2double(strtrim(E2txtArray{ie+1}(9:16)));
%                 obj.E(ie).G(8)  = str2double(strtrim(E2txtArray{ie+1}(17:24)));
%             end
            
%%%%%%%%%%%%% Extract element data
            ei = find(not(cellfun('isempty',strfind(d,obj.elName))));  % index of each row having elName
            % create cell array with all rows containing elName data and
            % extract element information, then grid point information
            switch obj.elName
                case 'CQUAD4'
                    EtxtArray = datCellArray(ei(1):ei(end));
                    for ie = 1:numel(EtxtArray)
                        obj.E(ie).EID = str2double(strtrim(EtxtArray{ie}(9:16)));
                        obj.E(ie).PID = str2double(strtrim(EtxtArray{ie}(17:24)));
                        for je = 1:4
                            k = 8*(je-1);
                            obj.E(ie).G(je) = str2double(strtrim(EtxtArray{ie}(25+k:33+k)));
                        end
                    end
                case 'CHEXA'
                    EtxtArray = datCellArray(ei(1):ei(end)+1);
                    for ie = 1:2:numel(EtxtArray)
                        obj.E(ie).EID = str2double(strtrim(EtxtArray{ie}(9:16)));
                        obj.E(ie).PID = str2double(strtrim(EtxtArray{ie}(17:24)));
                        obj.E(ie).G(1)  = str2double(strtrim(EtxtArray{ie}(25:33)));
                        obj.E(ie).G(2)  = str2double(strtrim(EtxtArray{ie}(34:41)));
                        obj.E(ie).G(3)  = str2double(strtrim(EtxtArray{ie}(42:49)));
                        obj.E(ie).G(4)  = str2double(strtrim(EtxtArray{ie}(50:57)));
                        obj.E(ie).G(5)  = str2double(strtrim(EtxtArray{ie}(58:65)));
                        obj.E(ie).G(6)  = str2double(strtrim(EtxtArray{ie}(66:73)));
                        obj.E(ie).G(7)  = str2double(strtrim(EtxtArray{ie+1}(9:16)));
                        obj.E(ie).G(8)  = str2double(strtrim(EtxtArray{ie+1}(17:24)));
                    end
            end

            
%%%%%%%%%%%% Store grid point position with element data
%             for ii = 1:length(obj.E)
%                 for jj = 1:obj.nGrid
%                     % store index of each NID with respective element
%                     obj.E(ii).Gi(jj) = find(not(vertcat(obj.G(:).ID)-obj.E(ii).G(jj)));
%                     % store coords of each grid point with respective element
%                     obj.E(ii).P{jj} = [obj.G(obj.E(ii).Gi(jj)).X1 ...
%                                        obj.G(obj.E(ii).Gi(jj)).X2 ...
%                                        obj.G(obj.E(ii).Gi(jj)).X3];
%                 end
%             end
            
%%%%%%%%%%%% Further reduce the element set to specify the part
            
% %%%%%%%%%%%% Get unique gridpoint coordinates
%             obj.uGi = unique(vertcat(obj.E(:).Gi)); % store unique grid ID indices
%             obj.uP  = [X1(obj.uGi) X2(obj.uGi) X3(obj.uGi)];
%             end
        %% check if the number is an exponential in Nastran's form and convert
        function value = getValue(string)
        % CHECKNUMBER takes a string and checks if it can be converted to a number.
        % If it is not, then it assumes an exponential in Nastran form and converts
            value = str2double(string);
            if isnan(value)
                for j = 2:8
                    if string(j) == '+' || string(j) == '-'
                        num = str2double(string(1:j-1));
                        expon = str2double(string(j:end));
                        value = num*10^expon;
                        break
                    end
                end
            end
%             switch ind
%                 case 1
%                     obj.X1(ig) = value;
%                 case 2
%                     obj.X2(ig) = value;
%                 case 3
%                     obj.X3(ig) = value;
%             end
            end
        end
    end
end

