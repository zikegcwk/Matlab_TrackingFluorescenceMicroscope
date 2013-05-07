function  output = Keqdist(prefix,filenumber1,filenumberlast,limits,minlength)
% Collects time in low and high FRET for each molecule, calculates Keq and plots a histogram of
% Keq's and dG's. dG as defined is for unfolding, needs to be plotted with "-" sign.
%Limits is the largest (and correspondingly, smallest) Keq I can measure on
%a trace. Most simply to define this as an average trace length (in
%frames), implying that I can measure Keq=Nframes(total)-1/1.
%Minlength is in seconds!
MergedHist = [];
for i=filenumber1:filenumberlast
    filename = strcat(prefix, 'cascade', num2str(i),'(4).dat');
    try
        KeqHist = [];
        Kin = importdata(filename);
        k=1;
        TimeLow(k,1) = 0;
        TimeHigh(k,1) = 0;
        Keq(k,1) = 0;
        for j=2:(length(Kin))
                        
            if Kin(j,1)==0
%                 
                TimeLow(k,1) = TimeLow(k,1) + (isfinite(Kin(j,2))*Kin(j,2));
%                 isfinite(Kin(j,2))
%                 isfinite(Kin(j,3))
%                 return
            elseif Kin(j,1)==3
                TimeHigh(k,1) = TimeHigh(k,1) + (isfinite(Kin(j,2))*Kin(j,2));
                
            elseif Kin(j,1)==9&&Kin(j,2)==9
                if (TimeLow(k,1)+TimeHigh(k,1))>(1000*minlength/Kin(1,2))
                    if (TimeLow(k,1) ~=0)&&(TimeHigh(k,1))~=0
                        Keq(k,1) = TimeHigh(k,1)/TimeLow(k,1);
                        LogKeq(k,1) = log10(Keq(k,1));
                        dG(k,1) = -0.585*log(Keq(k,1));
                    elseif TimeHigh(k,1) == 0
                        Keq(k,1) = 0;
                        LogKeq(k,1) = -log10(limits);
                        dG(k,1) = 0.585*log(limits);
                    elseif TimeLow(k,1) == 0
                        Keq(k,1) = limits;
                        LogKeq(k,1) = log10(limits);
                        dG(k,1) = -0.585*log(limits);
                    else 
                        Keq(k,1) = NaN;
                        dG(k,1) = NaN;
                    end
                k=k+1;
                TimeLow(k,1) = 0;
                TimeHigh(k,1) = 0;
                else
                end
%                 TimeAvLow(k,1)
%                 TimeHigh(k,1)
%                 TimeAvHigh(k,1)
                    %k=k+1;
                    TimeLow(k,1) = 0;
                    TimeHigh(k,1) = 0;
%                 return
            else
            end
        
            
        end

%         return
        KeqHist = [Keq LogKeq dG];
        MergedHist = [MergedHist;KeqHist];
        outputfilename = strcat('(KeqHist',num2str(minlength),')cascade',num2str(i),'(4).dat');
        fid = fopen(outputfilename,'w');
        fprintf(fid,'%4.4f %4.3f %4.3f\n',KeqHist');
        fclose(fid);
        hist(LogKeq) %When I start modifying the look of histograms, don't forget to color fisrt and last dwells differnet color.
    catch
        strcat('error, possibly file ',filename,'  missing')
    end
end
if filenumber1~=filenumberlast
    newfilename = strcat('(',num2str(filenumber1),'_',num2str(filenumberlast),')(KeqHist',num2str(minlength),').dat');
    fid = fopen(newfilename,'w');
    fprintf(fid,'%4.4f %4.3f %4.3f\n',MergedHist');
    fclose(fid)
else
end