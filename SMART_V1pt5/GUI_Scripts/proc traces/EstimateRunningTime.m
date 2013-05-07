function EstimateRunningTime(params)
%% estimate time for one iteration
A = params.Ainitial;
if strcmp(A,'auto'),
    A = GetAutoAinitial_(params.nStates);
end
E = params.Einitial;
if strcmp(E,'auto'),
    E = GetAutoEinitial_(params.data,params.nStates,params.nChannels,params.fitChannelType);
end

tic
[P,F,B,normF,normB,logPx] = Post_(A,E,params.fitChannelType,params.data);
cumsumlognormF = cumsum(log(normF));
cumsumlognormB = fliplr(cumsum(log(fliplr(normB))));

iterationTime = toc

%% estimate number of iterations
maxIterations = [2 params.maxIterEM]; %[lower upper]

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

for i = 1:length(paramsToTry2D),
    temp = params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))};
    maxIterations = maxIterations + length(temp{1})*length(temp{2});
end
for i = 1:length(paramsToTry1D),
    temp = params.ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))};
    maxIterations = maxIterations + length(temp);
end

clear paramsToTry2D;
clear paramsToTry1D;

paramsToTry2D = regexp(params.paramsErrorToBoundAuto,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))','match');
paramsToTry1D = regexp(params.paramsErrorToBoundAuto,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])','match');
paramsToTry1D = [regexp(params.paramsErrorToBoundAuto,'^.\(\d*(,\d*)*\)','match') paramsToTry1D];
paramsToTry1D = [paramsToTry1D regexp(params.paramsErrorToBoundAuto,'.\(\d*(,\d*)*\)$','match')];

maxIterations = maxIterations + length(paramsToTry2D)*params.auto_boundsMeshSize^2 + length(paramsToTry1D)*params.auto_boundsMeshSize;

disp(['estimated time to train and get error bounds ' num2str(round(maxIterations(1)*iterationTime)) ' to ' num2str(round(maxIterations(2)*iterationTime)) 's']);

