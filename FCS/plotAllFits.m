function plotAllFits(y,idxs,omeg,xi)
n=length(idxs);
h=get(gca,'ColorOrder');
leg={};
for j=1:n
    i=idxs(j);
    semilogx(y(i).tau,y(i).g,'Color',h(mod(i-1,7)+1,:));
    hold on;
    leg{j}=strcat('dilution=',num2str(y(i).tag));
end
legend(leg,'Location','Best');
for j=1:n
    i=idxs(j);
    gth=g2_singleparticle(y(i).tau,y(i).N,y(i).D,omeg,xi);
    semilogx(y(i).tau,gth,'Color',h(mod(i-1,7)+1,:),'LineStyle',':');
    hold on;
end
xlabel('\tau');
ylabel('g_{2}(\tau)');

    