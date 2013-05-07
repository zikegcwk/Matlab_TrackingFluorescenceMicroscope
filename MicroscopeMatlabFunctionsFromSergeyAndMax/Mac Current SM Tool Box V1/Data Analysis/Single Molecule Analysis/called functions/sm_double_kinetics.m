function [B,C]=sm_double_kinetics(sorted,title,otherplots,xrange,binlim,yrangeunfolding,yrangefolding)


%xrange = [-2.5 2.5];
%yrangeunfolding = [0.1 26];
%yrangefolding = [0.01 26];
flodingratescale = 'log';
dltgtick = binlim(1):binlim(2)

dltg = [sorted{:,1}]'

folding = [];
unfolding =[];

for i=1:size(sorted,1)
    
    
    unfolding = [unfolding ; sorted{i,2}];
    folding = [folding ; sorted{i,3}];

    
    
end

    temp = isnan(unfolding);
    unfolding(temp)=0;
    folding(temp)=0;
    dltg(temp(:,1))=0;
    
    temp = isnan(folding);
    unfolding(temp)=0;
    folding(temp)=0;
    dltg(temp(:,1))=0;
  

% It is better to define the title at the beginning
%title = ['Single Moleule Fraction Folded'];
figure3= figure('Name',strcat(title, '_Double_Kinetics') ,'PaperPosition',[0 0 6.5 7],'papersize',[6.5 7]);



% Plots the amplitues on the left
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure3,'Position',[0.08 0.7 0.35 0.27],'box','on',...
    'YTick', [0 0.2 0.4 0.6 0.8 1],'color','none','XTick',dltgtick);
ylabel(axes1,'Unfolding Amplitude','FontSize',10)
xlim(axes1,xrange);
ylim(axes1,[0 1]);
hold(axes1,'all');

stem1=stem(dltg,unfolding(:,1),'Parent',axes1, 'LineStyle','none','MarkerSize',3);

% Creats stemplot

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure3,'Position',[0.08 0.39 0.35 0.27],...
    'box','on','YTick', [0 0.2 0.4 0.6 0.8 1],'color','none','XTick',dltgtick);
xlim(axes3,xrange);
ylim(axes3,[0 1]);
ylabel(axes3,'Folding Amplitudes','FontSize',10);
xlabel(axes3,'\Delta G Kcal/mol','FontSize',10)
hold(axes3,'all');
stem3=stem(dltg,folding(:,1),'Parent',axes3,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);


ucor = corr(dltg,unfolding(:,1));
fcor = corr(dltg,folding(:,1));
d = ['Amplitude Corr Unfold= ' num2str(round(100*ucor)/100)];
e = ['Amplitude Corr Fold = ' num2str(round(100*fcor)/100)];
annotation1 = annotation(figure3,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on',...
    'String',{d,e},'LineStyle','none');

% Plot on the right folding and unfolding rates

axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.7 0.35 0.27],'Parent',figure3,...
    'Visible','on','box','on','Yscale', flodingratescale,'YMinorTick','on','color','none','XTick',dltgtick);
ylabel(axes2,'Unfolding k [sec^{-1}]');
xlim(axes2,xrange);
ylim(axes2,yrangeunfolding);
hold(axes2,'all');
stem2=stem(dltg,unfolding(:,2),'Parent',axes2, 'LineStyle','none','MarkerSize',3);


axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.7 0.35 0.27],'Parent',figure3,...
    'Visible','on','box','on','color','none','Yscale', flodingratescale,'YMinorTick','on','color','none','XTick',dltgtick);
ylabel(axes2,'Unfolding k [sec^{-1}]');
xlim(axes2,xrange);
ylim(axes2,yrangeunfolding);
hold(axes2,'all');
stem2=stem(dltg,unfolding(:,3),'Parent',axes2, 'LineStyle','none','MarkerSize',3, 'MarkerEdgeColor','r');


axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.39 0.35 0.27],'Parent',figure3,'box',...
    'on','Yscale', flodingratescale,'YMinorTick','on','color','none','XTick',dltgtick);
ylabel(axes4,'Folding k [sec^{-1}]');
xlim(axes4,xrange);
ylim(axes4,yrangefolding);
xlabel(axes4,'\Delta G Kcal/mol','FontSize',10)
hold(axes4,'all');
stem4=stem(dltg,folding(:,2),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);

axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.39 0.35 0.27],'Parent',...
    figure3,'box','on','color','none','Yscale', flodingratescale,'YMinorTick','on','color','none','XTick',dltgtick);
ylabel(axes4,'Folding k [sec^{-1}]');
xlim(axes4,xrange);
ylim(axes4,yrangefolding);
xlabel(axes4,'\Delta G Kcal/mol','FontSize',10)
hold(axes4,'all');
stem4=stem(dltg,folding(:,3),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],...
    'MarkerSize',3, 'MarkerEdgeColor','r');

uxcorf = corr(dltg,unfolding(:,2));
uxcors = corr(dltg,unfolding(:,3));
fxcorf = corr(dltg,folding(:,2));
fxcors = corr(dltg,folding(:,3));

a = ['Corr slow k_{u}= ' num2str(round(100*uxcors)/100)     '   fast k_{u}= ' num2str(round(100*uxcorf)/100)];
b = ['Corr slow k_{f}= ' num2str(round(100*fxcors)/100)     '   fast k_{f}= ' num2str(round(100*fxcorf)/100)];
annotation1 = annotation(figure3,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{a,b},...
    'LineStyle','none');

annotation(figure3,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',...
    strcat(title, ' Double Kinetics'),'LineStyle','none');
clipboard('copy',strcat(title, ' Double Kinetics'))


qoverlay = strcmp(otherplots, 'more_info');
if  qoverlay == 1;

    
    figure('PaperPosition',[0 0 2.5 2.5],'papersize',[2.5 2.5]);
    scatter(dltg,folding(:,4))
    xlabel('\Delta G Kcal/mol','FontSize',10)
    ylabel('R^{2} Check','FontSize',10)

    
end
