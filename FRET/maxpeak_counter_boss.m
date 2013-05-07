%function peak_counter_boss looks into data files and count the counts of
%peaks detected by peak_detector boss. It returns the average counts and
%std of the counts. Right now it just look into tags{3}. 

function [counts,counts_std,N_pk]=maxpeak_counter_boss(filenum,dt,level)


disp(sprintf('processing data_%g.mat... \n',filenum));
load(sprintf('data_%g.mat',filenum));

[pk_time,pk_index,pk_count]=peak_detector_boss(tags{3},dt,level,0);

N_pk=length(pk_count);

if N_pk<30
     max_pk_count=zeros(N_pk,1);
     for j=1:1:N_pk
        max_pk_count(j)=max(pk_count);
        temp_max_index_group=find(pk_count==max_pk_count(j));
        %so you won't find the same thing again next time. (1,1) takes care
        %of the situation when you have several max at different times.
        pk_count(temp_max_index_group(1,1))=-1;
    end




else
    max_pk_count=zeros(30,1);
    for j=1:1:30
        max_pk_count(j)=max(pk_count);
        temp_max_index_group=find(pk_count==max_pk_count(j));
        %so you won't find the same thing again next time. (1,1) takes care
        %of the situation when you have several max at different times.
        pk_count(temp_max_index_group(1,1))=-1;
    end
end

counts=mean(max_pk_count);
counts_std=std(max_pk_count);
    
    


%disp(sprintf('Number of peaks is: %g. \n',N_pk));
disp(sprintf('Average peak counts is: %g. \n',counts));
