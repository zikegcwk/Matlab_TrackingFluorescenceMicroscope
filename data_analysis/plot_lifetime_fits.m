% function plot_lifetime_fits(cellix, tau, gcell, rate, offset, baseline);
function plot_lifetime_fits(cellix, tau, gcell, rate, offset, baseline);

g = inline('beta(1)*(1-exp(-beta(2)*abs(t)/1e-9)) + beta(3)', 'beta', 't');

for u = 1:length(cellix),
    ix = cellix(u);
    for v = 1:size(gcell{ix}, 1),
        figure(u*100+v); clf;
        hold on;
        plot(tau, gcell{ix}(v, :));
        plot(tau, g([baseline{ix}(v), rate{ix}(v), offset{ix}(v)], tau), 'r-', 'LineWidth', 2);
        hold off;
    end;
end;

return;
        