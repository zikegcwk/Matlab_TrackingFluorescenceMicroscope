function output = averagetraces(filename,framesaveraged)
% This script will be grabbing the traces file collected at a certain frame
% rate and box-average the frames to lower time resolution. Each frame of
% the averaged trace will contain the average of framesaveraged frames of
% the initial traces. Not that this is not the running average!
%So far done for 2-frame averaging
fid = fopen(filename)
originallength = fread(fid,1,'int32')
numberoftraces = fread(fid,1,'int16')
newlength = floor(originallength/framesaveraged)
data = fread(fid,'int16');
%Will need If..elseif here to check divisibility by 2..3..etc
%For now will do with rounding and forgetting about last column in the
%original data
IntensitiesMatrix = reshape(data,numberoftraces+1,originallength);
AveragedIM = zeros(numberoftraces+1,newlength);
AveragedIM(1,:) = 1:newlength;
for i=2:(numberoftraces+1)
    for j=1:newlength
        %AveragedIM(i,j) =(IntensitiesMatrix(i,2*j)+IntensitiesMatrix(i,2*j-1))/2; %Less
        %%general function
        N=framesaveraged;
        temp=zeros(1,N);
        temp(1,:) = IntensitiesMatrix(i,(N*(j-1)+1):(N*j));
        AveragedIM(i,j) = mean(temp);
        %AveragedIM(i,j) =
        %(IntensitiesMatrix(i,N*(j-1)+1)+IntensitiesMatrix(i,N*j))/2;
    end
end
m=findstr(filename,'.');
newname=filename(1:m-1);
newfilename = strcat(newname, '(averaged', num2str(framesaveraged), ').traces');
fid2 = fopen(newfilename, 'wb');

fwrite(fid2, newlength, 'int32');
fwrite(fid2, numberoftraces, 'int16');
fwrite(fid2, AveragedIM, 'int16');
fclose(fid);
output=1;
fclose(fid2);