w1 = .5;
w2 = .25;

r = .5;
rb = 0;%-.75;

phi1 = 1;
phi2 = 1;%phi1*(w1^2/w2^2);

D = 6;
gamma = 40;

omega = 2*pi*10000;%7922;

tau = logspace(-6,0,250);

x20 = D/gamma;
x2t = x20*exp(-gamma*tau);

w2a = (w1^2/4);
w2b = (w2^2/4);

cab = r^2/2./((x20+w2a)*(x20+w2b)-x2t.^2);
Tab = sqrt(phi1*phi2)*sqrt(w2a*w2b)./((x20+w2a)*(x20+w2b)-x2t.^2)...
    .*exp(-cab.*((w2a+w2b+2*x20-2*x2t.*cos(omega*tau))+(rb/r)^2.*(w2a+x20)))...
    .*besseli(0,2*cab*(rb/r).*sqrt((x20+w2a)^2+x2t.^2-2*x2t*(x20+w2a).*cos(omega*tau)));

Tba = Tab;

caa = r^2/2./((x20+w2a)*(x20+w2a)-x2t.^2);
Taa = sqrt(phi1*phi1)*sqrt(w2a*w2a)./((x20+w2a)*(x20+w2a)-x2t.^2)...
    .*exp(-caa.*((w2a+w2a+2*x20-2*x2t.*cos(omega*tau))));

Tbb = sqrt(phi2*phi2)*sqrt(w2b*w2b)./((x20+w2b)*(x20+w2b)-x2t.^2)...
    .*exp(-(r^2*(w2b+x20-x2t.*cos(omega*tau))+rb^2*(w2b+x20-x2t))./((w2b+x20)^2-x2t.^2))...
    .*besseli(0,r*rb*(w2b+x20-x2t)./((w2b+x20)^2-x2t.^2).*sqrt(2*(1+cos(omega*tau))));

g = Taa+Tab+Tba+Tbb;

g = g/g(end);
%figure;
%subplot(4,1,1);semilogx(tau,Taa/g(end));
%subplot(4,1,2);semilogx(tau,Tab/g(end));
%subplot(4,1,3);semilogx(tau,Tba/g(end));
%subplot(4,1,4);semilogx(tau,Tbb/g(end));
figure;semilogx(tau,[Taa; Tab; Tbb;])

figure;semilogx(tau,g)