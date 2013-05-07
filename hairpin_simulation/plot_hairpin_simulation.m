function plot_hairpin_simulation(filenum,dt)
    

load(sprintf('data_%g.mat',filenum));


%% plot data
scrsz = get(0,'ScreenSize');
figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100]); clf;
%t = cell(length(tags), 1);
hold all;
[I, t] = atime2bin(tags{1}, dt);
plot(t,I);
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
%title(plot_title);

%% plot true state values
high=F_high*dt;
low=F_low*dt;
clear j k
k=1;
size(t)

for j=1:1:(size(T,1)-1)
tl=T(j+1,1);
size(t,2)

    while(t(1,k)<=tl)
        if T(j,2)==-1
            s(k)=low;
        elseif T(j,2)==1
            s(k)=high;
        end
        
        if k<size(t,2)
        k=k+1;
        end
    end
end

hold on;
size(s);
plot(t(1,1:size(s)),s,'r');
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            














