function fit2=rate_getter(gctl,g2,gctlN,g2N,t_tide)



tau=logspace(-(size(g2{1,1},2)+1)/10,0,(size(g2{1,1},2)+1));
tau=tau(1:end-1);
g3=addfcs(gctl,g2,gctlN,g2N);
g3=fcs_N(tau,g3,t_tide);
% figure(2);clf;
% fplot(tau,g3,1e-6);

[tau22,g22]=fcs_cut(tau,g3,10^-6);

fit=FCS_diffusion_fit(tau22,g22{1,6},2,pi*4/0.633,[0 0],'xyz');

figure(119);clf;
fplot(tau22,g22);
hold on;
plot(log10(tau22),fit.thry,'b','LineWidth',2);
[tau2c,g2c]=fcs_chopper(tau22,g22,10^-3,fit.thry);
fit2=FCS_twostate_fit(tau2c,g2c{2,4},1);
fit2.t_tide=t_tide;
figure(119);hold on;
plot(log10(tau22),(fit2.amp.*exp(-fit2.rate.*tau22)+1).*fit.thry,'g','LineWidth',2)
thry1=(fit2.amp.*exp(-fit2.rate.*tau22)+1).*fit.thry;