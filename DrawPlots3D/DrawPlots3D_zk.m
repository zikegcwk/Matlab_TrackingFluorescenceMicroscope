



function DrawPlots3D_list(filenum,dt,ts,te)

load(sprintf('data_%g.mat',filenum));
%% plot fluorescence
subplot(4, 1, 1:2);
t = cell(length(tags), 1);
hold all;
if length(tags)==1
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    plot(t{1},I{1}*1e-3/dt,'b');
elseif length(tags)==2
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    %plot(t{1},I{1}*1e-3/dt,'b');
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    %plot(t{2},I{2}*1e-3/dt,'r');
    plot(t{1},I{1}+I{2}*1e-3/dt,'k');
elseif length(tags)==3
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    plot(t{1},I{1}*1e-3/dt,'b');
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    plot(t{2},I{2}*1e-3/dt,'r');
    [I{3}, t{3}] = atime2bin(tags{3}, dt);
    plot(t{3},I{3}*1e-3/dt,'g');
elseif length(tags)==4
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    [I{3}, t{3}] = atime2bin(tags{3}, dt);
    [I{4}, t{4}] = atime2bin(tags{4}, dt);
    plot(t{1},I{1}*1e-3/dt,'r');
    plot(t{2},I{2}*1e-3/dt,'m');
    plot(t{3},-I{3}*1e-3/dt,'b');
    plot(t{4},-I{4}*1e-3/dt,'c');
    plot(t{1},t{1}*0,'k');    
end
 
set(gca, 'Box', 'On');
xlabel('Time [s]', 'FontSize', 14);
ylabel('Fluorescence [kHz]', 'FontSize', 14);
set(gca, 'FontSize', 12);
plot_title = sprintf('data\\_%g.mat', filenum);
title(plot_title);
axis([ts te 0 10])
axis 'auto y';

%%plot the stage postions
    subplot(4, 1, 3);
    plot(t0, stage_pos(:,1),t0, stage_pos(:,2),t0, stage_pos(:,3));
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Position [\mum]', 'FontSize', 14);
    set(gca, 'FontSize', 12);
    set(gca, 'LineWidth', 1);

        axis([ts te 0 100])
        axis 'auto y';

%% plot the laser power and such. 
subplot(4,1,4);
plot(t0,daq_out(:,1),'k');
hold on;
plot(t0,daq_out(:,2),'g');    
xlabel('Time [s]', 'FontSize', 14);
ylabel('Qdot Fluorescence [A.U.]', 'FontSize', 14);
axis([ts te 0 60])
axis 'auto y';
set(gca, 'FontSize', 12);
set(gca, 'LineWidth', 1);
    