function [estTR estE logliks pStates] = trainHMM(data,TR, E_rates,model_type)
%% prepare to estimate
if nargin==3
    model_type='ergodic';
end

color = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'w'];

len = size(data,2);
num_states = size(TR,1);

%notice here that E(i,j) is the emmission probability in state i, but emit
%j-1 counts. This is to take care of the zero emmissions. 
for i=1:num_states
    for j=1:1:max(data)*5
        E(i,j) = poisspdf(j, E_rates(i));
    end
end


%% filtering and estimation
if strcmp(model_type,'ergodic')
    [estTR, estE, logliks] = hmmtrain(data, TR, E);
elseif strcmp(model_type,'2L1H_heter')
     [estTR, estE, logliks] = hmmtrain_2L1H(data, TR, E);
elseif strcmp(model_type,'2L2H_heter')
     [estTR, estE, logliks] = hmmtrain_2L1H(data, TR, E);
elseif strcmp(model_type,'step')
     [estTR, estE, logliks] = hmmSTEPtrain(data, TR, E);
else
    error('model_type can only be 2L1H_heter or 2L2H_heter');
end

[pStates, LogpSeq] = hmmdecode(data, estTR, estE); %pStates is the posterior prob
%LogpSeq=logliks(end) that is what we expect from theory understanding.

% % %% plotting 
t=1:1:length(data);
figure(1997);
clf;
subplot(2,2,1);
plot(t/100,data*0.1);
xlabel('Time[S]','FontSize',14)
ylabel('Count Rate[kHz]','FontSize',14)


subplot(2,2,2);
for j=1:num_states
    plot((1:1:length(estE(j,:)))/10,estE(j,:), color(j),'LineStyle','none','Marker','*')
    hold on;
    my_L{j}=sprintf('state %g',j);
end
    xlabel('Time[S]', 'FontSize',14)
    ylabel('Emmision Rate Probability', 'FontSize',14)
    legend(my_L)
 
subplot(2,2,3);
for j=1:1:num_states
    plot(t/100,pStates(j,:)+j,color(j));
    hold on;
end
legend(my_L)
xlabel('Time[S]','FontSize',14)
ylabel('Posterior Probability','FontSize',14)



subplot(2,2,4);
plot(logliks);
title('Learning Curve','FontSize',14)
xlabel('Number of Iteration in E-M algorithm', 'FontSize', 14)
ylabel('log of likelihood','FontSize', 14)

