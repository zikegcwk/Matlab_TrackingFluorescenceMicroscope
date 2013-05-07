function  output = kbleach(inputfilename,filenumber1,filenumberlast)
% Collects total  time in low and high FRET for each molecule, plots a histogram of
% and fits to a single-exponential. 
MergedHist = [];
for i=filenumber1:filenumberlast
    filename = strcat('(kinetics)',inputfilename, 'cascade', num2str(i),'(4).dat');
    try
        BleachHist = [];
        Kin = importdata(filename);
        k=1;
        TimeTotal(k,1) = 0;
        for j=2:(length(Kin))
                        
            if Kin(j,1)==0
%                 
                TimeTotal(k,1) = TimeTotal(k,1) + (isfinite(Kin(j,2))*Kin(j,2));
%                 isfinite(Kin(j,2))
%                 isfinite(Kin(j,3))
%                 return
            elseif Kin(j,1)==3
                TimeTotal(k,1) = TimeTotal(k,1) + (isfinite(Kin(j,2))*Kin(j,2));
                
            elseif Kin(j,1)==9&&Kin(j,2)==9
                if (TimeTotal(k,1))>0
                    
                    k=k+1;
                    
                    
                else
                end
%   
            end
        
            
        end

%         return
        BleachHist = TimeTotal;
        MergedHist = [MergedHist;BleachHist];
        outputfilename = strcat('(BleachHist',num2str(minlength),')cascade',num2str(i),'(4).dat');
        fid = fopen(outputfilename,'w');
        fprintf(fid,'%4.3f\n',BleachHist');
        fclose(fid);
        hist(LogKeq) %When I start modifying the look of histograms, don't forget to color fisrt and last dwells differnet color.
    catch
        strcat('error, possibly file ',filename,'  missing')
    end
end
if filenumber1~=filenumberlast
    newfilename = strcat('(',num2str(filenumber1),'_',num2str(filenumberlast),')(BleachHist)',').dat');
    fid = fopen(newfilename,'w');
    fprintf(fid,'%4.3f\n',MergedHist');
    fclose(fid)
else
end