function [avg_intensity, duration, gcell, tau] ...
    = scan_tfcs(subdir_prefix, subdir_num, taumin, taumax, numtau, delay, ploton);

if nargin < 6, 
    error('Not enough arguments.');
end;

if nargin < 7,
    ploton = 0;
end;

tic;

tau = linspace(taumin, taumax, numtau);

gcell = cell(length(subdir_num), 1);
fit_rate = cell(length(subdir_num), 1);
avg_intensity = cell(length(subdir_num), 1);
fit_offset = cell(length(subdir_num), 1);
fit_baseline = cell(length(subdir_num), 1);
duration = cell(length(subdir_num), 1);

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
        avg_intensity{u} = zeros(length(trajfile), 1);
        duration{u} = zeros(length(trajfile), 1);
        
        for v = 1:length(trajfile),
            fprintf('\t\tLoading trajectory %g...', v);
            load(strcat('data_', num2str(trajfile(v))));
            fprintf('done.\n');
            
            data0 = tags0(tags0 >= trajstart(v) & tags0 <= trajstop(v));
            data1 = tags1(tags1 >= trajstart(v) & tags1 <= trajstop(v)) - delay;
            
            duration{u}(v) = trajstop(v)-trajstart(v);
            avg_intensity{u}(v) = (length(data0) + length(data1))/duration{u}(v);
            
            fprintf('\t\t\tComputing autocorrelation...');
            g = corr_Laurence(data0, data1, tau);
            fprintf('done.\n');
                        
            g = g(1:end-1); % Last element is garbage
    
            gcell{u}(v, :) = g';
            
            if ploton,
                figure(100*u+v);
                plot(tau(1:end-1), g);
            end;
        end;
        fprintf('\tDone correlating trajectories.\n');
    else
        fprintf('\tNo trajectory data found.\n');
    end;
    fprintf('\tReturning to parent directory.\n');
    cd('..');    
end;

tau = tau(1:end-1); % Don't return the unused lag time

fprintf('Completed in %gs\n', toc);
return;

    
    
    

