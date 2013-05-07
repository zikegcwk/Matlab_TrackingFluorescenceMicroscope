function output = BoxcarAvTraces(filenumber1,filenumberlast, boxsize)
for i=filenumber1:filenumberlast
    filename = strcat('cascade', num2str(i),'(4)','.traces');
    try
        fid=fopen(filename);
        length = fread(fid,1,'int32');
        
        NumberTraces = fread(fid,1,'int16');
        Data = fread(fid,[NumberTraces+1 length],'int16');
        fclose(fid);
        size(Data)
        AveragedData = Data;
        for j=2:NumberTraces+1
            
            %size(AveragedData)
            for k=boxsize:length
                %ans = size(sum(Data(j,(1+k-box):k)))
                AveragedData(j,k) = sum(Data(j,(1+k-boxsize):k))/boxsize;
            end
            
            
        end
        size(AveragedData)
        
        Data = AveragedData;%return
        outputfilename = strcat('(box',num2str(boxsize),')cascade',num2str(i),'(4).traces');
        fid = fopen(outputfilename,'w');
        fwrite(fid,length,'int32');
        fwrite(fid,NumberTraces,'int16');
        fwrite(fid,Data,'int16');
        fclose(fid);
    catch
        output = strcat('No file named ', filename, ' found, or something else is wrong')
    end
end
    