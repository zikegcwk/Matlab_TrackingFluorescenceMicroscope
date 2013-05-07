function [B,C]=Individual_Molecules_Kinetics_V1(kinetics_defmlc_file,fps,minimumlifetime)

% This script was created on 051108 By Max Greenfeld It is a modivation of
% an earlier script FractionFoldedIndividualMoleculesAndKinetics.  This
% looks to be a good starting point for more visulation of individual
% molecule data

% This file needs as an input a kinetics_defmlc file and parameters such as
% the minimum trace langth and the number of frames per second

%this script is best run by running the first cell to generate the matrix
%of all the kinetic and residuals.  Then running the second cell to have
%the data plotted in a nice way

%edit individual_Molecules_Kinetics_V1;
%pause

%% Run The first section to generate the array to be ploted
% this code was modifided by Max on 072708 to make it scalable to look at
% multipule data files simultanously...not all parts were updated so that
% is scales perfectly

core_file_name = {'cascade32(start).dat'};

%core_file_name = cellstr(['cascade24.26.27.28.29.30.32.33.34.35.(070908 P4P6 WT 20 mM Ba and 100 mM Na With Break End mM)(4).dat'; 'test'  ]);
    
fps = 25;
%numberofmolecules=100;
minimumlifetime =30;
title = '070908 P4P6 WT 20 mM Ba and 100 mM Na With Break';
%
%
number_of_movies = size(core_file_name,1);
data = [];
for i=1:number_of_movies
new_names = track_filename(core_file_name{i});

%rawdatatoimport = char(new_names{1});
%tobeimported = char();

finalrawdata = importdata(new_names{1});
finaldata = importdata(new_names{2});

%data = single_molecule_fits_new_header(importdata(new_names{2}),importdata(new_names{1},fps,minimumlifetime);
tempdata = single_molecule_fits_new_header(finaldata,finalrawdata,fps,minimumlifetime);

data = cat(3, data, tempdata);
end

%
%rawdatatoimport = '(donor_acceptor_defmlc)cascade24.26.27.28.29.30.32.33.34.35.(070908 P4P6 WT 20 mM Ba and 100 mM Na With Break End mM)(4).dat'; %(donor_acceptor_defmlc)
%tobeimported ='(kinetics_defmlc)cascade24.26.27.28.29.30.32.33.34.35.(070908 P4P6 WT 20 mM Ba and 100 mM Na With Break End mM)(4).dat'; %(kinetics_defmlc)


%finaldata = importdata(tobeimported);
%finalrawdata = importdata(rawdatatoimport);

%data = single_molecule_fits(finaldata,finalrawdata,fps,minimumlifetime);
%data = single_molecule_fits_new_header(finaldata,finalrawdata,fps,minimumlifetime);
%fps = finalrawdata(2,4);

% 
%%
numberofmolecules = data{1};
meanfractionfolede = data{2};
meantracelength = data{3};
meankfold = data{4};
meankunfold = data{5};
sorted = data{6};
bulkdata = data{7};
rawbulkdata = data{8};
newsorted = data{9};
sorted2 = sorted;

% this was updated on 072908 to that that this is steped through correctly
%
% numberofmolecules = [];
% meanfractionfolede = [];
% meantracelength = [];
% meankfold = [];
% meankunfold = [];
% sorted = {};
% bulkdata = {};
% rawbulkdata = {};
% newsorted = {};
% 
% for i=1:number_of_movies
% numberofmolecules = [numberofmolecules data{1,i}];
% meanfractionfolede = [meanfractionfolede data{2,i}];
% meantracelength = [meantracelength data{3,i}];
% meankfold = [meankfold data{4,i}];
% meankunfold = [meankunfold data{5,i}];
% sorted = {sorted data{6,i}};
% bulkdata = {bulkdata data{7,i}};
% rawbulkdata ={rawbulkdata  data{8,i}};
% newsorted = {newsorted data{9,i}};
% sorted2 = sorted;
% end

%% assign sorted to default unsorted values
sorted = sorted2;
%% Align or Concatenate Matrices
% basicly I need to beable to concatenat traces again..


% The new datafile shoult be temporairy extracted into a matrix which can
% be steped through in an efficient manner...I think best way to do this is
% to teporarialy creat a file that is accessed plotted and destroyet...this
% sould be easy to scale
output = align_data_files(data , 1);


%% sort sorted 

sortparameter = 3011; % Signal to Noise
%sortparameter = 3012; % Mean Total Intensity

sorted = sorted2;
eliminatemolecules = find(sorted(:,sortparameter)<=3.5);
sorted(eliminatemolecules,:)=[];

%% Secton does a bulk kinetic fit

bulkkineticsplusresiduals(bulkdata{:,:},fps)
%%
bulkkineticslogscale(bulkdata{:},fps,100, [10^-2 10^-1 1 10 100 1000 ],100, [10^-2 10^-1 1 10 100 1000],title)

%% This section cals a bulk thermo fitting function

bulkthermoplusresiduals(rawbulkdata, 100, [],fps,title)

%% Calls a function to plot the mean FRET intensity as a function of dltG

Mean_FRET_Inetnsity_Correlation(sorted)
%% Begin looking for position correlations

position_correlations(newsorted,title,meantracelength,1, [0 3 100 5 1000])


%% Creates a 4 plot figure showing the binned thermodynamics and stem plots
% single exponential fits and a stem plot of the individual molule
% termodynamics showing trace length on the y axis


sm_thermo_single_kinetics(sorted,title,meantracelength)
%sm_thermo_single_kinetics_newheader(newsorted,title,[-3 3],4,[-4 4],130,[0.05 100],[0.05 100])


%% Plot Kinetics of Double Exponentials

sm_double_kinetics(sorted,title,meantracelength)


%% Plots single molecul kinetic and thermodynamic fits

meta_sm_fits(sorted,title)

%% In this section you plot the varables without having to rerun everything

unfoldx= 20;
foldx=5;
ymaximum = 10;
lotsofticks = [1:100]*0.1;
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];

for j=0:5
figure1 = figure('Color',[1 1 1],'Name', title,'PaperPosition',[0 0 8 6],'papersize',[8 6]);  
annotation(figure1,'textbox','Position',[0.45 0.925 0.1 0.075],'FitHeightToText','on','String','unfolding','LineStyle','none');
annotation(figure1,'textbox','Position',[0.8 0.925 0.1 0.075],'FitHeightToText','on','String','folding','LineStyle','none');

annotation(figure1,'textbox','Position',[0.6 0.001 0.2 0.065],'FitHeightToText','on','String','Time [sec]','LineStyle','none');
annotation(figure1,'textbox','Position',[0.08 0.001 0.2 0.065],'FitHeightToText','on','String','Dlt G [Kcal/mol]','LineStyle','none');


k=1;
for   i=(1+20*j):(20+20*j)

    
axes0=axes('FontName','Arial','FontSize',9,'Position',[0.1 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [-3 3],'color','none','YTick',[]);
hold(axes0,'all');
scatter0 = scatter(sorted(i,1),0.5*k,'Parent',axes0,'Marker','square','MarkerEdgeColor',[0 0 0],'SizeData',[24],'DisplayName','unfoldingfast');
    
 
axes1=axes('FontName','Arial','FontSize',9,'Position',[0.340 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log' , 'YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
ylabel(axes1,'Residuals of Normalized Counts');
hold(axes1,'all')
scatter1 = scatter(sorted(i,11:510),(sorted(i,511:1010)+.5*k),'Parent',axes1,'Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');


axes2=axes('FontName','Arial','FontSize',9,'Position',[0.506 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes2,'all');
scatter1 = scatter(sorted(i,11:510),(sorted(i,1011:1510)+.5*k),'Parent',axes2,'Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes3=axes('FontName','Arial','FontSize',9,'Position',[0.672 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes3,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2011:2510)+.5*k),'Parent',axes3,'Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');

axes4=axes('FontName','Arial','FontSize',9,'Position',[0.838 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes4,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2511:3010)+.5*k),'Parent',axes4,'Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');
k=k+1;

axes1=axes('FontName','Arial','FontSize',9,'Position',[0.340 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log' , 'YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes2=axes('FontName','Arial','FontSize',9,'Position',[0.506 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes3=axes('FontName','Arial','FontSize',9,'Position',[0.672 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes4=axes('FontName','Arial','FontSize',9,'Position',[0.838 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);

end
end


%% Smmerizes residal and fit parameters


xlimdltg = [-2.5 2.5];

unfoldx= 70;
singleku = [0 6];
doubleku = [0 25];

foldx=5;
singlekf = [0 10];
doublekf = [0 25];

ymaximum = 25.5;



% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];
lotsofticks = [1:250]*0.1;
lessticls = [1:50]*0.5;


for j=0:0
figure1 = figure('Color',[1 1 1],'Name', title,'PaperPosition',[0 0 16 12],'papersize',[16 12]);  

% unfolding heaser
annotation(figure1,'textbox','Position',[0.1837 0.985 0.3 0.015],'FitHeightToText','off','String','unfolding','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','k','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.1837 0.97 0.3877 0.005],'FaceColor', 'k');
% folding heaser
annotation(figure1,'textbox','Position',[0.5918 0.985 0.3 0.015],'FitHeightToText','off','String','folding','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','g','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.5918 0.97 0.3877 0.005],'FaceColor', 'g');

%footers of double and single exponential
annotation(figure1,'textbox','Position',[0.1837 0.011 0.3 0.02],'FitHeightToText','off','String','single exponential','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','r','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.1837 0.005 0.1428 0.005],'FaceColor', 'r');
annotation(figure1,'textbox','Position',[0.3469 0.011 0.3 0.02],'FitHeightToText','off','String','double exponential','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','b','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.3469 0.005 0.2245 0.005],'FaceColor', 'b');

annotation(figure1,'textbox','Position',[0.5918 0.011 0.3 0.02],'FitHeightToText','off','String','single exponential','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','r','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.5918 0.005 0.1428 0.005],'FaceColor', 'r');
annotation(figure1,'textbox','Position',[0.7551 0.011 0.3 0.02],'FitHeightToText','off','String','double exponential','LineStyle','none','FontWeight','Bold','VerticalAlignment','top', 'HorizontalAlignment','left','Color','b','EdgeColor', 'none');
annotation(figure1,'rectangle','Position',[0.7551 0.005 0.2245 0.005],'FaceColor', 'b');





k=1;
for   i=(1+50*j):(50+50*j)
 
    % axes 0 and 1 are for the thermo and signal to noise
    % axes 2 to 6 are for the unfolding
    % axes 7 to 11 are for the folding
    
axes0=axes('FontName','Arial','FontSize',10,'Position',[0.0204 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', xlimdltg,'color','none','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off','YTick',lessticls,'YtickLabel',[]);
xlabel(axes0,'\Delta G [kcal/mol]');
hold(axes0,'all');
scatter0 = scatter(sorted(i,1),0.5*k,'Parent',axes0,'Marker','square','MarkerEdgeColor',[0 0 0],'MarkerFaceColor','k','SizeData',[24],'DisplayName','unfoldingfast');
    
axes1=axes('FontName','Arial','FontSize',10,'Position',[0.102 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log' , 'YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes1,'S/N');
hold(axes1,'all')

axes2=axes('FontName','Arial','FontSize',10,'Position',[0.1837 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim',[0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
ylabel(axes2,'Residuals of Normalized Counts');
xlabel(axes2,'Time [sec]');
hold(axes2,'all');
scatter1 = scatter(sorted(i,11:510),(sorted(i,511:1010)+.5*k),'Parent',axes2,'Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');

axes3=axes('FontName','Arial','FontSize',10,'Position',[0.2653 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', singleku,'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes3,'ku [sec^-1]');
hold(axes3,'all');
scatter1 = scatter(sorted(i,3),0.5*k,'Parent',axes3,'Marker','square','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',[24],'DisplayName','unfoldingfast');

axes4=axes('FontName','Arial','FontSize',10,'Position',[0.3469 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
ylabel(axes4,'Residuals of Normalized Counts');
xlabel(axes4,'Time [sec]');
hold(axes4,'all');
scatter1 = scatter(sorted(i,11:510),(sorted(i,1011:1510)+.5*k),'Parent',axes4,'Marker','square','MarkerEdgeColor','r','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes5=axes('FontName','Arial','FontSize',10,'Position',[0.4286 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 1],'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes5,'Amplitude');
hold(axes5,'all');
scatter1 = scatter(sorted(i,4),0.5*k,'Parent',axes5,'Marker','d','MarkerEdgeColor','r','MarkerFaceColor','b','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes6=axes('FontName','Arial','FontSize',10,'Position',[.5102 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', doubleku,'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes6,'ku [sec^-1]');
hold(axes6,'all');
scatter1 = scatter(sorted(i,5),0.5*k,'Parent',axes6,'Marker','square','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');
scatter1 = scatter(sorted(i,6),0.5*k,'Parent',axes6,'Marker','square','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

%Places Minor Ticks On Residual Crves
axes2=axes('FontName','Arial','FontSize',10,'Position',[0.1837 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim',[0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
axes4=axes('FontName','Arial','FontSize',10,'Position',[0.3469 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);


% This section start the folding axes i.e. axes 7 to 11

axes7=axes('FontName','Arial','FontSize',10,'Position',[0.5918 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim',[0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
ylabel(axes7,'Residuals of Normalized Counts');
xlabel(axes2,'Time [sec]');
hold(axes7,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2011:2510)+.5*k),'Parent',axes7,'Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');

axes8=axes('FontName','Arial','FontSize',10,'Position',[0.6736 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', singlekf,'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes8,'kf [sec^-1]');
hold(axes8,'all');
scatter1 = scatter(sorted(i,7),0.5*k,'Parent',axes8,'Marker','square','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',[24],'DisplayName','unfoldingfast');

axes9=axes('FontName','Arial','FontSize',10,'Position',[0.7551 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
ylabel(axes9,'Residuals of Normalized Counts');
xlabel(axes9,'Time [sec]');
hold(axes9,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2511:3010)+.5*k),'Parent',axes9,'Marker','o','MarkerEdgeColor','r','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes10=axes('FontName','Arial','FontSize',10,'Position',[0.8367 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 1],'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes10,'Amplitude');
hold(axes10,'all');
scatter1 = scatter(sorted(i,8),0.5*k,'Parent',axes10,'Marker','d','MarkerEdgeColor','r','MarkerFaceColor','b','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes11=axes('FontName','Arial','FontSize',10,'Position',[0.9184 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', doublekf,'color','none','XScale','linear','YMinorTick','off','YGrid', 'on','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lessticls);
xlabel(axes11,'kf [sec^-1]');
hold(axes11,'all');
scatter1 = scatter(sorted(i,9),0.5*k,'Parent',axes11,'Marker','square','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');
scatter1 = scatter(sorted(i,10),0.5*k,'Parent',axes11,'Marker','square','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

%Places Minor Ticks On Residual Crves
axes7=axes('FontName','Arial','FontSize',10,'Position',[0.5918 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim',[0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
axes9=axes('FontName','Arial','FontSize',10,'Position',[0.7551 .075 0.06122 .9],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);





k=k+1;
end
end


%% This is verson of the meta plot allows for binning of different molecules across the entier distribution 











%% So the values don't dump

%% Just for Saftey






