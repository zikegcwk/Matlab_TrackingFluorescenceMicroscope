function output = sim11B(trans, frame, bin);
%simulates time trace of FRET from a two-state system
%Usage: simulation5(argc, argh, frame, bin)
%start with argc=10, argh=6, frame=5000, bin=4
%trans: a matrix of transitions from state n to state n+i; must be perfect square 
%frame : Number of frames to simulate
%bin is used for sliding average
%Harold & Bernie

% four states rates:
% % %     AA  AB  AC  AD
% % %     BA  BB  BC  BD
% % %     CA  CB  CC  CD
% % %     DA  DB  DC  DD
starttime = cputime;
%LIFETIME of states
a=1./trans;
a(find(a==Inf))=0;
lifetimes = 1./sum(a')
arga = lifetimes(1);
argb = lifetimes(2)
argc = lifetimes(3);
argd = lifetimes(4)
% Transition probabilities
Totaltime = sum(a')
trans = a
Paa = trans(1,1)/Totaltime(1);
Pab = trans(1,2)/Totaltime(1);
Pac = trans(1,3)/Totaltime(1);
Pad = trans(1,4)/Totaltime(1);

Pba = trans(2,1)/Totaltime(2);
Pbb = trans(2,2)/Totaltime(2);
Pbc = trans(2,3)/Totaltime(2);
Pbd = trans(2,4)/Totaltime(2);

Pca = trans(3,1)/Totaltime(3);
Pcb = trans(3,2)/Totaltime(3);
Pcc = trans(3,3)/Totaltime(3);
Pcd = trans(3,4)/Totaltime(3);

Pda = trans(4,1)/Totaltime(4);
Pdb = trans(4,2)/Totaltime(4);
Pdc = trans(4,3)/Totaltime(4);
Pdd = trans(4,4)/Totaltime(4);

fret_bin=-0.8:0.01:1.4;
bgd_noise=10; %default = 20
bga_noise=10; %default = 22

% These numbers are determined from the background fluctuation

ha_noise=5;
hd_noise=5;


ca_noise=5;
cd_noise=5;
%according to measurement in Jan.
%signal noise(besides background noise) from Cy3-DNA was 1.4 times higher than the shot
%noise. So use 1.4^1.4 for these numbers. Considering dyes in the ribosome
%are much noisier, this is the lower limit.
Imax=700;
% this number is important as well. This is about right!
FRETc=0.1;
FRETh=0.8;
% These numbers seem to be the most important. If they are 0.75 and 0.45,
% they should be resolved with no averaging. The fact that they appear to
% be unresolved means they should be closer.
Iac=Imax*FRETc;
Idc=Imax-Iac;

Iah=Imax*FRETh;
Idh=Imax-Iah;
n1=20000; % max 20,000 visits to a state
t.a=round(exprnd(arga,n1,1)); % generates random numbers from an exponential dist. of how long you spend in the  state
t.b=round(exprnd(argb,n1,1));
t.c=round(exprnd(argc,n1,1));
t.d=round(exprnd(argd,n1,1));

% Ia=zeros(1,frame);
% Id=zeros(1,frame);
m=1;
   % start in any state
 state = 'a';
%  loopmarker = 1;
% statelog = zeros(1,n1);
Ia = ones(m,1);
Id = ones(m,1);
i=1;
while m < frame, %n1 is 20,000    
    state;
    timecheck = cputime - starttime;
    if 0.1*timecheck == floor(0.1*timecheck)
        disp(timecheck)
    end
    i=i+1;
    statelog(i) = state;
    loopmarker = 1;    
%     state
    % generate noisy data for time spent in that state
    if i > n1    % until m exceeds frames
        tooomany = 0
        i
        break;
        
    end
    if state == 'a' & loopmarker == 1
    Ia(m:m+t.a(i)-1)=normrnd(Iac,sqrt(ca_noise*Iac+bga_noise^2),1,t.a(i)); % Ia is a random number
    Id(m:m+t.a(i)-1)=normrnd(Idc,sqrt(cd_noise*Idc+bgd_noise^2),1,t.a(i)); % Id is a random number
    m=m+t.a(i); %after spending this time in this state with this noise, you transfer to the next state THIS IS THE DECISION.    % m increases by tc(i)
    % but to which state do I go next?
    wheretonext = rand;    %coin toss ""Monte Carlo""
        if wheretonext < Pab
            state = 'b';
        elseif wheretonext > 1-Pad
            state = 'd';    %%RARE
        else
            state = 'c';
        end
        loopmarker = 0;
    elseif state == 'b' & loopmarker == 1
    Ia(m:m+t.b(i)-1)=normrnd(Iac,sqrt(ca_noise*Iac+bga_noise^2),1,t.b(i)); % Ia is a random number
    Id(m:m+t.b(i)-1)=normrnd(Idc,sqrt(cd_noise*Idc+bgd_noise^2),1,t.b(i)); % Id is a random number
    m=m+t.b(i); %after spending this time in this state with this noise, you transfer to the next state THIS IS THE DECISION.    % m increases by tc(i)
    % but to which state do I go next?
    wheretonext = rand;   %coin toss

        if wheretonext < Pba
            state = 'a';
%     disp('BA')
        elseif wheretonext > 1-Pbc
            state = 'c';        %%RARE
%             disp('RARE')
        else
            state = 'd';
%             disp('BD')
        end
        loopmarker = 0;
    elseif state == 'c' & loopmarker == 1
    Ia(m:m+t.c(i)-1)=normrnd(Iah,sqrt(ca_noise*Iac+bga_noise^2),1,t.c(i)); % Ia is a random number
    Id(m:m+t.c(i)-1)=normrnd(Idh,sqrt(cd_noise*Idc+bgd_noise^2),1,t.c(i)); % Id is a random number
    m=m+t.c(i); %after spending this time in this state with this noise, you transfer to the next state THIS IS THE DECISION.    % m increases by tc(i)
    % but to which state do I go next?
    wheretonext = rand;    %coin toss
        if wheretonext < Pcb
            state = 'b';        %%RARE
        elseif wheretonext > 1-Pcd
            state = 'd';
        else
            state = 'a';
        end
        loopmarker = 0;
    elseif state == 'd' & loopmarker == 1
    Ia(m:m+t.d(i)-1)=normrnd(Iah,sqrt(ca_noise*Iac+bga_noise^2),1,t.d(i)); % Ia is a random number
    Id(m:m+t.d(i)-1)=normrnd(Idh,sqrt(cd_noise*Idc+bgd_noise^2),1,t.d(i)); % Id is a random number
    m=m+t.d(i); %after spending this time in this state with this noise, you transfer to the next state THIS IS THE DECISION.    % m increases by tc(i)
    % but to which state do I go next?
    wheretonext = rand;    %coin toss
        if wheretonext < Pda
            state = 'a';        %%RARE
        elseif wheretonext > 1-Pdc
            state = 'c';
        else
            state = 'b';
        end
        loopmarker = 0;
    else
        disp('No State')
    end
end
i
m
%our exposure time is 10 times higher than the sampling time.
column=floor((m-1));
% Ia_ob=reshape(Ia(1:column*10), 10, column);
% Ia_ob=mean(Ia_ob,1);
% Id_ob=reshape(Id(1:column*10), 10, column);
% Id_ob=mean(Id_ob,1);
% 
Ia_bin=0;
Id_bin=0;
for i=1:bin,
    Ia_bin=Ia_bin+Ia(i:column-bin+i);
    Id_bin=Id_bin+Id(i:column-bin+i);
end
Ia_ob=Ia_bin./bin;
Id_ob=Id_bin./bin;
figure;

fret=Ia_ob./(Ia_ob+Id_ob);
set(0,'DefaultLineLineWidth',1);
axis1=subplot('position',[0.0500    0.7012    0.5    0.2238]);
set(gcf,'position',[100  200   860   500])
plot(1:length(Ia_ob),Ia_ob,'r-',1:length(Id_ob),Id_ob,'g-');
set(axis1, 'ylim', [-50 Imax*1.5]);
grid on;
zoom on;
axis2=subplot('position',[0.0500    0.4056    0.5    0.2238]);
plot(1:length(fret),fret,'m-');
set(axis2, 'ylim', [-0.2 1.2]);
grid on;
zoom on;

axis3=subplot('position',[0.0500    0.1100    0.5    0.2238]);
[hist_data I]=hist(fret,fret_bin);
[fresult,gof,output] = fit(fret_bin',hist_data','Gauss2','Start',[100 FRETh 0.2 100 FRETc 0.2]);
histogram=[I' hist_data'];
save('from_simulation5.dat','histogram','-ascii');

bar(I, hist_data,'w');
shading flat;

peak=inline('a*exp(-((x-b)./c).^2)','a','b','c','x');
x=-0.2:0.01:1.2;
peak1=peak(fresult.a1, fresult.b1, fresult.c1, x);
peak2=peak(fresult.a2, fresult.b2, fresult.c2, x);

line(x, fresult(x),'color','r');
line(x, peak1,'color','b');
line(x, peak2,'color','g');

xlim=get(axis3,'xlim');
ylim=get(axis3,'ylim');
scan_start=min(find(x>=FRETh));
scan_end=min(find(x>=FRETc));

for i=scan_start:scan_end,    
    if (peak1(i)-peak2(i))*(peak1(i+1)-peak2(i+1))<0
        break;
    end
end
% threshold = mean([x(i) x(i+1)]);
threshold = mean([FRETc FRETh]);
line(threshold,ylim(1):100:ylim(2),'color','k');
subplot(axis2);
cut=threshold*ones(1,length(fret));
line(1:length(fret),cut,'color','b');

index_high=find(fret>=threshold);
index_low=find(fret<threshold);

x=diff(index_high);
low_time = x(find(x~=1))-1; % all low dwells
table = tabulatebetter(low_time);
subplot('position',[0.650    0.1100    0.3    0.4]);
% data_low=hist(low_time,1:10*argc);
scatter(table(:,1),1-table(:,4));
% bar(low_time,'w');
%  [doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],table(:,1),table(:,4)); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
 curve_low = fit(table(:,1),1-table(:,4),'exp2','Lower',[0 -2 0 -2], 'Upper', [1 -0.0001 1 -0.00001])
 line(table(1:max(table(:,1)),1), curve_low(1:max(table(:,1))),'color','r');
A={['hybrid state(low FRET) lowtime'];
    ['A1 = ' num2str(curve_low.a)];
    ['t1 = ' num2str(-1/curve_low.b)];
    ['A2 = ' num2str(curve_low.c)];
    ['t2 = ' num2str(-1/curve_low.d)]};
text(60,0.7, A);
 zoom on;

x=diff(index_low);
high_time = x(find(x~=1))-1; %high dwells
subplot('position',[0.650    0.5500    0.3    0.4]);
% data_high=hist(high_time,1:10*argc);
% bar(1:5*argc,data_high(1:5*argc),'w');
% curve_high = fit((1:10*argc)',data_high','exp1','Startpoint',[data_high(1) -1/argc]);
% line(1:5*argc, curve_high(1:5*argc),'color','r');
table = tabulatebetter(high_time);
% data_low=hist(low_time,1:10*argc);
scatter(table(:,1),1-table(:,4));
% bar(low_time,'w');
%  [doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],table(:,1),table(:,4)); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
 curve_high = fit(table(:,1),1-table(:,4),'exp2','Lower',[0 -2 0 -2], 'Upper', [1 -0.0001 1 -0.00001])
 line(table(1:max(table(:,1)),1), curve_high(1:max(table(:,1))),'color','r');
A={['classical state(high FRET) hightime'];
    ['A1 = ' num2str(curve_high.a)];
    ['t1 = ' num2str(-1/curve_high.b)];
['A2 = ' num2str(curve_high.c)];
    ['t2 = ' num2str(-1/curve_high.d)]};
text(.25*max(table(:,1)),0.7, A);
zoom on;

% % % for i=1:length(low_time)-2
% % % refold_low(i) = low_time(i)+ high_time(i);
% % % refold_high(i) = high_time(i) + low_time(i+1);
% % % end
frettrace = [low_time high_time];
%find values < 1 lifetime, or greater than 3 lifetimes as refolding
if arga <= argb
    shortlow = arga;
    longlow = argb;
else
    shortlow = argb;
    longlow = arga;
end
if argc <= argd
    shorthigh = argc;
    longhigh = argd;
else
    shorthigh = argd;
    longhigh = argc;
end
if shortlow < 2
    shortlowindex = find(low_time<=shortlow);
else
    shortlowindex = find(low_time<=0.5*shortlow);
end
longlowindex = find(low_time>=2*longlow);
if shorthigh < 2
    shorthighindex = find(high_time<=shorthigh);
else
    shorthighindex = find(high_time<=0.5*shorthigh);
end
longhighindex = find(high_time>=2*longhigh);
refold_high=[];
refold_low=[];
refold_high_long=[];
refold_low_long =[];
for i=1:max(size(shortlowindex))-1
    refold_high(i) = high_time(shortlowindex(i));
end
if i<2
    refold_high = ones(10,1);
end
for i=1:(max(size(shorthighindex))-2)
    refold_low(i) = low_time(shorthighindex(i)+1);
end
if i<2
    refold_low = ones(10,1);
end

for i=1:max(size(longlowindex))-1
    refold_high_long(i) = high_time(longlowindex(i));
end
if i<2
    refold_high_long = ones(10,1);
end
for i=1:(max(size(longhighindex))-2)
    refold_low_long(i) = low_time(longhighindex(i)+1);
end
if i<2
    refold_hlow_long = ones(10,1);
end



area1 = 100*fresult.a1*fresult.c1/(fresult.a1*fresult.c1+fresult.a2*fresult.c2);
area2 = 100 - area1;
center1 = fresult.b1;
center2 = fresult.b2;
width1 = fresult.c1 * sqrt(2);
width2 = fresult.c2 * sqrt(2);
% use cell array of strings
A={['area1(%) = ' num2str(area1)];
    ['center1 = ' num2str(center1)];
    ['width1 = ' num2str(width1)];
    ['area2(%) = ' num2str(area2)];
    ['center2 = ' num2str(center2)];
    ['width2 = ' num2str(width2)]};
subplot(axis3);
text(-0.5, mean(ylim), A);
zoom on;

disp(fresult);
disp(gof);
output = fret;
output = statelog;

figure 
set(gcf,'position',[50 50 1000 650]);
set(0,'DefaultLineLineWidth',2,'DefaultAxesBox','on');
subplot('position',[0.03    0.5500    0.3    0.4]);
table = tabulatebetter(high_time);
datahigh = table;
myoptions = fitoptions('method', 'NonlinearLeastSquares', 'Algorithm','Trust-Region','Lower',[0 -10000 0 -10000],'Upper',[1 inf 1 inf],'StartPoint', [0.3 -0.5 0.7 -0.01],'MaxFunEvals',1000);
myotheroptions = fitoptions('method', 'NonlinearLeastSquares', 'Algorithm','Trust-Region','Lower',[0 0.0001 0.0001],'Upper',[1 20 20],'StartPoint', [0.3 0.5 0.7],'MaxFunEvals',1000,'TolFun',1e-18, 'MaxIter',1e6,'TolX',1e-18);
mysingoptions = fitoptions('method', 'NonlinearLeastSquares', 'Algorithm','Trust-Region','Lower',[0.001],'Upper',[1000],'StartPoint', [0.5],'MaxFunEvals',10000);
% myoptions = fitoptions
myfit = fittype('1-a.*exp(-b.*x)-(1-a).*exp(-c.*x)');
mysingfit = fittype('1-exp(-a.*x)');
scatter(table(:,1),table(:,4),'sk');
[curve_high, gof1, output1] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output1s] = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
  line(table(1:max(table(:,1)),1), output1.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output1s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
 hightime = curve_high.a/curve_high.b+(1-curve_high.a)/curve_high.c;
A={['unfolding (high time) ' num2str(max(size(high_time)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(round(1/curve_high.b)) ' k~' num2str(0.1*round(10*(40*curve_high.b))) '~ ' '\color{green}\bf' num2str(round(longhigh)) '\color{black}\rm'];
    ['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(round(1/curve_high.c)) ' k~' num2str(0.1*round(10*(40*curve_high.c))) '~ ' '\color{green}\bf' num2str(round(shorthigh)) '\color{black}\bf']};
text(.25*max(table(:,1)),0.3, A);
zoom on;
keep1 = curve_high;
subplot('position',[0.36    0.5500    0.3    0.4]);
table = tabulatebetter(refold_high);
% scatter(table(:,1),table(:,4),'sk');
% scatter(datahigh(:,1),datahigh(:,4),'.g');
plot(datahigh(:,1),datahigh(:,4),'xg',table(:,1),table(:,4),'sk','Linewidth',1);
if size(table)>3
[curve_high, gof1, output2] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output2s]= fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
  line(table(1:max(table(:,1)),1), output2.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output2s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
A={['Refolding  (refold high) ' num2str(max(size(refold_high)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(0.1*(round(10/curve_high.b)))];
    ['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(0.1*(round(10/curve_high.c)))]};
text(.25*max(table(:,1)),0.3, A);
end
zoom on;
subplot('position',[0.69    0.5500    0.3    0.4]);
table = tabulatebetter(refold_high_long);
plot(datahigh(:,1),datahigh(:,4),'xg',table(:,1),table(:,4),'sk','Linewidth',1);
if size(table)>3
[curve_high, gof1, output3] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output3s] = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
  line(table(1:max(table(:,1)),1), output3.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output3s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
A={['refolding (refold high long) ' num2str(max(size(refold_high_long)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(0.1*(round(10/curve_high.b)))];
    ['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(0.1*(round(10/curve_high.c)))]};
text(.25*max(table(:,1)),0.3, A);
end
zoom on;
subplot('position',[0.03    0.100    0.3    0.4]);
table = tabulatebetter(low_time);
datalow = table;
scatter(table(:,1),table(:,4),'sk');
if size(table)>3
[curve_high, gof1, output4] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output4s] = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
  line(table(1:max(table(:,1)),1), output4.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output4s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
  lowtime = curve_high.a/curve_high.b+(1-curve_high.a)/curve_high.c;
 A={['Folding (low time) ' num2str(max(size(low_time)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(round(1/curve_high.b)) ' ' ' k~' num2str(0.1*round(10*(40*curve_high.b))) '~ ' '\color{green}\bf' num2str(longlow) '\color{black}\rm'];;
    ['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(round(1/curve_high.c)) ' ' ' k~' num2str(0.1*round(10*(40*curve_high.c))) '~ ' '\color{green}\bf' num2str(round(shortlow)) '\color{black}\bf']};
text(.25*max(table(:,1)),0.3, A);
end
zoom on;

subplot('position',[0.36    0.100    0.3    0.4]);
table = tabulatebetter(refold_low);
plot(datalow(:,1),datalow(:,4),'xg',table(:,1),table(:,4),'sk','Linewidth',1);
if size(table)>3
[curve_high, gof1, output5] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output5s] = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
 line(table(1:max(table(:,1)),1), output5.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output5s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
A={['Refolding (refold low) ' num2str(max(size(refold_low)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(0.1*(round(10/curve_high.b)))];
['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(0.1*(round(10/curve_high.c)))]};
text(.25*max(table(:,1)),0.3, A);
end
zoom on;
subplot('position',[0.69    0.100    0.3    0.4]);
table = tabulatebetter(refold_low_long);
plot(datalow(:,1),datalow(:,4),'xg',table(:,1),table(:,4),'sk','Linewidth',1);
if size(table)>3
[curve_high, gof1, output6] = fit(table(:,1),table(:,4),myfit, myotheroptions)
[curve_sing, gof1, output6s] = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
 line(table(1:max(table(:,1)),1), curve_high(0:max(table(:,1))-1),'color','b');
 line(table(1:max(table(:,1)),1), curve_sing(0:max(table(:,1))-1),'color','r'); 
  line(table(1:max(table(:,1)),1), output6.residuals(1:max(table(:,1))),'color','c','LineWidth',2,'LineStyle','none','Marker','.','MarkerSize', 4); 
  line(table(1:max(table(:,1)),1), output6s.residuals(1:max(table(:,1))),'color','m','LineWidth',2,'LineStyle',':'); 
 hold on
%  table = tabulatebetter(t.b)
%  scatter(table(:,1),table(:,4),'om');
%  curve_sing2 = fit(table(:,1),table(:,4),mysingfit, mysingoptions)
%   line(table(1:max(table(:,1)),1), curve_sing2(0:max(table(:,1))-1),'color','m'); 
A={['Refolding (refold low long) ' num2str(max(size(refold_low_long)))];
    ['A1 = ' num2str(0.01*round(100*curve_high.a))];
    ['t1 = ' num2str(0.1*(round(10/curve_high.b)))];
['A2 = ' num2str(1-0.01*round(100*curve_high.a))];
    ['t2 = ' num2str(0.1*(round(10/curve_high.c)))]};
text(.25*max(table(:,1)),0.3, A);
end
zoom on;

%%Find the maximum x-axis length, and make all graphs the same size
longestdwellhigh = max([high_time refold_high_long refold_high]);
longestdwelllow = max([refold_low low_time refold_low_long]);
myax = get(gcf,'children');
for i=length(myax)-5:length(myax)-2
    set(myax(i),'Xlim',[0 longestdwelllow]);
    set(myax(i),'Ylim',[-0.2 1]);
end
for i=length(myax)-2:length(myax)
    set(myax(i),'Xlim',[0 longestdwellhigh]);
    set(myax(i),'Ylim',[-0.2 1]);
end
mystring = 1./trans;
mystring(find(mystring==Inf))=0;

% mystring = mystring'
% make into 4 columns right aligned
annot1 = text(0.4*longestdwelllow, 0, num2str(mystring), 'FontName', 'FixedWidth', 'FontWeight', 'bold','EdgeColor','black'); %, 'FitHeightToText', 'on', 'HorizontalAlignment', 'right', 'Margin',0.1, 'BackgroundColor', 'white' );
% annot2 = text(0.55, 0.65, num2str(mystring(:,1)));
% annot3 = text(0.55, 0.65, num2str(mystring(:,1)));
% annot4 = text(0.55, 0.65, num2str(mystring(:,1)));
% % TOO MUCH Memory
% % annot1 = annotation('textbox',[0.55 0.65 0.01 0.1],'string', num2str(mystring(:,1)), 'FitHeightToText', 'on', 'HorizontalAlignment', 'right', 'Margin',0.1, 'BackgroundColor', 'white' );
% % dd = get(annot1,'Position');
% % cc = (dd(1) + dd(3));
% % annot2 = annotation('textbox',[cc 0.65 0.01 0.1],'string', num2str(mystring(:,2)), 'FitHeightToText', 'on', 'HorizontalAlignment', 'right', 'Margin',0.1, 'BackgroundColor', 'white');
% % dd = get(annot2,'Position');
% % cc = (dd(1) + dd(3));
% % annot3 = annotation('textbox',[cc 0.65 0.01 0.1],'string', num2str(mystring(:,3)), 'FitHeightToText', 'on', 'HorizontalAlignment', 'right', 'Margin',0.1, 'BackgroundColor', 'white');
% % dd = get(annot3,'Position');
% % cc = (dd(1) + dd(3));
% % annot4 = annotation('textbox',[cc 0.65 0.01 0.1],'string', num2str(mystring(:,4)), 'FitHeightToText', 'on', 'HorizontalAlignment', 'right', 'Margin',0.1, 'BackgroundColor', 'white');
sum(high_time)/(sum(low_time)+sum(high_time))
hightime/(hightime+lowtime)
query = [output1.exitflag output2.exitflag output3.exitflag output4.exitflag output5.exitflag output6.exitflag]
h= gcf;
s = ['print' ' -f' num2str(h) ' -dmeta'];
eval(s);
endtime = cputime;
% output = keep1;
timeelapsed = endtime-starttime
