%% %%%%%%%% Store the bdf text in a cell arrray %%%%%%%%%%%%%%%%%%%%%%%%%%%
function charArray = readBDF(flName)
    fprintf('storing text from %s\n',flName)
    FID = fopen(flName);
    d = textscan(FID, '%s', 'delimiter', '\n', 'whitespace', ''); % put each row in cell in a cell array
%     cellArray = d{1,1}(:);                      % simplify
%     charArray = char(cellArray);
    charArray = char(d{1}(:));  % reformat to a character array
    fclose(FID);
end
