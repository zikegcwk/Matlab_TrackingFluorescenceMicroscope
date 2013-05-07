function errorBounds = GetErrorBoundsManual_(A,E,fitChannelType,x,paramsErrorToBound,ManualBoundRegions)
paramsToTry2D = regexp(paramsErrorToBound,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))','match');
paramsToTry1D = regexp(paramsErrorToBound,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])','match');
paramsToTry1D = [regexp(paramsErrorToBound,'^.\(\d*(,\d*)*\)','match') paramsToTry1D];
paramsToTry1D = [paramsToTry1D regexp(paramsErrorToBound,'(?<=,).\(\d*(,\d*)*\)$','match')];

% get indeces of starting positions
paramsToTry2Didxs = regexp(paramsErrorToBound,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))');
paramsToTry1Didxs = regexp(paramsErrorToBound,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])');
paramsToTry1Didxs = [regexp(paramsErrorToBound,'^.\(\d*(,\d*)*\)') paramsToTry1Didxs];
paramsToTry1Didxs = [paramsToTry1Didxs regexp(paramsErrorToBound,'(?<=,).\(\d*(,\d*)*\)$')];
allidxs = sort([paramsToTry2Didxs  paramsToTry1Didxs],'ascend');

n = length(paramsToTry2D) + length(paramsToTry1D);
errorBounds = struct('dimension',cell([n 1]),'var1name',[],'var2name',[],'var1region',[],'var2region',[],'PMat',[]);

%get 2D confidence regions
for i = 1:length(paramsToTry2D),
    varsstr = regexp(paramsToTry2D{i},'[ae]\(\d*(,\d*)*\)','match');
    errorBounds(i).dimension = 2;
    for j = 1:2,
        errorBounds(i).(['var' num2str(j) 'name']) = varsstr{j};
        errorBounds(i).(['var' num2str(j) 'region']) = ManualBoundRegions{find(allidxs == paramsToTry2Didxs(i))}{j}';
    end    
end
%get 1D confidence regions
for i = length(paramsToTry2D)+1:length(paramsToTry2D)+length(paramsToTry1D),
    varsstr = regexp(paramsToTry1D{i-length(paramsToTry2D)},'[ae]\(\d*(,\d*)*\)','match');
    errorBounds(i).dimension = 1;    
    errorBounds(i).var1name = varsstr{1};
    errorBounds(i).var2name = [];
    errorBounds(i).var1region = ManualBoundRegions{find(allidxs == paramsToTry1Didxs(i-length(paramsToTry2D)))}';
    errorBounds(i).var2region = [];   
end

% get matrix M(i,j) = exp(log(Px|A',E') - log(Px|A,E))
logPxMax = LogPxWith_E_(A,E,fitChannelType,x);
% get 2D M(i,j)
for i = 1:length(paramsToTry2D),
    errorBounds(i).PMat = zeros(length(errorBounds(i).var1region),length(errorBounds(i).var2region));
    for j = 1:length(errorBounds(i).var1region),
        for k = 1:length(errorBounds(i).var2region),
            Atry = A;
            Etry = E;
            
            rclist = [];
            if strcmp(errorBounds(i).var1name(1), 'a'),
                [r,c] = GetNumsFromString_(errorBounds(i).var1name);
                Atry(r,c) = errorBounds(i).var1region(j);
                rclist = [rclist ; r c];
            elseif strcmp(errorBounds(i).var1name(1), 'e'),
                [n,c,p] = GetNumsFromString_(errorBounds(i).var1name);
                Etry{n,c}(p) = errorBounds(i).var1region(j);
            end
            if strcmp(errorBounds(i).var2name(1), 'a'),
                [r,c] = GetNumsFromString_(errorBounds(i).var2name);
                Atry(r,c) = errorBounds(i).var2region(k);
                rclist = [rclist ; r c];
            elseif strcmp(errorBounds(i).var2name(1), 'e'),
                [n,c,p] = GetNumsFromString_(errorBounds(i).var2name);
                Etry{n,c}(p) = errorBounds(i).var2region(k);
            end
            
            Atry = ARenormalizeWithFixed_(rclist,Atry);
            
            errorBounds(i).PMat(j,k) = LogPxWith_E_(Atry,Etry,fitChannelType,x);
        end
    end
    errorBounds(i).PMat = exp(errorBounds(i).PMat-logPxMax);
end
% get 1D M(i)
for i = length(paramsToTry2D)+1:length(paramsToTry2D)+length(paramsToTry1D),
    errorBounds(i).PMat = zeros(length(errorBounds(i).var1region),1);
    for j = 1:length(errorBounds(i).var1region),
        Atry = A;
        Etry = E;

        rclist = [];
        if strcmp(errorBounds(i).var1name(1), 'a'),
            [r,c] = GetNumsFromString_(errorBounds(i).var1name);
            Atry(r,c) = errorBounds(i).var1region(j);
            rclist = [rclist ; r c];
        elseif strcmp(errorBounds(i).var1name(1), 'e'),
            [n,c,p] = GetNumsFromString_(errorBounds(i).var1name);
            Etry{n,c}(p) = errorBounds(i).var1region(j);
        end

        Atry = ARenormalizeWithFixed_(rclist,Atry);

        errorBounds(i).PMat(j) = LogPxWith_E_(Atry,Etry,fitChannelType,x);
    end
    errorBounds(i).PMat = exp(errorBounds(i).PMat-logPxMax);
end