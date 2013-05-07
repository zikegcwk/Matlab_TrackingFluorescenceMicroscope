function output = intensity_hist(prefix,filenumber1, filenumberlast)
%Outputs histograms of donor, acceptor and total intensity. Later add
%averaging by NLFF.
for i=filenumber1:filenumberlast
    try
        filename = strcat(prefix,'cascade', num2str(i),'(4).traces');

                fid=fopen(filename,'r');
                len=fread(fid,1,'int32');
                Ntraces=fread(fid,1,'int16');
                Data=fread(fid,[Ntraces+1 len],'int16');
                fclose(fid);
    catch
        errorrr = ['file ' num2str(i) ' does not exist, or is in the wrong format']
        continue
    end
        handles.donor_all = Data(2:2:end,:);
        handles.acceptor_all = Data(3:2:end,:);

        Intensity_bins = -3000:100:30000;
        Donor_hist = hist(handles.donor_all(:),Intensity_bins);
        Acceptor_hist = hist(handles.acceptor_all(:),Intensity_bins);
        Total_I_hist = Donor_hist+Acceptor_hist;
        B = [Intensity_bins' Donor_hist' Acceptor_hist' Total_I_hist'];
        save(strcat(prefix,'cascade',num2str(i),'(IntensityDIST).dat'),'B','-ascii');
end