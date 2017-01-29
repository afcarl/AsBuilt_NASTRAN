classdef GRIDclass < nMAT.cardClass
    %GRID objects
    %   
    
    properties %(Access = private)
        name;
        ID;     % node ID number
        CP;     % reference coord frame ID
        X;      % position in CP axes
        CD;     % analysis coordinate frame
    end
    
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods
        function obj = GRIDclass(C)
            f = obj.f;
            obj.name = strtrim(C(1,f{1}));
            obj.ID   = obj.getValue(C(1,f{2}));
            obj.CP   = obj.getValue(C(1,f{3}));
            obj.X(1) = obj.getValue(C(1,f{4}));
            obj.X(2) = obj.getValue(C(1,f{5}));
            obj.X(3) = obj.getValue(C(1,f{6}));
            obj.CD   = obj.getValue(C(1,f{7}));
        end
    end
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid)
            CS = cell(1,10);
            CS{1,1} = sprintf('%-8s',obj.name);
            CS{1,2} = sprintf('%-8d',obj.ID);
            CS{1,3} = sprintf('%-8d',obj.CP);
            CS{1,4} = num2nasSFFstr(obj.X(1));
            CS{1,5} = num2nasSFFstr(obj.X(2));
            CS{1,6} = num2nasSFFstr(obj.X(3));
            CS{1,7} = sprintf('%-8d',obj.CD);
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

