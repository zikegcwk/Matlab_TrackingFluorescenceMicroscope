clear testdata;
clear estseq;
clear eststate;
clear ks;
clear dfN2 dfN2s dfN4
 load ergodic_leftright.mat
 load for_prediction.mat
clf;
rawdata =df+1;
rawdata=[1 rawdata];
m{1}=10154-1;
m{2}=10519-1;
m{3}=10884-1;
m{4}=11250-1;
m{5}=11615-1;
m{6}=11980-1;
m{7}=11345-1;
len = length(rawdata);

leg=360;
for k=1:1:50000
    for j=1:7
        temp1 = find(pred_pSt{1,j}(:,m{j}) == max(pred_pSt{1,j}(:,m{j}))); %starting state
        temp2 = find(pred_pSt{2,j}(:,m{j}) == max(pred_pSt{2,j}(:,m{j})));
        temp3 = find(pred_pSt{3,j}(:,m{j}) == max(pred_pSt{3,j}(:,m{j})));

         %[OSTseq{1,j} OSTstate{1,j}] = hmmgenerate_edit(leg,pred_trans{1,j}, pred_rate{1,j}, temp1); %two states
         %[OSTseq{2,j} OSTstate{2,j}] = hmmgenerate_edit(leg,pred_trans{2,j}, pred_rate{2,j},temp2); %two states, with different predicted output
         [OSTseq{3,j} OSTstate{3,j}] = hmmgenerate_edit(leg,pred_trans{3,j}, pred_rate{3,j},temp3); %four state model, with two silent non-communicating states

        dfN2(j,k)=sum(OSTseq{1,j}-1);
        dfN2s(j,k)=sum(OSTseq{2,j}-1);
        dfN4(j,k)=sum(OSTseq{3,j}-1);
   
    end
end


bin=0:5:250;
for j=1:1:7
    hist_df{1,j}=hist(dfN2(j,:),bin);
%     figure(100);hold all;
%     plot(bin,hist_df{1,j},'LineWidth',2);
    
    hist_df{2,j}=hist(dfN2s(j,:),bin);
%     figure(101);hold all;
%     plot(bin,hist_df{2,j},'LineWidth',2);
    
    hist_df{3,j}=hist(dfN4(j,:),bin);
%     figure(102);hold all;
%     plot(bin,hist_df{3,j},'LineWidth',2);
    
%     figure(103);hold all;
%     plot(bin,hist_df{1,j}/sum(hist_df{1,j})/5,'LineWidth',2);
%     figure(104);hold all;
%     plot(bin,hist_df{2,j}/sum(hist_df{2,j})/5,'LineWidth',2);
    figure(105);hold all;
    plot(bin,hist_df{3,j}/sum(hist_df{3,j})/5,'LineWidth',2);
    pred(j,:)=hist_df{3,j}/sum(hist_df{3,j})/5;
end
% figure(100);
% title('ergodic two state out of sample prediction')
% legend('1998','1999','2000','2001','2002','2003','2004');
% figure(101);
% title('ergodic two state with silent state out of sample prediction');
% legend('1998','1999','2000','2001','2002','2003','2004');
% figure(102);
% title('left and right network. four state with two silent, non commmunicating states')
% legend('1998','1999','2000','2001','2002','2003','2004');
% figure(103);
% title('ergodic two state out of sample prediction. normalized')
% xlabel('Expected total loss in the year','FontSize',14);
% ylabel('Prabobilty Density','FontSize',14);
% legend('1999','2000','2001','2002','2003','2004','2005');
% figure(104);
% title('ergodic two state with silent state out of sample prediction. normalized');
% legend('1999','2000','2001','2002','2003','2004','2005');
% xlabel('Expected total loss in the year','FontSize',14);
% ylabel('Prabobilty Density','FontSize',14);
figure(105);
title('left and right network. four state with two silent, non commmunicating states. normalized')
legend('1999','2000','2001','2002','2003','2004','2005');
xlabel('Expected total loss in the year','FontSize',14);
ylabel('Prabobilty Density','FontSize',14);
% 
save('outofsample.mat')


