%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize parameters for which to gather data  

   
% signal parameters
% transition matrix, state 1 is red low (FRET low), state 2 is red high
A = [0.99 0.005 0.005;...
    0.005  0.99 0.005;...
    0.01 0.01 0.98];
A = Normalize(A,2); %makes sure all rows add to 1

N = 10000;

%means and standard deviations of red or green channel in state 1 or 2
mr1   = 100;      mg1 = 130;
stdr1 = 15;      stdg1 = 5;
mr2   = 120;     mg2  = 110;
stdr2 = 15;      stdg2 = 5;
mr3   = 140;
stdr3 = 15;
%         mr3   = 110;      mg3 = 125;
%         stdr3 = 5;      stdg3 = 5;
% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([3 1]);
E{1,1} = [mr1; stdr1]; %E{1,2} = [mg1 ; stdg1];
E{2,1} = [mr2; stdr2]; %E{2,2} = [mg2 ; stdg2];
E{3,1} = [mr3; stdr3];      %E{3,2} = E{2,2};

[pi,x] = HMMNoisy3_(A,E,'gauss',N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize fitting parameters
clear params

params.nChannels = 1; %number of channels, red is 1, green is 2
params.nStates = 3;%number of states in model 
params.discStates = [];%[1 2];%[2 1];
params.noHops = [];%[1 3];%[1 3; 3 1];
params.tryPerms = true;

%% set Ainitial = 'auto', Einitial 'auto' or set them to a particular value
params.Ainitial = 'auto'; %could have A = [0.98 0.02 ; 0.01 0.99]
params.Einitial = 'auto'; %could have E = cell([2 2]); E{2,1} = [5 ; 3] means state 2, channel 1 (red) has mean 5, stdev 3, etc

%% specify fit type for each channel, red then green
params.fitChannelType = cell({'gauss'}); %each channel must be 'exp' or 'gauss'

%% specify data
params.data = x; %x is T by num_channels, column 1 is acceptor (red), column 2 is donor (green)
                 %x can have any number of channels, one per column
params.pi = pi; %true hidden state, leave this at 0 when working with real data

%% paramters related to training

params.trainA = true; %set to false if want to never change initial guess for A
params.trainE = true; %set to false if want to never change initial guess for E

params.maxIterEM = 200;      %maximum number of iterations for EM to converge
params.threshEMToConverge = 10^(-6);   %likelihood threshold for EM to converge, don't make lower than this to avoid strange behavior

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

params.paramsErrorToBoundAuto = '';%'(a(1,2),a(2,1))';%'(a(1,2),a(2,1))';%'(a(1,2),a(2,1)),e(1,1,1),e(2,1,1)'; %a's are plotted together on 2-d plot, e's are plotted on 1-d plots
params.paramsErrorToBoundManual = '';%'(a(1,2),a(2,1)),e(1,1,1)';%'(a(2,1),a(1,2))';%,e(1,2,1),(e(1,1,1),a(1,2))';%set to empty for now, but is of same format as paramsErrorToBoundAuto
                                      %could try 'a(1,2),(e(2,1,1),e(2,2,1))';
params.auto_boundsMeshSize = 20;  %how finely do we want to explore param region for confidence bounds
                                 %computation times scales as the square of this number 
                                 %must be at least 3 to later run ShowErrorBounds(output,'auto') 
params.auto_MeshSpacing = 'square'; %can be 'square' for equally spaced rectangles  
                                  %only affects the parameters that are automatically estimated
params.auto_confInt = 0.97;       %within what confidence interval do we want to explore parameters

% the number of entries here must correspond to number of parameters in paramsErrorToBoundManual string
params.ManualBoundRegions = [];
% params.ManualBoundRegions{1} = {linspace(0.001,0.03,20),linspace(0.001,0.04,20)};
% params.ManualBoundRegions{2} = linspace(50,200,100);

%% other parameters
params.plotPFits = false;     %true if want to plot fit as EM computation progresses, false otherwise
params.showProgressBar = false;  
params.pause = false;


%% consistency check for parameters
%     CheckParamsConsistency(params);

%% estimate running itme
%     EstimateRunningTime(params);

%% fit parameters
params.nStates = 1
output1 = TrainPostDec_(params);
params.nStates = 2
output2 = TrainPostDec_(params);
params.nStates = 3
output3 = TrainPostDec_(params);
params.nStates = 4
output4 = TrainPostDec_(params);
params.nStates = 5
output5 = TrainPostDec_(params);

figure

tMax = 1000;
subplot(5,2,[1 2]), hold on
% plot(-x+(mr1+mr2),'k-')
colors = [0 1 0 ; 0 0 1 ; 1 0 0];
for i = 1:3, 
    plot((pi == i).*((mr1+mr3)/2),'ks','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:),'MarkerSize',3);
end
plot(x,'k-')
% plot((pi.*0 == 0)-1,'ws','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]);
ylabel('intensity')
axis([0 tMax min(x(1:tMax)) max(x(1:tMax))])

colors = [1 0 0 ; 0 1 0 ; 0 0 1];
axis([0 tMax min(x(1:tMax)) max(x(1:tMax))]);

% subplot(5,1,2), hold on
% for i = 1:3, 
%     plot((pi == i).*4,'ks','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:),'MarkerSize',3);
% end
% plot((output2.postFit(1,:)>0.5).*3.5,'rs','MarkerSize',3,'MarkerFaceColor','r');
% plot((output2.postFit(2,:)>0.5).*3.5,'gs','MarkerSize',3,'MarkerFaceColor','g');
% 
% plot((output3.postFit(1,:)>0.5).*3,'rs','MarkerSize',3,'MarkerFaceColor','r');
% plot((output3.postFit(2,:)>0.5).*3,'gs','MarkerSize',3,'MarkerFaceColor','g');
% plot((output3.postFit(3,:)>0.5).*3,'bs','MarkerSize',3,'MarkerFaceColor','b');
% 
% plot((output4.postFit(1,:)>0.5).*2.5,'rs','MarkerSize',3,'MarkerFaceColor','r');
% plot((output4.postFit(2,:)>0.5).*2.5,'gs','MarkerSize',3,'MarkerFaceColor','g');
% plot((output4.postFit(3,:)>0.5).*2.5,'bs','MarkerSize',3,'MarkerFaceColor','b');
% plot((output4.postFit(4,:)>0.5).*2.5,'ms','MarkerSize',3,'MarkerFaceColor','m');
% 
% plot((output5.postFit(1,:)>0.5).*2,'rs','MarkerSize',3,'MarkerFaceColor','r');
% plot((output5.postFit(2,:)>0.5).*2,'gs','MarkerSize',3,'MarkerFaceColor','g');
% plot((output5.postFit(3,:)>0.5).*2,'bs','MarkerSize',3,'MarkerFaceColor','b');
% plot((output5.postFit(4,:)>0.5).*2,'ms','MarkerSize',3,'MarkerFaceColor','m');
% plot((output5.postFit(5,:)>0.5).*2,'cs','MarkerSize',3,'MarkerFaceColor','c');
% 
% axis([0 tMax 0 5]);


subplot(6,2,[3 4]), hold on
% for i = 1:3, 
%     plot((pi == i)-1,'k.','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
% end
% plot((pi.*0 == 0)-1,'ws','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]);
plot(output2.postFit(1,:),'r-');
plot(output2.postFit(2,:),'g-');
axis([0 tMax -0.1 1.1]);
legend('P_1','P_2')
ylabel('probability')

subplot(6,2,[5 6]), hold on
% for i = 1:3, 
%     plot((pi == i)-1.1,'k.','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
% end
% plot((pi.*0 == 0)-1,'ws','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]);
plot(output3.postFit(1,:),'r-');
plot(output3.postFit(2,:),'g-');
plot(output3.postFit(3,:),'b-');
axis([0 tMax -0.1 1.1]);
legend('P_1','P_2','P_3')
ylabel('probability')

subplot(6,2,[7 8]), hold on
% for i = 1:3, 
%     plot((pi == i)-1.1,'k.','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
% end
% plot((pi.*0 == 0)-1,'ws','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]);
plot(output4.postFit(1,:),'r-');
plot(output4.postFit(2,:),'g-');
plot(output4.postFit(3,:),'b-');
plot(output4.postFit(4,:),'m-');
axis([0 tMax -0.1 1.1]);
xlabel('time (s)')
legend('P_1','P_2','P_3','P_4')
ylabel('probability')

subplot(6,2,[9 11]), hold on
plot([2 3 4 5],[output2.logPx output3.logPx output4.logPx output5.logPx],'k.-')
xlabel('number of states')
ylabel('log(P(data|model))')

subplot(6,2,[10 12]), hold on
plot([2 3 4 5],[output2.BIC output3.BIC output4.BIC output5.BIC]-output3.BIC,'k.-')
xlabel('number of states')
ylabel('BIC - BIC_{2 state}')

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
