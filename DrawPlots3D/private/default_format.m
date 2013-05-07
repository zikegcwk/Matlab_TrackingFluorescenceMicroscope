function default_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, num_var, var_args);



detect_max_z = 1 && trackdata;

max_z_thresh = 39.95;



dt = 1e-2;



plot_title = [];

if num_var,

    filenum = var_args{1};

    plot_title = sprintf('data\\_%g.mat', filenum);

end;



if num_var > 1,

    if ~strcmp(class(var_args{2}), 'char'),

        dt = var_args{2};

    else

        if num_var == 3,

            dt = var_args{3};

        end;

    end;

end;



numPlots = 1 + trackdata + daqdata;

subplot(numPlots, 1, 1);



t = cell(length(tags), 1);

hold all;

for u = 1:length(tags),

    [I{u}, t{u}] = atime2bin(tags{u}, dt);

    plot(t{u}, I{u}*1e-3/dt);

end;

hold off;

set(gca, 'Box', 'On');



xlabel('Time [s]', 'FontSize', 14);

ylabel('Fluorescence [kHz]', 'FontSize', 14);

set(gca, 'FontSize', 12);

title(plot_title);



if detect_max_z, % color fluorescence data black if z stage was on upper rail.

    z0 = stage_pos(:, 3);

    zmax_ix = find(z0 >= max_z_thresh); % all points where z is on the rail

    if numel(zmax_ix) > 0,

        zmax_diff = diff(zmax_ix);

        diffix = find(zmax_diff > 1); % where the z stage switches away from the rail



        timeRailOn = t0([zmax_ix(1); zmax_ix(diffix+1)]);

        timeRailOff = t0(zmax_ix(diffix));



        % The final period for which the z stage is on the rail will

        % usually not be caught by the above criteria.

        if length(timeRailOff) < length(timeRailOn), 

            timeRailOff(end+1) = t0(zmax_ix(end));

        end;



        hold on;

        for u = 1:length(t),

            ZmaxI = zeros(size(I{u}));

            for v = 1:length(timeRailOn),

                Iix = find(t{u} > timeRailOn(v) & t{u} < timeRailOff(v));

                plot(t{u}(Iix), I{u}(Iix)*1e-3/dt, 'k');

            end;

        end;

        hold off;

        fprintf('Warning: data tainted due to z stage on upper rail.\n');

        fprintf('\tThis fluorescence data is plotted in black.\n');

    end;

end;



if trackdata,

    subplot(numPlots, 1, 2);

    plot(t0, stage_pos(:,1),t0, stage_pos(:,2),t0, stage_pos(:,3));

    xlabel('Time [s]', 'FontSize', 14);

    ylabel('Position [\mum]', 'FontSize', 14);

    set(gca, 'FontSize', 12);

    set(gca, 'LineWidth', 1);

end;

    

if daqdata,

    subplot(3, 1, 3);

    

    plot(t0, daq_out);

    

    xlabel('Time [s]', 'FontSize', 14);

    ylabel('NIDAQ data', 'FontSize', 14);

    set(gca, 'FontSize', 12);

    set(gca, 'LineWidth', 1);

end;





