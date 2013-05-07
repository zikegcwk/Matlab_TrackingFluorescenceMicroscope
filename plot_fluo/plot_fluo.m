%this function plots the fluorescence in different colors. 

function [I,t,Laser,stdLaser]=plot_fluo(filenum, dt,t_begin,t_end,plot_flag),
if nargin==1
    dt=1e-2;
    t_begin=0;
    t_end=15;
    plot_flag=1;
end

if nargin==2
    t_begin=0;
    t_end=15;
    plot_flag=1;
end

if exist(sprintf('./data_%g.mat',filenum))
    %display('plotting......');
    load(sprintf('data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end
for u=1:length(tags)
    te(u)=max(tags{u});
end
t_end=max(te);
for u=1:length(tags)
    data{u} = tags{u}(tags{u} >= t_begin & tags{u} <= t_end);
    [I{u}, t{u}] = atime2bin(data{u}, dt);
end

% if exist('daq_out')
%      laserindex=find(t0>=t_begin & t0<=t_end);
%      Laser=mean(daq_out(laserindex,1));
%      stdLaser=std(daq_out(laserindex,1));
% end

if nargout==0
    plot_flag=1;
else
    plot_flag=0;
end

if plot_flag
    scrsz = get(0,'ScreenSize');
    figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100]); clf;
    %t = cell(length(tags), 1);
    hold all;
    for u = 1:length(tags),
        if u<3
            %[I{u}, t{u}] = atime2bin(data{u}, dt);
            plot(t{u}, I{u});
        else
            %[I{u}, t{u}] = atime2bin(data{u}, dt);
            plot(t{u}, I{u});
        end    
    end;

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
end
if nargout==0
    clear I;
    clear t Laser stdLaser;
    
end

if nargout ==2
    clear Laser;
    clear stdLaser;
end




