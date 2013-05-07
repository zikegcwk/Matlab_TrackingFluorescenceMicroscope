% load figSNRdata2.mat

%errors
toPlot = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
nu = 0.01;

pctError = zeros(size(data,1),size(data,2),3);
rates = cell([length(SNRList) 1]);

% for i = 1:length(SNRList),
%     for j = 1:size(data,2),
%         pctError(i,j,1) = log10(1+mean(abs(diag(flipud(data{i,j}.threshA)) - [nu ; nu])./[nu ; nu]))*(1-max(max(isnan(data{i,j}.threshA))));
%         pctError(i,j,2) = log10(1+mean(abs(diag(flipud(data{i,j}.A)) - [nu ; nu])./[nu ; nu]))*(1-max(max(isnan(data{i,j}.A))));
%         pctError(i,j,3) = log10(1+mean(abs(diag(flipud(data{i,j}.piA)) - [nu ; nu])./[nu ; nu]))*(1-max(max(isnan(data{i,j}.piA))))*...
%             (2==length(data{i,j}.piA));
%     end
% end
% toPlot = zeros(size(data,1),1);
% for i = 1:length(SNRList),
%     for k = 1:3,
%         toPlot(i,k) = mean(pctError(i,:,k));
%     end
% end

for i = 1:length(SNRList),
    for j = 1:size(data,2),
        if isempty(data{i,j}.flags),
            if length(data{i,j}.piA) == 2,
                rates{i} = [rates{i}; mean(diag(flipud(data{i,j}.threshA))) mean(diag(flipud(data{i,j}.A))) mean(diag(flipud(data{i,j}.piA)))];
                if max(isnan(rates{i}(end,:))) == 1,
                    rates{i}(end,:) = [];
                end
            end
        end
    end
end

for i = 1:length(rates),
    for j = 1:3,
        rates{i}(:,j) = sort(rates{i}(:,j),'ascend');
    end
end
    
toPlot1 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
toPlot2 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
toPlot3 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit

for i = 1:length(SNRList),
%     for k = 1:3,
%         toPlot1(i,:) = mean(log10(1+(rates{i}-0.01)/0.01));
%         toPlot1(i,:) = mean(rates{i});
%         toPlot2(i,:) = std(rates{i});
        
        toPlot1(i,:) = mean(rates{i});
        for j = 1:3,
            r = find(rates{i}(:,j) >= 0.1*max(rates{i}(:,j)),1,'first');
            toPlot2(i,j) = rates{i}(round(length(rates{i})/2.5),j);
            r = find(rates{i}(:,j) >= 0.1*max(rates{i}(:,j)),1,'last');
            toPlot3(i,j) = rates{i}(round(6*length(rates{i})/10),j);
        end
end

figure
hold on
plot(log10(SNRList),toPlot1(:,1),'g.-')
% plot(log10(SNRList),toPlot2(:,1),'g--')
% plot(log10(SNRList),toPlot3(:,1),'g--')
plot(log10(SNRList),toPlot1(:,1) - toPlot2(:,1),'g--');
plot(log10(SNRList),toPlot1(:,1) + toPlot3(:,1),'g--');
plot(log10(SNRList),toPlot1(:,2),'b.-')
% plot(log10(SNRList),toPlot2(:,2),'b--')
% plot(log10(SNRList),toPlot3(:,2),'b--')
plot(log10(SNRList),toPlot1(:,2) - toPlot2(:,2),'b--');
plot(log10(SNRList),toPlot1(:,2) + toPlot3(:,2),'b--');
plot(log10(SNRList),toPlot1(:,3),'k.-')
% plot(log10(SNRList),toPlot2(:,3),'g--')
% plot(log10(SNRList),toPlot3(:,3),'g--')
plot(log10(SNRList),toPlot1(:,3) - toPlot2(:,3),'k--');
plot(log10(SNRList),toPlot1(:,3) + toPlot3(:,3),'k--');

toPlot2log = log10(toPlot1 - toPlot2);
toPlot3log = log10(toPlot1 + toPlot3);
toPlot1log = log10(toPlot1);

figure
hold on
plot(log10(SNRList),toPlot1log(:,1),'g.-')
plot(log10(SNRList),toPlot2log(:,1),'g--')
plot(log10(SNRList),toPlot3log(:,1),'g--')

plot(log10(SNRList),toPlot1log(:,2),'b.-')
plot(log10(SNRList),toPlot2log(:,2),'b--')
plot(log10(SNRList),toPlot3log(:,2),'b--')

plot(log10(SNRList),toPlot1log(:,3),'k.-')
plot(log10(SNRList),toPlot2log(:,3),'k--')
plot(log10(SNRList),toPlot3log(:,3),'k--')
