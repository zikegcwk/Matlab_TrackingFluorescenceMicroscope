function [fit_rate, avg_intensity, fit_offset, fit_baseline, gcell, tau] ...
    = scan_lifetime(subdir_prefix, subdir_num, taumax, numtau, delay, ploton);

if nargin < 5, 
    error('Not enough arguments.');
end;

if nargin < 6,
    ploton = 0;
end;

tic;

gfit = inline('beta(1)*(1 - exp(-beta(2)*abs(t)/1e-9)) + beta(3)', 'beta', 't');
tau = linspace(-taumax, taumax, numtau);
tau(end + 1) = 2*tau(end) - tau(end-1);

gcell = cell(length(subdir_num), 1);
fit_rate = cell(length(subdir_num), 1);
avg_intensity = cell(length(subdir_num), 1);
fit_offset = cell(length(subdir_num), 1);
fit_baseline = cell(length(subdir_num), 1);

for u = 1:length(subdir_num);
    fprintf('Entering directory ');
    fprintf(subdir_prefix);
    fprintf(num2str(subdir_num(u)))
    fprintf('...');
    cd(strcat(subdir_prefix, num2str(subdir_num(u))));
    fprintf('done.\n');
    
    if exist('./trajectories.csv', 'file'),
        fprintf('\tLoading trajectory data...');
        trajix = load('trajectories.csv');
        
        trajfile = trajix(:, 1);
        trajstart = trajix(:, 2);
        trajstop = trajix(:, 3);

        fprintf('done.\n\t\t%g trajectories found.\n', length(trajfile));
        
        
        gcell{u} = zeros(length(trajfile), length(tau)-1);
        rates = zeros(length(trajfile), 1);
        intensity = zeros(length(trajfile), 1);
        offset = zeros(length(trajfile), 1);
        baseline = zeros(length(trajfile), 1);
        
        for v = 1:length(trajfile),
            fprintf('\t\tLoading trajectory %g...', v);
            load(strcat('data_', num2str(trajfile(v))));
            fprintf('done.\n');
            
            data0 = tags0(tags0 >= trajstart(v) & tags0 <= trajstop(v));
            data1 = tags1(tags1 >= trajstart(v) & tags1 <= trajstop(v)) - delay;
            
            intensity(v) = (length(data0) + length(data1))/(trajstop(v) - trajstart(v));
            
            fprintf('\t\t\tComputing autocorrelation...');
            g = corr_Laurence(data0, data1, tau);
            fprintf('done.\n');
                        
            g = g(1:end-1); % Last element is garbage
    
            gcell{u}(v, :) = g';
            
            betaguess(3) = min(g);
            betaguess(1) = g(1) - min(g);
            betaguess(2) = 0.1;
            
            fprintf('\t\t\tFitting fluorescence lifetime...');
            beta = nlinfit(tau(1:end-1), g, gfit, betaguess);
            fprintf('done.\n');
            
            rates(v) = beta(2);
            offset(v) = beta(3);
            baseline(v) = beta(1);
            
            if ploton,
                figure(100*u+v);
                hold on;
                plot(tau(1:end-1), g);
                plot(tau(1:end-1), gfit(beta, tau(1:end-1)), 'r-', 'LineWidth', 2);
                hold off;
            end;
        end;
        fprintf('\tDone fitting trajectories.\n');
        fit_rate{u} = rates;
        fit_offset{u} = offset;
        fit_baseline{u} = baseline;
        avg_intensity{u} = intensity;
    else
        fprintf('\tNo trajectory data found.\n');
    end;
    fprintf('\tReturning to parent directory.\n');
    cd('..');    
end;

tau = tau(1:end-1); % Don't return the unused lag time

fprintf('Completed in %gs\n', toc);
return;

    
    
    

