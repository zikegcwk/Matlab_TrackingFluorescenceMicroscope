%function peak_fluo_hist plots all the fluorescence peaks within a data
%file.
function total_pks=peak_fluo_hist(filenum,dt,level)


if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end



t = cell(length(tags), 1);

for u = 1:1%length(tags),
    %make the last parameter to be 1 then you can plot the histograms of
    %the peaks.
    total_pks=peak_detector_boss(tags{3},dt,level,1);
end;
