function errorBounds = GetErrorBoundsAuto_(A,E,fitChannelType,x,confInt,boundsMeshSize,auto_MeshSpacing,paramsErrorToBound)
paramsToTry2D = regexp(paramsErrorToBound,'(?<=\().\(\d*(,\d*)*\),.\(\d*(,\d*)*\)(?=\))','match');
paramsToTry1D = regexp(paramsErrorToBound,'(?<=[^\(]).\(\d*(,\d*)*\)(?=[^\)])','match');
paramsToTry1D = [regexp(paramsErrorToBound,'^.\(\d*(,\d*)*\)','match') paramsToTry1D];
paramsToTry1D = [paramsToTry1D regexp(paramsErrorToBound,'(?<=,).\(\d*(,\d*)*\)$','match')];

n = length(paramsToTry2D) + length(paramsToTry1D);
errorBounds = struct('dimension',cell([n 1]),'var1name',[],'var2name',[],'var1region',[],'var2region',[],'PMat',[]);

%get 2D confidence regions
for i = 1:length(paramsToTry2D),
    varsstr = regexp(paramsToTry2D{i},'[ae]\(\d*(,\d*)*\)','match');
    errorBounds(i).dimension = 2;
    for j = 1:2,
        errorBounds(i).(['var' num2str(j) 'name']) = varsstr{j};
        if strcmp(varsstr{j}(1),'a'),
            [r,c] = GetNumsFromString_(varsstr{j});
            errorBounds(i).(['var' num2str(j) 'region']) = GetConfRegionSizeA_(r,c,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing);
        elseif strcmp(varsstr{j}(1),'e'),         
            [n,c,p] = GetNumsFromString_(varsstr{j});
            errorBounds(i).(['var' num2str(j) 'region']) = GetConfRegionSizeE_(n,c,p,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing);
        end
    end    
end
%get 1D confidence regions
for i = length(paramsToTry2D)+1:length(paramsToTry2D)+length(paramsToTry1D),
    varsstr = regexp(paramsToTry1D{i-length(paramsToTry2D)},'[ae]\(\d*(,\d*)*\)','match');
    errorBounds(i).dimension = 1;    
    errorBounds(i).var1name = varsstr{1};
    errorBounds(i).var2name = [];
    if strcmp(varsstr{1}(1),'a'),
        [r,c] = GetNumsFromString_(varsstr{1});
        errorBounds(i).var1region = GetConfRegionSizeA_(r,c,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing);
        errorBounds(i).var2region = [];
    elseif strcmp(varsstr{1}(1),'e'),          
        [n,c,p] = GetNumsFromString_(varsstr{1});
        errorBounds(i).var1region = GetConfRegionSizeE_(n,c,p,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing);
        errorBounds(i).var2region = [];
    end    
end
% get matrix M(i,j) = exp(log(Px|A',E') - log(Px|A,E))
logPxMax = LogPxWith_E_(A,E,fitChannelType,x);
% get 2D M(i,j)
for i = 1:length(paramsToTry2D),
    errorBounds(i).PMat = zeros(length(errorBounds(i).var1region),length(errorBounds(i).var2region));
    
    if strcmp(errorBounds(i).var1name(1), 'a') && strcmp(errorBounds(i).var2name(1), 'a'),
        e = Get_e_(E,fitChannelType,x); %precompute e if not changing emissions parameters
        both_a = true;
    else
        both_a = false;
    end
    
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
            
            if both_a,
                errorBounds(i).PMat(j,k) = LogPxWith_es_(Atry,e); %this is faster than recomputing e multiple times
            else
                errorBounds(i).PMat(j,k) = LogPxWith_E_(Atry,Etry,fitChannelType,x);
            end
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