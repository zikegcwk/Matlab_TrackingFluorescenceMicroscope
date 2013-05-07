function [fitfn, betaguess, fit_info] = tfcs3d_fit(omegaxy, omegaz, ...
        Gr, fitr, Gw, fitw, ...
        Ga, fita, Gz0, fitz0, GGxy, fitGxy, GGz, fitGz, Gnxy, fitnxy, ...
        Gnz, fitnz, GD, fitD);

fncall = 'tfcs3d(tau, beta(1), beta(2),';
betaguess = [omegaxy, omegaz];
fit_info = {NaN, NaN};

if fitr,
    betaguess = [betaguess, Gr];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Gr;
    fncall = strcat(fncall, sprintf('%g,', Gr));
end;

if fitw,
    betaguess = [betaguess, Gw];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Gw;
    fncall = strcat(fncall, sprintf('%g,', Gw));
end;

if fita,
    betaguess = [betaguess, Ga];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Ga;
    fncall = strcat(fncall, sprintf('%g,', Ga));
end;

if fitz0,
    betaguess = [betaguess, Gz0];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Gz0;
    fncall = strcat(fncall, sprintf('%g,', Gz0));
end;

if fitGxy,
    betaguess = [betaguess, GGxy(1), GGxy(2)];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('[beta(%g), beta(%g)],', length(betaguess)-1,length(betaguess)));
else
    fit_info{end+1} = GGxy;
    fncall = strcat(fncall, sprintf('[%g, %g],', GGxy(1), GGxy(2)));
end;

if fitGz,
    betaguess = [betaguess, GGz];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = GGz;
    fncall = strcat(fncall, sprintf('%g,', GGz));
end;

if fitnxy,
    betaguess = [betaguess, Gnxy];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Gnxy;
    fncall = strcat(fncall, sprintf('%g,', Gnxy));
end;

if fitnz,
    betaguess = [betaguess, Gnz];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g),', length(betaguess)));
else
    fit_info{end+1} = Gnz;
    fncall = strcat(fncall, sprintf('%g,', Gnz));
end;

if fitD,
    betaguess = [betaguess, GD];
    fit_info{end+1} = NaN;
    fncall = strcat(fncall, sprintf('beta(%g))', length(betaguess)));
else
    fit_info{end+1} = GD;
    fncall = strcat(fncall, sprintf('%g)', GD));
end;

fitfn = inline(fncall, 'beta','tau');

return;

  
  