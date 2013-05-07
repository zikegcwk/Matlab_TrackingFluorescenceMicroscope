function [B,C]=dltG_change_with_time(newsorted,qdltg,title,dltg_range,numberbins,xrange,...
    tracelengthaxess,yrangeunfolding,yrangefolding,refold_plot,stepsize,threshold_point,...
    chage_with_time,dltg_peak_centerm,dltg_signa_to_noise,STN_method)


figure2= figure('Name', title,'PaperPosition',[0 0 6.5 7],'papersize',[6.5 7]);

for i=1:size(qdltg,2)

positions = find([newsorted{:,3}]==qdltg(i) );  
tempdata = newsorted(positions,:);

color_order ={ 'k' 'r' 'g' 'b' 'c' 'm' };
temp_color = color_order{i};

if chage_with_time == true
running_equlibrium ={};
for j= 1:size(tempdata,1)
    

temptrace=tempdata{j,1};
tempfret = temptrace(:,3)
anomolous = find(tempfret < -0.1 | tempfret > 1.1);
tempfret(anomolous) =[];

number_of_frames = stepsize*tempdata{j,2};

position = number_of_frames;
temp_running_equlibrium =[];
while position <= size(tempfret,1)

    positionfret = tempfret(1:position);

    highposition = find(positionfret > threshold_point);
    highfret = positionfret(highposition);
    positionfret(highposition) = [];
    lowfret  = positionfret;   
    equilibrium = size(highfret,1)/size(lowfret,1);
    dltg=-1.987*293*log(equilibrium)/1000;
    temp_running_equlibrium = [temp_running_equlibrium dltg];
    position = position + number_of_frames;

end

running_equlibrium = cat(1,running_equlibrium, temp_running_equlibrium);


end


axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.08 0.7 0.85 0.27],'box','on'...
    ,'color','none');

xlabel(axes1,'Time [sec]','FontSize',10)
ylabel(axes1,'Apparent \Delta G Kcal/mol');
xlim(axes1,[0,1000]);
ylim(axes1,dltg_range);
hold(axes1,'all');


for m=1:size(running_equlibrium,1)

xdata = (1:size(running_equlibrium{m},2))*number_of_frames;
ydata = running_equlibrium{m};




% Plot of molecules that do fold

bar1=plot(xdata,ydata ,'Parent',axes1)


end
end



if dltg_peak_centerm==true

thermo_fits = [];
for i=1: size(tempdata,1)    
    thermo_fits = [ thermo_fits; tempdata{i,5}];    
end


axes3 = axes('FontName','Arial','FontSize',10,'Parent',figure2,'Position',[0.08 0.39 0.35 0.27],'box','on','color','none');
%stem1=stem(lowerthantracelength(:,1) ,lowerthantracelength(:,2),'Parent',axes3,'Marker','none','Color','r');
xlim(axes3,dltg_range);
ylim(axes3,[-0.1 1]);
xlabel(axes3,'\Delta G Kcal/mol','FontSize',10);
ylabel(axes3,'Gaussian Center','FontSize',10)
hold(axes3,'all');
stem1=scatter([tempdata{:,4}]',thermo_fits(:,2),'Parent',axes3,'MarkerEdgeColor',temp_color);

% fcor = corr([tempdata{:,4}]',thermo_fits(:,2));
% 
% xline = [-2 2];
% yline = .2;
% plot( xline, [yline (fcor*(xline(2)-xline(1))+yline)],'Parent',axes3, 'Marker','none','LineWidth',2,'Color','r');

 stem1=scatter([tempdata{:,4}]',thermo_fits(:,5),'Parent',axes3,'MarkerEdgeColor','b');
% fcor = corr([tempdata{:,4}]',thermo_fits(:,5));
% xline = [-2 2];
% yline = .8;
% plot( xline, [yline (fcor*(xline(2)-xline(1))+yline)],'Parent',axes3, 'Marker','none','LineWidth',2,'Color','r');


end


if dltg_signa_to_noise==true
    
    
    dltg = [tempdata{:,4}]';
    STN = cell2mat(tempdata(:,6));
    
    
axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.39 0.35 0.27],'Parent',figure2,'box','on',...
    'YMinorTick','on','color','none');
ylabel(axes4,'Signa to Noise');
ylim(axes4,[1 6]);
xlim(axes4,dltg_range);
xlabel(axes4,'\Delta G Kcal/mol','FontSize',10)
hold(axes4,'all');
    
stem1=scatter(dltg ,STN(:,STN_method),'Parent',axes4,'MarkerEdgeColor',temp_color);
    
% fcor = corr(dltg ,STN(:,STN_method));
% xline = [-2 2];
% yline = 2;
% 
% plot( xline, [yline (fcor*(xline(2)-xline(1))+yline)],'Parent',axes4, 'Marker','none','LineWidth',2,'Color','r');
        
    
end






% meantracelength = mean(tracelength);
% 
% %create annotation labels
% a = ['Total Molecules = ' num2str(totalmolecules)];
% b = ['Mean Trace Length [sec]= ' num2str(round(meantracelength))];
% c = ['Mean = ' num2str(round(100*bootmean)/100) '    Std = ' num2str(round(100*bootstd)/100)];
% annotation1 = annotation(figure2,'textbox','Position',[0.05 .1 0.5 0.03],'FitHeightToText','on','String',{a,b,c},...
%     'color', temp_color,'LineStyle','none');
% 
% axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.7 0.35 0.27],'Parent',figure2,'Visible','on','box','on','Yscale',...
%     flodingratescale,'YMinorTick','on','XTick',dltgtick,'color','none');
% ylabel(axes2,'Unfolding k [sec^{-1}]');
% ylim(axes2,yrangeunfolding);
% xlim(axes2,xrange);
% hold(axes2,'all');
% 
% 
% ucor = corr(dltg',unfolding(:,1));
% fcor = corr(dltg',folding(:,1))

%d = ['correlation unfold= ' num2str(round(100*ucor)/100)];
%e = ['correlation fold = ' num2str(round(100*fcor)/100)];
%annotation1 = annotation(figure2,'textbox','Position',[0.55 .1 0.5 0.03],'FitHeightToText','on','String',{d,e},'LineStyle','none');


if refold_plot == true
    
    
dltg = [tempdata{:,4}]';
total_intensity = cell2mat(tempdata(:,7));

axes5 = axes('FontName','Arial','FontSize',10,'Position',[0.58 0.06 0.35 0.27],'Parent',figure2,'box','on',...
    'color','none');
ylabel(axes5,' Intensity');
ylim(axes5,[0 10]);
xlim(axes5,dltg_range);
xlabel(axes5,'\Delta G Kcal/mol','FontSize',10)
hold(axes5,'all');
    
stem1=scatter(dltg ,STN(:,STN_method),'Parent',axes5,'MarkerEdgeColor',temp_color);




end

end

annotation(figure2,'textbox','Position',[0.1 .95 0.9 0.03],'FitHeightToText','on','String',...
    strcat(title, ' SM Thermo Single Kinetics'),'LineStyle','none');
clipboard('copy',strcat(title, ' SM Thermo Single Kinetics'))


