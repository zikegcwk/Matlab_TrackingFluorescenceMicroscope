%function files_combine takes file number from s_N to e_N and combine them
%linearly. The length of the file is given by file_length. Basically I want
%to verify that doing averages on different files are the same if you
%combine them together and calculate FCS curves.

%created by ZK 08/23/2009

function files_combine(s_N,e_N,file_length);

big_tags=cell(4,1);

for filenum=s_N:1:e_N
    
    block_num=filenum-s_N;
    
    load(sprintf('data_%g', filenum));
        for k=1:1:4
            big_tags{k}=[big_tags{k},tags{k}+block_num*file_length];
        end
end

clear tags;
tags=big_tags;

save(sprintf('data_%g',s_N+10000),'tags');
    


