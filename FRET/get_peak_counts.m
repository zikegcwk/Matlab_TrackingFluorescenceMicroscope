function [c,std_c,N_pk]=get_peak_counts(s_N,e_N,dt,level)

N=e_N-s_N+1;
temp_c=zeros(N,1);

for j=s_N:1:e_N

    [temp_c(j-s_N+1,1),temp_std(j-s_N+1,1),temp_N_pk(j-s_N+1,1)]=maxpeak_counter_boss(j,dt,level);
end

% c=mean(temp_c,1);
% std_c=sum(temp_std.^2)/N;
% N_pk=mean(temp_N_pk,1);
% 









c=temp_c;
std_c=temp_std;
N_pk=temp_N_pk;

j=1;
while j<length(c)
    if c(j)==0
        c(j)=[];
        std_c(j)=[];
    end
    j=j+1;
end