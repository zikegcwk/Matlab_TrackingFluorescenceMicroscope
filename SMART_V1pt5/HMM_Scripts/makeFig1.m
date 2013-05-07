%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize parameters for which to gather data  

   
% signal parameters
% transition matrix, state 1 is red low (FRET low), state 2 is red high
% A = [0.95 0.05 ; 0.1 0.9];
A = [0.95 0.05 ; 0.075 0.925];

N = 2000;

%means and standard deviations of red or green channel in state 1 or 2
mr1   = 1000;      mg1 = 1700;
stdr1 = 300;      stdg1 = 500;
mr2   = 1700;     mg2  = 1000;
stdr2 = 500;      stdg2 = 300;
%         mr3   = 110;      mg3 = 125;
%         stdr3 = 5;      stdg3 = 5;
% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([2 2]);
E{1,1} = [mr1; stdr1]; E{1,2} = [mg1 ; stdg1];
E{2,1} = [mr2; stdr2]; E{2,2} = [mg2 ; stdg2];

% E = cell([2 1]);
% E{1,1} = [mr1; stdr1]; 
% E{2,1} = [mr2; stdr2];
%         E{3,1} = [mr3; stdr3]; E{3,2} = [mg3 ; stdg3];

[pi,x] = HMMNoisy3_(A,E,'gauss',N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize fitting parameters
clear params

params.nChannels = 2; %number of channels, red is 1, green is 2
params.nStates = 2;%number of states in model 
params.discStates = [];
params.noHops = [];
params.tryPerms = true;

%% set Ainitial = 'auto', Einitial 'auto' or set them to a particular value
params.Ainitial = 'auto'; %could have A = [0.98 0.02 ; 0.01 0.99]
params.Einitial = 'auto'; %could have E = cell([2 2]); E{2,1} = [5 ; 3] means state 2, channel 1 (red) has mean 5, stdev 3, etc

%% specify fit type for each channel, red then green
params.fitChannelType = cell({'gauss','gauss'}); %each channel must be 'exp' or 'gauss'

%% specify data
params.data = x; %x is T by num_channels, column 1 is acceptor (red), column 2 is donor (green)
                 %x can have any number of channels, one per column
params.pi = pi; %true hidden state, leave this at 0 when working with real data

%% paramters related to training

params.trainA = true; %set to false if want to never change initial guess for A
params.trainE = true; %set to false if want to never change initial guess for E

params.maxIterEM = 200;      %maximum number of iterations for EM to converge
params.threshEMToConverge = 10^(-4);   %likelihood threshold for EM to converge, don't make lower than this to avoid strange behavior

params.SNRwarnthresh = 1; %warns if 2 states have SNR less than this
params.returnFit = true;

%% parameters related to parameter error bounds estimation

%these strings are in the format
%(a(i1,i2),a(i3,i4)),e(i5,i6,i7),(e(i8,i9,i10),a(i11,i12)),a(i13,ai14), ...
%letters that are grouped like (p(),q()) are given bounds jointly on a 2D plot
%letters that are grouped like ...,p(),... are given bound on a 1D plot
%e(n,c,p) = value of parameter #p of channel c (1 is red, 2 is green) in
%hidden state n (2 is high, 1 is low)
%p = 1 corresponds to mean, p = 2 corresponds to stdev
%a(r,c) = value of transition rate from hidden state r to hidden state c

params.paramsErrorToBoundAuto = '(a(1,2),a(2,1))';%'(a(1,2),a(2,1))';%'(a(1,2),a(2,1))';%'(a(1,2),a(2,1)),e(1,1,1),e(2,1,1)'; %a's are plotted together on 2-d plot, e's are plotted on 1-d plots
params.paramsErrorToBoundManual = '';%'e(1,1,1)';%'(a(2,1),a(1,2))';%,e(1,2,1),(e(1,1,1),a(1,2))';%set to empty for now, but is of same format as paramsErrorToBoundAuto
                                      %could try 'a(1,2),(e(2,1,1),e(2,2,1))';
params.auto_boundsMeshSize = 20;  %how finely do we want to explore param region for confidence bounds
                                 %computation times scales as the square of this number 
                                 %must be at least 3 to later run ShowErrorBounds(output,'auto') 
params.auto_MeshSpacing = 'square'; %can be 'square' for equally spaced rectangles  
                                  %only affects the parameters that are automatically estimated
params.auto_confInt = 0.99;       %within what confidence interval do we want to explore parameters

% the number of entries here must correspond to number of parameters in paramsErrorToBoundManual string
params.ManualBoundRegions = [];
% params.ManualBoundRegions{1} = {linspace(0.001,0.03,20),linspace(0.001,0.04,20)};
params.ManualBoundRegions{1} = linspace(50,200,100);
%         params.ManualBoundRegions{1} = {dataGatherParams{i}.regionnu21,dataGatherParams{i}.regionnu12};
%params.ManualBoundRegions{2} = linspace(0.5,20,8);
%params.ManualBoundRegions{3} = {linspace(0,10,5),(0:0.1:1)};
% params.ManualBoundRegions{1} = [0.001 0.002 0.004 0.008 0.01 0.0105 0.02 0.03 0.04];
%params.ManualBoundRegions{1} = {(0:20),(0:20)};

%% other parameters
params.plotPFits = true;     %true if want to plot fit as EM computation progresses, false otherwise
params.showProgressBar = false;  
params.pause = false;


%% consistency check for parameters
%     CheckParamsConsistency(params);

%% estimate running itme
%     EstimateRunningTime(params);

%% fit parameters
output = TrainPostDec_(params);

%% make plot 
figure

tMax = 400;
subplot(4,4,[1 2 3 4])
hold on
plot(x(:,1),'r-')
plot(x(:,2),'g-')
set(gca,'xtick',[]);
ylabel('intensity')
axis([0 tMax min(min(x(1:tMax,:))) max(max(x(1:tMax,:)))])

subplot(4,4,[5 6 7 8]), hold on
plot(pi-1,'k.','Color',[1 1 1].*0.8,'LineWidth',3,'MarkerSize',5);
plot(output.postFit(2,:),'k-');
axis([0 length(output.postFit) -0.1 1.1]);
set(gca,'ytick',[0 0.5 1]);
xlabel('time (ms)');
ylabel('probability')
axis([0 tMax -0.1 1.1]);

binsr = linspace(min(mr1,mr2)-3*max(stdr1,stdr2),max(mr1,mr2)+3*max(stdr1,stdr2),100)';
binsg = linspace(min(mg1,mg2)-3*max(stdg1,stdg2),max(mg1,mg2)+3*max(stdg1,stdg2),100)';

subplot(4,4,[9 10]), hold on
n = hist(x(:,1),binsr);
hist(x(:,1),binsr);
h = findobj(gca,'Type','patch');
set(h,'EdgeColor','r');
set(h,'FaceColor','r');

y1 = length(x).*(binsr(2)-binsr(1)).*pdf('norm',binsr,output.E{1,1}(1),output.E{1,1}(2)).*(output.A(2,1)/(output.A(1,2)+output.A(2,1)));
y2 = length(x).*(binsr(2)-binsr(1)).*pdf('norm',binsr,output.E{2,1}(1),output.E{2,1}(2)).*(output.A(1,2)/(output.A(1,2)+output.A(2,1)));

plot(binsr,y1,'k-','LineWidth',2);
plot(binsr,y2,'k--','LineWidth',2);
% plot(binsr,y1+y2,'k:','Color',[1 1 1].*0);

axis([max(binsr(1),0) binsr(end) 0 max(n)*1.2]);
xlabel('acceptor intensity')
ylabel('counts')

subplot(4,4,[13 14]), hold on
n = hist(x(:,2),binsg);
hist(x(:,2),binsg);
h = findobj(gca,'Type','patch');
set(h,'EdgeColor','g');
set(h,'FaceColor','g');

y1 = length(x).*(binsr(2)-binsr(1)).*pdf('norm',binsg,output.E{1,2}(1),output.E{1,2}(2)).*(output.A(2,1)/(output.A(1,2)+output.A(2,1)));
y2 = length(x).*(binsr(2)-binsr(1)).*pdf('norm',binsg,output.E{2,2}(1),output.E{2,2}(2)).*(output.A(1,2)/(output.A(1,2)+output.A(2,1)));

plot(binsr,y1,'k-','LineWidth',2);
plot(binsr,y2,'k--','LineWidth',2);
% plot(binsr,y1+y2,'k:','Color',[1 1 1].*0);

axis([max(binsg(1),0) binsg(end) 0 max(n)*1.2]);
xlabel('donor intensity')
ylabel('counts')

subplot(4,4,[11 12 15 16]), hold on
v1 = output.errorBoundsAuto(1).var1region;
v2 = output.errorBoundsAuto(1).var2region;
PMat = output.errorBoundsAuto(1).PMat;

    var1plot = [0 ; (v1+[diff(v1)./2 ; 0])];
    var1plot(1) = max(2*v1(1)-var1plot(2),0);
    var1plot(end) = min(2*v1(end)-var1plot(end-1),1);
    
    var2plot = [0 ; (v2+[diff(v2)./2 ; 0])];
    var2plot(1) = max(2*v2(1)-var2plot(2),0);
    var2plot(end) = min(2*v2(end)-var2plot(end-1),1);
    
    PtoPlot = zeros(size(PMat)+1); PtoPlot(1:end-1,1:end-1) = PMat;
        
pcolor(var2plot,var1plot,PtoPlot); shading flat
set(gca,'ydir','default');
[C,h] = contour(v2,v1,PMat,(1-params.auto_confInt),'Color',[1 0 0]);
set(gca,'Color',[0 0 0.5625]);
axis([0 output.A(2,1).*1.5 0 output.A(1,2).*1.5])
plot(output.A(2,1),output.A(1,2),'wx');
plot(A(2,1),A(1,2),'mx');
xlabel('k_{12} (kHz)')
ylabel('k_{21} (kHz)')
% set(gca,'xtick',0:0
% set(gca,'ytick',linspace(0,output.A(1,2).*1.5,5)');
title('data likelihood vs. k_{12} and k_{21}')
colorbar('Location','EastOutside')


%dye and acceptor inferred histograms

% params2 = params;
% params2.data = params.data(:,2)./(params.data(:,1)+params.data(:,2));
% params2.nChannels = 1;
% params2.fitChannelType = {'gauss'};
% output2 = TrainPostDec_(params2);

% try
%     output = TrainPostDec_(params);
% catch ErrorMessage
%     disp(['error: ' ErrorMessage.message]);
% end

%% compare BIC to model with one more and one fewer state
% CompareBICOneLessOrMoreStates(params,output);

%% show inferred model  
%     ShowHMM(output.A,output.E,output.fitChannelType,1);
% ShowHMM(output.A,output.E,output.fitChannelTypes,0);

%% plot parameters
%     if numel(whos('ErrorMessage')) == 0, % if no error occurred  
%         ShowErrorBounds(output,'auto');
%         ShowErrorBounds(output,'manual');
%         pause
%         close all
%     end
