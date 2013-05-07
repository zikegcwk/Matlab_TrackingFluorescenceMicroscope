function [B,C]=FractionFoldedIndividualMoleculesSimulations(alltraces,minimumlifetime)

% this was modified from FractionFoldedIndividualMolecules to take
% simulated data

% this is just a varable change between the two functions
finaldata=alltraces;
fps=1 % just to prevend delating varables

finaldatasize = size(finaldata);
numberrows = finaldatasize(1);

fractionhighfret = 2*ones(1, numberrows);
alltracelength = zeros(1, numberrows) ;
tempdewells = zeros(numberrows, 2);

for 1:numberrows;
    
    
    
    if finaldata(j,1)== 9;
        
        if (sum(tempdewells(:,1))+sum(tempdewells(:,2)))/fps>=minimumlifetime
        x = sum(tempdewells(:,2))/(sum(tempdewells(:,1))+sum(tempdewells(:,2))) ;
              
        tracelength=((sum(tempdewells(:,1))+sum(tempdewells(:,2))))/fps;
        
        x=x;
        fractionhighfret(1,j)= x;
        alltracelength(1,j)=tracelength;
        
        clear x;
        clear tempdewlls;
        tempdewells = zeros(numberrows, 2);
        
        else
        clear x;
        clear tempdewlls;
        tempdewells = zeros(numberrows, 2);
        end
        
            
    continue;
    
    elseif finaldata(j,1)== 0;
        
        tempdewells(j,1)=finaldata(j,2);
        tempdewells(j,2)=0;
        continue;
    else 
        tempdewells(j,2)=finaldata(j,2);
        tempdewells(j,1)=0;
    continue;
    end;
end;


fractionhighfret=fractionhighfret(isfinite(fractionhighfret));

tosort = fractionhighfret';
sorted = sortrows(tosort);
numberofmolecules = find(sorted>=0 & sorted <= 1 );
numberofmolecules = size(numberofmolecules,1);

binddata=[];

% this is to calculate the average trace length
tracelengthtosort=alltracelength' ;
sortedtracelength=sortrows(tracelengthtosort);
sizesortedtracelength=size(sortedtracelength,1);
starttracelength=find(sortedtracelength >0 );
meantracelength=mean(sortedtracelength(starttracelength,1));


%% This is to creat a stem plot of the data 


nobin = find(sorted>=0 & sorted <= 1 );
      
datanobin= sorted(nobin);% bin of fret state
datanobin(:,2)=1;


% at the moment this misses the last molecule this should be corrected
%linedata=[];
%tempdatanobin=[];
%sizedatanobin=size(datanobin(:,2),1);
%linedata=2*ones(sizedatanobin,2);
%for i=1:sizedatanobin-1;
  
 %   if datanobin(i,1)==datanobin(i+1,1)
  %      index=index+1;
   %       tempdatanobin=[datanobin(i,1) index];
          %tempdatanobin(1,1) =datanobin(i,1);
         % tempdatanobin(1,2) =tempdatanobin(1,2)+datanobin(i,2);
 
 
  %else 
    
   %   if tempdatanobin(1,2)>=2;
      
    %      linedata(i,1)=tempdatanobin(1,1);
     %     linedata(i,2)=tempdatanobin(1,2);
          
      %    tempdatanobin=[0 0];
       %   index=0;
      %else 

       %   linedata(i,1)=datanobin(i,1);
        %  linedata(i,2)=datanobin(i,2);
         % tempdatanobin=[0 0];
      %end
    %end
    
%end

%sortedlinedata=sortrows(linedata,1);
%positionofsorted=find(sortedlinedata(:,1)<2);
%finalsortedlinedata = sortedlinedata(positionofsorted,:);
  
%%
bin1 = find(sorted>=0 & sorted < 0.1 );
      binddata(1,1)= 0.0;
      binddata(1,2)= mean(sorted(bin1));
      binddata(1,3)= size(bin1,1);
      binddata(1,4)= size(bin1,1)/numberofmolecules;

bin2 = find(sorted>=.1 & sorted < 0.2 );
      binddata(2,1)= 0.1;
      binddata(2,2)= mean(sorted(bin2));
      binddata(2,3)= size(bin2,1);  
      binddata(2,4)= size(bin2,1)/numberofmolecules;

bin3 = find(sorted>=.2 & sorted < 0.3 );
      binddata(3,1)= 0.2;
      binddata(3,2)= mean(sorted(bin3));
      binddata(3,3)= size(bin3,1); 
      binddata(3,4)= size(bin3,1)/numberofmolecules;
      
bin4 = find(sorted>=0.3 & sorted < 0.4 );
      binddata(4,1)= 0.3;
      binddata(4,2)= mean(sorted(bin4));
      binddata(4,3)= size(bin4,1); 
      binddata(4,4)= size(bin4,1)/numberofmolecules;
      
bin5 = find(sorted>=0.4 & sorted < 0.5 );
      binddata(5,1)= 0.4;
      binddata(5,2)= mean(sorted(bin5));
      binddata(5,3)= size(bin5,1); 
      binddata(5,4)= size(bin5,1)/numberofmolecules;
      
bin6 = find(sorted>=0.5 & sorted < 0.6 );
      binddata(6,1)= 0.5;
      binddata(6,2)= mean(sorted(bin6));
      binddata(6,3)= size(bin6,1); 
      binddata(6,4)= size(bin6,1)/numberofmolecules;
      
bin7 = find(sorted>=0.6 & sorted < 0.7 );
      binddata(7,1)= 0.6;
      binddata(7,2)= mean(sorted(bin7));
      binddata(7,3)= size(bin7,1); 
      binddata(7,4)= size(bin7,1)/numberofmolecules;
      
bin8 = find(sorted>=0.7 & sorted < 0.8 );
      binddata(8,1)= 0.7;
      binddata(8,2)= mean(sorted(bin8));
      binddata(8,3)= size(bin8,1); 
      binddata(8,4)= size(bin8,1)/numberofmolecules;

bin9 = find(sorted>=0.8 & sorted < 0.9 );
      binddata(9,1)= 0.8;
      binddata(9,2)= mean(sorted(bin9));
      binddata(9,3)= size(bin9,1); 
      binddata(9,4)= size(bin9,1)/numberofmolecules;

bin10 = find(sorted>=0.9 & sorted <= 1 );
      binddata(10,1)= 0.9;
      binddata(10,2)= mean(sorted(bin10));
      binddata(10,3)= size(bin10,1); 
      binddata(10,4)= size(bin10,1)/numberofmolecules;
    
    
    
    
title = ['Individual Molecule Fraction Folded'];
figure1 = figure('Name', title,'PaperPosition',[0 0 3 5],'papersize',[3 5]);


axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.55 0.7 .4]);
axes2 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.55 0.7 .4],'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],'YAxisLocation','right','box','on');

ylabel(axes1,'Number of Molecule','FontSize',10);
ylabel(axes2,'Fraction of Molecules','FontSize',10)
xlabel(axes2,'Fraction High FRET','FontSize',10)


hold(axes1,'all');
hold(axes2,'all');

bar1=bar(binddata(:,1),binddata(:,3),'Parent',axes1,'BarLayout','stacked','BarWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
bar2=bar(binddata(:,1),binddata(:,4),'Parent',axes2,'BarLayout','stacked','BarWidth',1,'EdgeColor',[0 0 0]);

xlim(axes1,[-0.02 1]);
xlim(axes2,[-0.02 1]);


%% Create stem plot 

axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.15 0.7 .3],'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],'box','on');
xlim(axes3,[-0.02 1]);
ylabel(axes3,'Number of Molecule','FontSize',10);
hold(axes3,'all')

%stem1=stem(finalsortedlinedata(:,1),finalsortedlinedata(:,2),'Parent',axes3);

%% Create textbox


%create annotation labels
a = ['Total Molecules = ' num2str(sum(binddata(:,3)))];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
%c = ['k1 = ' num2str(round(100*doublefitlowval(2))/100)];
%d = ['A2 = ' num2str(round(100*doublefitlowval(3))/100)];
%e = ['k2 = ' num2str(round(100*doublefitlowval(4))/100)];
%f = [num2str(timetotallow) ' s'];
%g = [num2str(totaldwellslow) ' dwells'];


annotation1 = annotation(figure1,'textbox','Position',[0.1 0.0 0.1 0.1],'FitHeightToText','on','String',{a,b},'LineStyle','none');
%annotation3 = annotation(figure1,'textbox','Position',[0.25 0.1 0.1 0.1],'FitHeightToText','on','String',{f,g},'LineStyle','none');
%annotation5 = annotation(figure1,'textbox','Position',[0.15 0.7 0.3 0.3],'String','Unfolding','LineStyle','None','FontSize',18);    



binddata




       
  
    
 