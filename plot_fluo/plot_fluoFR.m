%this function plots the fluorescence in different colors. 
function [I,t]=plot_fluoFR(filenum, dt,t_begin,t_end),

if nargin==1
    dt=1e-3;
      t_begin=0;
    t_end=60;
end

if nargin==2
    t_begin=0;
    t_end=60;
end

if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end

scrsz = get(0,'ScreenSize');

figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100]); clf;

t = cell(length(tags), 1);
hold all;
for u = 1:length(tags),
    [I{u}, t{u}] = atime2bin(tags{u}, dt,t_begin,t_end);
%    plot(t{u}, I{u});
end;
Ay = I{1}+I{2}; Dy = I{3}+I{4};
plot(t{1},Dy,'b-',t{1},-Ay,'g-');

hold off;
set(gca, 'Box', 'On');

xlabel('Time [s]', 'FontSize', 14);

if 10^-6<=dt<10^-3
     ylabel(sprintf('Counts in %g uS',dt*10^6), 'FontSize', 14);
end

if 10^-3<=dt<=10^-0
    ylabel(sprintf('Counts in %g mS',dt*10^3), 'FontSize', 14);
end

set(gca, 'FontSize', 12);
set(gca, 'LineWidth', 1);
title(plot_title);



