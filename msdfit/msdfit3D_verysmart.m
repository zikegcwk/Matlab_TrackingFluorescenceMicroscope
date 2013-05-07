function [D_fit, noiseDensity_fit, gammac_fit, gammap_fit, L, Dnoise,h] = msdfit3D_verysmart(dt, dx, dy, dz, eb, givenParams,initGuess,plotTag)

%given params should be in order noiseDensity,gammac,gammap;
%initGuess should be in order D, noiseDensity, gammac, gammap;
%the sum of the number of parameter in givenParams and initGuess should be
%4
eb=eb/sum(eb);
Dfit=-ones(1,3);
noiseDensity_fit=Dfit;
gammac_fit=Dfit;
gammap_fit=Dfit;
L=Dfit;
Dnoise=Dfit;
[D_fit(1), noiseDensity_fit(1), gammac_fit(1), gammap_fit(1), L(1), Dnoise(1)]=msdfit1D_smart(dt,dx,eb,givenParams(1,:),initGuess(1,:));
[D_fit(2), noiseDensity_fit(2), gammac_fit(2), gammap_fit(2), L(2), Dnoise(2)]=msdfit1D_smart(dt,dy,eb,givenParams(2,:),initGuess(2,:));
[D_fit(3), noiseDensity_fit(3), gammac_fit(3), gammap_fit(3), L(3), Dnoise(3)]=msdfit1D_smart(dt,dz,eb,givenParams(3,:),initGuess(3,:));


if plotTag
    h=figure();
    semilogx(dt, dx, 'b'); hold on;
    semilogx(dt, dy, 'g'); hold on;
    semilogx(dt, dz, 'r'); hold on;
    
    for i=1:3
    if(D_fit(i)>0)
    semilogx(dt, msdfun_smart([D_fit(i),noiseDensity_fit(i),gammac_fit(i),gammap_fit(i)],dt), 'k');  hold on;
    end
    
    end
else
    h=[];
end
    
    