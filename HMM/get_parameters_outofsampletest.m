%% real stuff
clear data;
rawdata =df+1;
rawdata=[1 rawdata];
m1998=10154-1;
m1999=10519-1;
m2000=10884-1;
m2001=11250-1;
m2002=11615-1;
m2003=11980-1;
m2004=12345-1;

data{1}=rawdata(1:m1998);
data{2}=rawdata(1:m1999);
data{3}=rawdata(1:m2000);
data{4}=rawdata(1:m2001);
data{5}=rawdata(1:m2002);
data{6}=rawdata(1:m2003);
data{7}=rawdata(1:m2004);

% 
% %% two states 
%  Gtr2=1/2*ones(2,2);
%  ini_rates2{1}=[1;5];
%  for j=1:1:7
%     [pred_trans{1,j} pred_rate{1,j} pred_liks{1,j} pred_pSt{1,j}] = trainHMM(data{j},Gtr2,ini_rates2{1});
%  end
%  
% save('for_prediction.mat','pred*','data*','ini*','G*');
%  
%  ini_rates2{2}=[0;5];
%  for j=1:1:7
%     [pred_trans{2,j} pred_rate{2,j} pred_liks{2,j} pred_pSt{2,j}] = trainHMM(data{j},Gtr2,ini_rates2{2});
%  end
% save('for_prediction.mat','pred*','data*','ini*','G*');
% Two silent, non-communicating states in a four state model
Gtr4=0.25*ones(4,4);
ini_rates4{3}=[0;0;0.8;1.1];
for j=1:1:7
    [pred_trans{3,j} pred_rate{3,j} pred_liks{3,j} pred_pSt{3,j}] = trainHMM(data{j},Gtr4,ini_rates4{3},'2L2H_heter');
 end

save('for_predictionNEW.mat','pred*','data*','ini*','G*');

% 
% 
% 
% %% save stuff and plotting. 
% 
% 
% save('ergodic_leftright.mat')
% figure;title('log Likelihood vs different number of states')
% lik=[logliks2{1}(end);logliks3{1}(end);logliks4{1}(end)];
% plot(2:4,lik,'LineStyle','none','Marker','s','MarkerSize',6,'MarkerFaceColor','b')
% hold on;
% lik_zerorate=[logliks2{2}(end);logliks3{2}(end);logliks4{2}(end)];
% plot(2:4,lik_zerorate,'LineStyle','none','Marker','o','MarkerSize',6,'MarkerFaceColor','r')
% lik_leftright=[logliks3{3}(end);logliks4{3}(end)];
% plot(3:4,lik_leftright,'LineStyle','none','Marker','^','MarkerSize',6,'MarkerFaceColor','g')
% 
% %% calculate the BICs. 
% 
% n=length(df);
% Lnn=log(n);
% %k is the number of free parameters to be estimated. 
% %6 for ergodic two state, 12 for three state, and 20 for four state
% ke=[6;12;20];
% BICe=-2*lik+ke.*Lnn;
% %for one slient states models
% ks1=[5;11;15];
% BICs1=-2*lik_zerorate+ks1.*Lnn;
% %for two silent states models with non-communicating silent states
% ks2=[8;16];
% BICs2=-2*lik_leftright+ks2.*Lnn;
% 
% figure;
% plot(2:4,BICe,'LineStyle','none','Marker','s','MarkerSize',6,'MarkerFaceColor','b');
% hold on;
% plot(2:4,BICs1,'LineStyle','none','Marker','o','MarkerSize',6,'MarkerFaceColor','r');
% plot(3:4,BICs2,'LineStyle','none','Marker','^','MarkerSize',6,'MarkerFaceColor','g');