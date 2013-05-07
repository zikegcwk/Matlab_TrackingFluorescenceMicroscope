tau=logspace(-5,-1,200);
g2=corr_Laurence(tags{3},tags{3},tau);%links to corr_Laurence
g2=g2(1:end-1)-1;
tau=tau(1:end-1);

figure;
semilogx(tau,g2);

tau=logspace(-5,-1,200);
[g2N,g2N_std]=corr_Laurence_ZK(tags{3},tags{3},tau);%links to corr_Laurence_ZK
g2N=g2N(1:end-1);
g2N_std=g2N_std(1:end-1);

tau=tau(1:end-1);

figure;
subplot(1,2,1)
semilogx(tau,g2N,'r');
subplot(1,2,2);
semilogx(tau, g2N_std);
