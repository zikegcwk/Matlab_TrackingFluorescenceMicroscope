%% Marija Vrljic 13Oct2007
%% This converts iXon, Andor, spool.dat files to uncompressed tiff stacks.
%% Spool.dat corresponds to the individual frames of the movie, so a series
%% of spool.dat files in the folder represents all the frames of a single
%% movie. This combines all the frames into a single movie. Select
%% directory which has many subfolders (each subfolder has many spool.dat
%% files and represents one movie). Then, your movies will be saved as tiff
%% stacks with names corresponding to the subfolder file name. 


currentpath=('J:\');
datadir = uigetdir(currentpath,'Select data folder');
cd(datadir);
currentpath=cd();
dir_info=dir(datadir);
s=size(dir_info);
cd('..');
parentpath=cd();
[token,rem]=strtok(currentpath,parentpath);
cd(currentpath);

number=size(dir_info)
  
for j=3:number(1),
 if dir_info(j).isdir
    cd(dir_info(j).name); 
    datadir2=cd();
    dir_info2=dir(datadir2);
    s=size(dir_info2);
    NumFiles=s(1);
    
     file=dir_info(j).name;
     filename=[currentpath '\' file '.tif'];
     
fid=fopen('spool1.dat');
info=dir('spool1.dat');    
imagesizex=512;
imagesizey=info.bytes/imagesizex/2;
fclose(fid);

k=0;
wr_mode='overwrite';

for i=1:NumFiles
    display(i);
    temp=strfind(dir_info2(i).name,'spool');
    if isempty(temp) ==0  
        k=k+1;
        file=['spool' num2str(k) '.dat'];
        fid=fopen(file);
        img=fread(fid,[imagesizex,imagesizey],'*uint16');
        fclose(fid);
        imwrite(img,filename,'tiff','Compression','none','WriteMode',wr_mode);
        wr_mode = 'append';
    end
end

cd('..');

  end
end

