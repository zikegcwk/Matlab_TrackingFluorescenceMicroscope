function [e,std_e]=get_FRET_e(e_N)

temp_e=zeros(e_N);


for j=1:1:e_N
    temp_e=FRET_e_by_tags(j);
end

e=mean(temp_e);
std_e=std(temp_e);
