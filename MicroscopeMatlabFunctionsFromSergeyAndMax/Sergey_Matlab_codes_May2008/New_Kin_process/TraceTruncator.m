function output = TraceTruncator(filenumber1,filenumberlast,endpoint)
for i=filenumber1:filenumberlast
    filename = strcat('cascade', num2str(i),'(4)','.traces');
    try
        fid=fopen(filename);
        length = fread(fid,1,'int32');
        
        NumberTraces = fread(fid,1,'int16');
        Data = fread(fid,[NumberTraces+1 length],'int16');
        fclose(fid);
        TruncatedData = zeros(NumberTraces+1,endpoint);
        for j=1:NumberTraces+1
            TruncatedData(j,1:endpoint) = Data(j,1:endpoint);
        end
        outputfilename = strcat('(tr',num2str(endpoint),')cascade',num2str(i),'(4).traces');
        fid = fopen(outputfilename,'w');
        fwrite(fid,endpoint,'int32');
        fwrite(fid,NumberTraces,'int16');
        fwrite(fid,TruncatedData,'int16');
        fclose(fid);
    catch
        output = strcat('No file named ', filename, ' found, or something else is wrong')
    end
end   