function [B,C]=Individual_Molecules_Kinetics_V1s(kinetics_defmlc_file,fps,minimumlifetime)

% This script was created on 051108 By Max Greenfeld It is a modivation of
% an earlier script FractionFoldedIndividualMoleculesAndKinetics.  This
% looks to be a good starting point for more visulation of individual
% molecule data

% This file needs as an input a kinetics_defmlc file and parameters such as
% the minimum trace langth and the number of frames per second

%this script is best run by running the first cell to generate the matrix
%of all the kinetic and residuals.  Then running the second cell to have
%the data plotted in a nice way

%% Run The first section to generate the array to be ploted
tobeimported ='(kin10)(box3)cascade5(4).dat';
fps = 100;
numberofmolecules=100;
minimumlifetime =10;
title = ['test-1'];

%end of input variables

finaldata = importdata(tobeimported);

numberrows = size(finaldata,1);

%Reduing the earlier section more efficienty
% this will basicly creat individual kinetics files

tempdewells = [];
singletracesummary=[];

for j=1:numberrows;    
    
        if finaldata(j,1)== 9 

            if finaldata(j,3)== 9; %SERGEY has 3 columns///finaldata(j,4)== 9 this can be used for scoring in the future
                A=tempdewells; % change of variables grabed code from kinanyfps2residuals
                % then sort it
            sorted= sortrows(A,1);
                % find the low/high breakpoint
            low = find(sorted,1) - 1;
                % create a low fret array
            lowsorted = sorted(1:low,:);
                %create the high fret array
            highsorted = sorted(low+1:end,:);
                %switch refolding


                % find the frequency data
                % grab the dwells times into a single array, and divide by the frame rate
            highfretdwells = highsorted(:,2)'/fps;
            lowfretdwells = lowsorted(:,2)'/fps;
               %create a the bin centers vectors from 0 to a value

                % get a table of frequency data
                hightable = tabulatebetter(highfretdwells);
                lowtable = tabulatebetter(lowfretdwells);

            longestdwellhigh = max(hightable(:,1));
            longestdwelllow  = max(lowtable(:,1));

                %total length of dwells
            timetotalhigh   = sum(highsorted(:,2))/fps;    
            timetotallow    = sum(lowsorted(:,2))/fps;

                %number of dwells
            totaldwellshigh = size(highsorted,1);
            totaldwellslow  = size(lowsorted,1);


                if (timetotalhigh+timetotallow) > minimumlifetime;%SERGEY: need to add limit for a minimum number of dwells here, but don't through out these with mols that are too short!

                    tracelength          =  timetotalhigh+timetotallow;
                    tempfractionhighfret =  timetotalhigh/tracelength;


                    equilibrium = tempfractionhighfret/(1-tempfractionhighfret);
                    tempdltg=-1.987*293*log(equilibrium)/1000;




                            %   fit with single and double exponenetials
                    options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');

                    %unfolding
                    [singlefithigh resnormhighsingle]= lsqcurvefit(@singleexponential,[0.001],hightable(:,1),hightable(:,4));
                    resnormhighsingle
                    xvalues=hightable(:,1);
                    ysingle=(singleexponential(singlefithigh,xvalues));
                    meanunfoldingresidual = mean(hightable(:,4)-ysingle);      

                    unfoldingreslduals = hightable(:,4)-ysingle;      
                    concatlength=500-size(ysingle,1);
                    newunfoldingreslduals = [ unfoldingreslduals' zeros(1, concatlength)];
                    newunfoldingxvalues = [ xvalues' zeros(1, concatlength)];

                    [doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],hightable(:,1),hightable(:,4),[0 0.1 0.1],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
                    resnormhigh
                    ydouble=(doubleexponential(doublefithigh,xvalues))
                    doubleunfoldingreslduals = hightable(:,4)-ydouble; 
                    newdoubleunfoldingreslduals = [ doubleunfoldingreslduals' zeros(1, concatlength)];



                    %folding
                    [singlefitlow, resnormlowsingle] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
                    resnormlowsingle
                    xvalues=lowtable(:,1);
                    ysingle=(singleexponential(singlefitlow,xvalues));
                    meanfoldingresidual = mean(lowtable(:,1)-ysingle);


                    foldingreslduals = lowtable(:,4)-ysingle;      
                    concatlength=500-size(ysingle,1);
                    newfoldingreslduals = [ foldingreslduals' zeros(1, concatlength)];
                    newfoldingxvalues = [ xvalues' zeros(1, concatlength)];

                    [doublefitlow, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],lowtable(:,1),lowtable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
                    resnormhigh
                    ydouble=(doubleexponential(doublefitlow,xvalues));
                    doublefoldingreslduals = lowtable(:,4)-ydouble; 
                    newdoublefoldingreslduals = [ doublefoldingreslduals' zeros(1, concatlength)];






                    % single trace summary is a summary carrying 
                     tempsummary =[tempdltg,tracelength,singlefithigh,doublefithigh,singlefitlow,doublefitlow ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals];
                    %tempsummary =[tempdltg,tracelength,singlefithigh,meanunfoldingresidual,singlefitlow,meanfoldingresidual ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals];

                            singletracesummary = [singletracesummary;tempsummary];


                            clear x;
                            clear tempdewlls;
                            tempdewells = [];

                            else
                            clear x;
                            clear tempdewlls;
                            tempdewells = [];
                end

            else 
                clear x;
                clear tempdewlls;
                tempdewells = [];
        end  

        continue 

        else
            tempdewells=[tempdewells; finaldata(j,:)];

            continue        
        end
end


numberofmolecules  = size(singletracesummary,1);

meanfractionfolede = mean(singletracesummary(:,1));
meantracelength    = mean(singletracesummary(:,2));
meankfold    = mean(singletracesummary(:,3));
meankunfold    = mean(singletracesummary(:,5));


sorted= sortrows(singletracesummary,1);


%% Creates a 4 plot figure showing the binned thermodynamics and stem plots
% single exponential fits and a stem plot of the individual molule
% termodynamics showing trace length on the y axis


% bind the data and generates some stastics
bootmean = mean(bootstrp(100,@mean,sorted(:,1)));
bootstd = mean(bootstrp(100,@std,sorted(:,1)));

binddata=[];
numberbins=12;
startdltg=-2.5;


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

xrange = [-2.5 2.5];
yrangeunfolding = [0 15];
yrangefolding = [0 15];


% Plots the thermodynamis on the left side of  the figure
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];
figure2= figure('Name', title,'PaperPosition',[0 0 6 5],'papersize',[6 5]);

axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1]);
ylabel(axes1,'Fraction of Molecules','FontSize',10)


xlim(axes1,xrange);
ylim(axes1,[0 1]);

hold(axes1,'all');
bar1=bar((binddata(:,1)+0.25), binddata(:,4)/sum(binddata(:,4)),'Parent',axes1,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);

% Creats stemplot
templication = find(sorted(:,2)<=meantracelength );
lowerthantracelength = sorted(templication,:);
templication = find(sorted(:,2)>meantracelength );
greaterthantracelength = sorted(templication,:);

tracelengthaxess = 200;

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',[-4 -2 0 2 4],'box','on');
stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Color','r','LineStyle','none','MarkerSize',3);
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');

xlim(axes3,xrange);
ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Trace Length [sec]','FontSize',10);
xlabel(axes3,'dlt G Kcal/mol','FontSize',10)

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'XTick',[-4 -2 0 2 4],'Visible','on','box','on','color','none');
xlim(axes3,xrange);
ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Trace Length [sec]','FontSize',10);
hold(axes3,'all');
%stem1=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes3,'Marker','none','Color','k');
stem1=stem(greaterthantracelength(:,1) ,greaterthantracelength(:,2),'Parent',axes3,'Color','k','LineStyle','none','MarkerSize',3);


%create annotation labels
a = ['Total Molecules = ' num2str(sum(binddata(:,4)))];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');

axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.575 0.35 .325],'Parent',figure2,'Visible','on','box','on');
ylabel(axes2,'Unfolding k [sec^-1]');
ylim(axes2,yrangeunfolding);
xlim(axes2,xrange);
hold(axes2,'all');

axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.2 0.35 .325],'Parent',figure2,'box','on');
ylabel(axes4,'Folding k [sec^-1]');
ylim(axes4,yrangefolding);
xlim(axes4,xrange);
xlabel(axes4,'dlt G Kcal/mol','FontSize',10)
hold(axes4,'all');

stem2=stem(sorted(:,1),sorted(:,3),'Parent',axes2, 'LineStyle','none','MarkerSize',3);
stem4=stem(sorted(:,1),sorted(:,7),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);



%% Plot Kinetics of Double Exponentials

xrange = [-2.5 2.5];
yrangeunfolding = [0 30];
yrangefolding = [0 30];

% It is better to define the title at the beginning
%title = ['Single Moleule Fraction Folded'];
figure3= figure('Name', title,'PaperPosition',[0 0 6 5],'papersize',[6 5]);



% Plots the amplitues on the left
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure3,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1]);
ylabel(axes1,'Unfolding Amplitude','FontSize',10)
xlim(axes1,xrange);
ylim(axes1,[0 1]);
hold(axes1,'all');

stem1=stem(sorted(:,1),sorted(:,4),'Parent',axes1, 'LineStyle','none','MarkerSize',3);

% Creats stemplot

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure3,'Position',[0.1 0.2 0.35 .325],'XTick',[-4 -2 0 2 4],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1]);
xlim(axes3,xrange);
ylim(axes3,[0 1]);
ylabel(axes3,'Folding Amplitudes','FontSize',10);
xlabel(axes3,'dlt G Kcal/mol','FontSize',10)
hold(axes3,'all');
stem3=stem(sorted(:,1),sorted(:,8),'Parent',axes3,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);


% Plot on the right folding and unfolding rates

axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.575 0.35 .325],'Parent',figure3,'Visible','on','box','on');
ylabel(axes2,'Unfolding k [sec^-1]');
xlim(axes2,xrange);
ylim(axes2,yrangeunfolding);
hold(axes2,'all');
stem2=stem(sorted(:,1),sorted(:,5),'Parent',axes2, 'LineStyle','none','MarkerSize',3);


axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.575 0.35 .325],'Parent',figure3,'Visible','on','box','on','color','none');
ylabel(axes2,'Unfolding k [sec^-1]');
xlim(axes2,xrange);
ylim(axes2,yrangeunfolding);
hold(axes2,'all');
stem2=stem(sorted(:,1),sorted(:,6),'Parent',axes2, 'LineStyle','none','MarkerSize',3, 'MarkerEdgeColor','r');


axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.2 0.35 .325],'Parent',figure3,'box','on');
ylabel(axes4,'Folding k [sec^-1]');
xlim(axes4,xrange);
ylim(axes4,yrangefolding);
xlabel(axes4,'dlt G Kcal/mol','FontSize',10)
hold(axes4,'all');
stem4=stem(sorted(:,1),sorted(:,9),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3);

axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.55 0.2 0.35 .325],'Parent',figure3,'box','on','color','none');
ylabel(axes4,'Folding k [sec^-1]');

xlim(axes4,xrange);
ylim(axes4,yrangefolding);
xlabel(axes4,'dlt G Kcal/mol','FontSize',10)
hold(axes4,'all');
stem4=stem(sorted(:,1),sorted(:,10),'Parent',axes4,'LineStyle','none', 'Marker','square','MarkerEdgeColor',[0 0 1],'MarkerSize',3, 'MarkerEdgeColor','r');



%% In this section you plot the varables without having to rerun everything

unfoldx= 20;
foldx=5;
ymaximum = 10;
lotsofticks = [1:100]*0.1;
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];

for j=0:8
figure1 = figure('Color',[1 1 1],'Name', 'title','PaperPosition',[0 0 8 6],'papersize',[8 6]);  
annotation(figure1,'textbox','Position',[0.45 0.925 0.1 0.075],'FitHeightToText','on','String','unfolding','LineStyle','none');
annotation(figure1,'textbox','Position',[0.8 0.925 0.1 0.075],'FitHeightToText','on','String','folding','LineStyle','none');

annotation(figure1,'textbox','Position',[0.6 0.001 0.2 0.065],'FitHeightToText','on','String','Time [sec]','LineStyle','none');
annotation(figure1,'textbox','Position',[0.08 0.001 0.2 0.065],'FitHeightToText','on','String','Dlt G [Kcal/mol]','LineStyle','none');


k=1;
for   i=(1+20*j):(20+20*j)

    
axes0=axes('FontName','Arial','FontSize',10,'Position',[0.1 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [-3 3],'color','none','YTick',[]);
hold(axes0,'all');
scatter0 = scatter(sorted(i,1),0.5*k,'Parent',axes0,'Marker','square','MarkerEdgeColor',[0 0 0],'SizeData',[24],'DisplayName','unfoldingfast');
    
 
axes1=axes('FontName','Arial','FontSize',10,'Position',[0.340 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log' , 'YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
ylabel(axes1,'Residuals of Normalized Counts');
hold(axes1,'all')
scatter1 = scatter(sorted(i,11:510),(sorted(i,511:1010)+.5*k),'Parent',axes1,'Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');


axes2=axes('FontName','Arial','FontSize',10,'Position',[0.506 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes2,'all');
scatter1 = scatter(sorted(i,11:510),(sorted(i,1011:1510)+.5*k),'Parent',axes2,'Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes3=axes('FontName','Arial','FontSize',10,'Position',[0.672 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes3,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2011:2510)+.5*k),'Parent',axes3,'Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');

axes4=axes('FontName','Arial','FontSize',10,'Position',[0.838 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','off','YGrid', 'off','YMinorGrid', 'off', 'YtickLabel',[],'YTick',lotsofticks);
hold(axes4,'all');
scatter1 = scatter(sorted(i,1511:2010),(sorted(i,2511:3010)+.5*k),'Parent',axes4,'Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');
k=k+1;

axes1=axes('FontName','Arial','FontSize',10,'Position',[0.340 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log' , 'YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes2=axes('FontName','Arial','FontSize',10,'Position',[0.506 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 unfoldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes3=axes('FontName','Arial','FontSize',10,'Position',[0.672 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);
axes4=axes('FontName','Arial','FontSize',10,'Position',[0.838 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0.1 foldx],'color','none','XScale','log','YMinorTick','On','YGrid', 'on','YMinorGrid', 'on', 'YtickLabel',[]);

end
end







%% So the values don't dump

%% Just for Saftey






