function [y,std_g,h]=ciplot_zk(tau,g,color_index,style)




darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;0,102,102;255,204,255;174,119,0;204,204,204];
lightcolor=lightcolor/255;

if nargin==2
    color_index=1;
    style='-';
end

if nargin==3
    style='-';
end


y=mean(g);
size_g=size(g);
std_g=std(g)./size_g(1,1).^0.5;

%figure;
h=ciplot(y+std_g,y-std_g,tau,lightcolor(color_index,:));
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

hold on;
semilogx(tau,y,'color',darkcolor(color_index,:),'LineWidth',2,'LineStyle',style);
set(gca,'XScale','log');

if nargout ==0
    clear y std_g h;
end

if nargout==2
    clear h;
end