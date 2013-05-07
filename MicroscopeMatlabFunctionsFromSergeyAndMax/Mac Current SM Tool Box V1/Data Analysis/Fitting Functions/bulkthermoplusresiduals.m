function  output = bulkthermoplusresiduals(inputdata,overlayid,overlay, fitnumber, numberbins, tweakguesses,fps,title,lbound,ubound,rounded)
%
% a script to fit the histograms
% output = histfit(datasource, concentration, tweakguesses)
% datasource - filename of data
% concentration - the concentration of that datasource
% tweakguesses - if you want, you can adjust the inital parameters for the
% fitting routine FORMAT: [xc1 w1 A1 xc2 w2 A2 ]
% output=[concentration output highfrequency highpercentage highpercentagechecker];

% variable to manuall run script

%datasource='cascade52(4)(FRETDIST).dat'
%concentration=1
%tweakguesses=[]

tempdata =[];
for i=1:size(inputdata,1)

    temp=[];
    temp = inputdata{i};
    tempdata = [tempdata; temp(:,:)];

end

datasource =tempdata;


qoverlay = strcmp(overlay, 'overlay');
if  qoverlay == 1;
figure1 = figure('Name', title,'PaperPosition',[0 0 3 5],'papersize',[3 5]);
end

for i=1:size(overlayid,2)

    
tweak = tweakguesses;
tg = isempty(tweak);

%datasource=a;

%first grab the data
%A = importdata(datasource);

%datasource=[];
%datasource = inputdata{overlayid(i)};

color_order ={ 'k' 'r' 'g' 'b' 'c' 'm' };
%temp_color_order =color_order(k);


if  qoverlay == 0;
figure1 = figure('Name', title,'PaperPosition',[0 0 3 5],'papersize',[3 5]);
end



todelete = find(datasource(:,3)<-.2);
datasource(todelete,:)=[];
todelete = find(datasource(:,3)>1.2);
datasource(todelete,:)=[];

%then plot it
%Create figure
%title = [num2str(20) ' mM Metal distribution'];

% Create axes
axes1 = axes('FontName','Arial','FontSize',10,'Parent',figure1,'Position',[0.15 0.55 0.8 .4],'box','on');
%xlabel(axes1,'FRET value');
ylabel(axes1,'Counts','FontSize',10);
hold(axes1,'all');
xlim(axes1,[-0.1 1.1]);
zlim(axes1,[0 10]);
% creat residuals axes
axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.15 0.3 0.8 0.2],'Parent',figure1,'Visible','on','box','on');

xlabel(axes2,'FRET value');
ylabel(axes2,'Residuals');
xlim(axes2,[-0.1 1.1]);


hold(axes1,'all');


% Create bar
hist(datasource(:,3),numberbins,'Parent',axes1);
[tempy tempx] = hist(datasource(:,3),numberbins);
A = [tempx; tempy]';


axis tight

% reply = input('Do you want 1 or 2 peaks? 1/2 [2]: ');
% if isempty(reply)
%     reply = 2;
% end
% then fit it
if fitnumber == 2
%     if tg == 1
    tweak = [100 0.15 0.1 100 0.8 0.15];
%     else
%     tweak = tweak;
%     end
options = optimset('Display','iter','TolFun',1e-12);  

%[1cmplitude 1center 1stdev 2cmplitude 2center 2stdev]
options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
histfit=lsqcurvefit(@gauss2,tweak,A(:,1),A(:,2),lbound,ubound,options);
output = histfit;
bounded = [output(3) output(6)]
plot1 = line(A(:,1),gauss1(output(1:3),A(:,1)),'Color','blue','LineWidth',2,'Parent',axes1);
plot2 = line(A(:,1),gauss1(output(4:6),A(:,1)),'Color','green','LineWidth',2,'Parent',axes1);
plot3 = line(A(:,1),gauss2(output,A(:,1)),'Color','red','LineWidth',2,'LineStyle','-.','Parent',axes1);
plot4 = scatter(A(:,1),(A(:,2)-gauss2(output,A(:,1))),'Parent',axes2,'Marker','o','MarkerEdgeColor',[0 0 0],'SizeData',[24]);

if histfit(1) < 0,
    histfit(1)= (-1).*(histfit(1))
end
if histfit(4) < 0,
    histfit(4)= (-1).*(histfit(4))
    histfit(6)= (-1).*(histfit(6))
end
output = histfit;
set(gca,'XLim',[0 1]);

xlim(axes1,[-0.1 1.1]);
xlim(axes2,[-0.1 1.1]);

time = sum(A(:,2))/fps{1};
% check the math for the fraction folded
stopper = find(A(:,1) < 0.5);
stopper = max(stopper);
lowsum = sum(A(1:stopper,2));
highsum = sum(A(stopper:end,2));
highfrequencychecker = highsum/(highsum+lowsum);
highpercentagechecker = highfrequencychecker*100;
%%%%%%%%%%%%%%gaussian distribution, high fret finder:
% y=(x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))+(x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)));
% high = (output(1)/(output(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))
% low = (x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))
% ydatalow=gauss1([output(1),output(2),output(3)],tempx);
% ydatahigh=gauss1([output(4),output(5),output(6)],tempx);
% ydatatotal=gauss2([output(1),output(2),output(3),output(4),output(5),output(6)],tempx);
% sumhigh = sum(ydatahigh);
% sumlow = sum(ydatalow);
% sumdouble = sum(ydatatotal);
% sumcheck = sumhigh+sumlow;
% newfractionhigh = round(100*sumhigh/sumcheck);

%fresult2str = {'a1' num2str(output(1));'b1' num2str(output(2));'c1' num2str(output(3));'a2' num2str(output(4));'b2' num2str(output(5));'c2' num2str(output(6))};
%fresult2str = num2str(output);
%create annotation labels

% 
% a = ['A1 = ' num2str(round(output(1)))];
% b = ['b1 = ' num2str(round(100*output(2))/100)];
% c = ['A2 = ' num2str(round(output(4)))];
% d = ['b2 = ' num2str(round(100*output(5))/100)];
% e = ['time = ' num2str(round(time))];
% i = [ 'FWHM1 = ' num2str(round(100*output(3)*2*sqrt(2*log(2)))/100)];
% j = [ 'FWHM2 = ' num2str(round(100*output(6)*2*sqrt(2*log(2)))/100)];


% f = ['fraction high = ' num2str(round((output(4)/(output(1)+output(4))*1000))/10) '%'];
% g = ['%>FRET 0.5 = ' num2str(round(highpercentagechecker)) '%'];
%h = ['REAL %high = ' num2str(newfractionhigh) '%'];

% highfrequency = output(4)/(output(1)+output(4)) ;
% highpercentage = (output(4)/(output(1)+output(4)))*100;
% % check the math for the fraction folded
% stopper = find(A(:,1) < 0.48);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% highfrequencychecker = highsum/(highsum+lowsum);
% highpercentagechecker = highfrequencychecker*100
% 
% stopper = find(A(:,1) < 0.3);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% lowfrequencychecker = lowsum/(highsum+lowsum);
% lowpercentagechecker = lowfrequencychecker*100
% clipboard('copy', lowfrequencychecker)
% first = [output(1) output(2) output(3)];
% second= [output(4) output(5) output(6)];


% plot2 = plot(A(:,1),gauss1(first,A(:,1)),'Color','blue','LineWidth',2);
% plot3 = plot(A(:,1),gauss1(second,A(:,1)),'Color','blue','LineWidth',2);

% un comment this section if the code need to be used for 3 gausians


% elseif reply == 3
%     if tg == 1
%     tweak = [100 0.1 0.1 100 0.5 0.1 100 0.8 0.1];
%     else
%     tweak = tweak;
%     end
% options = optimset('Display','iter','TolFun',1e-12);  
% options = optimset('LevenbergMarquardt','on','TolFun',1e-15,'MaxFunEvals',100000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
% histfit=lsqcurvefit(@gauss3,tweak,A(:,1),A(:,2),[0 0.05 0 0 0.48 0 0 0.75 0],[100000 0.15 .2 100000 .58 .2 1000000 .85 .2],options);
% output = histfit;
% plot1 = line(A(:,1),gauss3(output,A(:,1)),'Color','red','LineWidth',2);
% if histfit(1) < 0,
%     histfit(1)= (-1).*(histfit(1))
% end
% if histfit(4) < 0,
%     histfit(4)= (-1).*(histfit(4))
%     histfit(6)= (-1).*(histfit(6))
% end
% if histfit(7) < 0,
%     histfit(7)= (-1).*(histfit(4))
%     histfit(9)= (-1).*(histfit(6))
% end
% 
% output = histfit;
% 
% time = sum(A(:,2))/51.4;
% % check the math for the fraction folded
% stopper = find(A(:,1) < 0.3);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% highfrequencychecker = highsum/(highsum+lowsum);
% highpercentagechecker = highfrequencychecker*100;
% 
% %%%%%%%%%%%%%%gaussian distribution, high fret finder:
% % y=(x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))+(x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)));
% % high = (output(1)/(output(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))
% % low = (x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))
% ydatalow=gauss1([output(1),output(2),output(3)],A(:,1));
% ydatahigh=gauss1([output(7),output(8),output(9)],A(:,1));
% ydatamid=gauss1([output(4),output(5),output(6)],A(:,1));
% ydatatotal=gauss3([output(1),output(2),output(3),output(4),output(5),output(6),output(7),output(8),output(9)],A(:,1));
% sumhigh = sum(ydatahigh);
% summid = sum(ydatamid);
% sumlow = sum(ydatalow);
% sumtriple = sum(ydatatotal);
% sumcheck = sumhigh+sumlow+summid;
% newfractionhigh = round(100*sumhigh/sumcheck);
% 
% %fresult2str = {'a1' num2str(output(1));'b1' num2str(output(2));'c1' num2str(output(3));'a2' num2str(output(4));'b2' num2str(output(5));'c2' num2str(output(6))};
% %fresult2str = num2str(output);
% %create annotation labels
% a = ['A1 = ' num2str(output(1))];
% b = ['b1 = ' num2str(output(2))];
% i = ['A3 = ' num2str(output(7))];
% j = ['b3 = ' num2str(output(8))];
% c = ['A2 = ' num2str(output(4))];
% d = ['b2 = ' num2str(output(5))];
% e = ['time = ' num2str(time)];
% f = ['fraction high = ' round(num2str((output(7)/(output(1)+output(4)+output(7))*100))) '%'];
% g = ['%>FRET 0.3 = ' num2str(round(highpercentagechecker)) '%'];
% h = ['REAL %high = ' num2str(newfractionhigh) '%'];
% highfrequency = output(7)/(output(1)+output(4)+output(7)) ;
% highpercentage = (output(7)/(output(1)+output(4)+output(7)))*100;
% % check the math for the fraction HIGH
% stopper = find(A(:,1) < 0.65);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% highfrequencychecker = highsum/(highsum+lowsum);
% highpercentagechecker = highfrequencychecker*100
% 
% stopper = find(A(:,1) < 0.3);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% lowfrequencychecker = lowsum/(highsum+lowsum);
% lowpercentagechecker = lowfrequencychecker*100
% clipboard('copy', lowfrequencychecker)
% first = [output(1) output(2) output(3)];
% second= [output(4) output(5) output(6)];
% % plot2 = plot(A(:,1),gauss1(first,A(:,1)),'Color','blue','LineWidth',2);
% % plot3 = plot(A(:,1),gauss1(second,A(:,1)),'Color','blue','LineWidth',2);


















elseif fitnumber == 3
    %if tg == 1
    tweak = [100 0.15 0.1 100 0.5 0.15 100 0.8 0.15];
    %else
    %tweak = tweak;
    %end
options = optimset('Display','iter','TolFun',1e-12);  

%[1cmplitude 1center 1stdev 2cmplitude 2center 2stdev]
options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
histfit=lsqcurvefit(@gauss3,tweak,A(:,1),A(:,2),lbound,ubound,options);
output = histfit;
bounded = [output(3) output(6)]
plot1 = line(A(:,1),gauss1(output(1:3),A(:,1)),'Color','blue','LineWidth',2,'Parent',axes1);
plot2 = line(A(:,1),gauss1(output(4:6),A(:,1)),'Color','green','LineWidth',2,'Parent',axes1);
plot3 = line(A(:,1),gauss1(output(7:9),A(:,1)),'Color','k','LineWidth',2,'Parent',axes1);
plot4 = line(A(:,1),gauss3(output,A(:,1)),'Color','red','LineWidth',2,'LineStyle','-.','Parent',axes1);
plot5 = scatter(A(:,1),(A(:,2)-gauss3(output,A(:,1))),'Parent',axes2,'Marker','o','MarkerEdgeColor',[0 0 0],'SizeData',[24]);

% if histfit(1) < 0,
%     histfit(1)= (-1).*(histfit(1))
% end
% if histfit(4) < 0,
%     histfit(4)= (-1).*(histfit(4))
%     histfit(6)= (-1).*(histfit(6))
% end
output = histfit;
set(gca,'XLim',[0 1]);

xlim(axes1,[-0.1 1.1]);
xlim(axes2,[-0.1 1.1]);

time = sum(A(:,2))/fps{1};
% check the math for the fraction folded
%stopper = find(A(:,1) < 0.5);
%stopper = max(stopper);
%lowsum = sum(A(1:stopper,2));
%highsum = sum(A(stopper:end,2));
%highfrequencychecker = highsum/(highsum+lowsum);
%highpercentagechecker = highfrequencychecker*100;



%f = ['fraction high = ' num2str(round((output(4)/(output(1)+output(4))*1000))/10) '%'];
%g = ['%>FRET 0.5 = ' num2str(round(highpercentagechecker)) '%'];











else 
%     fresult = fit(A(:,1),A(:,2),'gauss1');
% output=  coeffvalues(fresult);
%     if tg == 1
    tweak = [300 0.1 0.1];
%     else
%     tweak = tweak;
%     end

options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');

histfit=lsqcurvefit(@gauss1,tweak,A(:,1),A(:,2),lbound,ubound,options);
output = histfit;
time = sum(A(:,2))/40;
%fresult2str = {'a1' num2str(output(1));'b1' num2str(output(2));'c1' num2str(output(3))};  
% c = ['A1 = ' num2str(output(1))];
% d = ['b1 = ' num2str(output(2))];
% a = [ ];
% b = [ ];
% i = [ ];
% j = [ ];
% e = ['time = ' num2str(time)];
stopper = find(A(:,1) < 0.48);
stopper = max(stopper);
lowsum = sum(A(1:stopper,2));
highsum = sum(A(stopper:end,2));
highfrequency = highsum/(highsum+lowsum);
highpercentage = highfrequency*100;
% check the math for the fraction folded
stopper = find(A(:,1) < 0.5);
stopper = max(stopper);
lowsum = sum(A(1:stopper,2));
highsum = sum(A(stopper:end,2));
highfrequencychecker = highsum/(highsum+lowsum);
highpercentagechecker = highfrequencychecker*100


% f = ['fraction high = ' num2str(highpercentage) '%'];
% g = ['%>FRET 0.5 = ' num2str(highpercentagechecker) '%'];


% display the fits
% Create plot
% plot1 = plot(A(:,1),gauss2(output,A(:,1)));
% first = [output(1) output(2) output(3)];
% second= [output(4) output(5) output(6)];
plot2 = plot(A(:,1),gauss1(output,A(:,1)));
end


% plot3 = plot(A(:,1),gauss1(second,A(:,1)));
%xlabel('FRET value');
ylabel('Counts','Parent',axes1);
ylabel('Residuals','Parent',axes2);
% check the math for the fraction folded
% stopper = find(A(:,1) < 0.5);
% stopper = max(stopper);
% lowsum = sum(A(1:stopper,2));
% highsum = sum(A(stopper:end,2));
% highfrequencychecker = highsum/(highsum+lowsum);
% highpercentagechecker = highfrequencychecker*100

% make a legend, show the important info
legend off;

output=[ output ];




fractnotlowfret =0;

if fitnumber == 2 || fitnumber == 3
d = ['A_{2} = ' num2str(round(rounded*output(4))/rounded)];
e = ['\mu_{2} = ' num2str(round(rounded*output(5))/rounded)];
f = [ 'FWHM_{2} = ' num2str(round(rounded*output(6)*2*sqrt(2*log(2)))/rounded)];

if fitnumber==2
m = [ 'F_{2} = '  num2str(round(rounded*(output(4)/(output(1)+output(4))))/rounded)];
l = ['%>FRET 0.5 = ' num2str(round(highpercentagechecker)) '%'];
fractnotlowfret= (output(4)/(output(1)+output(4)));

else
m = [ 'F_{2} = '  num2str(round(rounded*(output(4)/(output(1)+output(4)+output(7))))/rounded)];
l='';
fractnotlowfret= output(4)/(output(1)+output(4)+output(7));
end
annotation(figure1,'textbox','Position',[0.2 0.25 0.1 0],'String',{d e f m l },'FitHeightToText','on','LineStyle','none', 'FontSize',8,'Color','g','VerticalAlignment','baseline','HorizontalAlignment','left');
end

if fitnumber == 3
g = ['A_{3} = ' num2str(round(rounded*output(7))/rounded)];
h = ['\mu_{3} = ' num2str(round(rounded*output(8))/rounded)];
i = [ 'FWHM_{3} = ' num2str(round(rounded*output(9)*2*sqrt(2*log(2)))/rounded)];
m = [ 'F_{3} = '  num2str(round(rounded*(output(7)/(output(1)+output(4)+output(7))))/rounded)];
fractnotlowfret = fractnotlowfret+output(7)/(output(1)+output(4)+output(7));
annotation(figure1,'textbox','Position',[0.35 0.25 0.1 0],'String',{g h i m },'FitHeightToText','on','LineStyle','none', 'FontSize',8,'Color','k','VerticalAlignment','baseline','HorizontalAlignment','left');
end



%if fitnumber == 2
%k = ['fraction high = ' num2str(round((output(4)/(output(1)+output(4))*1000))/10) '%'];
%annotation(figure1,'textbox','Position',[0.2 0.1 .2 0],'String',{k l },'FitHeightToText','on','LineStyle','none', 'FontSize',8,'Color','k','VerticalAlignment','baseline','HorizontalAlignment','left');



a = ['A_{1} = ' num2str(round(rounded*output(1))/rounded)];
b = ['\mu_{1} = ' num2str(round(rounded*output(2))/rounded)];
c = [ 'FWHM_{1} = ' num2str(round(rounded*output(3)*2*sqrt(2*log(2)))/rounded)];
m = [ 'F_{1} = '  num2str(round(rounded*(1-fractnotlowfret))/rounded)];

annotation(figure1,'textbox','Position',[0.05 0.25 0.1 0],'String',{a b c m },'FitHeightToText','on','LineStyle','none', 'FontSize',8,'Color','b','VerticalAlignment','baseline','HorizontalAlignment','left');

j = ['time = ' num2str(round(time))];
annotation(figure1,'textbox','Position',[0.05 0.1 0 0],'String',{ j },'FitHeightToText','off','LineStyle','none', 'FontSize',8,'Color','k','VerticalAlignment','baseline');

annotation(figure1,'textbox','FontSize',8,'Position',[0.15 .96 0.9 0.04],'FitHeightToText','on','String',strcat(title, ' Bulk Thermo'),'LineStyle','none');
clipboard('copy',strcat(title, ' Bulk Thermo'))








end

%output=[ output highfrequency highpercentage highpercentagechecker lowfrequencychecker (1-highfrequency-lowfrequencychecker)];





end


