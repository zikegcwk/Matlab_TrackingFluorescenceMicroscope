function output = LinFRETfilter(filenumber1, filenumberlast, boxsize, threshold)
%This will be "fast-and-dirty" filtering. As cut-off, I'll use the standard
%deviation calculated over the whole trace as a sum of squares of deviations of real 
%data from the running average at this point, divided by number of points.
%Then the filter will check, if the signal in each channel deviates more
%than average at each point. When a signal in one channel deviates more
%than a threshold value, and in another channel it does not, the data in
%the first channel is averaged. Otherwise it is left to be.
%Threshold is expected to be 2-3
%Boxsizes of 2-? can be optimized based on frequency of transition relative
%to noise.
for i=filenumber1:filenumberlast
    filename = strcat('cascade', num2str(i),'(4)','.traces');
    try
        fid=fopen(filename);
        length = fread(fid,1,'int32');
        
        NumberTraces = fread(fid,1,'int16');
        Data = fread(fid,[NumberTraces+1 length],'int16');
        fclose(fid);
        AveragedData = Data;
        DeviationData = Data;
        StanDev = zeros(NumberTraces+1,1);
        for j=2:NumberTraces+1
            
     
            %size(AveragedData)
            for k=boxsize:length
                %ans = size(sum(Data(j,(1+k-box):k)))
                AveragedData(j,k) = sum(Data(j,(1+k-boxsize):k))/boxsize;
                DeviationData(j,k) = abs(Data(j,k)-AveragedData(j,k));
                %StanDev(j,1) = StanDev(j,1) + DeviationData(j,k);
                
            end
            StanDev(j,1) = sum(DeviationData(j,:))/(length-boxsize+1);
        end
%        Data(2,100:120)
%        DeviationData(2,100:120)
%        StanDev(2,1)
%         return
        for j=2:2:NumberTraces%+1
                for k=boxsize:length
                    if (DeviationData(j,k) > threshold*StanDev(j,1))&&(DeviationData(j+1,k) < threshold*StanDev(j+1,1))
                        Data(j,k) = AveragedData(j,k);
                        
                    elseif (DeviationData(j,k) < threshold*StanDev(j,1))&&(DeviationData(j+1,k) > threshold*StanDev(j+1,1))
                        Data(j+1,k) = AveragedData(j+1,k);
                    else
                    end
                    
                end
                
        end
     %size(Data)
        outputfilename = strcat('LFF',num2str(boxsize),'(',num2str(10*threshold),')cascade',num2str(i),'(4).traces');
        fid = fopen(outputfilename,'w');
        fwrite(fid,length,'int32');
        fwrite(fid,NumberTraces,'int16');
        fwrite(fid,Data,'int16');
        fclose(fid);
    catch
        output = strcat('No file named ', filename, ' found, or something else is wrong')
    end
end   