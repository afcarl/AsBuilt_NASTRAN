classdef PCOMPclass < nMAT.cardClass
    %PCOMP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        PID;        % Property ID number
        NSM;        % Non-structural Mass
        TREF;       % Reference temperature
        MID;        % Vector of layer material reference ID numbers
        T;          % Vector of layer thickness values
        TH;         % Vector of layer orientation angles
        SOUT = 'YES';  % Stress or strain output request
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = PCOMPclass(varargin)
            
            if nargin == 0

            elseif ischar(varargin{1})
                charArray = varargin{1};
                obj.readCard(charArray)
                
            elseif isa(varargin{1},'nMAT.nasCard.PCOMPclass')
                oldObj = varargin{1};     % existing PCOMP object
                obj = nMAT.cardClass.makeCopy(oldObj);
                oldCQUAD4 = varargin{2};    % existing CQUAD4 object
                pid = varargin{3};          % PID of first PCOMP
                mid = varargin{4};          % MID of first lamina
%                 obj.calcCard(pid,mid,t);
                obj.modPCOMP(oldCQUAD4,pid,mid)
            else
            end
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end    

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function readCard(obj,C)
            f = obj.f;
            obj.name   = strtrim(C(1,f{1}));
            obj.PID    = obj.getValue(C(1,f{2}));
            obj.NSM    = 0;  %obj.getValue(C(1,f{4}));
            obj.TREF   = obj.getValue(C(1,f{7}));
            obj.MID(1) = obj.getValue(C(2,f{2}));
            obj.T(1)   = obj.getValue(C(2,f{3}));
            obj.TH(1)  = obj.getValue(C(2,f{4}));
            for j = 3:size(C,1)-1
                obj.MID(end+1) = obj.getValue(C(j,f{2}));
                obj.T(end+1)   = obj.getValue(C(j,f{3}));
                obj.TH(end+1)  = obj.getValue(C(j,f{4}));
                obj.MID(end+1) = obj.getValue(C(j,f{6}));
                obj.T(end+1)   = obj.getValue(C(j,f{7}));
                obj.TH(end+1)  = obj.getValue(C(j,f{8}));
            end
            obj.MID(end+1) = obj.getValue(C(end,f{2}));
            obj.T(end+1)   = obj.getValue(C(end,f{3}));
            obj.TH(end+1)  = obj.getValue(C(end,f{4}));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         function calcCard(obj,pid,mid,tLam,tRL)
%             
%             CPT_K13C  = polyval(obj.c_K13C(1,:) ,tLam);
%             CPT_Boron = polyval(obj.c_Boron(1,:),tLam);
%             
%             obj.PID               = pid;
%             obj.MID([2:10,17:25]) = mid;
%             obj.MID(11:16)        = mid + 1;
%             obj.T([2:10,17:25])   = CPT_K13C;
%             obj.T(11:16)          = CPT_Boron;
%             obj.T(end)            = tRL;
%         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function modPCOMP(obj,cObj,pid,mid)
            CPT_K13C  = polyval(obj.c_K13C(1,:) ,cObj.tLam);
            CPT_Boron = polyval(obj.c_Boron(1,:),cObj.tLam);
            
            obj.PID               = pid;
            obj.MID([2:10,17:25]) = mid;
            obj.MID(11:16)        = mid + 1;
            obj.T([2:10,17:25])   = CPT_K13C;
            obj.T(11:16)          = CPT_Boron;
            obj.T(end)            = cObj.tRL;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid,rlFlag)
            CS = cell(14,10);
            CS{1,1}  = sprintf('%-8s',obj.name);
            CS{1,2}  = sprintf('%-8d',obj.PID);
            CS{1,4}  = num2nasSFFstr(obj.NSM);
            CS{1,7}  = num2nasSFFstr(obj.TREF);
            CS{2,2}  = sprintf('%-8d',obj.MID(1));
            CS{2,3}  = num2nasSFFstr(obj.T(1));
            CS{2,4}  = num2nasSFFstr(obj.TH(1));
            CS{2,5}  = sprintf('%8s','YES ');
            if rlFlag
                CS{15,2}  = sprintf('%-8d',obj.MID(end));
                CS{15,3}  = num2nasSFFstr(obj.T(end));
                CS{15,4}  = num2nasSFFstr(obj.TH(end));
                CS{15,5}  = sprintf('%8s','YES ');
            end
            for i = 3:14        % i = line number
                i1 = 2*i-4; i2 = i1+1;
                CS{i,2}  = sprintf('%-8d',obj.MID(i1));
                CS{i,3}  = num2nasSFFstr(obj.T(i1));
                CS{i,4}  = num2nasSFFstr(obj.TH(i1));
                CS{i,5}  = sprintf('%8s','YES ');
                CS{i,6}  = sprintf('%-8d',obj.MID(i2));
                CS{i,7}  = num2nasSFFstr(obj.T(i2));
                CS{i,8}  = num2nasSFFstr(obj.TH(i2));
                CS{i,9}  = sprintf('%8s','YES ');
            end
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

