%function peak_graber looks into data_filenum.mat and pull out peak
%fluorescences. 

function peak_graber(filenum,dt,level,new_filenum)

load(sprintf('data_%g.mat',filenum));

%locate where the pks are in the acceptor channel. 
[pk_time,pk_index,pk_count]=peak_detector_boss(tags{1},dt,level,0);

pk_low=pk_time-0.01;
pk_high=pk_time+0.01;


