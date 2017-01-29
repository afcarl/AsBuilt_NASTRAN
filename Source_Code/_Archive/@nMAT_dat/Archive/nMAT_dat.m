classdef nMAT_dat < handle
    %NMAT_DAT Stores all data from Nastran .dat file into useful structs in
    %an object
    %   Because this is a subclass of handle, does that mean the object it
    %   creates can be changed more easily by a script that uses it?
    
    properties
        flName;         % file name w/o extension
%         datCellArray;   % each line of text in one cell of a cell array
        tRange = {1:8 9:16 17:24 25:32 33:40 41:48 49:56 57:64 65:72 73:80};
        G = struct('name',[],'ID',[],'CP',[],'X',[]); % grid data
        E = struct('name',[],'EID',[],'PID',[],'G',[],'MCID',[],'ZOFFS',[],'P',[]);         % element datas
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
            disp('storing .dat text')
            datFID = fopen([obj.flName '.dat']);
            d = textscan(datFID, '%s', 'delimiter', '\n'); % put each row in cell in array
            datCellArray = d{1,1}(:);                      % simplify
%%%%%%%%%%%%% Extract header info
            
%%%%%%%%%%%%% Extract property data

%%%%%%%%%%%%% Extract material data
            
%%%%%%%%%%%%% Extract part grid point data
            disp('extracting grid data')
            gi = find(not(cellfun('isempty',strfind(datCellArray,'GRID'))));  % index of each row having 'GRID'
            % Extract GRID information (small-field format)
            for ig = 1:length(gi)
                obj.G(ig).name = strtrim(datCellArray{gi(ig)}(obj.tRange{1}));
                obj.G(ig).ID = str2double(datCellArray{gi(ig)}(obj.tRange{2}));
                obj.G(ig).CP = str2double(datCellArray{gi(ig)}(obj.tRange{3}));
                obj.G(ig).X(1) = getValue(datCellArray{gi(ig)}(obj.tRange{4}));
                obj.G(ig).X(2) = getValue(datCellArray{gi(ig)}(obj.tRange{5}));
                obj.G(ig).X(3) = getValue(datCellArray{gi(ig)}(obj.tRange{6}));
            end
            
%%%%%%%%%%%%% Extract element data
            disp('extracting element data')
            eStart = gi(end)+1; % start of element entries begins on the row immediately after the last GRID entry
            eEnd = length(datCellArray)-1; % the second to last row of the .dat file is the end of the elements
            name = deal(cellfun(@(x) strtrim(x(1:8)),datCellArray(eStart:eEnd),'UniformOutput',false));
            ie = 1;
            for ii = 0:length(name)-1
                switch char(name(ii+1))
                    case 'CHEXA'
                        obj.E(ie).name = 'CHEXA';
                        obj.E(ie).EID = str2double(datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).G(5)  = str2double(datCellArray{eStart+ii}(obj.tRange{8}));
                        obj.E(ie).G(6)  = str2double(datCellArray{eStart+ii}(obj.tRange{9}));
                        obj.E(ie).G(7)  = str2double(datCellArray{eStart+ii+1}(obj.tRange{2}));
                        obj.E(ie).G(8)  = str2double(datCellArray{eStart+ii+1}(obj.tRange{3}));
                        ie = ie+1;
                    case 'CQUAD4'
                        obj.E(ie).name = 'CQUAD4';
                        obj.E(ie).EID = str2double(datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(datCellArray{eStart+ii}(obj.tRange{7}));
                        ie = ie+1;
                    case '+'
                        % no new element if text line begins with '*'
                    case 'CPENTA'
                        obj.E(ie).name = 'CPENTA';
                        obj.E(ie).EID = str2double(datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).MCID  = str2double(datCellArray{eStart+ii}(obj.tRange{8}));
                        obj.E(ie).ZOFFS  = str2double(datCellArray{eStart+ii}(obj.tRange{9}));
                        ie = ie+1;
                   case 'CTRIA3'
                        obj.E(ie).name = 'CTRIA3';
                        obj.E(ie).EID = str2double(datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).MCID  = str2double(datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).ZOFFS  = str2double(datCellArray{eStart+ii}(obj.tRange{8}));
                        ie = ie+1;
                    otherwise
                        disp(['Unexpected text: ' char(name(ii+1))]);
                end
                
            end
            
%%%%%%%%%%%%% Put grid point location data inside of element structs
            disp('adding grid locations to elements')
            for i1 = 1:length(obj.E)
                for i2 = 1:length(obj.E(i1).G)
                    obj.E(i1).P{i2} = obj.G(not(vertcat(obj.G.ID)-obj.E(i1).G(i2)));
                end
                disp('finished storing grid point coordinates of elemnt #%d\n',i1)
            end
                
                
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
            %% get field from nastran cell array
            % nastCellArray is a cell array containing Nastran bulk field
            % text with each line of text in its own cell
            % lineNum is the line number on which the Nastran card starts
            % fldNum is the 8-character field we want to extract
            %
            % not implemented yet. Add more functionality by returning the
            % datatype required. i.e. char for 'CQUAD4' or double for EID
            function fText = getField(nastCellArray,lineNum,fldNum)
                switch fldNum
                    case 1
                        fText =  str2double(nastCellArray{lineNum}(1:8));
                    case 2
                        fText =  str2double(nastCellArray{lineNum}(9:16));
                    case 3
                        fText =  str2double(nastCellArray{lineNum}(17:24));
                    case 4
                        fText =  str2double(nastCellArray{lineNum}(25:32));
                    case 5
                        fText =  str2double(nastCellArray{lineNum}(33:40));
                    case 6
                        fText =  str2double(nastCellArray{lineNum}(41:48));
                    case 7
                        fText =  str2double(nastCellArray{lineNum}(49:56));
                    case 8
                        fText =  str2double(nastCellArray{lineNum}(57:64));
                    case 9
                        fText =  str2double(nastCellArray{lineNum}(65:72));
                    case 10
                        fText =  str2double(nastCellArray{lineNum}(73:80));
                    case 11
                        fText =  str2double(nastCellArray{lineNum}(1:8));
                    case 12
                        fText =  str2double(nastCellArray{lineNum}(9:16));
                    case 13
                        fText =  str2double(nastCellArray{lineNum}(17:24));
                    otherwise
                        disp('Incorrect Field Requested')
                end                        
            end
        end
    end
end

