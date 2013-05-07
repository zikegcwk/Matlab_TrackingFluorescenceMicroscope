%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize parameters for which to gather data  

   
% signal parameters
% transition matrix, state 1 is red low (FRET low), state 2 is red high
A = [0.9 0 0.1 ;...
     0    0.99 0.01;...
     0.1 0.02 0.88];
%  A = [0.99 0.01 ; 0.01 0.99];
    
A = Normalize(A,2); %makes sure all rows add to 1

N = 10000;

%means and standard deviations of red or green channel in state 1 or 2
mrL   = 100;      mgH = 130;
stdrL = 10;      stdgH = 10;
mrH   = 120;     mgL  = 110;
stdrH = 10;      stdgL = 10;

nStates = size(A,1);
nChannels = 2; %red and green

% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([nStates nChannels]);
E{1,1} = [mrL; stdrL]; E{1,2} = [mgH ; stdgH];
E{2,1} = [mrL; stdrL]; E{2,2} = [mgH ; stdgH];
E{3,1} = [mrH; stdrH]; E{3,2} = [mgL ; stdgL];

[pi,x] = HMMNoisy3_(A,E,'gauss',N);
figure
subplot(2,1,1)
plot(x)
subplot(2,1,2)
plot(pi),axis([0 length(pi) 0 nStates+1])
pause
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize fitting parameters
clear params

params.nChannels = 2; %number of channels, red is 1, green is 2
params.nStates = 3;%number of states in model 
params.discStates = [2 1];

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
params.plotPFits = true;     %true if want to plot fit as EM computation progresses, false otherwise
params.showProgressBar = true;  
params.pause = false;


%% consistency check for parameters
%     CheckParamsConsistency(params);

%% estimate running itme
%     EstimateRunningTime(params);

%% fit parameters
output = TrainPostDec_(params);
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
