% Tim Coon
% 20160216
function bdf = parseCards(bdf)
h = waitbar(0,'Parsing Cards.');
    % parse into card object arrays
    i = 1;  % initialize line index
    L = size(bdf.charArray,1);
    while i <= L
        f1 = strtrim(bdf.charArray(i,1:8)); % field #1 (if first line of a card)
%         fprintf('Check Line #%d\n',i)
%         if f1 == cList
%             N = matlab.lang.makeValidName(S)
%         end
        switch f1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            case 'CORD2R'
                l = i+1;
                if isfield(bdf,'CORD2R')
                    bdf.CORD2R(end+1) = nMAT.nasCard.CORD2Rclass(bdf.charArray(i:l,:));
                else
                    bdf.CORD2R = nMAT.nasCard.CORD2Rclass(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'PCOMP'
                l = i+14;
                if isfield(bdf,'PCOMP')
                    bdf.PCOMP(end+1) = nMAT.nasCard.PCOMPclass(bdf.charArray(i:l,:));
                else
                    bdf.PCOMP = nMAT.nasCard.PCOMPclass(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'PSOLID'
                l = i+0;
                if isfield(bdf,'PSOLID')
                    bdf.PSOLID(end+1) = nMAT.nasCard.PSOLIDclass(bdf.charArray(i:l,:));
                else
                    bdf.PSOLID = nMAT.nasCard.PSOLIDclass(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'MAT1'
                l = i+1;
                if isfield(bdf,'MAT1')
                    bdf.MAT1(end+1) = nMAT.nasCard.MAT1class(bdf.charArray(i:l,:));
                else
                    bdf.MAT1 = nMAT.nasCard.MAT1class(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'MAT8'
                l = i+1;
                if isfield(bdf,'MAT8')
                    bdf.MAT8(end+1) = nMAT.nasCard.MAT8class(bdf.charArray(i:l,:));
                else
                    bdf.MAT8 = nMAT.nasCard.MAT8class(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            case 'GRID'
                l = i+0;
                if isfield(bdf,'GRID')
                    bdf.GRID(end+1) = nMAT.nasCard.GRIDclass(bdf.charArray(i:l,:));
                else
                    bdf.GRID = nMAT.nasCard.GRIDclass(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            case 'CQUAD4'
                l = i+0;
                if isfield(bdf,'CQUAD4')
                    bdf.CQUAD4(end+1) = nMAT.nasCard.CQUAD4class(bdf.charArray(i:l,:));
                else
                    bdf.CQUAD4 = nMAT.nasCard.CQUAD4class(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            case 'CTRIA3'
                l = i+0;
                if isfield(bdf,'CTRIA3')
                    bdf.CTRIA3(end+1) = nMAT.nasCard.CTRIA3class(bdf.charArray(i:l,:));
                else
                    bdf.CTRIA3 = nMAT.nasCard.CTRIA3class(bdf.charArray(i:l,:));
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            otherwise
%                 disp('no matching card class defined')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        waitbar(i/L);
        i = i+1;
    end
    close(h)
end
