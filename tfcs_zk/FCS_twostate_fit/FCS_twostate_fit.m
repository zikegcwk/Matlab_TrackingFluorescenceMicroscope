%function fit=FCS_twostate_fit(tau,g2,plot_flag)
function fit=FCS_twostate_fit(tau,g2,plot_flag)
%% initialize
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;



f2fit=@(para,tau) FCS_twostate(tau,para(1),para(2));

%amplitude of the exp guess
para_1_guess=max(mean(g2));
%rates guess
para_2_guess=10^4;
%% for a vector
if size(g2,1)~=1
    %get the average value and weights
    [tau,ave_g2,std_g2,h]=draw_fcs(tau,g2,1,0);
     %set weights as 1/sigma^2.
     w=1./std_g2.^2;
     %weight the data. 
     wg2=w.^0.5.*ave_g2;
     %weight the model function
       
    f2fit=@(para,tau) w.^0.5.*FCS_twostate(tau,para(1),para(2));
    [para_fit,residues,J,sigma]=nlinfit(tau,wg2,f2fit,[para_1_guess,para_2_guess]);
    %generate c.i. for the fitting parameters
    ci=nlparci(para_fit,residues,'jacobian',J);
    %output results
    fit.amp=para_fit(1);fit.stdamp=ci(1,2)-para_fit(1);
    fit.rate=para_fit(2);fit.stdrate=ci(2,2)-para_fit(2);
    [hh,pp]=chi2gof(residues);
    fit.h=hh;
    fit.p=pp;
    fit.thry=FCS_twostate(tau,fit.amp,fit.rate);
    fit.tau=tau;
    fit.g2=g2;
    if ~hh
        disp('Accept Model!')
    else
        disp('Reject Model!')
    end
        
    if plot_flag
        figure;
        hold on;

%         subplot(3,1,3);
%         plot(log10(tau),residues,'*r');
%         %axis([tau(1) tau(end) min(residues) max(residues)])
%         xlabel('Tau [S]', 'FontSize', 10);
%         ylabel('Weighted \newline Residue [A.U.]', 'FontSize', 10);
%         axis tight;

%        subplot(3,1,1:2);hold on;
        plot(log10(tau),FCS_twostate(tau,para_fit(1),para_fit(2)),'r','LineWidth',2);
        shadedErrorBar_zk(tau,g2,{'Color',darkcolor(2,:),'LineWidth',2});hold on;
        legend('two-state fit','data');Box on;  
        %axis([tau(1) tau(end) min(min(ave_g2),1) max(ave_g2)])
        xlabel('Tau [S]', 'FontSize', 10);
        ylabel('Correlation [A.U.]', 'FontSize', 10);
        axis tight;
   
    end

else
%% if not vector

    [para_fit,r]=nlinfit(tau,g2,f2fit,[para_1_guess,para_2_guess]);
    fit.parafit=para_fit;
    fit.r=r;
    fit.tau=tau;
    fit.thry=FCS_twostate(tau,para_fit(1),para_fit(2));
    if plot_flag
        figure;
        subplot(2,1,1)
        semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
        hold on;
        semilogx(tau,FCS_twostate(tau,para_fit(1),para_fit(2)),'LineWidth',2);
        %title(cd);
        subplot(2,1,2)
        semilogx(tau,r)
    end
end

end


function g2tau=FCS_twostate(t,A,kk)

g2tau=A.*exp(-kk.*t);

end