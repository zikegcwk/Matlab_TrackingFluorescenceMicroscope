function [B,C]=sm_thermo_single_kinetics(sorted,title,meantracelength)




% bind the data and generates some stastics
bootmean = mean(bootstrp(100,@mean,sorted(:,1)));
bootstd = mean(bootstrp(100,@std,sorted(:,1)));

binddata=[];
numberbins=12;
startdltg=-3;

% Parameters that affect plots
xrange = [-3.5 3.5];
dltgtick = [-3 -2  -1  0  1  2 3];
yrangeunfolding = [0.05 100];
yrangefolding = [0.05 1000];
flodingratescale = 'log';
fractionmax = 1;



j=0;
for i=1:numberbins-1
            
bin = find(sorted(:,1)>=(startdltg+j) & sorted(:,1) < startdltg+.5+j );
      binddata(i,1)= startdltg+j;
      binddata(i,2)= mean(sorted(bin,1));
      binddata(i,3)= mean(sorted(bin,2));
      binddata(i,4)= size(bin,1);
      binddata(i,5)= mean(sorted(bin,3));
      binddata(i,6)= mean(sorted(bin,4));
      binddata(i,7)= mean(sorted(bin,5));
      binddata(i,8)= mean(sorted(bin,6));
      j=j+.5;
    
end

% calculated fractions of molecules in eache bin
totalmolecules = size(sorted,1);

fractiondontunfold = size(find(sorted(:,1)<-3),1)/totalmolecules;
fractionfolding = binddata(:,4)/totalmolecules;
fractiondontfold   = size(find(sorted(:,1)>3),1)/totalmolecules;

extrememolecule = [-3.25 fractiondontunfold ; 3.25 fractiondontfold];


% Plots the thermodynamis on the left side of  the figure
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];
figure2= figure('Name', title,'PaperPosition',[0 0 5 5],'papersize',[5 5]);

% Plot of molecule that rarely or never fold 
axes0 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1],'XTick',dltgtick,'color','none');
ylabel(axes0,'Fraction of Molecules','FontSize',10)
xlim(axes0,xrange);
ylim(axes0,[0 fractionmax]);
hold(axes0,'all');
bar0=bar(extrememolecule(:,1),extrememolecule(:,2),'Parent',axes0,'BarLayout','stacked','BarWidth',.07,'FaceColor','r','EdgeColor','r');


% Plot of molecules that do fold
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1],'color','none');
ylabel(axes1,'Fraction of Molecules','FontSize',10)
xlim(axes1,xrange);
ylim(axes1,[0 fractionmax]);
hold(axes1,'all');
bar1=bar((binddata(:,1)+0.25), fractionfolding ,'Parent',axes1,'BarLayout','stacked','BarWidth',.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);


% Creats stemplot
templication = find(sorted(:,2)<=meantracelength );
lowerthantracelength = sorted(templication,:);
templication = find(sorted(:,2)>meantracelength );
greaterthantracelength = sorted(templication,:);

tracelengthaxess = 200;

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,xrange);
ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Trace Length [sec]','FontSize',10);
xlabel(axes3,'\Delta G Kcal/mol','FontSize',10)
hold(axes3,'all');
stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Color','k','LineStyle','none','MarkerSize',3);

%axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'Visible','on','box','on','color','none');
axes5 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'box','on','color','none');
xlim(axes5,xrange);
ylim(axes5,[0 tracelengthaxess]);
ylabel(axes5,'Trace Length [sec]','FontSize',10);
hold(axes5,'all');
%stem2=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes5,'Marker','none','Color','k');
stem2=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes5,'Color','k','LineStyle','none','MarkerSize',3);


%create annotation labels
a = ['Total Molecules = ' num2str(totalmolecules)];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');

axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.6 0.575 0.35 .325],'Parent',figure2,'Visible','on','box','on','Yscale', flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');
ylabel(axes2,'Unfolding k [sec^{-1}]');
ylim(axes2,yrangeunfolding);
xlim(axes2,xrange);
hold(axes2,'all');

axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.6 0.2 0.35 .325],'Parent',figure2,'box','on','Yscale', flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');
ylabel(axes4,'Folding k [sec^{-1}]');
ylim(axes4,yrangefolding);
xlim(axes4,xrange);
xlabel(axes4,'\Delta G Kcal/mol','FontSize',10)
hold(axes4,'all');

stem2=stem(sorted(:,1),sorted(:,3),'Parent',axes2, 'LineStyle','none','MarkerSize',3);
stem4=stem(sorted(:,1),sorted(:,7),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);

ucor = corr(sorted(:,1),sorted(:,3));
fcor = corr(sorted(:,1),sorted(:,7));

d = ['correlation unfold= ' num2str(round(100*ucor)/100)];
e = ['correlation fold = ' num2str(round(100*fcor)/100)];
annotation1 = annotation(figure2,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{d,e},'LineStyle','none');

annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',strcat(title, ' SM Thermo Single Kinetics'),'LineStyle','none');
clipboard('copy',strcat(title, ' SM Thermo Single Kinetics'))
