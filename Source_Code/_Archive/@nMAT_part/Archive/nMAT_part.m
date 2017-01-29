classdef nMAT_part < handle
    %NMAT_PART objects contain all Nastran info for a part in a FEM
    %   Detailed explanation goes here
    
%%
    properties
        flName;         % file name w/o extension
        ptName;         % part name
        elName;         % element type
        nGrid;          % number of grid points per element
        uGi;            % unique grid point indices for the part
        uP;             % unique grid point locations for the part
        E = struct('EID',[],'PID',[],'G',[],'Gi',[],'P',[])
    end

%%
    methods
        function obj = nMAT_part(fileName,partName)
            obj.flName = fileName;
            obj.ptName = partName;
            obj.getElName()
            obj.readElData();
            
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
        
        function readElData(obj)
            % Store the .dat text in a cell arrray
            datFID = fopen([obj.flName '.dat']);
            d = textscan(datFID, '%s', 'delimiter', '\n'); % put each row in cell in array
            d = d{1,1}(:);                              % simplify

%%%%%%%%%%%%% Extract all grid point data
            gi = find(not(cellfun('isempty',strfind(d,'GRID'))));  % index of each row having 'GRID'
            % create cell array with all rows containing GRID data
            GtxtArray = d(gi(1):gi(end));
            % Extract GRID information (small-field format)
            ID = zeros(numel(GtxtArray),1);
            CP = ID; X1 = ID; X2 = ID; X3 = ID;
            for ig = 1:numel(GtxtArray)
                ID(ig) = str2double(strtrim(GtxtArray{ig}(9:16)));
                CP(ig) = str2double(strtrim(GtxtArray{ig}(17:24)));
                getValue(strtrim(GtxtArray{ig}(25:32)),1);
                getValue(strtrim(GtxtArray{ig}(33:40)),2);
                getValue(strtrim(GtxtArray{ig}(41:48)),3);
            end
            
%%%%%%%%%%%%% Extract element data
            ei = find(not(cellfun('isempty',strfind(d,obj.elName))));  % index of each row having elName
            % create cell array with all rows containing elName data and
            % extract element information, then grid point information
            switch obj.elName
                case 'CQUAD4'
                    EtxtArray = d(ei(1):ei(end));
                    for ie = 1:numel(EtxtArray)
                        obj.E(ie).EID = str2double(strtrim(EtxtArray{ie}(9:16)));
                        obj.E(ie).PID = str2double(strtrim(EtxtArray{ie}(17:24)));
                        for je = 1:4
                            k = 8*(je-1);
                            obj.E(ie).G(je) = str2double(strtrim(EtxtArray{ie}(25+k:33+k)));
                        end
                    end
                case 'CHEXA'
                    EtxtArray = d(ei(1):ei(end)+1);
                    for ie = 1:2:numel(EEtxtArray)
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
            for ii = 1:length(obj.E)
                for jj = 1:obj.nGrid
                    % store index of each NID with respective element
                    obj.E(ii).Gi(jj) = find(not(ID-obj.E(ii).G(jj)));
                    % store coords of each grid point with respective element
                    obj.E(ii).P{jj} = [X1(obj.E(ii).Gi(jj)) X2(obj.E(ii).Gi(jj)) X3(obj.E(ii).Gi(jj))];
                end
            end
            
%%%%%%%%%%%% Further reduce the element set to specify the part
            
%%%%%%%%%%%% Get unique gridpoint coordinates
            obj.uGi = unique(vertcat(obj.E(:).Gi)); % store unique grid ID indices
            obj.uP  = [X1(obj.uGi) X2(obj.uGi) X3(obj.uGi)];

        %% check if the number is an exponential in Nastran's form and convert
        function getValue(string,ind)
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
            switch ind
                case 1
                    X1(ig) = value;
                case 2
                    X2(ig) = value;
                case 3
                    X3(ig) = value;
            end
            end
        end
    end
end

