% load figSNRdata2.mat

%errors
toPlot = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
nu = 0.01;

pctError = zeros(size(data,1),size(data,2),3);
rates = cell([length(SNRList) 1]);

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

toPlot1 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
toPlot2 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit

for i = 1:length(SNRList),
    for k = 1:3,
        toPlot1(i,:) = mean(rates{i});
        toPlot2(i,:) = std(rates{i});
    end
end

figure
hold on

plot(-1,0,'g-');
plot(-1,0,'b-');
plot(-1,0,'k-');
legend('thresholding','HMM','noiseless')

plot((SNRList),toPlot1(:,1),'g.-')
plot((SNRList),toPlot1(:,1) - toPlot2(:,1),'g--');
plot((SNRList),toPlot1(:,1) + toPlot2(:,1),'g--');
plot((SNRList),toPlot1(:,2),'b.-')
plot((SNRList),toPlot1(:,2) - toPlot2(:,2),'b--');
plot((SNRList),toPlot1(:,2) + toPlot2(:,2),'b--');
plot((SNRList),toPlot1(:,3),'k.-')
plot((SNRList),toPlot1(:,3) - toPlot2(:,3),'k--');
plot((SNRList),toPlot1(:,3) + toPlot2(:,3),'k--');

set(gca,'xscale','log')
% set(gca,'yscale','log')
xlabel('SNR')
ylabel('inferred rate')