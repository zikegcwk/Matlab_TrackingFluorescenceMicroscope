function r=mass_fcs(gctl,gs)

%y(j,1) is control g2 for gs{j,6}.
y=input('Enter pairs for rate determination: ');
disp('we will work on:')

for j=1:1:size(y,1)
    gs{y(j,2),7}
end

tau=logspace(-(size(gs{1,1},2)+1)/10,0,(size(gs{1,1},2)+1));
tau=tau(1:end-1);

for j=1:1:size(y,1)
    t_tide=10^-3.5;
    g3=addfcs(gctl,gs,y(j,1),y(j,2));
    g3=fcs_N(tau,g3,t_tide);
    % figure(2);clf;
    % fplot(tau,g3,1e-6);

    [tau22,g22]=fcs_cut(tau,g3,10^-6);

    fit=FCS_diffusion_fit(tau22,g22{1,6},2,pi*4/0.633,[0 0],'xyz');

    figure(119);clf;
    fplot(tau22,g22);
    hold on;
    plot(log10(tau22),fit.thry,'b','LineWidth',2);
    [tau2c,g2c]=fcs_chopper(tau22,g22,10^-3.5,fit.thry);
    fit2=FCS_twostate_fit(tau2c,g2c{2,4},0);
    figure(119);hold on;
    plot(log10(tau22),(fit2.amp.*exp(-fit2.rate.*tau22)+1).*fit.thry,'g','LineWidth',2)
%%   
subplot(3,1,3);
        plot(log10(tau),residues,'*r');
        %axis([tau(1) tau(end) min(residues) max(residues)])
        xlabel('Tau [S]', 'FontSize', 10);
        ylabel('Weighted \newline Residue [A.U.]', 'FontSize', 10);
        axis tight;

        subplot(3,1,1:2);hold on;
        plot(log10(tau),FCS_twostate(tau,para_fit(1),para_fit(2)),'r','LineWidth',2);
        shadedErrorBar_zk(tau,g2,{'Color',darkcolor(2,:),'LineWidth',2});hold on;
        legend('two-state fit','data');Box on;  
        %axis([tau(1) tau(end) min(min(ave_g2),1) max(ave_g2)])
        xlabel('Tau [S]', 'FontSize', 10);
        ylabel('Correlation [A.U.]', 'FontSize', 10);
        axis tight;
    % FCS_threestate_fit(tau2c,g2c{2,4},1)
end