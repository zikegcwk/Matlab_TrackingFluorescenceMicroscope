%function peak_together look into filenum and find peaks into both Donor
%and Aceptor channels and find peaks that bigger than the level. Note all
%the fluorescences are binned at dt. Now if the two peaks are within plus
%minus 3 indexes, return 1 to Overlap_pk_N. So yeah, the function returns
%number of peaks in donor channel and aceptor channel and also the overlap
%peaks. 

%created by Zk 02/25/09

function [Don_pk_N, Acp_pk_N,Overlap_pk_N]=peak_together(filenum,dt,level)

%load the data file
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
[Acp_pk_time,Acp_pk_index]=peak_detector(Acp_tags,dt,level);
[Don_pk_time,Don_pk_index]=peak_detector(Don_tags,dt,level);

% number of peaks
Acp_pk_N=length(Acp_pk_index);
Don_pk_N=length(Don_pk_index);

%---------------FIND OVERLAP PEAKS---------------------%


N_pk=min(Acp_pk_N,Don_pk_N);

Overlap_pk_N=0;

for j=1:1:N_pk
    figure(1);hold on;
    plot(j,Acp_pk_time(j)-Don_pk_time(j),'*b');hold on;
    figure(2);hold on;
    plot(j,Acp_pk_index(j)-Don_pk_index(j),'or');hold on;
    
    
    if abs(Acp_pk_time(j)-Don_pk_time(j))<0.003
       Overlap_pk_N=Overlap_pk_N+1;
    end
end


    





