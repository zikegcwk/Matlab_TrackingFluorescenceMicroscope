function  output = Mean_FRET_Inetnsity_Correlation(sorteddata)

% written by Max Greenfeod on 062108 to look for correlation between the
% mean fret intensity of molecule and the apparent dlt G
%Sergey plotting sorted (:,25 and 26) for FRET and 25 for intensity, that's where they seem to be
title = 'temptitle';

deltag = [sorteddata{:,12}]
highfret = [sorteddata{:,26}]
lowfret = [sorteddata{:,27}]
meanint = [sorteddata{:,25}]
figure1 = figure('Name', title,'PaperPosition',[0 0 3 5],'papersize',[3 5]);

% Create axes
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.2 0.55 0.75 .35],'box','on');
ylabel(axes1,'Mean FRET','FontSize',10);
xlabel(axes1,'\Delta G [kcal/mol]','FontSize',10);
hold(axes1,'all');
xlim(axes1,[-2.5 2.5]);
ylim(axes1,[-.1 1.1]);
scatter(deltag,highfret,'Parent',axes1);

axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.2 0.55 0.75 .35],'box','on','color','none');
ylabel(axes1,'Mean FRET','FontSize',10);
xlabel(axes1,'\Delta G [kcal/mol]','FontSize',10);
hold(axes1,'all');
xlim(axes1,[-2.5 2.5]);
ylim(axes1,[-.1 1.1]);
scatter(deltag,lowfret,'Parent',axes1);

axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.2 0.1 0.75 .35],'box','on');
ylabel(axes1,'Mean Total Intensity','FontSize',10);
xlabel(axes1,'\Delta G [kcal/mol]','FontSize',10);
hold(axes1,'all');
xlim(axes1,[-2.5 2.5]);

scatter(deltag,meanint,'Parent',axes1);



%fresult2str = {'a1' num2str(output(1));'b1' num2str(output(2));'c1' num2str(output(3));'a2' num2str(output(4));'b2' num2str(output(5));'c2' num2str(output(6))};
%fresult2str = num2str(output);
%create annotation labels
% a = ['A1 = ' num2str(round(output(1)))];
% b = ['b1 = ' num2str(round(1000*output(2))/1000)];
% c = ['A2 = ' num2str(round(output(4)))];
% d = ['b2 = ' num2str(round(1000*output(5))/1000)];
% e = ['time = ' num2str(round(time))];
% i = [ 'FWHM1 = ' num2str(round(1000*output(3)*2*sqrt(2*log(2)))/1000)];
% j = [ 'FWHM2 = ' num2str(round(1000*output(6)*2*sqrt(2*log(2)))/1000)];
% f = ['fraction high = ' round(num2str((output(4)/(output(1)+output(4))*100))) '%'];
% g = ['%>FRET 0.5 = ' num2str(round(highpercentagechecker)) '%'];
% h = ['REAL %high = ' num2str(newfractionhigh) '%'];
% 




% % make a legend, show the important info
% legend off;
% 
% output=[concentration output highfrequency highpercentage highpercentagechecker lowfrequencychecker (1-highfrequency-lowfrequencychecker)];
% 
% annotation('textbox','Position',[0.15 0.1 0.135 0.15],'String',{a b c d },'FitHeightToText','on','LineStyle','none');
% annotation('textbox','Position',[0.5 -0.1 0.135 0.3413],'String',{ i j e f g h},'FitHeightToText','off','LineStyle','none');

%% So The values dont dump

%% Just for saftey
