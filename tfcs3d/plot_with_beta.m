function g = plot_with_beta(tau, beta, fit_info);

if length(fit_info) ~= 11,
    error('fit_info not recognized.');
end;

v = 3;
for u = 3:length(fit_info),
    if isnan(fit_info{u}),
        if u == 7, 
            fit_info{u} = [beta(v), beta(v+1)];
            v = v+2;
        else
            fit_info{u} = beta(v);
            v = v + 1;
        end;
    end;
end;

g = tfcs3d(tau, beta(1), beta(2), fit_info{3}, fit_info{4}, fit_info{5},...
    fit_info{6}, fit_info{7}, fit_info{8}, fit_info{9}, fit_info{10}, ...
    fit_info{11});

return;
