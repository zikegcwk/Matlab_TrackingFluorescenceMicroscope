%function fluo_hist plots fluorescence histograms for fluoresecnes levels
%great than the levels set by AcpLev and DonLev. Note you might need to
%change this code to match your detectors. For example, in the code,
%tags{1} is used for Donor and tags{2} is used for acceptor. 

function [Don_total_pks,Acp_total_pks]=fluo_hist(filenum,dt,AcpLev,DonLev,plot_flag)



if nargin<4
    DonLev=0;
end



if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end


t = cell(length(tags), 1);

hold all;
for u = 1:length(tags),
    %here C is the counts per bin size dt. 
    %dt is the time at the bin. 
    [C{u}, t{u}] = atime2bin(tags{u}, dt);
    
end;

%here we assume that tags{1} is the donor fluorescence
Don_index=find(C{1}>=DonLev);

%tags{2} is the acceptor fluorescence
Acp_index=find(C{2}>=AcpLev);


%good_index=Don_index;



fluo_Don=C{1}(Don_index);
fluo_Acp=C{2}(Acp_index);

Don_ruler=min(fluo_Don):1:max(fluo_Don);
Acp_ruler=min(fluo_Acp):1:max(fluo_Acp);

hist_Don=hist(fluo_Don,Don_ruler);
Don_total_pks=sum(hist_Don);
hist_Don=hist_Don/length(fluo_Don);

hist_Acp=hist(fluo_Acp,Acp_ruler);
Acp_total_pks=sum(hist_Acp);
hist_Acp=hist_Acp/length(fluo_Acp);


if plot_flag==1

%plot histograms
figure('Name',strcat(cd,'data',num2str(filenum),' Don Histogram')); 
bar(Don_ruler,hist_Don,'b');
axis([DonLev-0.5 max(Don_ruler)+0.5 0 1.2*max(hist_Don)])
xlabel('Counts per 250uS','FontSize',14);
ylabel('Probability','FontSize',14);
text(max(Don_ruler),max(hist_Don),strcat('Total number of bins that exceed-',num2str(DonLev),' counts is :',num2str(Don_total_pks)),'FontSize',12,'Color','r','HorizontalAlignment','Right')
title('Atto425 fluo-histogram','Color','r','FontSize',14);



figure('Name',strcat(cd,'data',num2str(filenum),' Acp Histogram')); 
bar(Acp_ruler,hist_Acp,'g');
axis([AcpLev-0.5 max(Acp_ruler)+0.5 0 1.2*max(hist_Acp)])
xlabel('Counts per 250uS','FontSize',14);
ylabel('Probability','FontSize',14)
text(max(Acp_ruler),max(hist_Acp),strcat('Total number of bins that exceed-',num2str(AcpLev),' counts is :',num2str(Acp_total_pks)),'FontSize',12,'Color','r','HorizontalAlignment','Right')
title('Atto532 fluo-histogram','Color','r','FontSize',14);

end