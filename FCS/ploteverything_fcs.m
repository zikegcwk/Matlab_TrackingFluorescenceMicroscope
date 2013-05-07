function ploteverything_fcs(x,idxs)
data=x.y;
tags=[data.tag];
D_mean=[data.D_mean];
D_std=[data.D_std];
D=[data.D];
N_mean=[data.N_mean];
N_std=[data.N_std];
N=[data.N];
figure, errorbar(tags(idxs),D_mean(idxs),D_std(idxs),'LineStyle','none','Marker','o','MarkerEdgeColor','b');
hold on, plot(tags(idxs),D(idxs),'LineStyle','none','Marker','o','MarkerEdgeColor','g');
figure, errorbar(tags(idxs),N_mean(idxs),N_std(idxs),'LineStyle','none','Marker','o','MarkerEdgeColor','b');
hold on, plot(tags(idxs),N(idxs),'LineStyle','none','Marker','+','MarkerEdgeColor','g');
figure, plotAllFits(data,idxs,x.w,x.xi);
h=get(gca,'ColorOrder');
leg={};
figure;
n=length(idxs);
for j=1:n
    i=idxs(j);
    plot(data(i).Ncounts,'Color',h(mod(i-1,7)+1,:),'LineStyle','-');
    hold on;
    leg{j}=strcat('dilution=',num2str(data(i).tag));
end
legend(leg);
countsrate=zeros(n,1);
for j=1:n
    i=idxs(j);
    countsrate(j)=sum(data(i).Ncounts);
end
figure, plot(tags(idxs),countsrate,'Marker','o','LineStyle','none');
end