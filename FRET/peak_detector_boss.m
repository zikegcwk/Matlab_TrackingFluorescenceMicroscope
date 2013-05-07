%function peak_detector_boss uses hideo's method to find a peak and return
%the location of the peak in index of the tags and its corresponding time. 
%function [pk_time,pk_index,pk_count]=peak_detector_boss(tags,dt,level,plot_flag)
function [pk_time,pk_index,pk_count]=peak_detector_boss(tags,dt,level,plot_flag)
if nargin==3
    plot_flag=0;
end




%bin the tags into a rate thing. 
[I, t] = atime2bin(tags, dt);
 
 %at the index where I is equal to level, pk_up_down is 1. 
 %after that point, if I is just bigger than level, pk_up_down is -1. 
pk_up_down=diff(I>level);

%now all you need to do is just to find the maximum between the 1 and -1. 

pk_up_index=find(pk_up_down==1);
pk_down_index=find(pk_up_down==-1);
 
N_pk=min(length(pk_up_index),length(pk_down_index));

pk_count=0;

for j=1:1:N_pk
    clear temp_index;
    if pk_up_index(j)<pk_down_index(j)
       temp_index=find(I(pk_up_index(j):pk_down_index(j))==max(I(pk_up_index(j):pk_down_index(j))));
       temp_pk_index=floor(mean(temp_index));
       pk_index(j)=temp_pk_index+pk_up_index(j)-1;
       pk_time(j)=t(pk_index(j));
       pk_count(j)=I(pk_index(j));
    end
end


if pk_count==0
    pk_time=0;
    pk_index=0;
    return;
else
    if plot_flag~=0

        pk_ruler=min(pk_count):1:max(pk_count);
        hist_pk=hist(pk_count,pk_ruler);
        total_pks=sum(hist_pk);
        hist_pk=hist_pk/length(pk_count);



        figure('Name',' Peak Histogram'); 
        bar(pk_ruler,hist_pk);
        axis([min(pk_ruler)-0.5 max(pk_ruler)+0.5 0 1.2*max(hist_pk)])
        xlabel('Counts per 250uS','FontSize',14);
        ylabel('Probability','FontSize',14)
        text(max(pk_ruler),max(hist_pk),strcat('Total number of peaks that exceed-',num2str(level),' counts is :',num2str(total_pks)),'FontSize',12,'Color','r','HorizontalAlignment','Right')
        title('Peak fluo-histogram','Color','r','FontSize',14);

    end
end
    
    
    