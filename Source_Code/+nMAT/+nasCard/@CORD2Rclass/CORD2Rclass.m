classdef CORD2Rclass < nMAT.cardClass
    %CORD2R Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        name;
        CID;    % Coord Sys ID
        RID;    % Alternate CS ID
        A;      % Origin coords
        B;      % Z-axis direction vector
        C;      % Vector in xz-plane
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = CORD2Rclass(C)
            f = obj.f;
            obj.name = strtrim(C(1,f{1}));
            obj.CID  = obj.getValue(C(1,f{2}));
            obj.RID  = obj.getValue(C(1,f{3}));
            obj.A(1) = obj.getValue(C(1,f{4}));
            obj.A(2) = obj.getValue(C(1,f{5}));
            obj.A(3) = obj.getValue(C(1,f{6}));
            obj.B(1) = obj.getValue(C(1,f{7}));
            obj.B(2) = obj.getValue(C(1,f{8}));
            obj.B(3) = obj.getValue(C(1,f{9}));
            obj.C(1) = obj.getValue(C(2,f{2}));
            obj.C(2) = obj.getValue(C(2,f{3}));
            obj.C(3) = obj.getValue(C(2,f{4}));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function writeCard(obj,fid)
            CS = cell(2,10);
            CS{1,1}  = sprintf('%-8s',obj.name);
            CS{1,2}  = sprintf('%-8d',obj.CID);
            CS{1,3}  = sprintf('%-8d',obj.RID);
            CS{1,4}  = num2nasSFFstr(obj.A(1));
            CS{1,5}  = num2nasSFFstr(obj.A(2));
            CS{1,6}  = num2nasSFFstr(obj.A(3));
            CS{1,7}  = num2nasSFFstr(obj.B(1));
            CS{1,8}  = num2nasSFFstr(obj.B(2));
            CS{1,9}  = num2nasSFFstr(obj.B(3));
            CS{1,10} = '+FEMAPC1';   % this might need to change if more coord systems, C2?
            CS{2,1}  = '+FEMAPC1';
            CS{2,2}  = num2nasSFFstr(obj.C(1));
            CS{2,3}  = num2nasSFFstr(obj.C(2));
            CS{2,4}  = num2nasSFFstr(obj.C(3));
            [CS{cellfun('isempty',CS)}] = deal(sprintf('%8s',' '));
            for row = 1:size(CS,1)
                fprintf(fid,obj.formatSpec,CS{row,:});
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

