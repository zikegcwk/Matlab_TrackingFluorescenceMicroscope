function [B,C]=FractionFoldedIndividualMoleculesSD(kinetics_defmlc_file,fps,minimumlifetime)

% this script was modified from kinFRETanalALLcascadeANYcopierResiduals.m
% by Max Greenfeld on 112707 to extract the molecule hetrogenity from the
% deliniated kinetics_defmlc file.  The kinetis of differnt molecule are
% deliniated with a [9 9 9 9] vector


%tobeimported = kinetics_defmlc_file % used this line if call in the function externally


%uses use thse lines to define ariables interally to opperate the fxn

tobeimported ='(kinetics_defmlc)cascade45.46.47.48.49.(25 mM)(4).dat';
fps = 25;
minimumlifetime= 30;

%end of input variables

finaldata = importdata(tobeimported);

numberrows = size(finaldata,1);

%% Reduing the earlier section more efficienty
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
              
        
        
        
        %   fit with single and double exponenetials
% options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
% 
% %unfolding
% [singlefithigh resnormhighsingle]= lsqcurvefit(@singleexponential,[0.001],hightable(:,1),hightable(:,4));
% resnormhighsingle
% xvalues=hightable(:,1);
% ysingle=(singleexponential(singlefithigh,xvalues));
% meanunfoldingresidual = mean(hightable(:,4)-ysingle);            
% 
% %folding
% [singlefitlow, resnormlowsingle] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
% resnormlowsingle
% 
% xvalues=lowtable(:,1);
% 
% ysingle=(singleexponential(singlefitlow,xvalues));
% meanfoldingresidual = mean(lowtable(:,1)-ysingle);
       
%This are dummy variable to keep the loop running If in the future I want
%to fit to the kinetics again just comment these out and umcomment the
%abover section about lined 77-94
equilibrium = tempfractionhighfret/(1-tempfractionhighfret);
dltg=-1.987*293*log(equilibrium)/1000;
singlefithigh =1;
meanunfoldingresidual =NaN;
singlefitlow =NaN;
meanfoldingresidual =NaN;

% single trace summary is a summary carrying 
 tempsummary =[tempfractionhighfret,tracelength,equilibrium,dltg,singlefithigh,meanunfoldingresidual,singlefitlow,meanfoldingresidual];
              
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


%% Bootstrap

bootmean = mean(bootstrp(100,@mean,sorted(:,1)));
bootstd = mean(bootstrp(100,@std,sorted(:,1)));

%% This is to creat a stem plot of the data 
% this code should be made nicer...


nobin = find(sorted(:,1)>=0 & sorted(:,1) <= 1 );
datanobin= sorted(nobin);% bin of fret state
datanobin(:,2)=1;


% at the moment this misses the last molecule this should be corrected
linedata=[];
tempdatanobin=[0,0];
sizedatanobin=size(datanobin(:,2),1);
linedata=2*ones(sizedatanobin,2);
index=0;


for i=1:sizedatanobin-1;
  
    if datanobin(i,1)==datanobin(i+1,1)
        index=index+1;
          tempdatanobin=[datanobin(i,1) index];
          %tempdatanobin(1,1) =datanobin(i,1);
         % tempdatanobin(1,2) =tempdatanobin(1,2)+datanobin(i,2);
 
  else 
    
      if tempdatanobin(1,2)>=2;
      
          linedata(i,1)=tempdatanobin(1,1);
          linedata(i,2)=tempdatanobin(1,2);
          
          tempdatanobin=[0 0];
          index=0;
      else 

          linedata(i,1)=datanobin(i,1);
          linedata(i,2)=datanobin(i,2);
          tempdatanobin=[0 0];
      end
    end    
end

sortedlinedata=sortrows(linedata,1);
positionofsorted=find(sortedlinedata(:,1)<2);
finalsortedlinedata = sortedlinedata(positionofsorted,:);
  
%%

binddata=[];
numberbins=12;
startdltg=-2.5;

j=0;
for i=1:numberbins-1
    
          
bin = find(sorted(:,4)>=(startdltg+j) & sorted(:,4) < startdltg+.5+j );
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
      
% bin = find(sorted(:,1)>=(1-1/numberbins) & sorted(:,1) <= 1 );
%       binddata(numberbins,1)= 1-1/numberbins;
%       binddata(numberbins,2)= mean(sorted(bin,1));
%       binddata(numberbins,3)= size(bin,1); 
%       binddata(numberbins,4)= size(bin,1)/numberofmolecules;
%       binddata(numberbins,5)= mean(sorted(bin,3));
%       binddata(numberbins,6)= mean(sorted(bin,4));
%       binddata(numberbins,7)= mean(sorted(bin,5));
%       binddata(numberbins,8)= mean(sorted(bin,6));
% 
%   equlibrium = [0; .1/.9; .2/.8; .3/.7; .4/.6; .5/.5; .6/.4; .7/.3; .8/.2; .9/.1  ]  ;
%   deltg= 1.987*293*log(equlibrium)/1000;
% binddata =   [binddata equlibrium deltg];
%% creat plot 1    
%'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]    
title = ['Individual Molecule Fraction Folded'];
figure1 = figure('Name', title,'PaperPosition',[0 0 3 5],'papersize',[3 5]);


axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.55 0.7 .4]);
%axes2 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.55 0.7 .4],'XTick',[-4 -2 0 2 4],'YAxisLocation','right','box','on');

ylabel(axes1,'Number of Molecule','FontSize',10);
%ylabel(axes2,'Fraction of Molecules','FontSize',10)
%xlabel(axes2,'dlt G Kcal/mol','FontSize',10)


hold(axes1,'all');
%hold(axes2,'all');

bar1=bar((binddata(:,1)+0.25), binddata(:,4),'Parent',axes1,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
%bar2=bar(binddata(2:10,10),binddata(2:10,4),'Parent',axes2,'BarLayout','stacked','BarWidth',1,'EdgeColor',[0 0 0]);

xlim(axes1,[-2 2]);
%xlim(axes2,[-2 2]);


% Create stem plot 

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.15 0.7 .3],'XTick',[-4 -2 0 2 4],'box','on');
%xlim(axes3,[-0.02 1]);
ylabel(axes3,'Number of Molecule','FontSize',10);
%hold(axes3,'all')

% This is not the proper place to do it but I need to calculate dlt G for
% each trace to plot it.
% 
% numberrows =size (finalsortedlinedata(:,1),1)
% dltg=[];
% for j=1:numberrows 
% tempdltg =1.987*293*log(finalsortedlinedata(j,1)/(1-finalsortedlinedata(j,1)))/1000
% dltg = [dltg;tempdltg]
% end


stem1=stem(sorted(:,4) ,sorted(:,5),'Parent',axes3);
xlim(axes3,[-2 2]);
% Create textbox



%create annotation labels
a = ['Total Molecules = ' num2str(sum(binddata(:,4)))];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
%d = ['Std = ' num2str(round(100*bootstd)/100)];
annotation1 = annotation(figure1,'textbox','Position',[0.1 0.0 0.1 0.1],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');



binddata


% %% create plot 2
% 
% title='';
% 
% figure2 = figure('Color',[1 1 1],'Name', title,'PaperPosition',[0 0 6 5],'papersize',[6 5]);
%  
% axes10 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.55 0.4 .4],'Parent',figure2,'Visible','on','box','on');
% ylabel(axes10,'k^-1');
% 
% axes30 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.3 0.4 0.2],'Parent',figure2,'Visible','on','box','on');
% xlabel(axes30,'Fraction High Fret');
% ylabel(axes30,'Residual');
% 
% axes20 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.55 0.4 0.4],'Parent',figure2,'box','on');
% 
% ylabel(axes20,'k^-1');
% 
% axes40 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.3 0.4 0.2],'Parent',figure2,'box','on');
% xlabel(axes40,'Fraction High Fret');
% ylabel(axes40,'Residuals');
% 
% 
% hold(axes10,'all')
% hold(axes20,'all')
% hold(axes30,'all')
% hold(axes40,'all')
% 
% 
% 
% bar1=bar(binddata(:,1),binddata(:,5),'Parent',axes10,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% bar3=bar(binddata(:,1),binddata(:,6),'Parent',axes30,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% 
% bar2=bar(binddata(:,1),binddata(:,7),'Parent',axes20,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% bar4=bar(binddata(:,1),binddata(:,8),'Parent',axes40,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% 
% xlim(axes10,[-0.02 1]);
% 
% xlim(axes30,[-0.02 1]);
% ylim(axes30,[-0.2 0.2]);
% 
% 
% xlim(axes20,[-0.02 1]);
% 
% xlim(axes40,[-0.02 1]);
% ylim(axes40,[-0.2 0.2]);
%     
% annotation6 = annotation(figure2,'textbox','Position',[0.65 0.7 0.3 0.3],'String','Folding','LineStyle','None','FontSize',18);  
% annotation5 = annotation(figure2,'textbox','Position',[0.15 0.7 0.3 0.3],'String','Unfolding','LineStyle','None','FontSize',18);    
% 
% a = ['meanfractionfolede = ' num2str(round(100*meanfractionfolede)/100)];
% b = ['meantracelength = ' num2str(round(100*meantracelength)/100)];
% c = ['meankfold = ' num2str(round(100*meankfold)/100)];
% d = ['meankunfold = ' num2str(round(100*meankunfold)/100)];
% 
% 
% annotation1 = annotation(figure2,'textbox','Position',[0.1 0.1 0.1 0.1],'FitHeightToText','on','String',{a,b,c,d},'LineStyle','none');
% 



