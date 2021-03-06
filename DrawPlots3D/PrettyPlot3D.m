% This is a function more making higher-quality plots.  It is meant to be
% edited heavily depending on the particular application.
function PrettyPlot3D(filenum, tstart, tstop);

dt = 1e-2;
%%Don't edit this section 
load(sprintf('data_%g', filenum));

numTraces = length(tags);
plotI = cell(size(tags));
tI = cell(size(tags));
for u = 1:numTraces,
    [plotI{u}, tI{u}] = atime2bin(tags{u}(find(tags{u} >= tstart & tags{u} <= tstop)) - tstart, dt);
    plotI{u} = plotI{u} / dt / 1000; % Convert from counts per bin to kHz
end;

daq_ix = find(t0 >= tstart & t0 <= tstop);
t0 = t0(daq_ix) - tstart;
x0 = x0(daq_ix);
y0 = y0(daq_ix);
z0 = z0(daq_ix);
NIDAQ_Out = NIDAQ_Out(daq_ix, :);


%%%%%%%%%%%%%%%%%%%% edit below 

figure(5000); clf;
subplot(2, 1, 1);

plot(tI{1}, plotI{1}+plotI{2});
ylabel('Fluorescence [kHz]', 'FontSize', 14);
axis([0 15.5 0 50]);
set(gca, 'FontSize', 12);

subplot(2, 1, 2);
if(1),
    plot(t0, [x0,y0,z0]);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Position [\mum]', 'FontSize', 14);
    axis([0 15.5 0 60]);
    set(gca, 'FontSize', 12);    
end;
if(0),
    [AX,H1,H2] = plotyy(t0, [x0,y0,z0], t0, NIDAQ_Out);
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Position [\mum]', 'FontSize', 14);
    axis([0 15.5 0 60]);
    set(gca, 'FontSize', 12);
    axes(AX(2));
    ylabel('Beam Intensity [a.u.]', 'FontSize', 14);
    axis([0 15.5 0 0.5]);
    set(AX(2), 'XTick', []);
    set(H2, 'LineStyle', ':');
end;

return;