function newlist=FCS_listexam(list)
k=1;dt=1e-2;
for j=1:1:size(list,1)

    load(sprintf('data_%g.mat',list(j,1)));
    figure(9901);clf;
    subplot(4,1,1:2);hold all;
    %% plot fluorescence
        t = cell(length(tags), 1);
        hold all;
        if length(tags)==1
            [I{1}, t{1}] = atime2bin(tags{1}, dt);
            plot(t{1},I{1}*1e-3/dt,'b');
        elseif length(tags)==2
            [I{1}, t{1}] = atime2bin(tags{1}, dt);
            %plot(t{1},I{1}*1e-3/dt,'b');
            [I{2}, t{2}] = atime2bin(tags{2}, dt);
            plot(t{2},(I{1}+I{2})*1e-3/dt,'k');
        elseif length(tags)==3
            [I{1}, t{1}] = atime2bin(tags{1}, dt);
            plot(t{1},I{1}*1e-3/dt,'b');
            [I{2}, t{2}] = atime2bin(tags{2}, dt);
            plot(t{2},I{2}*1e-3/dt,'r');
            [I{3}, t{3}] = atime2bin(tags{3}, dt);
            plot(t{3},I{3}*1e-3/dt,'g');
        end

        set(gca, 'Box', 'On');
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Fluorescence [kHz]', 'FontSize', 14);
        set(gca, 'FontSize', 12);
        plot_title = sprintf('data\\_%g.mat', list(j,1));
        title(plot_title);
        axis 'auto y';
        plot(list(j,2)*ones(101),0:0.1:10,'--r');
        plot(list(j,3)*ones(101),0:0.1:10,'--b');
        
        
        %axis([ts te 0 10])
        %
    
    %% plot the stage postions
        subplot(4,1,3);
        plot(t0, x0,t0, y0,t0, z0);
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Position [\mum]', 'FontSize', 14);
        set(gca, 'FontSize', 12);
        set(gca, 'LineWidth', 1);
            %axis([ts te 0 100])
            %axis 'auto y';
    
    %% plot the laser power and such. 
        subplot(4,1,4)
        plot(t0,daq_out(:,1),'k');
        hold on;
        plot(t0,daq_out(:,2),'g');    
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Qdot Fluorescence [A.U.]', 'FontSize', 14);
        %axis([ts te 0 60])
        %axis 'auto y';
        set(gca, 'FontSize', 12);
        set(gca, 'LineWidth', 1);
        
        figure(9902);
        
        taketag(j)=menu('take this?','no','yes')-1;
        
        if taketag
            newlist(k,1)=list(j,1);
            newlist(k,2)=list(j,2);
            newlist(k,3)=list(j,3);
        end
end
