classdef cardClass < handle
    %CARDCLASS 
    %   Extracts all cards from bdfObj into an object array unique to
    %   the card type.
    %   A card is distinguished in the bdf file by a string in the first
    %   field equal to one of the established card types in the card list.
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
        cList;   % cell array of strings with each supported card name
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Constant, Hidden)
        f = {1:8 9:16 17:24 25:32 33:40 41:48 49:56 57:64 65:72 73:80};
        formatSpec = '%s%s%s%s%s%s%s%s%s%s\n';
        fNumSep = '$<--1--><---2--><---3--><---4--><---5--><---6--><---7--><---8--><---9--><--10-->';
        % polynomial coefficients for each property as functions of
        % thickness. see K13C_Boron Properties by thickness_EMB.xlsx
        c_K13C  = [0.0000E+00  3.9800E-02  1.0000E-04;
                   0.0000E+00 -1.0832E+09  1.5483E+08;
                   0.0000E+00 -2.2416E+06  8.3730E+05;
                   0.0000E+00  2.3486E+00  3.4900E-02;
                   0.0000E+00 -1.1490E+07  1.3583E+06;
                   0.0000E+00 -1.1490E+07  1.3583E+06;
                   0.0000E+00 -5.7450E+06  6.7915E+05;
                   0.0000E+00 -3.2660E-01  8.7900E-02;
                   0.0000E+00  3.0316E-06 -9.1560E-07;
                   0.0000E+00  3.4187E-04 -4.4338E-06];
               
        c_Boron = [0.0000E+00  4.7400E-02 -3.0000E-04
                   0.0000E+00 -6.4479E+08  8.6106E+07
                   3.7161E+09 -6.0312E+08  2.6368E+07
                   0.0000E+00  1.7034E+00  1.2580E-01
                   1.2486E+09 -2.0210E+08  8.8010E+06
                   1.2486E+09 -2.0210E+08  8.8010E+06
                   6.2430E+08 -1.0105E+08  4.4005E+06
                   0.0000E+00 -5.3370E-01  1.1220E-01
                   0.0000E+00  6.2569E-06  1.4680E-06
                   0.0000E+00  4.4998E-04 -2.1188E-05];
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     properties (Dependent)
%         f;      % field index ranges
%     end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = cardClass()        
            obj.genCardList();
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function cL = get.cList(obj)
%             disp('getting cList')
            cL = obj.cList;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = set.cList(obj,cL)
%             disp('setting cList')
            cL = obj.cList;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         function val = get.f(obj)
% %             disp('getting f')
%             val = {1:8 9:16 17:24 25:32 33:40 41:48 49:56 57:64 65:72 73:80};
%         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = genCardList(obj)
            % generate card list using +nasCard Package directory
            cardDir = dir('P:\Coon_MATLAB_Lib\+nMAT\+nasCard');
            obj.cList = cellfun(@(x) x(2:end),{cardDir(3:end).name},'UniformOutput',false);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function value = getValue(string)
        % CHECKNUMBER takes STRING and checks if it can be converted to a
        % number. If it is not, then it assumes an exponential in Nastran
        % form and converts to numerical VALUE
            value = str2double(string);
            if isnan(value)
                idel = regexp(string,'[+-]');
                if strcmp(string,'        ')
                    value = 'BLANK';
                    return
                elseif isempty(idel)
                    error('unrecognized character array')
                end
                num = str2double(string(1:idel(end)-1));
                expon = str2double(string(idel(end):end));
                value = num*10^expon;
                if isnan(value)
                    disp('there is a problem')
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function matchGP(obj)
            % add grid point location data into element object
            ID = vertcat(obj.GRID.ID);
            if isfield(obj,'CTRIA3')
                for i = 1:length(obj.CTRIA3)
                    for j = 1:length(obj.CTRIA3(i).G)
                        obj.CTRIA3(i).P{j} = obj.GRID(not(ID-obj.CTRIA3(i).G(j))).X;
                    end
                    obj.CTRIA3(i).C = mean(vertcat(obj.CTRIA3(i).P{:}));
                end
            end
            if isfield(obj,'CQUAD4')
                for i = 1:length(obj.CQUAD4)
                    for j = 1:length(obj.CQUAD4(i).G)
                        obj.CQUAD4(i).P{j} = obj.GRID(not(ID-obj.CQUAD4(i).G(j))).X;
                    end
                    obj.CQUAD4(i).C = mean(vertcat(obj.CQUAD4(i).P{:}));
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % copy OLD handle object and copy values referenced by OLD object
        function new = makeCopy(old)
            % Instantiate new object of the same class.
            new = feval(class(old));
            % Copy all non-hidden properties.
            p = properties(old);
            for i = 1:length(p)
                new.(p{i}) = old.(p{i});
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeFieldNum(fid)
            fprintf(fid,fNumSep);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         function fNums = get.f(obj)
%         % return field number ranges
%             fNums = obj.f;
%         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

