% y = random('norm',2,1,[1000 1]);
% mList = linspace(2-0.2,2+0.2,81)';
% sList = linspace(1-0.2,1+0.2,80)';
% LList = zeros(length(mList),length(sList));
% 
% for i = 1:length(mList),
%     for j = 1:length(sList),
%         LList(i,j) = sum(log(pdf('norm',y,mList(i),sList(j))));
%     end
% end
% 
% close
% figure, hold on
% M = max(max(LList));
% R = exp(LList' - M);
% imagesc(mList,sList,R); %colorbar
% 
% [c,f] = contour(mList,sList,R,[0.2579 0.95],'LineWidth',1,'Color','k');
% 
% [r,c] = find(R' == 1);
% plot(mList(r),sList(c),'b.');
% 
% [phat,pci] = mle(y,'alpha',0.1);
% plot(phat(1),phat(2),'r.');
% plot([pci(1,1) pci(2,1)],[phat(2) phat(2)],'r-');
% plot([phat(1) phat(1)],[pci(1,2) pci(2,2)],'r-');
% 
% [mList(r) sList(c); phat(1) phat(2) ; mean(y) std(y)]

% y = random('exp',1,[1000 1]);
% mList = linspace(0.5,1.5,1000)';
% LList = zeros(length(mList),1);
% 
% for i = 1:length(mList),
%         LList(i) = sum(log(pdf('exp',y,mList(i))));
% end
% 
% close
% figure, hold on
% M = max(LList);
% R = exp(LList - M);
% plot(mList,R);
% % pause
% confInt = 1 - 0.2579;
% r1 = find(R >= (1-confInt),1,'first');
% r2 = find(flipud(R) >= (1-confInt),1,'first');
% r2 = length(R) - r2 + 1;
% rMax = find(R == max(R));
% 
% 
% [phat,pci] = mle(y,'distribution','exp','alpha',0.1);
% % plot(phat(1),phat(2),'r.');
% % plot([pci(1,1) pci(2,1)],[phat(2) phat(2)],'r-');
% % plot([phat(1) phat(1)],[pci(1,2) pci(2,2)],'r-');
% 
% [mList(r1) mList(rMax) mList(r2); pci(1) phat pci(2)]

y = random('gev',1.5,1,1.2,[1000 1]);
mList = linspace(0.5,1.5,1000)';
LList = zeros(length(mList),1);

for i = 1:length(mList),
        LList(i) = sum(log(pdf('exp',y,mList(i))));
end

close
figure, hold on
M = max(LList);
R = exp(LList - M);
plot(mList,R);
% pause
confInt = 1 - 0.2579;
r1 = find(R >= (1-confInt),1,'first');
r2 = find(flipud(R) >= (1-confInt),1,'first');
r2 = length(R) - r2 + 1;
rMax = find(R == max(R));


[phat,pci] = mle(y,'distribution','exp','alpha',0.1);
% plot(phat(1),phat(2),'r.');
% plot([pci(1,1) pci(2,1)],[phat(2) phat(2)],'r-');
% plot([phat(1) phat(1)],[pci(1,2) pci(2,2)],'r-');

[mList(r1) mList(rMax) mList(r2); pci(1) phat pci(2)]