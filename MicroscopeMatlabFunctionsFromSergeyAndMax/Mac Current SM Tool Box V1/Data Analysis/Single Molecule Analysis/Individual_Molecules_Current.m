function [B,C]=Individual_Molecules_Current(kinetics_defmlc_file,fps,minimumlifetime)

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

%trace_locations = {'C:\Documents and Settings\biochem\Desktop\010208 Max';
 %   'C:\Documents and Settings\biochem\Desktop\010208 Max'};

trace_locations = {'C:\Documents and Settings\Andre Gerber\My Documents\Sergey\TIR_Data_analysis\2009_Feb13\Feb20_2009_analysis\FixedMolafter'}
%movie_numbers={[7 15 18 21 24 28 31];[9 17 20 23 26 30 33] };
%movie_numbers={[37];[37] };
%movie_numbers={[1];[2]};

movie_numbers={[1 12 22 34]};

%size (movie_numbers)
%simulated_traces = simulated;

sequential_movies = 0; % Set to 0 for old files Set to 1 for new files or nume of sequentioa movies

rethreshold_traces = false; % true or false
average_method = 3;%this is the size of the boxcar

two_state = false; % I changed slightly the kinetics format for 3 states models...

threshold_method = 1; %averages data with smoothe function
x_talk = 0.05;
threshold_range = [0.65 0.65];



simulated_traces = 'no';

%movie_numbers={[95 ] ;[95 ]};
%movie_numbers={[45:59]};
fps = {[25];[25] }; 
data = single_molecule_kinetics(trace_locations,movie_numbers,fps,simulated_traces,...
    rethreshold_traces,average_method,two_state,threshold_method,threshold_range,x_talk,...
    sequential_movies);

%% Recalculate Non Kenetic Parameters

x_talk = 0.05;

%these are the parameters for recalculating the dltG
recalculate_dlt_G = 'no'; % specisify 'yes' if you want to recalculate the dltG
desired_trace_length = 100;
dltG_method = '2gausian';  % use 'threshold' or '2gausian'
threshold_point = 0.65;
% end

% recalculate S/N 
% to be added
recalculate_signal_to_noise = 'no';
noise_cutoff = 0.6; %look at the alograthim to see what this is actually doing...
intensit_threshold = 500; % Intensit Threshold for Sergey Signal To Noise

%
recalculated={};
recalculated = recalculat_non_kinetic(data,x_talk,recalculate_dlt_G ,desired_trace_length,dltG_method,...
    threshold_point,recalculate_signal_to_noise,noise_cutoff,intensit_threshold);


%% Sort Molecules By Quality and Concatenate Movies
% basicly I need to be able to concatenat traces again..
%Below is the olc concatenated file...the new one should be much
%better...but I need to check it some before forgetting about the old one
%concatenated_data = align_data_files(data ,{ [7 9] [15 17] [18 20] [21 23] [24 26] [28 30] [31 33] },2, 0);
% sort sorted 
%sortparameter = 3011; % Signal to Noise
%sortparameter = 3012; % Mean Total Intensity
title = 'test';

% This groups togetehr moledules you want to tree the same
% syntax grouping = { [1 95 97  ]; [2 96 98  ]};
grouping = { [1 95 97 99 101 103 105 ];[2 96 98 100 102 104 106 ]};
%grouping = { [1 95  ] };
grouping = {[1 30 ];[2 34]};
%grouping = {[1 30 ]};
grouping = {[1  34  ]};
movie_order = [1   ]; % set to 1 if no cat 4 if old format


new_id = false; % 011809 I don't think I need the any more...
% this adds lables to allos for overlays of data
% syn%tax new_id = { {[1 95 ]; [2 96 ]};  {[1 97 ] ;[2 98 ]}}
%new_id = { {[1 95 97 99 101 103 105 ]};  {[2 96 98 100 102 104 106 ]} ; }; % set to false if new groups do not need to be assigned
%new_id = {[1 30 ];[2 34]}; % set to false if new groups do not need to be assigned


concatenate = false;
slop = 0;
gltag_range = [-10 20];
tracelength = [0 10^4];
signal_to_noise = [0 10^4];
signal_to_noise_method = 1; % (1) origionally claculated (2) max version (3) recalculated of sergey
mean_intensity  = [0 10^4];


sorted={};
sorted = molecule_2_analyze(recalculated,concatenate,slop, grouping,gltag_range,tracelength,...
signal_to_noise,mean_intensity,new_id,signal_to_noise_method,movie_order);
size(sorted)

%% Secton does a bulk kinetic fit

%bulkkineticsplusresiduals(bulkdata{file_id},fps)
%bulkkineticsplusresiduals(bulkdata,file_id,fps)

doubleguess = [0.6,30,0.1];
stretchedguess = [0.6,0.1];
tripleguess = [0.2,30,0.2,0.1 0.1];

bulkkineticslogscale(sorted(:,11), [sorted{1,5} 200],100 , [10^-2 10^-1 1 10 100 1000 ],100, [10^-2 10^-1 1 10 100 1000],...
    title,'fit_double','fit_stretched','fit_triple',doubleguess,stretchedguess,tripleguess)

%% This section cals a bulk thermo fitting function

number_of_peaks =  2;

lowerbound = [];
%lowerbound = [0 0 0 0 0.3 .1 0 0.5 .1];%SERGEY-both in format [A1 x1
%w1...], temp disable
upperbound = [];
%upperbound = [10000 .5 .5 10000 .8 .4 10000 1 .8];
rounding = 100;

 bulkthermoplusresiduals(sorted(:,10),[1:1],'dontoverlay',number_of_peaks,100, [100 0.3 0.1 100 1.0 0.3],...
     fps,title,lowerbound,upperbound,rounding)

% bulkthermoplusresiduals_3D(rawbulkdata,[2:9],'subplot',[3 3],[-0.1 1.1 0 2000],30,fps,title)

%% Calls a function to plot the mean FRET intensity as a function of dltG

Mean_FRET_Inetnsity_Correlation(sorted)%Sergey removed {1,2} here
%% Begin looking for position correlatio ns

position_correlations(newsorted{file_id},title,meantracelength,1, [0 3 100 5 1000])


%% Creates a 4 plot figure showing the binned thermodynamics and stem plots
% single exponential fits and a stem plot of the individual molule
% termodynamics showing trace length on the y axis


% This is the current working version...it plots the data like we have been
% for the  6 mongths
 sm_thermo_single_kinetics_newheader( sorted(:,[10 12 13 14 16]),'std',...
     title,[-2 2],21,[-2 2],250,[0.3 100],[0.3 100]);

%Lets put what parameters are here
%plots kinetic parameters a a function of the mean observed FRET
%  sm_thermo_single_kinetics_meanfret( sorted(:,[10 12 13 14 16]),'rawfret',...
%      title,[-0.1 1.1],4,[-0.1 1.1],15,[0.05 100],[0.05 100]);


%% Some scripts for analyizing three state models

bar_width = [10, 60];
xrange = [0 1];
thresholds = [0.5 0.5];

three_state_bar_plots( sorted(:,[10 11 12 13 14 16]),...
     title,bar_width,xrange,thresholds);





%% Overlayed or Concatenated 

%sm_thermo_single_kinetics_newheader_overlay(concatenated_data,title,[-3 3],4,[-4 4],200,[0.05 100],[0.05 100])


overlay_id = [ 2  ];
refold_plot = true;
extreme_dltg = [-3, 3];
number_of_bins = 10;
fraction = true;
transparent = 0.2;

sm_thermo_single_kinetics_concatenate( sorted(:,[10 12 13 14 16 8]),overlay_id,...
     title,[-3 3],4,[-4 4],200,[0.05 100],[0.05 100],refold_plot,extreme_dltg,number_of_bins,fraction,...
     transparent);


%sm_thermo_single_kinetics(sorted{file_id},title,meantracelength)




%% Plot Kinetics of Double Exponentials

sm_double_kinetics( sorted(:,[12 15 17 ]),title,'more_info',[-4 4],[-3,3],[0.05 100],[0.05 100])


%% Plots single molecul kinetic and thermodynamic fits

meta_sm_fits(sorted{file_id},title)
%%  Simulat traces with kinetic parameters

% unfolding rate constants and amplitudes
au1=.34;
ku1=3.3; % 
au2=1-au1;
ku2=.23;

% unfolding rate constants and amplitudes
af1=0.59;
kf1=6.1; %
af2=1-af1;
kf2 =.25;

number_of_simulations = 200;
photo_bleack_rate= 100;
equlibrium=0.49;
fps = 10;
endtime = 300; %sec

simulated = trace_simulation_new_format( au1, ku1, au2, ku2, af1, kf1, af2, kf2,...
    number_of_simulations,photo_bleack_rate,equlibrium,fps, endtime);





%% dltG Change with Time?

overlay_id = [1];
chage_with_time = true;
stepsize = 5; %sec dltG after x number of sec
threshold = 0.5;

dltg_peak_center = true;

dltg_signa_to_noise = true;
STN_method = 1;

dltg_range = [-3 3];

refold_plot = true;

dltG_change_with_time(  sorted(:,[10 5 8 12 28 24 25]),overlay_id,...
     title,dltg_range,4,[-4 4],150,[0.05 100],[0.05 100],refold_plot,stepsize,threshold,chage_with_time,...
     dltg_peak_center,dltg_signa_to_noise,STN_method);



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






