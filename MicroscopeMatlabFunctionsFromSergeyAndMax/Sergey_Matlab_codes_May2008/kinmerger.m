function [newfilename] = kinmerger(start,stop,averaged,framelength)
%This function will merge kinetics from multiple analyzed files and output folding and unfolding files converted to seconds.
% FOR TODAY - quickfix, all in 1 matrix, sorted by rows
%Start=number of the file to start merging from
%Stop = number of the file to stop merging at.
% Averaged - suffix from averaging post-analysis
%Framelength - the length of a single frame in ms
MergedKin = [];
for i=start:stop
    getdatafrom = strcat('(kineticsall)cascade', num2str(i), '(4)','(averaged', num2str(averaged),').dat');
    %tempdata = 0; Do I need to re-zero tempdata here?
    try
        tempdata = importdata(getdatafrom);
        MergedKin = [MergedKin;tempdata];
    catch
    end
end
MergedKin(:,2) = MergedKin(:,2)*(framelength/1000);
MergedKin(:,5) = MergedKin(:,5)*(framelength/1000);
MergedKin = sortrows(MergedKin,1);
newfilename = strcat('(mergedAll)kin',num2str(start),'to',num2str(stop),'.dat');

dlmwrite(newfilename, MergedKin,',');
