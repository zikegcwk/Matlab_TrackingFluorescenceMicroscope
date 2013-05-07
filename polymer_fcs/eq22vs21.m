clear;
sigma = 0.15; % 150nm rms tracking error
gam = 2*pi*50; % 50Hz tracking bandwidth

wxy = 0.2; % 200nm beam waist
lambda = 0.444; % 444nm laser wavelength
zeta = lambda/(sqrt(2)*pi*wxy); % z axis beam width
wz = wxy/zeta;

L = 17; % 17um polymer contour length
b = 0.05; % polymer Kuhn length
labelDensity = 1/600; % in dyes / bp
numDyes = round(48000 * labelDensity);
Delta = L / numDyes; % Dye spacing

l = 1:numDyes;
Rg = sqrt(L*b/3 * ((l*Delta/L - 1/2).^2 + 1/12));


Q = 1;
tau = logspace(-7,-1,50);
approxRouse = zeros(size(tau));
approxZimm = zeros(size(tau));
for u = 1:length(tau),
    tovertau = tau(u);
    a = 2;
    approxRouse(u) = sum(1./((sigma^2 + Rg.^2 + wxy^2/4).^2 - (sigma^2 + 1/6*(2*Rg.^2 - sqrt(pi)*Q*tovertau^(1/a))).^2)*1./sqrt((sigma^2 + Rg.^2 + wz^2/4).^2 - (sigma^2 + 1/6*(2*Rg.^2 - sqrt(pi)*Q*tovertau^(1/a))).^2));
    a = 3/2;
    approxZimm(u) = sum(1./((sigma^2 + Rg.^2 + wxy^2/4).^2 - (sigma^2 + 1/6*(2*Rg.^2 - 2.68*Q*tovertau^(1/a))).^2)*1./sqrt((sigma^2 + Rg.^2 + wz^2/4).^2 - (sigma^2 + 1/6*(2*Rg.^2 - 2.68*Q*tovertau^(1/a))).^2));
end;

nsub = 4;
semilogx(tau((nsub+1):end), approxRouse(1:(end-nsub)), tau, approxZimm);

if(0),
    exactRouse = zeros(size(tau));
    for l = 1:numDyes,
        for m = l:numDyes,
            yl = l*Delta;
            ym = m*Delta;
            Rgl = sqrt(L*b/3*((yl/L-1/2)^2 + 1/12));
            Rgm = sqrt(L*b/3*((ym/L-1/2)^2 + 1/12));
            for u = 1:length(tau),
                hofx = quadgk(h1inline, 0, inf, 'MaxIntervalCount', 10000)
                h1inline = @(w)1./w.^2.*(1-exp(-w.^a1)).*cos(pi*w*(ym-yl)/L*tovertau^(-1/a));
                exactRouseTmp = 1./((sigma^2 + Rgl^2 + wxy^2/4)*(sigma^2 + Rgm^2 + wxy^2/4)-...
                    (sigma^2 + 1/6*(Rgl^2 + Rgm^2 - abs(yl-ym)*b - Q*tovertau^(1/a))).^2)*...
                    1./sqrt((sigma^2 + Rgl^2 + wz^2/4)*(sigma^2 + Rgm^2 + wz^2/4) -...
                    (sigma^2 + 1/6*(Rgl^2 + Rgm^2 - Q*tovertau^(1/a))).^2);
                exactRouse(u) = exactRouse(u) + exactRouseTmp;
                if l ~= m,
                    exactRouse(u) = exactRouse(u) + exactRouseTmp;
                end;
            end;
        end;
    end;
end;