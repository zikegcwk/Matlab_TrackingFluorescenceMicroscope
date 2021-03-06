function [NEFF,OMEGA,XI,VEFF]=fcs_beamfit(tau,g,dcoeff,plotTag)
if not(nargin==3 || nargin==4)
    error('Syntax error : invalid number of arguments. Type "help fcs_beamfit" for usage.');
else
    f2fit=@(beta,t) g2(t,dcoeff,beta(1),beta(2),beta(3));
    omega0=500e-9;
    a0=g(1);
    td0=omega0^2/(4*dcoeff);
    xi0=1;
    beta0=[a0,td0,xi0];
    BETA=nlinfit(tau,g,f2fit,beta0,statset('MaxIter',300));
    OMEGA=sqrt(4*dcoeff*BETA(2));
    VEFF=pi^(3/2)*OMEGA^3/BETA(3);
    NEFF=1/BETA(1);
    XI=BETA(3);
    c=1/(BETA(1)*VEFF);
    cmol=c*1e-6/6.02e23;
    display(sprintf('The fitting gives C= %d mol/l, Td= %d',cmol,BETA(2)));
    if (nargin==4 & plotTag)
        figure, semilogx(tau,g,tau,f2fit(BETA,tau));
    end
end
end

function y=g2(t,D,A,td,xi)
y=A*((1+t/td).^(-1)).*((1+(xi^2)*t/td).^(-1/2));
end