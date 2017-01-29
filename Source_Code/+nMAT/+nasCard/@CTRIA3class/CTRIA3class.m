classdef CTRIA3class < nMAT.cardClass
    %CTRIA3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        EID;        % Element ID
        PID;        % Property ID
        G;          % Grid point IDs
        MCID;       % Material coord system ID
        ZOFFS;      % Z-Offset
        P;          % Cell array of grid point locations
        C;          % Element centroids
        tLam;       % Thickness of laminate at the centroid
        tRL;        % Thickness of Replication Layer at the centroid
    end
    
    methods
        function obj = CTRIA3class(C)
            f = obj.f;
            obj.name = strtrim(C(1,f{1}));
            obj.EID  = obj.getValue(C(1,f{2}));
            obj.PID  = obj.getValue(C(1,f{3}));
            obj.G(1) = obj.getValue(C(1,f{4}));
            obj.G(2) = obj.getValue(C(1,f{5}));
            obj.G(3) = obj.getValue(C(1,f{6}));
            obj.MCID = obj.getValue(C(1,f{7}));
%             obj.ZOFFS = obj.getValue(C(1,f{8}));
        end
    end
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid,rlFlag)
            CS = cell(1,10);
            CS{1,1} = sprintf('%-8s',obj.name);
            CS{1,2} = sprintf('%-8d',obj.EID);
            CS{1,3} = sprintf('%-8d',obj.PID);
            CS{1,4} = sprintf('%-8d',obj.G(1));
            CS{1,5} = sprintf('%-8d',obj.G(2));
            CS{1,6} = sprintf('%-8d',obj.G(3));
            CS{1,7} = sprintf('%-8d',obj.MCID);
            % find total thickness, divide by 2 to get ZOFFS
            if rlFlag
                obj.ZOFFS = 0.5*(obj.tLam + obj.tRL);
            else
                obj.ZOFFS = 0.5*obj.tLam;
            end
            CS{1,8} = num2nasSFFstr(obj.ZOFFS);
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

