%[outx,outy]=fcs_normalizer(f,d,t,output_fig,my_legend)
%function fcs_normalizer(f,d) looks into figure(f) and normalize fcs curves

%to d from tau is equal to tide to the maximum tau.

function [outx,outy]=fcs_normalizer_one(f,d,t,output_fig,my_legend)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get plots paramemters
if f<0
    %do nothing. basically it will look for the figure that's currently
    %active.
else
    figure(f);
end
x = get(get(gca,'Children'),'XData');
y = get(get(gca,'Children'),'YData');
c = get(get(gca,'Children'),'Color');
mker  = get(get(gca,'Children'),'Marker');
mker_size=get(get(gca,'Children'),'MarkerSize');
mker_fceC=get(get(gca,'Children'),'MarkerFaceColor');
l_width=get(get(gca,'Children'),'LineWidth');
figure_title=get(get(gca,'title'),'string');
style=get(get(gca,'Children'),'LineStyle');

t_index=min(find(x{1}>t));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the normalization constants.
for j=1:1:length(x) 
    if size(x{j})~=size(x{d})
        error('taus have different sizes! recompute your fcs curves.')
    else
       N(j)=scale(y{j}(t_index:end),y{d}(t_index:end));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot the nomalized fcs curves
%scrsz = get(0,'ScreenSize');

%figure('Name',strcat(cd,' Normalized'),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
if output_fig>0
    figure(output_fig);clf;
else
    figure;
end

title(sprintf('figure %g(%s) normalized to data %g at %g second',f,figure_title,d,t));
hold all;
for j=length(x):-1:1
    semilogx(x{j},y{j}*N(j),'color',c{j},'Marker',mker{j},'MarkerSize',mker_size{j},'MarkerFaceColor',mker_fceC{j},'LineWidth',l_width{j},'LineStyle',style{j});
end
set(gca,'XScale','log')

if nargin==5
legend(my_legend);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot divide plot
if output_fig>0
    figure(output_fig+100);clf;
else
    figure;
end
title(sprintf('figure %g(%s) normalized to data %g at %g second DIVIDE PLOT',f,figure_title,d,t));
hold all;
for j=length(x):-1:1
    semilogx(x{j}(1:t_index),y{j}(1:t_index)*N(j)./y{length(x)}(1:t_index),'color',c{j},'Marker',mker{j},'MarkerSize',mker_size{j},'MarkerFaceColor',mker_fceC{j},'LineWidth',l_width{j},'LineStyle',style{j});
    outx{j}=x{j}(1:t_index);
    outy{j}=y{j}(1:t_index)*N(j)./y{length(x)}(1:t_index);
end
set(gca,'XScale','log')

if nargin==5
legend(my_legend);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%no output request, clear output variables
if nargout==0
    clear outx outy;
end