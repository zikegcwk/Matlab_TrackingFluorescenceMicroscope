%function stack_pk_Don look into data file specified by filenum and stack peaks that have maximum counts bigger than level at the Donor Channel.
%note that the fluorescences are binned at dt. 
%this function is to check if the Acp and Don detection volumes are the
%same. Apparently for 021709 data they are...

%Created 02/24/2009 by ZK.

function [Don_stack,Acp_stack]=stack_pk_Don(filenum,dt,level,plot_type)

if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end

%this is just how the data is saved for 021709 data. 
Don_tags=tags{1};
Acp_tags=tags{2};

[Don_C, Don_t] = atime2bin(Don_tags, dt);
[Acp_C, Acp_t] = atime2bin(Acp_tags, dt);

%find the pks for Acp and Don channel. 
clear Acp_pk_time;
clear Acp_pk_index;

%[Acp_pk_time,Acp_pk_index]=peak_detector(Acp_tags,dt,level);
[Don_pk_time,Don_pk_index]=peak_detector(Don_tags,dt,level);

% number of peaks
N_pk=length(Don_pk_index);
%N_Don_pk=length(Don_pk_index);

%one cannot just use the Acp_pk_index for the donor fluo as the index might
%be slightly different. You can see that by comparing the sizes of the two
%times: Acp_t and Don_t. Thus here we use the Acp_pk_time to locate the
%cloest time in the Don channel to find the right spot to do the
%comparison. 

for j=1:1:N_pk
    %find the right time spot and assign Don_pk_index. 
    Acp_pk_index(j)=dsearchn(Acp_t',Don_pk_time(j));
    Acp_pk_time(j)=Acp_t(Acp_pk_index(j));
     
end

%
for k=1:1:41
    Don_stack(k)=0;
    Acp_stack(k)=0;
end


for j=1:1:N_pk
    for k=1:1:41  
        Don_stack(k)=Don_stack(k)+Don_C(Don_pk_index(j)-21+k);
        Acp_stack(k)=Acp_stack(k)+Acp_C(Acp_pk_index(j)-21+k);
        
    end   
    
end

%get screen size for a big figure.

if strcmp(plot_type,'normalized')
    figure('Name',cd)
    plot((1:41)*dt,Don_stack/Don_stack(21),'b','LineWidth',2);
    hold on;
    plot((1:41)*dt,Acp_stack/Acp_stack(21),'g','LineWidth',2)
    xlabel('Time[S]')
    ylabel('Normalized counts in 250 uS')
elseif strcmp(plot_type,'pure')
    figure('Name',cd);  
    plot(Don_stack,'b','LineWidth',2);
    hold on;
    plot(Acp_stack,'g','LineWidth',2)
    xlabel('Time[S]')
    ylabel('Counts in 250 uS')
else
    disp('you suck');
    reture;
    
end







