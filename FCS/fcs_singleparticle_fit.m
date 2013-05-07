function [D,CEFF]=fcs_singleparticle_Dfit(tau,g,omega,xi)
if not(nargin==4)
    error('Syntax error : invalid number of arguments. Type "help fcs_singleparticle_fit" for usage.');
else
    f2fit=@(t,beta) g2(t,beta(1),beta(2));
    beta0=[1e-2,1e-2];
    BETA=nlinfit(tau,g,f2fit,beta0);
    [D,CEFF]=[BETA(1),BETA(2)];
end
end

function y=g2(t,Ceff,Omega,Xi,D)
1/(Ceff*Pi^(3/2))*1/((Omega^2+4*D*t)*sqrt((Omega/Xi)^2+4*D*t));
end
        