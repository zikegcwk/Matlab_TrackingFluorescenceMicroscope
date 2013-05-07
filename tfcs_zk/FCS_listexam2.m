function newlist=FCS_listexam2(list,avgFCS)
k=1;dt=1e-2;

if nargin==1 
    fcs_flag=0;
else 
    fcs_flag=1;
end 

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
            %plot(t{1},I{1}*1e-3/dt,'r');hold on;            
            [I{2}, t{2}] = atime2bin(tags{2}, dt);
            %plot(t{2},I{2}*1e-3/dt,'b');
            plot(t{2},(I{1}+I{2})*1e-3/dt,'k');
        elseif length(tags)==3
            [I{1}, t{1}] = atime2bin(tags{1}, dt);
            plot(t{1},I{1}*1e-3/dt,'b');
            [I{2}, t{2}] = atime2bin(tags{2}, dt);
            plot(t{2},I{2}*1e-3/dt,'r');
            [I{3}, t{3}] = atime2bin(tags{3}, dt);
            plot(t{3},I{3}*1e-3/dt,'g');
        end
        grid on;
        set(gca, 'Box', 'On');
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Fluorescence [kHz]', 'FontSize', 14);
        set(gca, 'FontSize', 12);
        plot_title = sprintf('data\\_%g.mat', list(j,1));
        title(plot_title);
        axis 'auto y';
        plot(list(j,2)*ones(101),0:0.1:10,'--g','LineWidth',3);
        plot(list(j,3)*ones(101),0:0.1:10,'--k','LineWidth',3);
        grid on;
        
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
        hold on;grid on;
        %plot(t0,daq_out(:,2),'g');    
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Tracking Laser[A.U.]', 'FontSize', 14);
        %axis([ts te 0 60])
        %axis 'auto y';
        set(gca, 'FontSize', 12);
        set(gca, 'LineWidth', 1);
        
        if fcs_flag
            figure(9902);clf;hold on;
            [tau,x1,x2,x3,stdx1,stdx2,stdx3]=...
                FCS_ZK_4(list(j,1),list(j,2),list(j,3),-5,0,50);      %plot(log10(tau),x1,'r');
            w=4;
            subplot(1,3,1);hold all;
            plot(log10(tau),x1,'r');
            plot(log10(tau),avgFCS{w,1},'r','LineWidth',2);
            box on;grid on;
            subplot(1,3,2);hold all;
            plot(log10(tau),x2,'b');
            plot(log10(tau),avgFCS{w,2},'b','LineWidth',2);
            box on;grid on;
            subplot(1,3,3);hold all;
            plot(log10(tau),x3,'k');
            plot(log10(tau),avgFCS{w,3},'k','LineWidth',2);
            box on;grid on;
        end
        
        %msd3d(list(1,1),list(1,2),list(1,3));
       
        taketag=input('take this?','s');
        
        
        if strcmp(taketag,'y')
            newlist(k,1)=list(j,1);
            newlist(k,2)=list(j,2);
            newlist(k,3)=list(j,3);
            k=k+1;
        end
end
