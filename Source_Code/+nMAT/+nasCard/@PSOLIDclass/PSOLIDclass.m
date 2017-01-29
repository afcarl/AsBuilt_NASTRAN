classdef PSOLIDclass < nMAT.cardClass
    %PSOLIDCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        PID;     % property ID
        MID;     % material ID
        CORDM;   % material coordinate ID
    end
    
    methods
        function obj = PSOLIDclass(C)
            f = obj.f;
            obj.name = strtrim(C(1,f{1}));
            obj.PID   = obj.getValue(C(1,f{2}));
            obj.MID   = obj.getValue(C(1,f{3}));
            obj.CORDM = obj.getValue(C(1,f{4}));
        end
    end
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid)
            CS = cell(1,10);
            CS{1,1} = sprintf('%-8s',obj.name);
            CS{1,2} = sprintf('%-8d',obj.PID);
            CS{1,3} = sprintf('%-8d',obj.MID);
            CS{1,4} = sprintf('%-8d',obj.CORDM);
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end