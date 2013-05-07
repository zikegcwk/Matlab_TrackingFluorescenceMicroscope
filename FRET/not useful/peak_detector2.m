%function peak_detector look into tags and bin into the tags into dt
%intervals. It find out the peak locations where the counts are bigger than
%the pre-set level. 

%the algrithm is that, it breaks the total time into intervals with each
%interval at 10mS. And then it look at the maximum counts within each small
%interval. If the maximum it finds is bigger than or equal to the level, then it
%returns this maximum index as the pk_index. 

function [pk_time, pk_index]=peak_detector2(filenum,dt,level)


if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end



 [C, t] = atime2bin(tags, dt);
 
%  figure;
%  
%  plot(t,C)
 %break into 10ms each.
t_step=1e-2;
N_intv=floor(t(end)/t_step);
 

clear temp_pk_index;
% index for storing pk_index. Or the number of pks in tags. 
k=1;
 
clear pk_index;


for j=1:1:N_intv
     t_start=t(1)+(j-1)*t_step;
     t_end=t_start+t_step;
       
    
    
     temp_index=find(t>=t_start & t<t_end);
     
     potential_pk=max(C(temp_index));
     
     %check if this local pk is bigger than the preset level.
     %if so, pass it to temp_real pk. 
     

     
     if potential_pk >= level
         
         real_pk=potential_pk;
         
         real_pk_index=find(C(temp_index)==real_pk);
            
         % if there are two peaks, like the two have the same counts, then
         % just take the average. If there is only one peak, then take the
         % maximum, of couse. 
            
         if length(real_pk_index)~=1
             real_pk_index=floor(mean(real_pk_index));
         end
         
         temp_pk_index=find(t==t_start)+ real_pk_index-1;
         
       
         
         if isempty(temp_pk_index)==0
                         
            pk_index(k)=temp_pk_index;
            pk_time(k)=t(pk_index(k));
            k=k+1;
   
         end
         
      
     end
     

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
         
        
end
 
     
 