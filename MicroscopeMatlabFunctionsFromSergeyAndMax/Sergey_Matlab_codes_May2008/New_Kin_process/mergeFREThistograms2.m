function [newfilename] = mergeFREThistograms2(prefix,start,stop, framelength)
%This function will merge FRET distibutions from multiple analyzed files and output a single distribution converted to seconds.
%In future, I will need to incorporate a check to verify that distributions
%are binned at the same resolution. For now, it is assumed to be 0.025 per
%bin.
% Start=number of the file to start merging from
%Stop = number of the file to stop merging at.
% Averaged - suffix from averaging post-analysis
%Framelength - the length of a single frame in ms
MergedFRET = zeros(73,2);
for i=start:stop
    getdatafrom = strcat(prefix,'cascade', num2str(i), '(4)(FRETDIST).dat');
    %tempdata = 0; Do I need to re-zero tempdata here?
    try
        tempdata = importdata(getdatafrom);
        FRETbins(:,1) = tempdata(:,1);
        MergedFRET = [MergedFRET tempdata(:,2:end-1)];
    catch
    end
end
NewFRET = [FRETbins MergedFRET (sum(MergedFRET,2)*(framelength/1000))];
newfilename = strcat('(mFRETDIST',num2str(start),'to',num2str(stop),')(',num2str(framelength),'ms).dat');
dlmwrite(newfilename, NewFRET,',');
