function E = GetAutoEinitial_(x,nStates,nChannels,fitChannelType,discStates)
dataMeans = mean(x);
dataStdevs = std(x);

E = cell([nStates nChannels]);
if nStates > 1,
    for i = 1:nStates,
        for j = 1:nChannels,  
            if strcmp(fitChannelType{j},'exp') || strcmp(fitChannelType{j},'gauss') || strcmp(fitChannelType{j},'poisson'),
                lbound = max(dataMeans(j)/2,dataMeans(j)-dataStdevs(j));
                ubound = dataMeans(j)+dataStdevs(j);
                m = lbound + (ubound-lbound)*(i-1)/(nStates - 1);
                E{i,j} = m;
            end
            if strcmp(fitChannelType{j},'gauss'),
                m = dataMeans(j)+dataStdevs(j)*(2*(i-1)/(nStates-1) - 1);
                v = dataStdevs(j);
                E{i,j} = [m ; v];
            end
        end
    end
else
    for j = 1:nChannels,
        if strcmp(fitChannelType{j},'exp') || strcmp(fitChannelType{j},'gauss') || strcmp(fitChannelType{j},'poisson'),
            E{1,j} = dataMeans(j);
        end
        if strcmp(fitChannelType{j},'gauss'),
            E{1,j} = [dataMeans(j) ; dataStdevs(j)];
        end
    end
end
%% enforce some discrete states have identically distributed emissions        
if ~isempty(discStates),
    E = EnforceDiscStates_(E,discStates,ones(nStates,length(x)));
end