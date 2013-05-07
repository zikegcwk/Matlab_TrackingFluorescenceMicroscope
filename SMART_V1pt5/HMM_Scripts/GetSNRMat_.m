function SNRMat = GetSNRMat_(E,fitChannelType)
nStates = size(E,1);
nChannels = size(E,2);

SNRMat = zeros(nStates,nStates);

meanMat = zeros(nStates,nChannels);
stdevMat = zeros(nStates,nChannels);

for k = 1:nStates,
    for i = 1:nChannels,  
        if strcmp(fitChannelType{i},'exp'),
            meanMat(k,i) = E{k,i}(1);
            stdevMat(k,i) = sqrt(meanMat(k,i));
        elseif strcmp(fitChannelType{i},'gauss'),
            meanMat(k,i) = E{k,i}(1);
            stdevMat(k,i) = E{k,i}(2);
        elseif strcmp(fitChannelType{i},'poisson'),
            meanMat(k,i) = E{k,i}(1);
            stdevMat(k,i) = sqrt(meanMat(k,i));
        else
            warning('MATLAB:something unknown','unknown channel type when computing SNR');
        end
    end
end



for k1 = 1:nStates-1,
    for k2 = k1+1:nStates,
        deltaMean = meanMat(k1,:)-meanMat(k2,:);
        SNRMat(k1,k2) = (1/2)*(sqrt(sum((deltaMean./stdevMat(k1,:)).^2)) + ...
            sqrt(sum((deltaMean./stdevMat(k2,:)).^2)));
        SNRMat(k2,k1) = SNRMat(k1,k2);
%         
%         for i = 1:nChannels,
%             
%             
%              
%             if strcmp(fitChannelType{i},'exp'),
% 
%                 tempSNR = abs((E{k1,i}(1)-E{k2,i}(1)))/sqrt(mean([E{k1,i}(1) E{k2,i}(1)]));
%             elseif strcmp(fitChannelType{i},'gauss'),
%                 tempSNR = abs((E{k1,i}(1)-E{k2,i}(1)))/mean([E{k1,i}(2) E{k2,i}(2)]);
%             elseif strcmp(fitChannelType{i},'poisson'),
%                 tempSNR = abs((E{k1,i}(1)-E{k2,i}(1)))/sqrt(mean([E{k1,i}(1) E{k2,i}(1)]));
%             else
%                 warning('MATLAB:something unknown','unknown channel type when computing SNR');
%             end
%             SNRMat(k1,k2) = SNRMat(k1,k2) + tempSNR;
%         end
%         SNRMat(k1,k2) = SNRMat(k1,k2)/nChannels;
    end
end