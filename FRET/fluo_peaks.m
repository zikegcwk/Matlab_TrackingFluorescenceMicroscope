%function fluo_peaks search peaks above level in tags specified by tagsnum1
%and tagnum2 in data file specified by filenum, and it returns the number
%of peaks in N1 N2 and colocalized peak in Nx.

function [N1,N2,Nx]=fluo_peaks(filenum,dt,level,tagnum1,tagnum2)

if nargin==3
    tagnum1=1;
    tagnum2=2;
end


if exist(sprintf('./data_%g.mat',filenum))
    display('nice');
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end

if (tagnum1>length(tags))|(tagnum2>length(tags))
    error('tagnums exceeds length of tags in this data file.')
end

[N1,N2,Nx]=peak_count_boss(tags{tagnum1},tags{tagnum2},dt,level);




