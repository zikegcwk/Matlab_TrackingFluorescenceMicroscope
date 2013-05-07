function output = TrainPostDec_(params)
%% load parameters from params struct
%lambdaMat = [lr1 lr2 ; lg1 lg2]
%gaussMat = [mr1 mr2 stdr1 stdr2 ; mg1 mg2 stdg1 stdg2]
nStates = params.nStates;
nChannels = params.nChannels;
discStates = params.discStates;
if isempty(discStates),
    discStates = ones([1 nStates]);
end
noHops = params.noHops;
sameHops = params.sameHops;
tryPerms = params.tryPerms;
fitChannelType = params.fitChannelType;
x = params.data; %x is T by 2, where T is number of data points, column 1 donor, column 2 acceptor
pi = params.pi;  
Ainitial = params.Ainitial;
Einitial = params.Einitial;

maxIterEM = params.maxIterEM;  
threshEMToConverge = params.threshEMToConverge;% * length(x);

confInt = params.auto_confInt;
boundsMeshSize = params.auto_boundsMeshSize;
auto_MeshSpacing = params.auto_MeshSpacing;

trainA = params.trainA;
trainE = params.trainE;

paramsErrorToBoundAuto = params.paramsErrorToBoundAuto;
paramsErrorToBoundManual = params.paramsErrorToBoundManual;
ManualBoundRegions = params.ManualBoundRegions;

SNRwarnthresh = params.SNRwarnthresh;
returnFit = params.returnFit;

%% parameters not loaded form params struct
relaxiter = 5; %max iter up to which relax A matrix added to trained A matrix 

%% initial round of fitting
A = Ainitial;
if strcmp(A,'auto'),
    A = GetAutoAinitial_(nStates,length(x),noHops);
end
E = Einitial;
if strcmp(E,'auto'),
    E = GetAutoEinitial_(x,nStates,nChannels,fitChannelType,discStates);
end
[A,E] = SortStates_(A,E);
[P,F,B,normF,normB,logPx] = Post_(A,E,fitChannelType,x);

cumsumlognormF = cumsum(log(normF));
cumsumlognormB = fliplr(cumsum(log(fliplr(normB))));

% logPxList(1) = logPx; %log(P(x|model))
logPxPrev = logPx; %log(P(x|model))
logPxPermMax = logPx; %store logPx to find maximum over constraints permutations  

if params.plotPFits,
    figure
    PlotPFits_(x,P,logPx,pi); 
    if params.pause,
        pause
    end
end

%% Expectation Maximization of model parameters  

if tryPerms, %try different permutations of discStates
    [discStatesList,noHopsList,sameHopsList] = PermuteConstraints_(discStates,noHops,sameHops);
else
    discStatesList = discStates;
    noHopsList = cell(1,1);
    noHopsList{1} = noHops;
end
bestDiscStates = discStatesList(1,:);
bestNoHops = noHopsList{1};
Aperm = A;
Eperm = E;  
    
everyPermFitCrashed = 1;
timedOutIterationNumber = 0;
for k = 1:size(discStatesList,1),
    try
        discStates = discStatesList(k,:);
        noHops = noHopsList{k};

        if params.showProgressBar,
            h = waitbar(0,'EM optimizing transition rates and signal parameters...');
        end
        done = 0; %done when converged or maxIterEM number of iterations reached
        iter = 1;
        while done == 0,
%             tic
            iter = iter + 1;

            %% reestimate transition rates
            if trainA,
                Ahat = A.*0;
                e = Get_e_(E,fitChannelType,x);
                for i = 1:nStates,
                    for j = 1:nStates,
                        Ahat(i,j) = sum(F(i,1:end-1).*B(j,2:end).*A(i,j).*e(2:end,j)'.*...
                            exp(cumsumlognormF(1:end-1)+cumsumlognormB(2:end)-cumsumlognormF(end)));
                    end
                end
                A = Ahat;
                
                %here add to A rates up to some iteration 
                if iter < relaxiter,
                    A = A + (ones(nStates,nStates)/nStates)./(iter^2);
                end
                
                %renormalize A
                A = A./(sum(A,2)*ones(1,nStates));
            end

            %% enforce some hops same
            if ~isempty(sameHops),
                A = EnforceSameHops_(A,sameHops);
            end
            
            %% enforce some hops forbidden  
            if ~isempty(noHops),
                A = EnforceNoHops_(A,noHops,iter<relaxiter);
            end

            %% reestimate emission parameters

            if trainE,
                Ep = E;
                for i = 1:nStates,
                    for j = 1:nChannels,
                        if strcmp(fitChannelType(j),'exp'),
                            Ep{i,j}(1) = sum(P(i,:).*x(:,j)')./sum(P(i,:));
                        elseif strcmp(fitChannelType(j),'gauss'),
                            Ep{i,j}(1) = sum(P(i,:).*x(:,j)')./sum(P(i,:));
                            Ep{i,j}(2) = sqrt(sum( P(i,:).*((x(:,j)' - Ep{i,j}(1)).^2))/sum(P(i,:)));
                        elseif strcmp(fitChannelType(j),'poisson'),
                            Ep{i,j}(1) = sum(P(i,:).*x(:,j)')./sum(P(i,:));
                        end
                    end
                end
                E = Ep;    

                %% enforce some discrete states have identically distributed emissions        
                if ~isempty(discStates),
                    E = EnforceDiscStates_(E,discStates,P);
                end
            end

            %% sort states by mean of emissions in channel 1, E{1,1}(1)
            [A,E] = SortStates_(A,E);

            %% recompute logPx with new parameters and maybe plot

            [P,F,B,normF,normB,logPx] = Post_(A,E,fitChannelType,x);

            cumsumlognormF = cumsum(log(normF));
            cumsumlognormB = fliplr(cumsum(log(fliplr(normB))));

        %     logPxList(iter) = logPx; %log(P(x|model))

            if params.plotPFits,
        %         PlotPFits_(x,P,exp(logPx - logPxList(iter-1))-1,pi);
                PlotPFits_(x,P,exp(logPx - logPxPrev)-1,pi);
                if params.pause,
                    pause(0.1)
                end
            end

            %% see if should stop iterating because converged
        %     if abs(exp(logPx - logPxList(iter-1)) - 1) < threshEMToConverge,
            if (abs(exp(logPx - logPxPrev) - 1) < threshEMToConverge) && (iter >= relaxiter),
                done = 1;
            else
                logPxPrev = logPx;
            end
            if done == 0 && iter >= maxIterEM && iter >= relaxiter,
                disp(['warning: max iteration number ' num2str(maxIterEM) ' reached before EM convergence']);
                disp(['to ' num2str(threshEMToConverge) ' threshold']);
                done = 1;
            end   
            if params.showProgressBar,
                waitbar(iter/maxIterEM,h,['at most about ' num2str(maxIterEM-iter) ' iterations, ' num2str(round((maxIterEM-iter)*toc)) ' s remaining']);
            end
        end
        everyPermFitCrashed = 0;     
%         logPx
    catch ME
        disp(ME.message)
    end
    % logPxMax = logPxList(end);  %maximum log likelihood of data found
    
    %% see if improved over previous permutation of discStates and noHops
    if logPxPermMax < logPx,
        logPxPermMax = logPx;
        bestDiscStates = discStates;
        bestNoHops = noHops;
        
        Aperm = A;
        Eperm = E;
        
        if iter == maxIterEM,
            timedOutIterationNumber = 1;
        else
            timedOutIterationNumber = 0;
        end        
    end        
    if params.showProgressBar,
        close(h);
    end
    if params.plotPFits,
    %     pause
    %     close;
    end
end
logPxMax = logPxPermMax;  %maximum log likelihood of data found
A = Aperm;
E = Eperm;

%% hill climb to find Ahat  

%% Get PMat
errorBoundsAuto = GetErrorBoundsAuto_(A,E,fitChannelType,x,confInt,boundsMeshSize,auto_MeshSpacing,paramsErrorToBoundAuto);
errorBoundsManual = GetErrorBoundsManual_(A,E,fitChannelType,x,paramsErrorToBoundManual,ManualBoundRegions);

%% Get BIC  

BIC = GetBIC_(logPxMax,length(x),nStates,nChannels,fitChannelType,trainA,trainE,noHops);
SNRMat = GetSNRMat_(E,fitChannelType);

%% return fit  
if returnFit,
    P = Post_(A,E,fitChannelType,x);
else
    P = [];
end

%% check to see which flags to set
flags = [];
if everyPermFitCrashed,
    flags{end+1,1} = 1;
    flags{end  ,2} = 'fit crashed';
end
if timedOutIterationNumber,
    flags{end+1,1} = 2;
    flags{end  ,2} = ['maximum iteration number of ' num2str(maxIterEM) ' reached during fit'];
end
stateIndices = [1 (cumsum(bestDiscStates)+1)]; stateIndices(end) = [];
for i = 1:length(stateIndices)-1,
    for j = i+1:length(stateIndices),
        [stateIndices(i),stateIndices(j)];
        if SNRMat(stateIndices(i),stateIndices(j)) < SNRwarnthresh,
            flags{end+1,1} = 3;
            flags{end  ,2} = ['SNR for states ' num2str(stateIndices(i)) ...
                ' and ' num2str(stateIndices(j)) ' is less than warning threshold of ' num2str(SNRwarnthresh)];
        end
    end
end

%% store outputs
output.A = A;
output.E = E;
output.fitChannelType = params.fitChannelType;
output.errorBoundsAuto = errorBoundsAuto;
output.errorBoundsManual = errorBoundsManual;
output.auto_confInt = params.auto_confInt;
output.logPx = logPxMax;
output.BIC = BIC;
output.SNRMat = SNRMat;
output.discStates = bestDiscStates;
output.noHops = bestNoHops;
outputs.sameHops = [];%bestSameHops;
output.postFit = P;
output.flags = flags;
output.normF = normF;