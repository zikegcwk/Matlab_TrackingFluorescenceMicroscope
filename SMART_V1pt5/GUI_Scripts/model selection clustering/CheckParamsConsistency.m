function CheckParamsConsistency(params)
if (params.nChannels ~= size(params.data,2)),
    error('params inconsistency: nChannels must match number of columns of data');
end
if length(params.fitChannelType) ~= params.nChannels,
    error('params inconsistency: nChannels must match length of fitChannelType, specify a signal type for each channel');
end
% warn if trying to use 'exp' fit for data that contains negative entries  
for i = 1:params.nChannels,
    if strcmp(params.fitChannelType{i},'exp') && (min(params.data(:,i)) < 0),
        error(['params inconsistency: cannot apply ''exp'' fit to channel ' num2str(i) ' because it contains negative entries']);
    end
end
if ~(strcmp(params.Ainitial,'auto')),
    if min(size(params.Ainitial) == [params.nStates params.nStates]) == 0,
        error('params inconsistency: size of manually set Ainitial must be nStates by nStates');
    end
    if min(abs(sum(params.Ainitial,2)-ones(params.nStates,1))) ~= 0,
        error('params inconsistency: manually set Ainitial rows do not add up to 1');
    end
    if max(max((params.Ainitial > 1) + (params.Ainitial < 0))) > 0,
        error('params inconsistency: manually set Ainitial must contain only elements in the range [0,1]');
    end
end

if ~(strcmp(params.Einitial,'auto')),
    if size(params.Einitial,1) ~= params.nStates,
        error('params inconsistency: nStates must match number of rows of E for manual initial value');
    end
    if size(params.Einitial,2) ~= params.nChannels,
        error('params inconsistency: nChannels must match number of columns of E for manual initial value');
    end
    for i = 1:params.nChannels,
        for j = 1:params.nStates,
            if strcmp(params.fitChannelType{i},'exp'),
                if min(size(params.Einitial{j,i}) == [1 1]) == 0,
                    error(['params inconsistency: E{' num2str(j) ',' num2str(i) '} specifies mean of ''exp'' signal and so must have size [1 1]']);
                end
            elseif strcmp(params.fitChannelType{i},'gauss'),
                if min(size(params.Einitial{j,i}) == [2 1]) == 0,
                    error(['params inconsistency: E{' num2str(j) ',' num2str(i) '} specifies [mean ; stdev] of ''gauss'' signal and so must have size [2 1]']);
                end
            end
        end
    end
end

if params.auto_boundsMeshSize < 3,
    error('params inconsistency: auto_boundsMeshSize must be at least 3');
end

% check consistency of manual error bounds region
paramsToTry2D = regexp(params.paramsErrorToBoundManual,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))','match');
paramsToTry1D = regexp(params.paramsErrorToBoundManual,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])','match');
paramsToTry1D = [regexp(params.paramsErrorToBoundManual,'^.\(\d*(,\d*)*\)','match') paramsToTry1D];
paramsToTry1D = [paramsToTry1D regexp(params.paramsErrorToBoundManual,'.\(\d*(,\d*)*\)$','match')];
% get indeces of starting positions
paramsToTry2Didxs = regexp(params.paramsErrorToBoundManual,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))');
paramsToTry1Didxs = regexp(params.paramsErrorToBoundManual,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])');
paramsToTry1Didxs = [regexp(params.paramsErrorToBoundManual,'^.\(\d*(,\d*)*\)') paramsToTry1Didxs];
paramsToTry1Didxs = [paramsToTry1Didxs regexp(params.paramsErrorToBoundManual,'.\(\d*(,\d*)*\)$')];
allidxs = sort([paramsToTry2Didxs  paramsToTry1Didxs],'ascend');

%get 2D confidence regions

if (length(paramsToTry2D) + length(paramsToTry1D)) ~= length(params.ManualBoundRegions),
    error('params inconsistency: number of ManualBoundRegions must match string input paramsErrorToBoundManual');
end
for i = 1:length(paramsToTry2D),
    if min(size(params.ManualBoundRegions{i}) == [1 2]) == 0,
        error('params inconsistency: 2-D ManualBoundRegions must be of form {rowvector, rowvector}');
    end
    if size(params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))}{1},1) > ...
            size(params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))}{1},2),
        error('params inconsistency: 2-D ManualBoundRegions must be of form {rowvector, rowvector}');
    end
    if size(params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))}{2},1) > ...
            size(params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))}{2},2),
        error('params inconsistency: 2-D ManualBoundRegions must be of form {rowvector, rowvector}');
    end
end
for i = 1:length(paramsToTry1D),
    if size(params.ManualBoundRegions{find(allidxs == paramsToTry1Didxs(i))},1) > ...
        size(params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))},2),
        error('params inconsistency: 1-D ManualBoundRegions must be of form rowvector');
    end
end
