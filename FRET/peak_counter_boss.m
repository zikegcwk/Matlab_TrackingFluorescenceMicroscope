%function peak_counter_boss looks into data files and count the counts of
%peaks detected by peak_detector boss. It returns the average counts and
%std of the counts. Right now it just look into tags{3}. 

function [counts,counts_std,N_pk]=peak_counter_boss(filenum,dt,level)


disp(sprintf('processing data_%g.mat... \n',filenum));
load(sprintf('data_%g.mat',filenum));

[pk_time,pk_index,pk_count]=peak_detector_boss(tags{3},dt,level,0);


counts=mean(pk_count);
counts_std=std(pk_count);

N_pk=length(pk_count);

disp(sprintf('Number of peaks is: %g. \n',N_pk));
disp(sprintf('Average peak counts is: %g. \n',counts));
