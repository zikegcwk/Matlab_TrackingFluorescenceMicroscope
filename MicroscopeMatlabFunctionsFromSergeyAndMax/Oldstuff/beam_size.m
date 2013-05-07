
fclose all;
[datafile,datapath]=uigetfile('*.pm*','Choose a PMA or PMB file');
if datafile==0, return; end
cd(datapath);
handles.pmafile=fopen(datafile,'r');
handles.filename=datafile;
imagesizex=fread(handles.pmafile,1,'uint16');
imagesizey=fread(handles.pmafile,1,'uint16');
s=dir(datafile);
handles.movie_all = zeros(imagesizey, imagesizex,1);
frame_no=fread(handles.pmafile,1,'uint16');
handles.movie_all(:,:) = fread(handles.pmafile,[imagesizex, imagesizey],'uint16')';

handles.displayframe=1;
colormap(jet); 
left=handles.movie_all(12:500,18:244)-62;
%middlex=handles.movie_all(256,1:256);
%h=plot(middlex);

mean(handles.movie_all(:,260:510));


s=surf(left(:,:,1));
set(s,'LineStyle','none');
axis tight;
%a  = gaussfit(left,'2d',0.1,'n')
%plotgaussfit(a(1,1:6),left(:,:,1),0.1,'n');

%fit_ML_normal(middlex)
%plot_normal(middlex,fit_ML_normal(middlex),gca,1,9)
  
handles.imagehandle=imshow(left(:,:),[0 120]);
colormap(jet);
pixval on;

   
