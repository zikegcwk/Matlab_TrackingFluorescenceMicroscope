function [D_fit, noiseDensity_fit, gammac_fit, gammap_fit, L, Dnoise] = msdfit1D_smart(dt, dx, eb, givenParams, initGuess)

%given params should be in order noiseDensity,gammac,gammap;
%initGuess should be in order D, noiseDensity, gammac, gammap;
%the sum of the number of parameter in givenParams and initGuess should be
%4

try
    beta0=initGuess;
    f2fit=@(beta,t) eb.*msdfun(cat(2,beta,givenParams),t);
    beta_fit=nlinfit(dt, eb.*dx, f2fit, beta0);
    
    allParams=cat(2,beta_fit,givenParams);
    D_fit=allParams(1);
    noiseDensity_fit=allParams(2);
    gammac_fit=allParams(3);
    gammap_fit=allParams(4);
    Dnoise=noiseDensity_fit^2*gammac_fit^2/2;
    L=sqrt(D_fit*(1/gammac_fit+1/gammap_fit)+1/gammac_fit*Dnoise);
catch EM1
    try
        f2fit=@(beta,t) eb.*msdfun_reduced(cat(2,beta,givenParams),t);
        if length(initGuess)==4;
            beta0=initGuess(1:3);
        else
            beta0=initGuess;
        end
        beta_fit=nlinfit(dt, eb.*dx, f2fit, beta0);
        
        allParams=cat(2,beta_fit,givenParams);
        D_fit=allParams(1);
        noiseDensity_fit=allParams(2);
        gammac_fit=allParams(3);
        gammap_fit=Inf;
        Dnoise=noiseDensity_fit^2*gammac_fit^2/2;
        L=sqrt(D_fit*(1/gammac_fit)+1/gammac_fit*Dnoise);
    catch EM2
        D_fit = -1;
        noiseDensity_fit = D_fit;
        gammac_fit=-1;
        gammap_fit=-1;
        L=-1;
        Dnoise=-1;
    end
end
