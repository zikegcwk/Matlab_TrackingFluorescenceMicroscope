%this function plots the fluorescence in different colors. 
function [I,t]=plot_fluo(filenum, dt,nbins,t_begin,t_end),
% modified by C.R. 7/22/09 to include histogram of counts

if nargin==1
    dt=1e-2;
    nbins = 20;
    t_begin = 0;
    t_end = 60;
end

if nargin==2
    nbins = 20;
    t_begin = 0;
    t_end = 60;
end

if nargin==3
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
    subplot(2,1,1);
    plot(t{u}, I{u});
end;

s = I{1};
for u = 1:length(tags)
    s = s+I{u};
end
edges = (0:max(s)/nbins:max(s));
subplot(2,1,2);
plot(edges,histc(s,edges),'o');
hold off;
set(gca, 'Box', 'On');


subplot(2,1,1);
xlabel('Time [s]', 'FontSize', 14);

if 10^-6<=dt<10^-3
     ylabel(sprintf('Counts in %g uS',dt*10^6), 'FontSize', 14);
end
if 10^-3<=dt<=10^-0
    ylabel(sprintf('Counts in %g mS',dt*10^3), 'FontSize', 14);
end

subplot(2,1,2);
ylabel('Number of occurrences','FontSize',14);

subplot(2,1,2);
if 10^-6<=dt<10^-3
     xlabel(sprintf('Counts in %g uS',dt*10^6), 'FontSize', 14);
end

if 10^-3<=dt<=10^-0
    xlabel(sprintf('Counts in %g mS',dt*10^3), 'FontSize', 14);
end


set(gca, 'FontSize', 12);
set(gca, 'LineWidth', 1);
title(plot_title);



