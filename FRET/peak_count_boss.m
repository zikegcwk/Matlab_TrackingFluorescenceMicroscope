%function peak_count_boss look into tags 1 and 2 and find number of peaks
%in tags1 and 2 as well as peaks that are colocalized. 

function [N1,N2,Nx]=peak_count_boss(tags1,tags2,dt,level)

plot_flag=0;

[pk_time1,pk_index1,pk_count1]=peak_detector_boss(tags1,dt,level,plot_flag);
[pk_time2,pk_index2,pk_count2]=peak_detector_boss(tags2,dt,level,plot_flag);


%number of counts in tags1 and tags2. 
N1=length(pk_index1);
N2=length(pk_index2);


peak_window=dt*3;

Nx=0;

if N1==0|N2==0
    Nx=0;
    return;
end


if N2>=N1
    for j=1:1:N1
        close_index(j)=dsearchn(pk_time2',pk_time1(j));
        close_time(j)=pk_time2(close_index(j));

        if abs(close_time(j)-pk_time1(j))<peak_window
            Nx=Nx+1;
        end

    end
    
    
elseif N1>N2
    for j=1:1:N2
        close_index(j)=dsearchn(pk_time1',pk_time2(j));
        close_time(j)=pk_time1(close_index(j));
        if abs(close_time(j)-pk_time2(j))<peak_window
            Nx=Nx+1;
%             figure(100);
%             hold on;
%             plot(j,abs(close_time(j)-pk_time2(j)),'sr','MarkerSize',10)
                      
        end
    end    
    
    
else
    return;
    
end

