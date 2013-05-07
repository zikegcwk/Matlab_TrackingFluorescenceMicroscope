function [B,C]=position_correlations(newsorted,title,meantracelength,stemwidth, zlimits)



% estract data of interest for this function
%xposition =[newsorted{5,:,:}]';
%yposition =[newsorted{6,:,:}]';
%dltg =[newsorted{7,:,:}]';
%tracelength =[newsorted{8,:,:}]';
% signaltonoise =[newsorted{19,:,:}]';
% totalintensity =[newsorted{20,:,:}]';


xposition =[newsorted{:,5}];
yposition =[newsorted{:,6}];
dltg =[newsorted{:,7}];
tracelength =[newsorted{:,8}];
%unfolding =[newsorted{:,9}];
%folding =[newsorted{:,11}];
signaltonoise =[newsorted{:,19}];
totalintensity =[newsorted{:,20}];



% gets usefill z axis limits
zdltglower = zlimits(1);
zdltgupper = zlimits(2);
ztracelength = zlimits(3);
zsignaltonoise = zlimits(4);
zintensity = zlimits(5);


figure2= figure('Name', title,'PaperPosition',[0 0 5 5],'papersize',[5 5]);

% Position vs dltG
axes0 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.575 0.35 .325],'color','none','box','off');
stem0=stem3(xposition,yposition,dltg,'Parent',axes0,'Color','k','LineWidth',stemwidth,'Marker', 'none');
zlabel(axes0,'\Delta G Kcal/mol','FontSize',10)
xlim(axes0,[64 128]);
ylim(axes0,[0 128]);
zlim(axes0,[zdltglower zdltgupper]);
hold(axes0,'all');

% Position vs trace length
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.1 0.2 0.35 .325],'color','none','box','off');
stem1=stem3(xposition,yposition,tracelength,'Parent',axes1,'Color','k','LineWidth',stemwidth,'Marker', 'none');
zlabel(axes1,'Trace Length [sec]','FontSize',10)
xlim(axes1,[64 128]);
ylim(axes1,[0 128]);
zlim(axes1,[0 ztracelength]);
hold(axes1,'all');

% Position vs signal to noise
axes2 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.6 0.575 0.35 .325],'color','none','box','off');
stem2=stem3(xposition,yposition,signaltonoise,'Parent',axes2,'Color','k','LineWidth',stemwidth,'Marker', 'none');
zlabel(axes2,'S/N','FontSize',10)
xlim(axes2,[64 128]);
ylim(axes2,[0 128]);
zlim(axes2,[0 zsignaltonoise]);
hold(axes2,'all');

% Position vs mean total intensity
axes4 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.6 0.2 0.35 .325],'color','none','box','off');
stem4=stem3(xposition,yposition,totalintensity,'Parent',axes4,'Color','k','LineWidth',stemwidth,'Marker', 'none');
zlabel(axes4,'Mean Intensity [AU]','FontSize',10)
xlim(axes4,[64 128]);
ylim(axes4,[0 128]);
zlim(axes4,[0 zintensity]);
hold(axes4,'all');


% %create annotation labels
% a = ['Total Molecules = ' num2str(totalmolecules)];
% b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
% c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
% annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},'LineStyle','none');
% 
% d = ['correlation unfold= ' num2str(round(100*ucor)/100)];
% e = ['correlation fold = ' num2str(round(100*fcor)/100)];
% annotation1 = annotation(figure2,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{d,e},'LineStyle','none');

annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',strcat(title, ' Position Correlation'),'LineStyle','none');
annotation(figure2,'textbox','Position',[0.1 .1 0.9 0.03],'FitHeightToText','on','String',strcat('Date Generated '' ', datestr(now)),'LineStyle','none');

clipboard('copy',strcat(title, ' Position Correlation'))
