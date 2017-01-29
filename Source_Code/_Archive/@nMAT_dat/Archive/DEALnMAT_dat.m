classdef nMAT_dat < handle
    %NMAT_DAT Stores all data from Nastran .dat file into useful structs in
    %an object
    %   Because this is a subclass of handle, does that mean the object it
    %   creates can be changed more easily by a script that uses it?
    
    properties
        flName;         % file name w/o extension
        nGrid;          % number of grid points per element
        G = struct('name',[],'ID',[],'CP',[],'X1',[],'X2',[],'X3',[]); % grid data
        E = struct('name',[],'EID',[],'PID',[],'G',[]);         % element datas
    end
    
    methods
        function obj = nMAT_dat(fileName,varargin)
            if nargin == 0
                fileName = 'Example_r3';
            end
            obj.flName = fileName;
            obj.readDat()
        end
    end
    
    methods ( Access = private)
        function readDat(obj)
%%%%%%%%%%% Store the .dat text in a cell arrray
            datFID = fopen([obj.flName '.dat']);
            d = textscan(datFID, '%s', 'delimiter', '\n'); % put each row in cell in array
            datCellArray = d{1,1}(:);                      % simplify
%%%%%%%%%%%%% Extract part grid point data
            gi = find(not(cellfun('isempty',strfind(datCellArray,'GRID'))));  % index of each row having 'GRID'
            % Extract GRID information (small-field format)

            for ig = 1:length(gi)
                obj.G(ig).ID = str2double(datCellArray{gi(ig)}(9:16));
                obj.G(ig).CP = str2double(datCellArray{gi(ig)}(17:24));
                obj.G(ig).X1 = getValue(datCellArray{gi(ig)}(25:32));
                obj.G(ig).X2 = getValue(datCellArray{gi(ig)}(33:40));
                obj.G(ig).X3 = getValue(datCellArray{gi(ig)}(41:48));
            end

%             obj.G(1:length(gi)) = obj.G;
%             C = cellfun(@(x) x(9:16),datCellArray(gi),'UniformOutput',false);
% %             [obj.G(:).ID] = deal(str2double(cellfun(@(x) x(9:16),datCellArray(gi),'UniformOutput',false)));
%             [obj.G(:).ID] = deal(C{:});
%             obj.G.CP = deal(str2double(cellfun(@(x) x(17:24),datCellArray(gi),'UniformOutput',false)));
%             obj.G.X1 = deal(getValue(cellfun(@(x) x(25:32),datCellArray(gi),'UniformOutput',false)));
%             obj.G.X2 = deal(getValue(cellfun(@(x) x(33:40),datCellArray(gi),'UniformOutput',false)));
%             obj.G.X3 = deal(getValue(cellfun(@(x) x(41:48),datCellArray(gi),'UniformOutput',false)));

%%%%%%%%%%%%% Extract element data
%             eStart = gi(end)+1; % start of element entries begins on the row immediately after the last GRID entry
%             eEnd = length(datCellArray); % the last row of the .dat file is the end of the elements
            i_CHEXA = find(not(cellfun('isempty',strfind(datCellArray,'CHEXA'))));   % index of each row containing CHEXA data
            n_CHEXA = length(i_CHEXA);
            iCQUAD4 = find(not(cellfun('isempty',strfind(datCellArray,'CQUAD4'))));   % index of each row containing CQUAD4 data
            nCQUAD4 = length(iCQUAD4);
            % Extract ELEMENT information (small-field format)
%             [obj.E(1:n_CHEXA).name] = 'CHEXA';
%             [obj.E(n_CHEXA+1:end).name] = 'CQUAD4';
            [obj.E.name] = deal(cellfun(@(x) x(1:8),datCellArray([i_CHEXA; iCQUAD4]),'UniformOutput',false));
            obj.E.EID = str2double(deal(cellfun(@(x) x(9:16),datCellArray([i_CHEXA; iCQUAD4]),'UniformOutput',false)));
            obj.E.PID = str2double(deal(cellfun(@(x) x(17:24),datCellArray([i_CHEXA; iCQUAD4]),'UniformOutput',false)));
            for i = 1:4
                k = 8*(i-1);
                obj.E.G(i) = str2double(deal(cellfun(@(x) x(25+k:32+k),datCellArray([i_CHEXA; iCQUAD4]),'UniformOutput',false)));
            end
            % CHEXA elements have data on two lines
            obj.E(1:n_CHEXA).G(5) = deal(cellfun(@(x) x(58:65),datCellArray(i_CHEXA),'UniformOutput',false));
            obj.E(1:n_CHEXA).G(6) = deal(cellfun(@(x) x(66:73),datCellArray(i_CHEXA),'UniformOutput',false));
            obj.E(1:n_CHEXA).G(7) = deal(cellfun(@(x) x(9:16),datCellArray(i_CHEXA+1),'UniformOutput',false));
            obj.E(1:n_CHEXA).G(8) = deal(cellfun(@(x) x(17:24),datCellArray(i_CHEXA+1),'UniformOutput',false));
        %% check if the number is an exponential in Nastran's form and convert
            function value = getValue(string)
            % CHECKNUMBER takes a string and checks if it can be converted to a number.
            % If it is not, then it assumes an exponential in Nastran form and converts
                value = str2double(string);
                if isnan(value)
                    for j = 1:8
                        if string(j) == '+' || string(j) == '-'
                            idel = j;   % store index of the last + or - in string
                        end
                    end
                    num = str2double(string(1:idel-1));
                    expon = str2double(string(idel:end));
                    value = num*10^expon;
                    if isnan(value)
                        disp('is NaN')
                    end
                end
            end
        end
    end
end

