function BIC = GetBIC_(logPxMax,N,nStates,nChannels,fitChannelType,trainA,trainE,noHops)
freeParams = 0;
if trainA,
    freeParams = freeParams + nStates^2 - nStates;
end
if trainE,
    for i = 1:nChannels,
        if strcmp(fitChannelType{i},'exp'),
            freeParams = freeParams + nStates;
        elseif strcmp(fitChannelType{i},'gauss'),
            freeParams = freeParams + nStates*2;
        elseif strcmp(fitChannelType{i},'poisson'),
            freeParams = freeParams + nStates;
        else
            warning('MATLAB:something unknown','unknown channel type when computing BIC');
        end
    end
end
%subtract free parameter for each entry in noHops
freeParams = freeParams - size(noHops,1);

BIC = -2*logPxMax + freeParams * log(N);
    