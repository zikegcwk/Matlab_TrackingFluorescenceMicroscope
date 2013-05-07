%% real stuff
data =df+1;
data=[1 data];

% two states 
Gtr2=1/2*ones(2,2);
emis_rates2{1}=[1;5];
[trans_est2{1} emis_est2{1} logliks2{1} pStates2{1}] = trainHMM(data,Gtr2,emis_rates2{1});
emis_rates2{2}=[0;5];
[trans_est2{2} emis_est2{2} logliks2{2} pStates2{2}] = trainHMM(data,Gtr2,emis_rates2{2});

% Three states
Gtr3=1/3*ones(3,3);
emis_rates3{1}=[1;2;5];
[trans_est3{1} emis_est3{1} logliks3{1}] = trainHMM(data,Gtr3,emis_rates3{1});
emis_rates3{2}=[0;1;5];
[trans_est3{2} emis_est3{2} logliks3{2}] = trainHMM(data,Gtr3,emis_rates3{2});
two silent, non-communicating states.
emis_rates3{3}=[0;0;5];
[trans_est3{3} emis_est3{3} logliks3{3}] = trainHMM(data,Gtr3,emis_rates3{3},'2L1H_heter');
 

%% four states

Gtr4=1/4*ones(4,4);
emis_rates4{1}=[1;2;3;5];
[trans_est4{1} emis_est4{1} logliks4{1}] = trainHMM(data,Gtr4,emis_rates4{1});
emis_rates4{2}=[0;1;3;5];
[trans_est4{2} emis_est4{2} logliks4{2}] = trainHMM(data,Gtr4,emis_rates4{2});

% Two silent, non-communicating states 
emis_rates4{3}=[0;0;1;5];
[trans_est4{3} emis_est4{3} logliks4{3} Pstate4] = trainHMM(data,Gtr4,emis_rates4{3},'2L2H_heter');


%% save stuff and plotting. 
save('ergodic_leftright.mat')
figure;title('log Likelihood vs different number of states')
lik=[logliks2{1}(end);logliks3{1}(end);logliks4{1}(end)];
plot(2:4,lik,'LineStyle','none','Marker','s','MarkerSize',6,'MarkerFaceColor','b')
hold on;
lik_zerorate=[logliks2{2}(end);logliks3{2}(end);logliks4{2}(end)];
plot(2:4,lik_zerorate,'LineStyle','none','Marker','o','MarkerSize',6,'MarkerFaceColor','r')
lik_leftright=[logliks3{3}(end);logliks4{3}(end)];
plot(3:4,lik_leftright,'LineStyle','none','Marker','^','MarkerSize',6,'MarkerFaceColor','g')

%% calculate the BICs. 

n=length(df);
Lnn=log(n);
%k is the number of free parameters to be estimated. 
%6 for ergodic two state, 12 for three state, and 20 for four state
ke=[6;12;20];
BICe=-2*lik+ke.*Lnn;
%for one slient states models
ks1=[5;11;15];
BICs1=-2*lik_zerorate+ks1.*Lnn;
%for two silent states models with non-communicating silent states
ks2=[8;16];
BICs2=-2*lik_leftright+ks2.*Lnn;

figure;
plot(2:4,BICe,'LineStyle','none','Marker','s','MarkerSize',6,'MarkerFaceColor','b');
hold on;
plot(2:4,BICs1,'LineStyle','none','Marker','o','MarkerSize',6,'MarkerFaceColor','r');
plot(3:4,BICs2,'LineStyle','none','Marker','^','MarkerSize',6,'MarkerFaceColor','g');