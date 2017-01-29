classdef MAT8class < nMAT.cardClass
    %MAT8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        MID;    % Material ID
        E1;     % Modulus in longitudinal-/fiber-/1-direction
        E2;     % Modulus in lateral-/matrix-/2-direction
        NU12;   % Poisson's ratio for uniaxial loading in 1-direction
        G12;    % In-plane shear modulus
        G1Z;    % Transverse shear modulus in 1Z-plane
        G2Z;    % Transverse shear modulus in 2Z-plane
        RHO;    % Mass density
        A1;     % CTE in 1-direction
        A2;     % CTE in 2-direction
        TREF;   % Reference temperature
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = MAT8class(varargin)
            if ischar(varargin{1})
                charArray = varargin{1};
                obj.readCard(charArray)
            elseif isnumeric(varargin{1})
                thickness = varargin{1};    % CMM composite thickness
                lam_type = varargin{2};     % K13C/996 or Boron/996
                mid = varargin{3};          % Mat ID determined by script
                obj.calcCard(thickness,lam_type,mid);
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
            obj.E1   = obj.getValue(C(1,f{3}));
            obj.E2   = obj.getValue(C(1,f{4}));
            obj.NU12 = obj.getValue(C(1,f{5}));
            obj.G12  = obj.getValue(C(1,f{6}));
            obj.G1Z  = obj.getValue(C(1,f{7}));
            obj.G2Z  = obj.getValue(C(1,f{8}));
            obj.RHO  = obj.getValue(C(1,f{9}));
            obj.A1   = obj.getValue(C(2,f{2}));
            obj.A2   = obj.getValue(C(2,f{3}));
            obj.TREF = obj.getValue(C(2,f{4}));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function calcCard(obj,t,lName,mid)
            switch lName
                case 'K13C'
                    c = obj.c_K13C;              
                case 'Boron'
                    c = obj.c_Boron;
            end
            obj.name = 'MAT8';
            obj.MID  = mid;
            obj.E1   = polyval(c(2,:),t);
            obj.E2   = polyval(c(3,:),t);
            obj.NU12 = polyval(c(4,:),t);
            obj.G12  = polyval(c(5,:),t);
            obj.G1Z  = polyval(c(6,:),t);
            obj.G2Z  = polyval(c(7,:),t);
            obj.RHO  = polyval(c(8,:),t);
            obj.A1   = polyval(c(9,:),t);
            obj.A2   = polyval(c(10,:),t);
            obj.TREF = 68;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid)
            CS = cell(2,10);
            CS{1,1} = sprintf('%-8s',obj.name);
            CS{1,2} = sprintf('%-8d',obj.MID);
            CS{1,3} = num2nasSFFstr(obj.E1);
            CS{1,4} = num2nasSFFstr(obj.E2);
            CS{1,5} = num2nasSFFstr(obj.NU12);
            CS{1,6} = num2nasSFFstr(obj.G12);
            CS{1,7} = num2nasSFFstr(obj.G1Z);
            CS{1,8} = num2nasSFFstr(obj.G2Z);
            CS{1,9} = num2nasSFFstr(obj.RHO);
            CS{2,2} = num2nasSFFstr(obj.A1);
            CS{2,3} = num2nasSFFstr(obj.A2);
            CS{2,4} = num2nasSFFstr(obj.TREF);
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

