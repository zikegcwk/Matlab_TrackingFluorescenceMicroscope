% % %% generate state and emission
% % leg=1000;%length of the data
% % low_step=80;low_rate=10; %on average, low state gives 10 counts withean lifetime of 80 steps.
% % high_step=80;high_rate=15;
% % 
% % %calculate transition probabilities given the mean lifetime.
% % P(1,2)=1/low_step;
% % P(1,1)=1-P(1,2);
% % P(2,1)=1/high_step;
% % P(2,2)=1-P(2,1);
% % clear EMIS;
% % 
% %generate the emition matrix.
% for j=1:1:5*high_rate
%     EMIS(1,j)=poisspdf(j,low_rate);
%     EMIS(2,j)=poisspdf(j,high_rate);
% end
% %EMIS(k,l) prob that state k will emit l 
% 
% %generate the actual data that we will work on;
% [seq,states]=hmmgenerate(leg,P,EMIS);
% 
% %plot data as well as the true state. 
% figure(6);clf;subplot(2,1,1);
% plot(seq);
% hold on;
% plot(1:1:leg,low_rate*ones(1,leg),'--k');
% plot(1:1:leg,high_rate*ones(1,leg),'--k');
% xlabel('Days','FontSize',14)
% ylabel('Default/Day','FontSize',14)
% subplot(2,1,2);
% plot(states-1,'r','LineWidth',2);
% xlabel('Days','FontSize',14)
% 
% %% calculate the posterior probability
% [pStates,pSeq, fs, bs, s] = hmmdecode(seq,P,EMIS); %pStates is the posterior prob. 
% figure(6);subplot(2,1,2);hold on;
% plot(pStates(2,:),'k');
% axis([0 leg -0.5 1.5])
% legend('State','Posterior Probability')%plot(fs(2,:),'b');
% %plot(bs(2,:),'g')

%% now let's train our model to describe this data
leg=400;
seq=I1;
%initial guess of the model.
guessTR(1,1)=0.9898;
guessTR(1,2)=1-guessTR(1,1);
guessTR(2,1)=0.0197;
guessTR(2,2)=1-guessTR(2,1);
%initial guess of the rate
guessEl=20;
guessEh=32;

for j=1:1:5*guessEh
    guessE(1,j)=poisspdf(j-1,guessEl);
    guessE(2,j)=poisspdf(j-1,guessEh);
end


%guessE=EMIS;
maxiter=100;
[estTR,estE,logliks] = hmmtrain(seq,guessTR,guessE,'Tolerance',1e-6);

low_rate=18;
high_rate=28;
%plot the guess results. 
figure(7);clf;
subplot(3,1,1);
hold on;
plot(seq);
hold on;
plot(1:1:leg,low_rate*ones(1,leg),'--k');
plot(1:1:leg,high_rate*ones(1,leg),'--k');
xlabel('Days','FontSize',14)
ylabel('Default/Day','FontSize',14)



subplot(3,1,2);
plot(logliks,'LineWidth',2);
xlabel('Number of Iteration in E-M algorithm','FontSize',14)
ylabel('Log of Likelihood','FontSize',14)
title('Learning Curve')
subplot(3,1,3);
[ESTpStates,ESTpSeq, ESTfs, ESTbs, ESTs] = hmmdecode(seq,estTR,estE);
plot(ESTpStates(2,:),'k','LineWidth',3);
axis([0 leg 0 2])
hold on;
plot(states-1,'r','LineWidth',2);
xlabel('time','FontSize',14)
legend('Posterior Probability from Optimized Parameters','State')
guessS=zeros(1,length(seq));
for j=1:1:length(seq)
    if ESTpStates(2,j)<=0.5
        guessS(j)=0;
    else
        guessS(j)=1;
    end
end

plot(guessS,'--g','LineWidth',2)
legend('Posterior Probability from Guessed Parameters','True State','Trained State')






% 
% 
% subplot(3,1,3);
% plot(estE(1,:),'b')
% hold on;
% plot(estE(2,:),'r');
% legend('low state','high state')
% xlabel('Default/Day','FontSize',14)
% ylabel('Default/Day Probability','FontSize',14)

P
estTR
