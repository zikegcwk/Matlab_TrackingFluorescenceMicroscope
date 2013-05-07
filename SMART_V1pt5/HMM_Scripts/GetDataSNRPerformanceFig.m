%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize parameters for which to gather data  
t_init = datestr(now);
% signal parameters
% transition matrix, state 1 is red low (FRET low), state 2 is red high
a12 = 0.1;
a21 = 0.1;
A = [(1-a12) a12 ; a21 (1-a21)];

nRecompute = 20;
SNRMin = 0.1;
SNRMax = 50;
SNRList = logspace(log10(SNRMin),log10(SNRMax),nRecompute)';
NJumpsList = 2*SNRMax./SNRList;
TMax = round(NJumpsList(1)  *0.5*(a12+a21)/(a12*a21));
TMin = round(NJumpsList(end)*0.5*(a12+a21)/(a12*a21));
TList = round(logspace(log10(TMin),log10(TMax),nRecompute)');
TList = flipud(TList);

numTimePointsPerSNR = 100000;
numTrialsPoints = round(numTimePointsPerSNR./TList);

% pause
mr1   = 100;
mr2   = 150;
%         mr3   = 110;      mg3 = 125;
%         stdr3 = 5;      stdg3 = 5;
% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([2 1]);
E{1,1} = mr1;
E{2,1} = mr2;
%         E{3,1} = [mr3; stdr3]; E{3,2} = [mg3 ; stdg3];
fitChannelType = cell({'poisson'});

confInt = 0.9;

%add noise to x for given SNR
%get values of mean for given value of SNR
mu1 = 100;
s1 = sqrt(mu1);
mu2List = SNRList.*0;
for i = 1:length(SNRList),
    SNR = SNRList(i);
    f = @(mu2) 0.5*((mu2-mu1)/sqrt(mu2) + (mu2-mu1)/sqrt(mu1)) - SNR;
    mu2List(i) = fzero(f,mu1*(1+SNR));
end

%% initialize fitting parameters
clear params

params.nChannels = 1; %number of channels, red is 1, green is 2
params.nStates = 2;%number of states in model 
params.discStates = [];
params.noHops = [];
params.sameHops = [];
params.tryPerms = false;

%% set Ainitial = 'auto', Einitial 'auto' or set them to a particular value
params.Ainitial = 'auto'; %could have A = [0.98 0.02 ; 0.01 0.99]
params.Einitial = 'auto'; %could have E = cell([2 2]); E{2,1} = [5 ; 3] means state 2, channel 1 (red) has mean 5, stdev 3, etc

%% specify fit type for each channel, red then green
params.fitChannelType = cell({'poisson'}); %each channel must be 'exp' or 'gauss'

%% specify data
params.data = []; %x is T by num_channels, column 1 is acceptor (red), column 2 is donor (green)
                 %x can have any number of channels, one per column
params.pi = 0; %true hidden state, leave this at 0 when working with real data

%% paramters related to training

params.trainA = true; %set to false if want to never change initial guess for A
params.trainE = true; %set to false if want to never change initial guess for E

params.maxIterEM = 200;      %maximum number of iterations for EM to converge
params.threshEMToConverge = 10^(-4);   %likelihood threshold for EM to converge, don't make lower than this to avoid strange behavior

params.SNRwarnthresh = 1; %warns if 2 states have SNR less than this
params.returnFit = false;

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
params.paramsErrorToBoundManual = '';%'e(1,1,1)';%'(a(2,1),a(1,2))';%,e(1,2,1),(e(1,1,1),a(1,2))';%set to empty for now, but is of same format as paramsErrorToBoundAuto
                                      %could try 'a(1,2),(e(2,1,1),e(2,2,1))';
params.auto_boundsMeshSize = 20;  %how finely do we want to explore param region for confidence bounds
                                 %computation times scales as the square of this number 
                                 %must be at least 3 to later run ShowErrorBounds(output,'auto') 
params.auto_MeshSpacing = 'square'; %can be 'square' for equally spaced rectangles  
                                  %only affects the parameters that are automatically estimated
params.auto_confInt = 0.9;       %within what confidence interval do we want to explore parameters

% the number of entries here must correspond to number of parameters in paramsErrorToBoundManual string
params.ManualBoundRegions = [];
% params.ManualBoundRegions{1} = {linspace(0.001,0.03,20),linspace(0.001,0.04,20)};
% params.ManualBoundRegions{1} = linspace(50,200,100);
%         params.ManualBoundRegions{1} = {dataGatherParams{i}.regionnu21,dataGatherParams{i}.regionnu12};
%params.ManualBoundRegions{2} = linspace(0.5,20,8);
%params.ManualBoundRegions{3} = {linspace(0,10,5),(0:0.1:1)};
% params.ManualBoundRegions{1} = [0.001 0.002 0.004 0.008 0.01 0.0105 0.02 0.03 0.04];
%params.ManualBoundRegions{1} = {(0:20),(0:20)};

%% other parameters
params.plotPFits = false;     %true if want to plot fit as EM computation progresses, false otherwise
params.showProgressBar = false;  
params.pause = false;


%% consistency check for parameters
%     CheckParamsConsistency(params);

%% estimate running itme
%     EstimateRunningTime(params);
[NJumpsList SNRList]
TList
%% fit parameters
% pause
clear outputs
outputsHMM = cell([length(SNRList) 1]);
outputsThreshNoisy = cell([length(SNRList) 1]);
outputsThreshNoiseless = cell([length(SNRList) 1]);
for i = 1:length(SNRList),
    outputsHMM{i} = zeros(numTrialsPoints(i),1);
    outputsThreshNoisy{i} = zeros(numTrialsPoints(i),1);
    outputsThreshNoiseless{i} = zeros(numTrialsPoints(i),1);
end
h = waitbar(0,'computing');
totalT = numTrialsPoints'*TList;
Tsofar = 0;
tic
for i = 1:length(SNRList),
    E{1,1} = mu1;
    E{2,1} = mu2List(i);
    for j = 1:numTrialsPoints(i),
        [i j numTrialsPoints(i) SNRList(i)]
        done = 0;
        while ~done,
            [pi,x] = HMMNoisy3_(A,E,'poisson',TList(i));
            if sum(abs(diff(pi))) >= 2, %force each trace to have at jumps from 1 to 2 and 2 to 1
                done = 1;
            end
        end            
        params.data = x;
        try
            params.nStates = 2;
            output2 = TrainPostDec_(params);
            BIC2 = output2.BIC;
            BIC2smaller = 1;
            try 
                params.nStates = 1;
                output1 = TrainPostDec_(params);
                if output1.BIC <= BIC2,
                    BIC2smaller = 0;
                end
            catch
            end
            if BIC2smaller == 1,
                outputsHMM{i}(j) = mean(diag(flipud(output2.A)));
            else
                outputsHMM{i}(j) = -mean(diag(flipud(output2.A))); %1-state model has lower BIC than 2-state model
            end
        catch
            outputsHMM{i}(j) = -1; %fit crashed
            disp([i j])
        end
        xthresh = (x >= ((mu1 + mu2List(i))/2));
        
        if size(GetAfrompi(xthresh),1) > 1,        
            outputsThreshNoisy{i}(j) = mean(diag(flipud(GetAfrompi(xthresh))));
        else
            outputsThreshNoisy{i}(j) = -1;
        end
        if size(GetAfrompi(pi),1) > 1,
            outputsThreshNoiseless{i}(j) = mean(diag(flipud(GetAfrompi(pi))));
        else
            outputsThreshNoiseless{i}(j) = -1;
        end
        
        Tsofar = Tsofar + TList(i);
        if (i < 10) || ((i >= 10) && (mod(j,100) == 0)),
            t_elapsed = round(toc);
            t_rem = round((totalT/Tsofar - 1)*t_elapsed);
            waitbar(Tsofar/totalT,h,{[num2str(floor(t_elapsed/60)) 'min, ' num2str(mod(t_elapsed,60)) ' s elapsed'],...
                                     ['approx ' num2str(floor(t_rem/60)) 'min, ' num2str(mod(t_rem,60)) ' s remaining']});
        end
    end
end
close(h)
% disp('getting rates...')
% %extract rates from data
% 
% outputsHMM = cell([length(SNRList) 1]);
% outputsThreshNoisy = cell([length(SNRList) 1]);
% outputsThreshNoiseless = cell([length(SNRList) 1]);
% for i = 1:length(SNRList),
%     outputsHMM{i} = zeros(numTrialsPoints(i),1);
%     outputsThreshNoisy{i} = zeros(numTrialsPoints(i),1);
%     outputsThreshNoiseless{i} = zeros(numTrialsPoints(i),1);
% end
% ratesHMM = zeros(length(SNRList),numTrialsPerSNRPoint);
% ratesThreshNoisy = ratesHMM;
% ratesThreshNoiseless = ratesHMM;
% 
% for i = 1:length(SNRList),
%     for j = 1:numTrialsPerSNRPoint(i),
%         ratesHMM(i,j) = mean(diag(flipud(outputsHMM{i,j})));
%         ratesThreshNoisy(i,j) = mean(diag(flipud(outputsThreshNoisy{i,j})));
%         ratesThreshNoiseless(i,j) = mean(diag(flipud(outputsThreshNoiseless{i,j})));
%     end
% end

save SNRPerformanceFigData.mat


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