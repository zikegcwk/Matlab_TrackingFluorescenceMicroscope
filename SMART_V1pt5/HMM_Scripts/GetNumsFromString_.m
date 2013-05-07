function varargout = GetNumsFromString_(s)
numsstr = regexp(s,'(?<=\D*)\d*(?=\D*)','match');
for i = 1:length(numsstr),
    varargout{i} = str2double(numsstr{i});
end