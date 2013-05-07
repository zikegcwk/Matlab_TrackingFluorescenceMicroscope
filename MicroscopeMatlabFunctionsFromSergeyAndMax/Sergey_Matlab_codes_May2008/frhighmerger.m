function [newfilename] = frhighmerger(start,stop,averaged)
%Function to merge data for fraction of time in high FRET state from multiple analyzed
%movie traces. Returns percentage of time (rounded to whole percents) each
%trace spent in high FRET
%filename would be the name '(flifetime)cascade' 
%averaged -enter the index of averaging
%start = movie number from which to start merging
%end = movie number at which to end averaging
MergedFHigh = [];
for i=start:stop
    getdatafrom = strcat('(frhigh)cascade', num2str(i), '(4)','(averaged', num2str(averaged),').dat');
    try
        tempdata = importdata(getdatafrom);
        MergedFHigh = [MergedFHigh;tempdata];
    catch
    end
end
MergedFHigh = round(MergedFHigh*100);
newfilename = strcat('(merged)frhigh',num2str(start),'to',num2str(stop),'.dat');
dlmwrite(newfilename, MergedFHigh,',');     