L = 17;
b = 0.17;

density_range = logspace(log10(1/10),log10(1/48000), 20);
error = zeros(size(density_range));
errav = zeros(size(density_range));
for dd = 1:length(density_range),
    fprintf('dd == %g\n', dd);
    dyedensity = density_range(dd);
    
    N = round(48000*dyedensity);
    Delta = L / N;

    l = 1:N; 

    [lmesh, mmesh] = meshgrid(l,l);

    error(dd) = L*b/3/N^2*sum(sum(1/3-1/2/L*((lmesh+mmesh)*Delta + abs(lmesh-mmesh)*Delta) + 1/2/L^2*(lmesh.^2*Delta^2 + mmesh.^2*Delta^2)));
    errav(dd) = L*b/9/N^2;
end;

plot(1./density_range, errav);
