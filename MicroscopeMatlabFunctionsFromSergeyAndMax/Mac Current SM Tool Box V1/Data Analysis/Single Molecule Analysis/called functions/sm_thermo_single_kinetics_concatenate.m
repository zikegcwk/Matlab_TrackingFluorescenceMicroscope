function [B,C]=sm_thermo_single_kinetics_concatenate(newsorted,qdltg,title,binlim,numberbins,xrange,...
    tracelengthaxess,yrangeunfolding,yrangefolding,refold_plot,extreme_dltg,number_of_bins,fraction,...
    transparent)



% extract data of interest for this function
%xposition =[newsorted{:,5}];
%yposition =[newsorted{:,6}];

figure2= figure('Name', title,'PaperPosition',[0 0 6.5 7],'papersize',[6.5 7]);


for i=1:size(qdltg,2)

positions = find([newsorted{:,6}]==qdltg(i) );  
tempdata = newsorted(positions,:);

%color_order ={ 'k' 'g' 'b' 'c' 'm' 'y' };
color_order ={ 'k' 'b' 'g'  'c' 'm' 'y' };

temp_color = color_order{i};


dltg =[tempdata{:,2}];
tracelength =[tempdata{:,3}];

unfolding   =[];
folding     =[];

for j=1:size(tempdata,1)
unfolding =[unfolding; tempdata{j,4}];
folding =[folding; tempdata{j,5}];
end

% qoverlay = strcmp(qdltg, 'overlay');
% if  qoverlay == 1;

% bind the data and generates some stastics
bootmean = mean(bootstrp(100,@mean,dltg(:)));
bootstd = mean(bootstrp(100,@std,dltg(:)));

binddata=[];
%numberbins=12;
%startdltg=-3;
width = [1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2];
% Parameters that affect plots
%xrange = xrange;
dltgtick = binlim(1):binlim(2);
%yrangeunfolding = [0.05 100];
%yrangefolding = [0.05 100];
flodingratescale = 'log';
fractionmax = 1;

%hist(dltg,numberbins);


temp = find(dltg <= extreme_dltg(1));
extreme_molecules = size(dltg(temp),2);
rest_of_molecule = dltg;
rest_of_molecule(temp)=[];

temp = find(dltg >= extreme_dltg(2));
extreme_molecules = [extreme_molecules,size(dltg(temp),2)];
rest_of_molecule = dltg;
rest_of_molecule(temp)=[];



bin_size = (abs(extreme_dltg(1))+extreme_dltg(2))/number_of_bins;
bincenters = ((1:number_of_bins)*bin_size)+extreme_dltg(1)*ones(size(((1:number_of_bins)*bin_size/2)))
%bincenters = bincenters - ones(size(bincenters))*bin_size/2



molecule_per_bin = [0];
for l=1:number_of_bins

temp = find(rest_of_molecule > bincenters(l)-(bin_size/2) & rest_of_molecule < bincenters(l)+(bin_size/2));

molecule_per_bin= [molecule_per_bin,size(temp,2)]

end

molecule_per_bin = [molecule_per_bin, 0];
bincenters = [ bincenters(1)-bin_size,bincenters]
bincenters = [ bincenters,bincenters(end)+bin_size]

extreme_molecule_per_bin = zeros(size(bincenters));
extreme_molecule_per_bin(1)=extreme_molecules(1);
extreme_molecule_per_bin(end)=extreme_molecules(2);

if fraction == true
    
   molecule_per_bin = molecule_per_bin/size(dltg,2);
   extreme_molecule_per_bin = extreme_molecule_per_bin/size(dltg,2);
    
end

%Max Redid 101208 next section is good for histograms
% [n,bin]=hist(dltg,numberbins);
% 
% fractionbin = sum(n);
% tempdata =[ bin' n' n'/fractionbin];
% totalmolecules = sum(n);
% histwidth = abs(abs(tempdata(2,1))-abs(tempdata(1,1)));
% 
% extremes =tempdata;
% extremes(:,2)=0;
% extremes(:,3)=0;
%  
% 
% temp = find(tempdata(:,1) < binlim(1));
% dontunfold = sum(tempdata(temp,:),1);
% if dontunfold ~= [ 0 0 0 ];
%   dontunfold(1)=  tempdata(temp(end),1);
% %extremes(1,:)=[(tempdata(temp(end)+1,1)-1) dontunfold];%- histwidth;
% extremes(temp(end),:)=dontunfold
% tempdata(temp,2)=0;
% tempdata(temp,3)=0;
% else 
% end
% temp=[];
% 
% temp = find(tempdata(:,1) > binlim(2));
% dontfold = sum(tempdata(temp,:),1);
% if dontfold ~= [ 0 0 0 ];
%   dontfold(1)= tempdata(temp(1),1)
%     %dontfold(1)=  tempdata(end,1)+1;
% %dontfold(1)=(tempdata(temp(end)+1,1)-1);
%    % extremes(end,:)=[(tempdata(temp(end)+1,1)-1) dontfold];%- histwidth;
% extremes(temp(1),:)=dontfold
% tempdata(temp,2)=0;
% tempdata(temp,3)=0;
% else 
% end
% temp=[];

%extremes = [dontunfold; dontfold];
%extremes(1,1)=  tempdata(1,1)- abs(abs(tempdata(2,1))-abs(tempdata(1,1)));
%extremes(2,1)=  tempdata(end,1)- abs(abs(tempdata(2,1))-abs(tempdata(1,1)));


% Plots the thermodynamis on the left side of  the figure
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];


% Plot of molecules that do fold
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.08 0.7 0.35 0.27],'box','on','YTick',...
    [0 0.2 0.4 0.6 0.8 1],'color','none','XTick',dltgtick);
ylabel(axes1,'Fraction of Molecules','FontSize',10)
xlim(axes1,xrange);
ylim(axes1,[0 fractionmax]);
hold(axes1,'all');
bar1=bar(bincenters,molecule_per_bin ,'Parent',axes1,'BarLayout','stacked','BarWidth',width(i),...
    'FaceColor',temp_color,'EdgeColor',temp_color);
alpha(transparent)

% Plot of molecule that rarely or never fold 
axes0 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.08 0.7 0.35 0.27],'box','on','YTick',...
    [0 0.2 0.4 0.6 0.8 1],'XTick',[0],'color','none');
ylabel(axes0,'Fraction of Molecules','FontSize',10)
tempx =get(axes1,'xlim');
%tempx(1)= tempx(1)+histwidth;
%tempx(2)= tempx(2)-histwidth;
xlim(axes0,xrange);
ylim(axes0,[0 fractionmax]);
hold(axes0,'all');
bar0=bar(bincenters,extreme_molecule_per_bin,'Parent',axes0,'BarLayout','stacked','BarWidth',width(i),'FaceColor','r','EdgeColor','r');
alpha(transparent)



% Creats stemplot
% templication = find(sorted(:,2)<=meantracelength );
% lowerthantracelength = sorted(templication,:);
% templication = find(sorted(:,2)>meantracelength );
% greaterthantracelength = sorted(templication,:);

%tracelengthaxess = 200;

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.08 0.39 0.35 0.27],'XTick',dltgtick,'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,xrange);
ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Trace Length [sec]','FontSize',10);
xlabel(axes3,'Mean FRET','FontSize',10)
hold(axes3,'all');
stem1=stem(dltg ,tracelength,'Parent',axes3,'Color','k','LineStyle','none','MarkerEdgeColor',temp_color,'MarkerSize',3);
alpha(transparent)

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
a = ['Total Molecules = ' num2str(size(dltg,2))];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},...
    'color', temp_color,'LineStyle','none');

axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.7 0.35 0.27],'Parent',figure2,'Visible','on','box','on','Yscale',...
    flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');

ylabel(axes2,'Unfolding k [sec^{-1}]');
ylim(axes2,yrangeunfolding);
xlim(axes2,xrange);
hold(axes2,'all');

axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.39 0.35 0.27],'Parent',figure2,'box','on','Yscale', flodingratescale,...
    'YMinorTick','on','XTick',dltgtick,'color','none');
alpha(transparent)
ylabel(axes4,'Folding k [sec^{-1}]');
ylim(axes4,yrangefolding);
xlim(axes4,xrange);
xlabel(axes4,'\Delta G Kcal/mol','FontSize',10)
hold(axes4,'all');

stem2=stem(dltg,unfolding(:,1),'Parent',axes2, 'LineStyle','none','MarkerEdgeColor',temp_color,'MarkerSize',3);
stem4=stem(dltg,folding(:,1),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',temp_color,'MarkerSize',3);

ucor = corr(dltg',unfolding(:,1));
fcor = corr(dltg',folding(:,1))

%d = ['correlation unfold= ' num2str(round(100*ucor)/100)];
%e = ['correlation fold = ' num2str(round(100*fcor)/100)];
%annotation1 = annotation(figure2,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{d,e},'LineStyle','none');

end

annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',...
    strcat(title, ' SM Thermo Single Kinetics'),'LineStyle','none');
clipboard('copy',strcat(title, ' SM Thermo Single Kinetics'))

if refold_plot == true

axes5 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.06 0.35 0.27],'Parent',figure2,'box','on',...
 'YTick',dltgtick,   'XTick',dltgtick,'color','none');
alpha(transparent)
ylabel(axes5,'\Delta G_{2} Kcal/mol');
ylim(axes5,xrange);
xlim(axes5,xrange);
xlabel(axes5,'\Delta G_{1} Kcal/mol','FontSize',10)
hold(axes5,'all');

positions = find([newsorted{:,6}]==1 );  
movies1 = newsorted(positions,:);
newsorted(positions,:)=[];
movies2 = newsorted;
scatter1 = scatter( [movies1{:,2}], [movies2{:,2}],'Parent',axes5, 'Marker','square','MarkerEdgeColor',temp_color);


fcor = corr([movies1{:,2}]', [movies2{:,2}]');
plot( [-2 2], [-2 2],'Parent',axes5, 'Marker','none','LineWidth',0.25,'Color','k');
plot( [-2 2], [-2 2]*fcor,'Parent',axes5, 'Marker','none','LineWidth',2,'Color','r');
plot( [-2 2], [-2 2]*0,'Parent',axes5, 'Marker','none','LineWidth',0.25,'Color','k');

paried_dltG = [[movies1{:,2}]',[movies2{:,2}]'];



% temp = find(paried_dltG(:,1) <= extreme_dltg(1) & paried_dltG(:,1) >= extreme_dltg(2));
% paried_dltG(temp)=[];
% temp = find(paried_dltG(:,2) <= extreme_dltg(1) & paried_dltG(:,2) >= extreme_dltg(2));
% paried_dltG(temp)=[];
% 

bin_size = (abs(extreme_dltg(1))+extreme_dltg(2))/number_of_bins;
bincenters = ((1:number_of_bins)*bin_size)+extreme_dltg(1)*ones(size(((1:number_of_bins)*bin_size/2)))
%bincenters = bincenters - ones(size(bincenters))*bin_size/2



molecule_per_bin = [0];
bined_molecules ={};
for l=1:number_of_bins

temp = find(paried_dltG(:,1) > bincenters(l)-(bin_size/2) & paried_dltG(:,1) < bincenters(l)+(bin_size/2));

molecule_per_bin = [molecule_per_bin,size(temp,1)]
bined_molecules  = cat(1,bined_molecules,{paried_dltG(temp,:)})

end

molecule_per_bin = [molecule_per_bin, 0];
bincenters = [ bincenters(1)-bin_size,bincenters]
bincenters = [ bincenters,bincenters(end)+bin_size]

molecule_per_bin = molecule_per_bin/size(dltg,2);



% 
% for l=1:number_of_bins
% 
% temp = find(paried_dltG(:,1) > bincenters(l)-(bin_size/2) & paried_dltG(:,1) < bincenters(l)+(bin_size/2));
% 
%    
% 
% 
% end

figure3= figure('Name', title,'PaperPosition',[0 0 6.5 6.5],'papersize',[6.5 6.5]);
for p=1:number_of_bins
a=bined_molecules{p};
temp = [ bincenters(2:11)',zeros(10,1)]
origional_bar =  [bincenters(2:11)',molecule_per_bin(2:11)'];
temp(p,2)=origional_bar(p,2);


subplot(2,5,p)
bar(temp(:,1),temp(:,2),'FaceColor','r','EdgeColor','r')
hold
stem(a(:,2),ones(size(a(:,2))))

ylim(gca,[0 1.1]);
xlim(gca,xrange);

end




end





