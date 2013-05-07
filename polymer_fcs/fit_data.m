fitloop = 0;
fitGeneral = 1;
save_fits = 1;
draw_plots = 1;
compute_fits = 0;

%data_path = 'w:\data\2008\052008\Sample_E\';
data_path = 'W:\data\2008\061008\Sample_G\run1';

if ~fitloop,
    N = 1;
    %filenum = 24; tstart = 0; tstop = 24;
    %filenum = 12; tstart = 72; tstop = 94;

    filenum = 17; tstart = 0; tstop = 70;
    
    if ~exist('g1') | ~exist('tau') | 0,
        currdir = pwd;
        cd(data_path);
        [tau,g0,g1] = lfcs(filenum, -5, 0, 100, tstart, tstop);
        cd(currdir);
    end;
else
    currdir = pwd;
    cd('w:\data\2008\052008\Sample_E\');
    load g2_verycoarse;
    cd(currdir);
    N = size(g1, 1);
end;
    
tau0rouse = 0.4;
tau0zimm = 0.3;

fittau = tau(find(tau >= 1e-4 & tau <= 1));
fitg1 = g1(:, find(tau >= 1e-4 & tau <= 1));

betarouse = zeros(N, 2);
betazimm = zeros(N, 2);
betageneral = zeros(N, 3);

g_rouse = zeros(N, length(tau));
g_zimm = zeros(N, length(tau));
g_general = zeros(N, length(tau));

scl = 1;

for kk = 1:N,
    fprintf('Fitting curve %g...', kk);
    
    if compute_fits,
        betarouse(kk, :) = nlinfit(fittau, fitg1(kk, :), @exactRouse, [tau0rouse 1]);
        betazimm(kk, :) = nlinfit(fittau, fitg1(kk, :), @exactZimm, [tau0zimm 1]);
        if fitGeneral,
            betageneral(kk, :) = nlinfit(fittau, fitg1(kk, :), @exactGeneral, [tau0zimm 1 3/2]);
        end;
    else
        betarouse(kk, :) = [tau0rouse scl];
        betazimm(kk, :) = [tau0zimm scl];
        betageneral(kk, :) = [tau0zimm scl 1.1];
    end;
    g_rouse(kk, :) = exactRouse(betarouse(kk, :), tau);
    g_zimm(kk, :) = exactZimm(betazimm(kk, :), tau);
    g_general(kk, :) = exactGeneral(betageneral(kk, :), tau);
    fprintf('Done.\n');
end;

if save_fits & fitloop,
    cd('w:\data\2008\052008\Sample_E\');
    save('exact_fits', 'betarouse', 'betazimm', 'betageneral', 'g_rouse', 'g_zimm', 'g_general');
    cd(currdir);
end;

if draw_plots,
    figure(12);
    if ~fitGeneral,
        semilogx(tau, g1, '.',tau, g_rouse, tau, g_zimm, 'LineWidth', 2);
        legend('Data', 'Rouse model', 'Zimm model');
    else
        semilogx(tau, g1, '.',tau, g_rouse, tau, g_zimm, tau, g_general, 'LineWidth', 2);
        legend('Data', 'Rouse model', 'Zimm model', sprintf('General model a==%g\n', betageneral(3)));
    end;
    xlabel('\tau [s]', 'FontSize', 14);
    ylabel('g_2(\tau)', 'FontSize', 14);

    figure(13);
    rouseError = norm(g1-g_rouse);
    zimmError = norm(g1-g_zimm);

    if ~fitGeneral
        semilogx(tau, g1-g_rouse, tau, g1-g_zimm, tau, 0*tau, 'k');
        legend('Rouse model', 'Zimm model');
        fprintf('L2 fitting error:\n\tRouse model: %g\n\tZimm model: %g\n', rouseError, zimmError);
    else
        semilogx(tau, g1-g_rouse, tau, g1-g_zimm, tau, g1-g_general, tau, 0*tau, 'k');
        legend('Rouse model', 'Zimm model', sprintf('General model a==%g', betageneral(3)));
        genError = norm(g1-g_general);
        fprintf('L2 fitting error:\n\tRouse model: %g\n\tZimm model: %g\nGeneral model: %g\n', rouseError, zimmError, genError);
    end;
    xlabel('\tau [s]', 'FontSize', 14);
    ylabel('Residual');
end;



