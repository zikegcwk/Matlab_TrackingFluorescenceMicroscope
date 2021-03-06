function [B,C]=IndividualMoleculesKinetics(kinetics_defmlc_file,fps,minimumlifetime)

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
tobeimported ='(kinetics_defmlc)cascade34.(10 mM)(4).dat';
fps = 10;
numberofmolecules=100;
minimumlifetime =60;

%end of input variables

finaldata = importdata(tobeimported);

numberrows = size(finaldata,1);

%Reduing the earlier section more efficienty
% this will basicly creat individual kinetics files

tempdewells = [];
singletracesummary=[];

for j=1:numberrows;    
    
    if finaldata(j,1)== 9 
       
        if finaldata(j,4)== 9; %finaldata(j,4)== 9 this can be used for scoring in the future
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
            

        if (timetotalhigh+timetotallow) > minimumlifetime;
        
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

[doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],hightable(:,1),hightable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
resnormhigh
ydouble=(doubleexponential(doublefithigh,xvalues))
doubleunfoldingreslduals = hightable(:,4)-ydouble; 
newdoubleunfoldingreslduals = [ doubleunfoldingreslduals' zeros(1, concatlength)];



%folding
[singlefitlow, resnormlowsingle] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
% resnormlowsingle

singlefitlow = mle(@singleexponential,[1],lowtable(:,1),lowtable(:,4));

%expfit(

xvalues=lowtable(:,1);
ysingle=(singleexponential(singlefitlow,xvalues));
meanfoldingresidual = mean(lowtable(:,1)-ysingle);


foldingreslduals = lowtable(:,4)-ysingle;      
concatlength=500-size(ysingle,1);
newfoldingreslduals = [ foldingreslduals' zeros(1, concatlength)];
newfoldingxvalues = [ xvalues' zeros(1, concatlength)];

[doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],hightable(:,1),hightable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
resnormhigh
ydouble=(doubleexponential(doublefithigh,xvalues));
doublefoldingreslduals = lowtable(:,4)-ydouble; 
newdoublefoldingreslduals = [ doublefoldingreslduals' zeros(1, concatlength)];





       
% single trace summary is a summary carrying 
 tempsummary =[tempdltg,tracelength,singlefithigh,meanunfoldingresidual,singlefitlow,meanfoldingresidual ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals];
              
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

%% In this section you plot the varables without having to rerun everything

unfoldx= 50;
foldx=50;
ymaximum = 10;



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
    
 
axes1=axes('FontName','Arial','FontSize',10,'Position',[0.340 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 unfoldx],'color','none','XScale','log' ,'YTick',[],'XMinorTick', 'off');
ylabel(axes1,'Residuals [AU]');
hold(axes1,'all');
scatter1 = scatter(sorted(i,7:506),(sorted(i,507:1006)+.5*k),'Parent',axes1,'Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');
xlim(axes1,[0 unfoldx]);

axes2=axes('FontName','Arial','FontSize',10,'Position',[0.506 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 unfoldx],'color','none','XScale','log','YTick',[]);
hold(axes2,'all');
scatter1 = scatter(sorted(i,7:506),(sorted(i,1007:1506)+.5*k),'Parent',axes2,'Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');

axes3=axes('FontName','Arial','FontSize',10,'Position',[0.672 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 foldx],'color','none','XScale','log','YTick',[]);
hold(axes3,'all');
scatter1 = scatter(sorted(i,1507:2006),(sorted(i,2007:2506)+.5*k),'Parent',axes3,'Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24],'DisplayName','unfoldingfast');

axes4=axes('FontName','Arial','FontSize',10,'Position',[0.838 .1 0.15 .85],'Parent',figure1,'Visible','on','box','on', 'ylim', [0 ymaximum], 'xlim', [0 foldx],'color','none','XScale','log','YTick',[]);
hold(axes4,'all');
scatter1 = scatter(sorted(i,1507:2006),(sorted(i,2507:3006)+.5*k),'Parent',axes4,'Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24],'DisplayName','unfoldingfast');
k=k+1;
end
end










