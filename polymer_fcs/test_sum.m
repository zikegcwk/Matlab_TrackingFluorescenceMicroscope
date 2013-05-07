p = 1:100;
a = 0.1;
Nb = 1000;

TauRange = logspace(-3,0,Nb);
btau = 0.1;

brange = linspace(0,1,Nb);
S = zeros(1,Nb);
Se = zeros(1, Nb);
Seapprox = zeros(1, Nb);
for bb = 1:Nb,
    tau = TauRange(bb);
    b = brange(bb);
    S(bb) = sum(1./p./p.*cos(p*pi*a).*cos(p*pi*b));
    Se(bb) = sum(1./p./p.*(1-exp(-tau*p.^2)).*cos(p*pi*a).*cos(p*pi*btau));
    Seapprox(bb) = sum(1./p./p.*(1-exp(-tau*p.^2)).*cos(p*pi*(a-btau))/2);
end;

Sexact = pi^2/6 - pi^2/4*(a+brange+abs(a-brange)) + pi^2/8*((a+brange).^2+(a-brange).^2)

figure(9);
plot(brange, S, brange, Sexact);

figure(10); 
semilogx(TauRange, Se, TauRange, Seapprox);



