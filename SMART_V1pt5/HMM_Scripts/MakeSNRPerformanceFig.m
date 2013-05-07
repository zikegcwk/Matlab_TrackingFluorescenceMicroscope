%load SNRPerformanceFigData.mat;

% %extract rates from data
% ratesHMM = zeros(length(SNRList),numTrialsPerSNRPoint);
% ratesThreshNoisy = ratesHMM;
% ratesThreshNoiseless = ratesHMM;
% 
% for i = 1:length(SNRList),
%     for j = 1:numTrialsPerSNRPoint,
%         ratesHMM(i,j) = mean(diag(flipud(outputsHMM{i,j}.A)));
%         ratesThreshNoisy(i,j) = mean(diag(flipud(outputsThreshNoisy{i,j})));
%         ratesThreshNoiseless(i,j) = mean(diag(flipud(outputsThreshNoiseless{i,j})));
%     end
% end
% 
% clear outputsHMM;
% clear outputsThreshNoisy;
% clear outputsThreshNoiseless;
% 
% save SNRPerformanceFigRateData.mat

load SNRPerformanceFigData.mat

rates{1} = outputsHMM;
rates{2} = outputsThreshNoisy;
rates{3} = outputsThreshNoiseless;

toPlot1 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
toPlot2 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit
toPlot3 = zeros(length(SNRList),3); %thresh fit, HMM fit, pi fit

iBIC1loweridxList = zeros(length(SNRList),1);

for i = 1:length(SNRList),    
    for j = 1:3,
        r = rates{j}{i};
        r(isnan(r)) = [];
        r(r==-1) = []; %get rid of trials that did not have trials or did not compute hopping rates
%         r(r<0) = [];
        if (j==1) && (sum(r<0)/length(r) >= 0.01),
            iBIC1loweridxList(i) = 1;
        end
        r = sort(abs(r),'ascend');
        if ~isempty(r),
            toPlot1(i,j) = mean(r);
            toPlot2(i,j) = r(max(round(  length(r)/10),1));
            [j i]
            toPlot3(i,j) = r(round(9*length(r)/10));
        else
            toPlot1(i,j) = -1;
            toPlot2(i,j) = -1;
            [j i]
            toPlot3(i,j) = -1;
        end
    end
end

figure
hold on

plot(2*SNRList(end),1,'r-');
ax1 = gca;
plot(2*SNRList(end),1,'b-');
plot(2*SNRList(end),1,'k-');
plot(2*SNRList(end),1,'g-','LineWidth',3);
plot(2*SNRList(end),1,'r--','LineWidth',2);

plot([SNRList(1) SNRList(end)],[1 1].*A(1,2),'g-','LineWidth',4);

plot(SNRList,toPlot1(:,3),'k.-','LineWidth',2,'MarkerSize',15)
plot(SNRList,toPlot1(:,1),'rs-','LineWidth',2)
plot(SNRList,toPlot1(:,2),'bo-','LineWidth',2)
% plot(SNRList,toPlot2(:,3),'k:','LineWidth',2)
% plot(SNRList,toPlot2(:,1),'r:','LineWidth',2)
% plot(SNRList,toPlot2(:,2),'b:','LineWidth',2)
% plot(SNRList,toPlot3(:,3),'k:','LineWidth',2)
% plot(SNRList,toPlot3(:,1),'r:','LineWidth',2)
% plot(SNRList,toPlot3(:,2),'b:','LineWidth',2)
plot(SNRList,toPlot2(:,3),'k:','LineWidth',1)
plot(SNRList,toPlot2(:,1),'r:','LineWidth',1)
plot(SNRList,toPlot2(:,2),'b:','LineWidth',1)
plot(SNRList,toPlot3(:,3),'k:','LineWidth',1)
plot(SNRList,toPlot3(:,1),'r:','LineWidth',1)
plot(SNRList,toPlot3(:,2),'b:','LineWidth',1)

set(gca,'XScale','log');
set(gca,'YScale','log')

% iBIC1loweridxList(1:3) = 1;
% iBIC1loweridxList(end-5:end) = 1;

BIC1lowerminidx = find(bwlabel(iBIC1loweridxList) == 1,1,'last');
BIC1lowermaxidx = find(bwlabel(iBIC1loweridxList) == 2,1,'first');
BIC1lowerBounds = get(ax1,'YLim');
if ~isempty(BIC1lowerminidx),
    plot([1 1].*SNRList(BIC1lowerminidx),BIC1lowerBounds,'r--','LineWidth',1);
end
if ~isempty(BIC1lowermaxidx),
    plot([1 1].*SNRList(BIC1lowermaxidx),BIC1lowerBounds,'r--','LineWidth',1);
end



axis([SNRList(1) SNRList(end) 1e-2 1e0])
legend('HMM fit','thresholding fit','noiseless fit','true rate','BIC_1 = BIC_2')
xlabel('Signal to Noise Ratio')
ylabel('inferred rate')

ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick',[]);
set(ax2,'XLim',[2 1000]);
set(ax2,'XDir','reverse');
set(ax2,'XScale','log')
set(ax2,'XTick',flipud(round(NJumpsList(2:2:length(NJumpsList)))))
xlabel(ax2,'mean number of jumps per trace');
axes(ax1);