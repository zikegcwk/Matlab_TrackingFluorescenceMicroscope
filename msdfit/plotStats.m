function Z=plotStats(varargin)
   Y=varargin{1};
    [n,p]=size(Y);
    idxTraces2plot=find(Y(:,4)>0 & Y(:,5)==1);
    traces2plot=Y(idxTraces2plot,:);
    [n2plot,p]=size(traces2plot);
    Z=zeros(nargin,3);
    X=1*ones(n2plot,1);
    scatter(X,traces2plot(:,4));
    hold on;
    h=get(gca,'ColorOrder');
    nextColor=h(1,:);
    m=mean(traces2plot(:,4));
    s=std(traces2plot(:,4),1);
    Z(1,1)=m;
    Z(1,2)=s;
    Z(1,3)=n2plot;
    line([0.75,1.25],[m,m],'Color',nextColor);
    line([0.75,1.25],[m-s,m-s],'Color',nextColor,'LineStyle',':');
    line([0.75,1.25],[m+s,m+s],'Color',nextColor,'LineStyle',':');
    
    
for i=2:nargin
    hold all;
    Y=varargin{i};
    [n,p]=size(Y);
     idxTraces2plot=find(Y(:,4)>0 & Y(:,5)==1);
    traces2plot=Y(idxTraces2plot,:);
    [n2plot,p]=size(traces2plot);
    X=i*ones(n2plot,1);
    scatter(X,traces2plot(:,4));
    nextColor=h(i,:);
    m=mean(traces2plot(:,4));
    s=std(traces2plot(:,4),1);
    line([i-0.25,i+0.25],[m,m],'Color',nextColor);
    line([i-0.25,i+0.25],[m-s,m-s],'Color',nextColor,'LineStyle',':');
    line([i-0.25,i+0.25],[m+s,m+s],'Color',nextColor,'LineStyle',':');
    Z(i,1)=m;
    Z(i,2)=s;
    Z(i,3)=n2plot;
end

