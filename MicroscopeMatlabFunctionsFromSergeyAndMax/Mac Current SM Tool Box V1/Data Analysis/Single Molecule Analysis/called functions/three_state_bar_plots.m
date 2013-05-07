function [B,C]=three_state_bar_plots(newsorted,title,bin_width,xrange,thresholds)



% extract data of interest for this function
%xposition =[newsorted{:,5}];
%yposition =[newsorted{:,6}];
%rawdltg =newsorted(:,1);
dltg =[newsorted{:,3}];
tracelength =[newsorted{:,4}];

totalmolecules = size(newsorted,1);
meantracelength = mean(tracelength);
bootmean = mean(bootstrp(100,@mean,dltg(:)));
bootstd = mean(bootstrp(100,@std,dltg(:)));



unfolding   =[];
folding     =[];

molecule_transitions = [];

for i=1:size(newsorted,1)

temp_raw_data = newsorted{i,1};
temp_dltg = newsorted{i,3}
temptrace = newsorted{i,2};
temptrace = temptrace(12:(end-2),:);
%sorted_trace = sortrows(temptrace);


% I need to clasify the satate of the molecule
% this is more complicated than the two state condition
% Pairwise i.e. time in the low FRET or time in the middle state

trace_size = size(temp_raw_data,1)
events_in_low_fret = size(find(temp_raw_data(:,3)< thresholds(1)),1);
events_in_low_middle_fret = size(find(temp_raw_data(:,3)> thresholds(1) & temp_raw_data(:,3)< thresholds(2)),1);


time_in_low_fret = events_in_low_fret / trace_size;


time_in_low_middle = events_in_low_middle_fret /  trace_size;






temp_position = find(temptrace(:,1)==0 & temptrace(:,4)==3);
low_to_high =  temptrace(temp_position,:);

temp_position = find(temptrace(:,1)==0 & temptrace(:,4)==1);
low_to_middle =  temptrace(temp_position,:);

temp_position = find(temptrace(:,1)==1 & temptrace(:,4)==3);
middle_to_high =  temptrace(temp_position,:);


temp_position = find(temptrace(:,1)==3 & temptrace(:,4)==0);
high_to_low =  temptrace(temp_position,:);

temp_position = find(temptrace(:,1)==3 & temptrace(:,4)==1);
high_to_middle =  temptrace(temp_position,:);

temp_position = find(temptrace(:,1)==1 & temptrace(:,4)==0);
middle_to_low =  temptrace(temp_position,:);



check_size = size(low_to_high,1)+ size(low_to_middle,1)+ size(middle_to_high,1)...
            + size(high_to_low,1)+ size(high_to_middle,1)+ size(middle_to_low,1);

      check_size ~= size(temptrace,1)
      
if check_size ~= size(temptrace,1)

error('missed some transitions')

end

folding_transitions   =  [size(low_to_high,1), size(low_to_middle,1), size(middle_to_high,1)];
folding_transitions = folding_transitions/sum(folding_transitions);

unfolding_transitions =  [size(high_to_low,1), size(high_to_middle,1), size(middle_to_low,1)];
unfolding_transitions = unfolding_transitions/sum(unfolding_transitions);






molecule_transitions = [  molecule_transitions;  [temp_dltg, 1 folding_transitions, unfolding_transitions,...
    time_in_low_fret,time_in_low_middle]];



end


temp_data = sortrows(molecule_transitions);

% i=1;
% while i<size(temp_data,2)
%     
%     if temp_data(i,1)==temp_data(i+1,1)
%         temp_data(i,:) = mean(temp_data(i:i+1,:));
%         temp_data(i+1,:)=[];  
%         i=i-1; 
%     end
%      i=i+1; 
% end

molecule_transitions = [];
molecule_transitions = temp_data;




%bar(molecule_transitions(1:end-1,1),molecule_transitions(1:end-1,3:4),'stack','BarWidth',100)

% Plots the thermodynamis on the left side of  the figure
% It is better to define the title at the beginning
%title = ['Individual Molecule Fraction Folded'];
figure2= figure('Name', title,'PaperPosition',[0 0 5 5],'papersize',[5 5]);





% Plot of molecules that do fold
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1],'color','none');
ylabel(axes1,'Folding Transitions','FontSize',10)
xlim(axes1,xrange);
%ylim(axes1,[0 fractionmax]);
hold(axes1,'all');

%bar(molecule_transitions(1,9),molecule_transitions(1,3:5),'Parent',axes1,'stack','BarWidth',bin_width(1),'EdgeColor','none')

bar(molecule_transitions(1:end,9),molecule_transitions(1:end,3:5),'Parent',axes1,'stack','BarWidth',bin_width(1),'EdgeColor','none')


axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,xrange);
%ylim(axes3,[0 tracelengthaxess]);
ylabel(axes3,'Unfolding Transitions','FontSize',10);
xlabel(axes3,'Fraction time in Low FRET','FontSize',10)
hold(axes3,'all');
bar(molecule_transitions(1:end,9),molecule_transitions(1:end,6:8),'Parent',axes3,'stack','BarWidth',bin_width(1),'EdgeColor','none')




axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.6 0.575 0.35 .325],'box','on','YTick', [0 0.2 0.4 0.6 0.8 1],'color','none');
%ylabel(axes1,'Folding Transitions','FontSize',10)
xlim(axes1,xrange);
%ylim(axes1,[0 fractionmax]);
hold(axes1,'all');
bar(molecule_transitions(1:end,10),molecule_transitions(1:end,3:5),'Parent',axes1,'stack','BarWidth',bin_width(2),'EdgeColor','none')


axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.6 0.2 0.35 .325],'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,xrange);
%ylim(axes3,[0 tracelengthaxess]);
%ylabel(axes3,'Unfolding Transitions','FontSize',10);
xlabel(axes3,'Fraction time in Middle FRET','FontSize',10)
hold(axes3,'all');
bar(molecule_transitions(1:end,10),molecule_transitions(1:end,6:8),'Parent',axes3,'stack','BarWidth',bin_width(2),'EdgeColor','none')






a = ['Total Molecules = ' num2str(totalmolecules)];
b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');

a = ['Low to High'];
annotation(figure2,'textbox','Position',[0.45 .8 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'b');
a = ['Low to Middle'];
annotation(figure2,'textbox','Position',[0.45 .75 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'g');
a = ['Middle to High'];
annotation(figure2,'textbox','Position',[0.45 .7 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'r');


a = ['High to Low'];
annotation(figure2,'textbox','Position',[0.45 .4 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'b');
a = ['High to Middle'];
annotation(figure2,'textbox','Position',[0.45 .35 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'g');
a = ['Middle to Low'];
annotation(figure2,'textbox','Position',[0.45 .3 0.5 0.03],'FitHeightToText','on','String',a,'LineStyle','none', 'color', 'r');


annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',strcat(title, ' SM Three State Transitions'),'LineStyle','none');
clipboard('copy',strcat(title, ' SM Three State Trnasitions'))





