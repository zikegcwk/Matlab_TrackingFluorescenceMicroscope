function [B,C]=sm_thermo_single_kinetics_newheader(newsorted,qdltg,title,binlim,numberbins,xrange,tracelengthaxess,yrangeunfolding,yrangefolding )



% extract data of interest for this function
%xposition =[newsorted{:,5}];
%yposition =[newsorted{:,6}];
rawdltg =newsorted(:,1);
dltg =[newsorted{:,2}];
tracelength =[newsorted{:,3}];

unfolding   =[];
folding     =[];

for i=1:size(newsorted,1)
unfolding =[unfolding; newsorted{i,4}];
folding =[folding; newsorted{i,5}];
end


qoverlay = strcmp(qdltg, 'rawfret');
if  qoverlay == 1;
dltg =[];
for i=1:size(rawdltg,1)

    temp=[];
    temp = rawdltg{i};
    meanfret = mean(temp(:,3));
    dltg = [dltg;meanfret];
end
end

% bind the data and generates some stastics
bootmean = mean(bootstrp(100,@mean,dltg(:)));
bootstd = mean(bootstrp(100,@std,dltg(:)));

binddata=[];
%numberbins=12;
%startdltg=-3;
width = 1;
% Parameters that affect plots
%xrange = xrange;
dltgtick = binlim(1):binlim(2);
%yrangeunfolding = [0.05 100];
%yrangefolding = [0.05 100];
flodingratescale = 'log';
fractionmax = 0.3;

hist(dltg,numberbins);
[n,bin]=hist(dltg,numberbins);

fractionbin = sum(n);
tempdata =[ bin' n' n'/fractionbin];
totalmolecules = sum(n);
histwidth = abs(abs(tempdata(2,1))-abs(tempdata(1,1)));

extremes =tempdata;
extremes(:,2)=0;
extremes(:,3)=0;
 

temp = find(tempdata(:,1) < binlim(1));
dontunfold = sum(tempdata(temp,:),1);
if dontunfold ~= [ 0 0 0 ];
  dontunfold(1)=  tempdata(temp(end),1);
%extremes(1,:)=[(tempdata(temp(end)+1,1)-1) dontunfold];%- histwidth;
extremes(temp(end),:)=dontunfold
tempdata(temp,2)=0;
tempdata(temp,3)=0;
else 
end
temp=[];

temp = find(tempdata(:,1) > binlim(2));
dontfold = sum(tempdata(temp,:),1);
if dontfold ~= [ 0 0 0 ];
  dontfold(1)= tempdata(temp(1),1)
    %dontfold(1)=  tempdata(end,1)+1;
%dontfold(1)=(tempdata(temp(end)+1,1)-1);
   % extremes(end,:)=[(tempdata(temp(end)+1,1)-1) dontfold];%- histwidth;
extremes(temp(1),:)=dontfold
tempdata(temp,2)=0;
tempdata(temp,3)=0;
else 
end
temp=[];

%extremes = [dontunfold; dontfold];
%extremes(1,1)=  tempdata(1,1)- abs(abs(tempdata(2,1))-abs(tempdata(1,1)));
%extremes(2,1)=  tempdata(end,1)- abs(abs(tempdata(2,1))-abs(tempdata(1,1)));


% Plots the thermodynamis on the left side of  the figure
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];
figure2= figure('Name', title,'PaperPosition',[0 0 12 9],'papersize',[12.5 9.5]);


% Plot of molecules that do fold
axes1 = axes('FontName','Arial','FontSize',16,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.1 0.2 0.3 0.8 1],'color','none','XTick',dltgtick);
ylabel(axes1,'Fraction of Molecules','FontSize',16)
xlim(axes1,xrange);
ylim(axes1,[0 fractionmax]);
hold(axes1,'all');
bar1=bar(tempdata(:,1),tempdata(:,3) ,'Parent',axes1,'BarLayout','stacked','BarWidth',width,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);

% Plot of molecule that rarely or never fold 
axes0 = axes('FontName','Arial','FontSize',16,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.1 0.2 0.3 0.8 1],'XTick',[0],'color','none');
ylabel(axes0,'Fraction of Molecules','FontSize',16)
tempx =get(axes1,'xlim');
%tempx(1)= tempx(1)+histwidth;
%tempx(2)= tempx(2)-histwidth;
xlim(axes0,xrange);
ylim(axes0,[0 fractionmax]);
hold(axes0,'all');
bar0=bar(extremes(:,1), extremes(:,3),'Parent',axes0,'BarLayout','stacked','BarWidth',width,'FaceColor','r','EdgeColor','r');




% Creats stemplot
% templication = find(sorted(:,2)<=meantracelength );
% lowerthantracelength = sorted(templication,:);
% templication = find(sorted(:,2)>meantracelength );
% greaterthantracelength = sorted(templication,:);

%tracelengthaxess = 200;

axes3 = axes('FontName','Arial','FontSize',16,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,xrange);
ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Trace Length [sec]','FontSize',16);
xlabel(axes3,'\DeltaG Kcal/mol','FontSize',16)
hold(axes3,'all');
stem1=stem(dltg ,tracelength,'Parent',axes3,'Color','k','LineStyle','none','MarkerSize',6);

% %axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'Visible','on','box','on','color','none');
% axes5 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',dltgtick,'box','on','color','none');
% xlim(axes5,xrange);
% ylim(axes5,[0 tracelengthaxess]);
% ylabel(axes5,'Trace Length [sec]','FontSize',10);
% hold(axes5,'all');
% %stem2=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes5,'Marker','none','Color','k');
% stem2=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes5,'Color','k','LineStyle','none','MarkerSize',3);


meantracelength = mean(tracelength);

%create annotation labels
a = ['Total Molecules = ' num2str(totalmolecules)];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');

axes2 = axes('FontName','Arial','FontSize',16,'Position',[0.6 0.575 0.35 .325],'Parent',figure2,'Visible','on','box','on','Yscale', flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');
ylabel(axes2,'Unfolding k [sec^{-1}]');
ylim(axes2,yrangeunfolding);
xlim(axes2,xrange);
hold(axes2,'all');

axes4 = axes('FontName','Arial','FontSize',16,'Position',[0.6 0.2 0.35 .325],'Parent',figure2,'box','on','Yscale', flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');
ylabel(axes4,'Folding k [sec^{-1}]');
ylim(axes4,yrangefolding);
xlim(axes4,xrange);
xlabel(axes4,'\DeltaG Kcal/mol','FontSize',16)
hold(axes4,'all');

stem2=stem(dltg,unfolding(:,1),'Parent',axes2, 'LineStyle','none','Marker','o','MarkerEdgeColor','r','MarkerSize',6);
stem4=stem(dltg,folding(:,1),'Parent',axes4,'LineStyle','none', 'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',6);

ucor = corr(dltg',unfolding(:,1));
fcor = corr(dltg',folding(:,1));

%d = ['correlation unfold= ' num2str(round(100*ucor)/100)];
%e = ['correlation fold = ' num2str(round(100*fcor)/100)];
%annotation1 = annotation(figure2,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{d,e},'LineStyle','none');

annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',strcat(title, ' SM Thermo Single Kinetics'),'LineStyle','none');
clipboard('copy',strcat(title, ' SM Thermo Single Kinetics'))
