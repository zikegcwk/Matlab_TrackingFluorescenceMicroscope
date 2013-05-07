function [newfilename] = flifetimemerger(start,stop,averaged,framelength)
%Function to merge data for lifetime of acceptor dye from multiple analyzed
%movie traces.
%filename would be the name '(flifetime)cascade' 
%averaged -enter the index of averaging
%start = movie number from which to start merging
%end = movie number at which to end averaging
MergedFLifetimes = [];
for i=start:stop
    getdatafrom = strcat('(flifetime)cascade', num2str(i), '(4)','(averaged', num2str(averaged),').dat');
    %tempdata = 0; Do I need to re-zero tempdata here?
    try
        tempdata = importdata(getdatafrom);
        MergedFLifetimes = [MergedFLifetimes;tempdata];
    catch
    end
end
MergedFLifetimes = MergedFLifetimes*(framelength/1000);
newfilename = strcat('(merged)flifet',num2str(start),'to',num2str(stop),'.dat');
dlmwrite(newfilename, MergedFLifetimes,',');

        