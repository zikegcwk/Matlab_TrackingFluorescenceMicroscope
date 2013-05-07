function output = CountHigh(filename,minlength)
%This script will concatenate kinetics matrixes from files with numbers
%given by parameters, and make a histogram of how many times each molecule
%visited Low FRET state. 
%Now works only with "postflow" kinetics files that have 4th column of "time
%after start of the trace"
Kinetics=[];
%for i=filenumber1:filenumberlast
    %filename = strcat(prefix,'(kinetics)',suffix,'cascade', num2str(i),'(4)','.dat');
    try
        tempdata = importdata(filename);
        Kinetics = [Kinetics;tempdata];
    catch
        ans = strcat('No file with ', filename, ' name')
    end
%end

HighHist = [];
HighCounter = 0;
Totaltime=0;
for j=2:length(Kinetics)    
    if Kinetics(j,1)~=9
        if (Kinetics(j,1)==3)&&(Kinetics(j,2)>5)%SERGEYTEMP - to discard what I consider noise ina specific dataset
            HighCounter = HighCounter+1;
            Totaltime = Totaltime+Kinetics(j,2);
        else
            Totaltime = Totaltime+Kinetics(j,2);
        end
    else
        if Kinetics(j,2)==9
            if (Totaltime*Kinetics(1,2)/1000)>minlength
            %TEMPif (Kinetics(j-1,4)*Kinetics(1,2)/1000)>minlength
               HighHist = [HighHist;HighCounter];
               HighCounter = 0;
            else
               HighCounter = 0;
            end
        end
    end
end
hist(HighHist)
outputfilename = strcat('CountHigh(',filename,'(',num2str(minlength),'s).dat');
fid = fopen(outputfilename,'w');
count = fprintf(fid,'%d\n',HighHist);
fclose(fid);
        