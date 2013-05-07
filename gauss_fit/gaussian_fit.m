%function guassian_fit fits y as a function of x by a gaussian. using

%nlinfit



%10/27/09 by ZK



function para_fit=gaussian_fit(x,y)
    para1_guess=y(1);
    para2_guess=max(y);
    para3_guess=10;
    para4_guess=5;
    
    
% if 0%size(y,1)~=1
%     mean_y=mean(y);
%     std_my=std(y/size(y,1)^0.5,0,1);
%     w=1./std_my.^2;
%     wy=w.^0.5.*mean_y;
%     f2fit=@(para,tau) w.^0.5.*gaussian(x,para(1),para(2),para(3),para(4));
%     [para_fit,residues,J,sigma]=nlinfit(x,wy,f2fit,[para1_guess,para2_guess,para3_guess,para4_guess]);
%     ci=nlparci(para_fit,residues,'jacobian',J);
%     figure;hold on;
%     
%      [para_fit,residues,J,sigma]=nlinfit(tau,wg2,f2fit,[para_1_guess,para_2_guess]);
%     %generate c.i. for the fitting parameters
%     ci=nlparci(para_fit,residues,'jacobian',J);
%     %output results
%     fitting_results{1,1}='two state amp';fitting_results{1,2}=para_fit(1);fitting_results{1,3}=ci(1,2)-para_fit(1);
%     fitting_results{2,1}='two state rate';fitting_results{2,2}=para_fit(2);fitting_results{2,3}=ci(2,2)-para_fit(2);
%     [hh,pp]=chi2gof(residues);
%     
%     if plot_flag
%     figure;hold on;
%     
%     subplot(4,1,4);
%     semilogx(tau,residues,'*r');
%     axis([tau(1) tau(end) min(residues) max(residues)])
%     xlabel('Tau [S]', 'FontSize', 14);
%     ylabel('Weighted Residue [A.U.]', 'FontSize', 14);
%     
%     
%     subplot(4,1,1:3)
%     ciplot_zk(tau,g2,1);
%     semilogx(tau,FCS_twostate(tau,para_fit(1),para_fit(2)),'r','LineWidth',2);
%     legend('data','two-state fit');Box on;  
%     axis([tau(1) tau(end) min(min(ave_g2),1) max(ave_g2)])
%     xlabel('Tau [S]', 'FontSize', 14);
%     ylabel('Correlation [A.U.]', 'FontSize', 14);
% 
% 
% else
    f2fit=@(para,x) gaussian(x,para(1),para(2),para(3),para(4));
  
    [para_fit,r]=nlinfit(x,y,f2fit,[para1_guess,para2_guess,para3_guess,para4_guess]);
    figure;
    plot(x,y,'-or','MarkerSize',4,'MarkerFaceColor','r');
    hold on;
    plot(x,gaussian(x,para_fit(1),para_fit(2),para_fit(3),para_fit(4)),'LineWidth',2);
%end





function G=gaussian(x,a,b,c,d)

G = a + b.* exp( -2*(x-c).^2./d^2);