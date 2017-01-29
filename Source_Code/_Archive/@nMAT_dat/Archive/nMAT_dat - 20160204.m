classdef nMAT_dat < handle
    %NMAT_DAT Stores all data from Nastran .dat file into useful structs in
    %an object
    %   Because this is a subclass of handle, does that mean the object it
    %   creates can be changed more easily by a script that uses it?
    
    properties
        flName;         % file name w/ extension
        datCellArray;   % each line of text in one cell of a cell array
        gi;             % indx of gridpoint lines
        tRange = {1:8 9:16 17:24 25:32 33:40 41:48 49:56 57:64 65:72 73:80};
        G = struct('iLine',[],'name',[],'ID',[],'CP',[],'X',[]); % grid data
        nG;             % copy of G struct to store modified data
        E = struct('iLine',[],'name',[],'EID',[],'PID',[],'G',[],'MCID',[],'ZOFFS',[],'P',[],'C',[]); % element datas
        nE;             % copy of E struct to store modified data
%         P = struct(
%         nP;
%         M = struct(
%         nM;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function obj = nMAT_dat(fileName,varargin)
            if nargin == 0
                fileName = 'Example_r3.dat';
            end
            obj.flName = fileName;
            obj.readDat()
            obj.nG = obj.G;
            obj.nE = obj.E;
%             obj.extText()
%             obj.extHead()
%             obj.extProp()
%             obj.extMate()
%             obj.extGrid()
%             obj.extElem()
            obj.geArrange()
        end
        
         % Make a copy of a handle object.
        function new = copy(this)
            % Instantiate new object of the same class.
            new = feval(class(this));
 
            % Copy all non-hidden properties.
            p = properties(this);
            for i = 1:length(p)
                new.(p{i}) = this.(p{i});
            end
        end
        
        function updateGrid(obj,partObj)
            if not(exist([obj.flName '_Modified'],'file'))
                disp('making new .dat file')
                copyfile(obj.flName,[obj.flName '_Modified']);
            end
            % add updated grid data
            disp('modifying new .dat file with node location data')
            [~,iDat,~] = intersect(vertcat(obj.G.ID),vertcat(partObj.G.ID));
            for i1 = 1:length(iDat)
                obj.nG(iDat(i1)).X(3) = partObj.nG(i1).X(3);
                obj.datCellArray{obj.nG(iDat(i1)).iLine}(obj.tRange{6}) = num2nastranSFFstr(partObj.nG(i1).X(3));
            end
            % update text file
            fout = fopen([obj.flName '_Modified'],'w');
            nrows = length(obj.datCellArray);
            for row = 1:nrows
                fprintf(fout,'%s\n',obj.datCellArray{row});
            end
            fclose(fout);
        end
        
        function updateThickness(obj,partObj)
            % The thickness data at the centroid of each element is stored
            % in the partObj. Use these values to update the thickness
            % specs for elements. The method will vary with part and
            % property type. Will need to make new property cards and new
            % material cards for each element, or close to it.
            if not(exist([obj.flName '_Modified'],'file'))
                disp('making new .dat file')
                copyfile(obj.flName,[obj.flName '_Modified']);
            end
            disp('modifying .dat file with thickness data')
            [~,iDat,~] = intersect(vertcat(obj.E.EID),vertcat(partObj.E.EID));
            % use a switch statement to choose a method
%             switch
            for i1 = 1:length(iDat)
                obj.nG(iDat(i1)).X(3) = partObj.nG(i1).X(3);
                obj.datCellArray{obj.nG(iDat(i1)).iLine}(obj.tRange{6}) = num2nastranSFFstr(partObj.nG(i1).X(3));
            end
            % update text file
            fout = fopen([obj.flName '_Modified'],'w');
            nrows = length(obj.datCellArray);
            for row = 1:nrows
                fprintf(fout,'%s\n',obj.datCellArray{row});
            end
            fclose(fout);
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        function readDat(obj)
%%%%%%%%%%% Store the .dat text in a cell arrray
%         function extText(obj)
            disp('storing .dat text')
            datFID = fopen(obj.flName);
            d = textscan(datFID, '%s', 'delimiter', '\n'); % put each row in cell in array
            obj.datCellArray = d{1,1}(:);                      % simplify
            fclose(datFID);
%         end
%%%%%%%%%%%%% Extract header info
            
%%%%%%%%%%%%% Extract property data

%%%%%%%%%%%%% Extract material data
            
%%%%%%%%%%%%% Extract part grid point data
%         function extGrid(obj)
            disp('extracting grid data')
            obj.gi = find(not(cellfun('isempty',strfind(obj.datCellArray,'GRID'))));  % index of each row having 'GRID'
            % Extract GRID information (small-field format)
            for ig = 1:length(obj.gi)
                obj.G(ig).iLine = obj.gi(ig);
                obj.G(ig).name = strtrim(obj.datCellArray{obj.gi(ig)}(obj.tRange{1}));
                obj.G(ig).ID = str2double(obj.datCellArray{obj.gi(ig)}(obj.tRange{2}));
                obj.G(ig).CP = str2double(obj.datCellArray{obj.gi(ig)}(obj.tRange{3}));
                obj.G(ig).X(1) = obj.getValue(obj.datCellArray{obj.gi(ig)}(obj.tRange{4}));
                obj.G(ig).X(2) = obj.getValue(obj.datCellArray{obj.gi(ig)}(obj.tRange{5}));
                obj.G(ig).X(3) = obj.getValue(obj.datCellArray{obj.gi(ig)}(obj.tRange{6}));
            end
%         end
%%%%%%%%%%%%% Extract element data
%         function extElem(obj)
            disp('extracting element data')
            eStart = obj.gi(end)+1; % start of element entries begins on the row immediately after the last GRID entry
            eEnd = length(obj.datCellArray)-1; % the second to last row of the .dat file is the end of the elements
            name = deal(cellfun(@(x) strtrim(x(1:8)),obj.datCellArray(eStart:eEnd),'UniformOutput',false));
            ie = 1;
            for ii = 0:length(name)-1
                obj.E(ie).iLine = eStart+ii;
                switch char(name(ii+1))
                    case 'CHEXA'
                        obj.E(ie).name = 'CHEXA';
                        obj.E(ie).EID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).G(5)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{8}));
                        obj.E(ie).G(6)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{9}));
                        obj.E(ie).G(7)  = str2double(obj.datCellArray{eStart+ii+1}(obj.tRange{2}));
                        obj.E(ie).G(8)  = str2double(obj.datCellArray{eStart+ii+1}(obj.tRange{3}));
                        ie = ie+1;
                    case 'CQUAD4'
                        obj.E(ie).name = 'CQUAD4';
                        obj.E(ie).EID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{7}));
                        ie = ie+1;
                    case '+'
                        % no new element if text line begins with '*'
                    case 'CPENTA'
                        obj.E(ie).name = 'CPENTA';
                        obj.E(ie).EID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).G(4)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).MCID  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{8}));
                        obj.E(ie).ZOFFS  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{9}));
                        ie = ie+1;
                   case 'CTRIA3'
                        obj.E(ie).name = 'CTRIA3';
                        obj.E(ie).EID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{2}));
                        obj.E(ie).PID = str2double(obj.datCellArray{eStart+ii}(obj.tRange{3}));
                        obj.E(ie).G(1)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{4}));
                        obj.E(ie).G(2)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{5}));
                        obj.E(ie).G(3)  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{6}));
                        obj.E(ie).MCID  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{7}));
                        obj.E(ie).ZOFFS  = str2double(obj.datCellArray{eStart+ii}(obj.tRange{8}));
                        ie = ie+1;
                    otherwise
                        disp(['Unexpected text: ' char(name(ii+1))]);
                end
                
            end
        end
%%%%%%%%%%%%% Put grid point location data inside of element structs
        function geArrange(obj)
            disp('adding grid locations to elements')
            ID = vertcat(obj.G.ID);
            for i1 = 1:length(obj.E)
                for i2 = 1:length(obj.E(i1).G)
                    obj.E(i1).P{i2} = obj.G(not(ID-obj.E(i1).G(i2))).X;
                end
                obj.E(i1).C = mean(vertcat(obj.E(i1).P{:}));
%                 fprintf('finished storing grid point coordinates of elemnt #%d\n',i1)
            end
        end
    end
    methods (Static)            
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
%                     if isnan(value)
%                         disp('is NaN')
%                     end
                end
            end
            
            function str = num2nastranSFFstr(num)
                % function str=num2nastranSFFstr(num); OR
                % str=num2fixedlengthstr(num, roundingflag);
                %
                % Convert double, NUM, to decimal string having 8 as the maximum length
                %
                % Convert double NUM to decimal string having MAXLENGTH [8] as maximum
                % length. Smart conversion with accurate result despite length constraint.
                %
                % ROUNDINGFLAG: 0 or [1]
                % 0: truncate fracional part (quicker)
                % 1: rounding fracional part (more accurate).
                %
                % Update: 15/Aug/2008, remove leading "0" when the string starts
                % as "0.xxxx"
                % 02-Aug-2010, replace num2str by sprintf (faster), thanks Erich
                %
                % Update: 03/Feb/2016 By: TEC
                % for Nastran small-field formant, remove 'E' and keep '+' sign for
                % exponential output
                %

                        if nargin<2
                            roundingflag=1; % rounding by default
                        end

                        maxlength = 8; % size of field for Nastran SFF
                        if num>=0
                            fracNDigits=maxlength;
                        else
                            fracNDigits=maxlength-1;
                        end


                        % "%G" format:
                        % ANSI specification X3.159-1989: "Programming Language C,"
                        % ANSI, 1430 Broadway, New York, NY 10018.
                        % str=num2str(num,['%0.' num2str(fracNDigits) 'G']);
                        str=sprintf('%0.*G', fracNDigits, num);
                        %
                        % Try to compact the string data to fit inside the field length
                        %
                        while length(str)>maxlength
                            if regexp(str,'^0\.') % delete the leading 0 in "0.xxx"
                                str(1)=[];
                                continue;
                            end
                            [istart iend]=regexp(str,'[+-](0)+'); % +/- followed by multiple 0
                            if ~isempty(istart) % Remove zero in xxxE+000yy or xxxE-000yy
                                str(istart+1:iend)=[];
                                continue
                            else
                %%%%% Remove this section for Nastran small-field format modification
                %                 [istart iend]=regexp(str,'E[+]');
                %                 if ~isempty(istart) % Remove "+" char in xxxE+yyy
                %                     str(iend)=[];
                %                     continue
                %                 end
                % 
                %                 [istart iend]=regexp(str,'E[+-]');
                %                 if ~isempty(istart) % Remove "E" char in xxxE+yyy or xxxE-yyy
                %                     str(istart)=[];
                %                     continue
                %                 end
                            end
                            idot=find(str=='.',1,'first');
                            if ~isempty(idot)
                                iE=find(str=='E',1,'first');
                                if roundingflag % rounding fraction part
                                    % Calculate the Length of the fractional part
                                    % Adjust its number of digits and start over again
                                    if ~isempty(iE) % before the mantissa
                                        % accommodate for the 'E' and remove at the end      
                                        maxlength = maxlength + 1;
                                        fracNDigits=maxlength-length(str)+iE-idot-1;
                %                         fracNDigits=maxlength-length(str)+iE-idot;
                                        %str=num2str(num,['%0.' num2str(fracNDigits) 'E']);
                                        str=sprintf('%0.*E', fracNDigits, num);
                                    else %if idot<=maxlength+1 % no mantissa
                                        fracNDigits=maxlength-idot;
                                        %str=num2str(num,['%0.' num2str(fracNDigits) 'f']);
                                        str=sprintf('%0.*f', fracNDigits, num);
                                    end
                                    roundingflag=0; % won't do rounding again
                                    continue % second pass with new string
                                else
                                    % truncate the fractional part
                                    if ~isempty(iE) % before the mantissa
                                        str(maxlength-length(str)+iE:iE-1)=[];
                %                         str(maxlength-length(str)+iE:iE-2)=[];  % allow one more decimal and remove 'E' at end
                %                         str(str=='E') = [];
                                        return;
                                    else %if idot<=maxlength+1 % no mantissa
                                        str(maxlength+1:end)=[];
                                        return;
                                    end
                                end
                            end
                            % it should not never go here, unless BUG
                            error('BuildMPS: cannot convert %0.12e to string\n',num);
                        end % while loop

                    % remove E for Nastran small-field format
                    iE=find(str=='E',1,'first');
                    if ~isempty(iE)
                        str(iE) = [];
                    end
                    while length(str) < 8
                        str = [' ', str];
                    end
                    if length(str) ~= 8
                        error('string is not 8 characters long')
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
%             function fText = getField(nastCellArray,lineNum,fldNum)
%                 switch fldNum
%                     case 1
%                         fText =  str2double(nastCellArray{lineNum}(1:8));
%                     case 2
%                         fText =  str2double(nastCellArray{lineNum}(9:16));
%                     case 3
%                         fText =  str2double(nastCellArray{lineNum}(17:24));
%                     case 4
%                         fText =  str2double(nastCellArray{lineNum}(25:32));
%                     case 5
%                         fText =  str2double(nastCellArray{lineNum}(33:40));
%                     case 6
%                         fText =  str2double(nastCellArray{lineNum}(41:48));
%                     case 7
%                         fText =  str2double(nastCellArray{lineNum}(49:56));
%                     case 8
%                         fText =  str2double(nastCellArray{lineNum}(57:64));
%                     case 9
%                         fText =  str2double(nastCellArray{lineNum}(65:72));
%                     case 10
%                         fText =  str2double(nastCellArray{lineNum}(73:80));
%                     case 11
%                         fText =  str2double(nastCellArray{lineNum}(1:8));
%                     case 12
%                         fText =  str2double(nastCellArray{lineNum}(9:16));
%                     case 13
%                         fText =  str2double(nastCellArray{lineNum}(17:24));
%                     otherwise
%                         disp('Incorrect Field Requested')
%                 end                        
%             end
            
            
            
        end
%     end
end

