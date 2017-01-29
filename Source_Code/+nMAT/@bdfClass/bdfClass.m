classdef bdfClass < handle
    %BDFCLASS reads and writes bdfs
    %   The supplied bdf is read into a cell array of strings, one cell per
    %   line.

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (GetAccess = protected, SetAccess = private)
        flName;         % file name w/ extension
        cellArray;   % each line of text in one cell of a cell array
        fRange;
        activeCards;
%         cardObj = cardClass;
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = bdfClass(fileName,varargin)
            if nargin == 0
                fileName = 'TestnMAT.bdf';
            end
            obj.flName = fileName;
            obj.readBDF()
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
    %%%%%%% Store the bdf text in a cell arrray %%%%%%%%%%%%%%%%%%%%%%%%%%%
        function readBDF(obj)
            fprintf('storing text from %s\n',obj.flName)
            FID = fopen(obj.flName);
            d = textscan(FID, '%s', 'delimiter', '\n'); % put each row in cell in array
            obj.cellArray = d{1,1}(:);                      % simplify
            fclose(FID);
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Separate 
        function getCards(obj)
            
        end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fileFormat(obj)
            format = 'SFF';
            switch format
                case 'SFF'
                    obj.fRange = {1:8 9:16 17:24 25:32 33:40 41:48 49:56 57:64 65:72 73:80};
                otherwise
                    
            end
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function str = getField(obj,fNum)
            if fNum < 1
                error('Field Number is less than 1\n')
            elseif fNum <= 10
                
            end
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Static)
        
    end
end

