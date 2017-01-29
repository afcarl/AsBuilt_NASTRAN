classdef MAT1class < nMAT.cardClass
    %MAT1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        MID;    % Material ID
        E;      % Young's Modulus
        G;      % Shear Modulus
        NU;     % Poisson's Ratio
        RHO;    % Mass density
        A;      % Thermal Expansion Coefficient
        TREF;   % Reference temperature
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = MAT1class(varargin)
            if ischar(varargin{1})
                charArray = varargin{1};
                obj.readCard(charArray)
            else 
                error('unrecognized input')
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function readCard(obj,C)
            f = obj.f;
            obj.name = strtrim(C(1,f{1}));
            obj.MID  = obj.getValue(C(1,f{2}));
            obj.E    = obj.getValue(C(1,f{3}));
            obj.G    = obj.getValue(C(1,f{4}));
            obj.NU   = obj.getValue(C(1,f{5}));
            obj.RHO  = obj.getValue(C(1,f{6}));
            obj.A    = obj.getValue(C(1,f{7}));
            obj.TREF = obj.getValue(C(1,f{8}));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid)
            CS = cell(1,10);
            CS{1,1} = sprintf('%-8s',obj.name);
            CS{1,2} = sprintf('%-8d',obj.MID);
            CS{1,3} = num2nasSFFstr(obj.E);
            CS{1,4} = num2nasSFFstr(obj.G);
            CS{1,5} = num2nasSFFstr(obj.NU);
            CS{1,6} = num2nasSFFstr(obj.RHO);
            CS{1,7} = num2nasSFFstr(obj.A);
            CS{1,8} = num2nasSFFstr(obj.TREF);
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

