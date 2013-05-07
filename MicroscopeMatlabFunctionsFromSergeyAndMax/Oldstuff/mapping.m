function varargout = gui3(varargin)



if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


% --------------------------------------------------------------------
function varargout = popupmenu2_Callback(hObject, eventdata, handles, varargin)
val = get(hObject,'Value');
switch val
case 1
    
     line(300,300,'marker','o','color','y','EraseMode','background','MarkerSize',20);
    
    
case 2 %Substract background 

   if get(handles.checkbox7,'Value')==1
        
        imagesizex=handles.i;
        imagesizey=handles.j;

        if imagesizex == 170
          den=5;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         set(handles.edit6,'String', 4.5);
        end


        for h=1:handles.numframes,
            for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = handles.movie_all(den*(i-1)+1:den*i,den*(j-1)+1:den*j,h);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
         end
         bg_image =  imresize(temp,[imagesizex imagesizey],'bilinear');
         handles.movie_all(:,:,h)=handles.movie_all(:,:,h)-bg_image;
        end

        low=min(min(handles.movie_all(:,:,1)));
        high=max(max(handles.movie_all(:,:,1)));
        colormap(jet);
        set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
        axes(handles.axes2);
        handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
        guidata(hObject,handles);
    
   elseif get(handles.checkbox8,'Value')==1
        tahis='not implemented yet'
    end


    
case 3 %Original image   
    set(handles.imagehandle,'CData',handles.image_t);

case 4 % last blue frame subtracted from all green and red frames
    
    blue_stop=sscanf(get(handles.edit14,'String'),'%d');
    green_start=sscanf(get(handles.edit15,'String'),'%d');
        
    blue=handles.movie_all(:,:,(blue_stop-1));
    
    for h=green_start:handles.numframes,
        handles.movie_all(:,:,h)=handles.movie_all(:,:,h)-blue;
    end

low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));
colormap(jet);
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);
handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
guidata(hObject,handles);

    
    

case 6 %Locating molecules based on donor image
    %signal-to-background noise should be higher than 20
    
    axes(handles.axes2);
    handles.threshold=sscanf(get(handles.edit1,'String'),'%d');
    nn=sscanf(get(handles.edit6,'String'),'%f');
    start_locate_don=sscanf(get(handles.edit19,'String'),'%d')
    
    fseek(handles.pmafile,((start_locate_don)*(handles.i*handles.j*2+2)+4),-1);
    got='here'
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16')';
    
    result=size(handles.movie_all(:,:,start_locate_don));
    
    imagesizex=handles.i;
    imagesizey=handles.j;

        if imagesizex == 170
          den=5;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         set(handles.edit6,'String', 4.5);
        end

        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    
        
        
    if handles.threshold == 0
        threshold = 7*std2(handles.background(1+3:result(1)-3,1+3:result(2)/2-3))
    else
        threshold = handles.threshold-mean2(handles.background);
    end

    m_number=0;
    for i=1+12:result(1)-12,
        for j=1+12:result(2)/2-12,
            if handles.movie_all(i,j,(start_locate_don))>threshold & handles.movie_all(i,j,(start_locate_don)) == max(max(handles.movie_all(i-1:i+1,j-1:j+1,(start_locate_don))))   %modified to include 5x5 instead of 3x3
                m_number=m_number+1;
                tempx(m_number)=j;
                tempy(m_number)=i;
            end
        end
    
    end
    
    overlap=zeros(1,m_number);
    for i=1:m_number,
        for j=i+1:m_number,
            if tempy(j)-tempy(i) > nn
                break;
            end
            if (tempx(i)-tempx(j))^2+(tempy(i)-tempy(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
            end
        end
    end

   %Text file printing of highest value
    if get(handles.checkbox5,'Value')==1
      file=strrep(handles.filename,'.pma','.txt');
    end
    
    if get(handles.checkbox6,'Value')==1
        file=strrep(handles.filename,'.pmb','.txt');
    end
    
    
    j=0;
     
    outputfile=fopen(file,'w');
   
    for i=1:m_number,             
        if overlap(i)==0
            j=j+1;
            x(2*j-1)=tempx(i);         
            y(2*j-1)=tempy(i);
            value=0;
            value2=0;
            
            
            %apply offset and find local maximum
           % x(2*j)=tempx(i)+result(2)/2+handles.xoffset;                    
           % y(2*j)=tempy(i)+handles.yoffset;
           % temp=handles.movie_all(y(2*j)-1:y(2*j)+1,x(2*j)-1:x(2*j)+1,(start_locate_don));
           % maxy=2;  % inserted here because line above gives trouble need to fix later
           % maxx=2; % inserted here because line above gives trouble need to fix later
           % x(2*j)=x(2*j)+maxx-2;
           % y(2*j)=y(2*j)+maxy-2;
           % donor_points(j,:)=[x(2*j-1) y(2*j-1)];
           % acceptor_points(j,:)=[x(2*j) y(2*j)];
           % value=0;
          
           %This block adds 5x5 around located spot and then prints to a
           %file the values for histograms.
           
           
           % 5x5 integrated spot modified to resemble circle, matrix
           % handles.spot. "Value" represents integrated spots at a desired
           % frame, and "values2" integrated spots 6 frames later. This was
           % written for comparing calcein intensities in the last frame of
           % blue and the first frame of green (shutter switching seems to
           % take ~ 6 frames). 
           
                     
           handles.spot=[ 0 0 1 0 0
                   0 1 1 1 0
                   1 1 1 1 1
                   0 1 1 1 0
                   0 0 1 0 0];
                    
           spotx=1;
           for min_x=tempx(i)-2:tempx(i)+2
               spoty=1;
               for min_y=tempy(i)-2:tempy(i)+2
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_y,min_x,(start_locate_don))));
                value2=value2+(handles.spot(spotx,spoty)*(handles.movie_all(min_y,min_x,(start_locate_don+6))));
                spoty=spoty+1;
               end
              spotx=spotx+1;
            end
            
            fprintf(outputfile,'%f ',value); 
            fprintf(outputfile,'%f\n',value2);
        end
    end
   
    fclose(outputfile);
      
    if j>3  
        %tform = cp2tform(acceptor_points,donor_points,'affine')
        %f = tform.tdata.Tinv
        %disp(f);
        %delete(findobj(gcf,'type','line'));
        for i=1:j,
        %    points=[x(2*i-1) y(2*i-1) 1]*f
        %    points=round(points);
        %    x(2*i)=points(1);
        %    y(2*i)=points(2);
            
            line(x(2*i-1),y(2*i-1),'marker','o','color','y','EraseMode','background');
           % line(x(2*i),y(2*i),'marker','o','color','w','EraseMode','background');
        end
        
        handles.x=x;
        handles.y=y;
        handles.num=j;
        %handles.f=f;
        guidata(hObject,handles);    
    end
    
     
    
case 7 % Locate molecules based on acceptor image
  
    axes(handles.axes2);
    handles.threshold=sscanf(get(handles.edit2,'String'),'%d');
    nn=sscanf(get(handles.edit6,'String'),'%f');
    start_locate_acc=sscanf(get(handles.edit20,'String'),'%d')
    
    fseek(handles.pmafile,((start_locate_acc)*(handles.i*handles.j*2+2)+4),-1);
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16')';
    
    result=size(handles.movie_all(:,:,start_locate_acc));
    
    imagesizex=handles.i;
    imagesizey=handles.j;

        if imagesizex == 170
          den=5;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         set(handles.edit6,'String', 4.5);
        end

        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    if handles.threshold == 0
        threshold = 7*std2(handles.background(1+12:result(1)-12,result(2)/2+3:result(2)-12))
    else
        threshold = handles.threshold-mean2(handles.background)
    end

    m_number=0;
    for i=1+12:result(1)-12,
        for j=result(2)/2+12:result(2)-12,
            if handles.movie_all(i,j,(start_locate_acc))>threshold & handles.movie_all(i,j,(start_locate_acc)) == max(max(handles.movie_all(i-1:i+1,j-1:j+1,(start_locate_acc))))   %modified to include 5x5 instead of 3x3
                m_number=m_number+1;
                tempx(m_number)=j;
                tempy(m_number)=i;
            end
        end
    
    end
    
    overlap=zeros(1,m_number);
    for i=1:m_number,
        for j=i+1:m_number,
            if tempy(j)-tempy(i) > nn
                break;
            end
            if (tempx(i)-tempx(j))^2+(tempy(i)-tempy(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
            end
        end
    end

   
    
    j=0;
    for i=1:m_number,             
        if overlap(i)==0
            j=j+1;
            x(2*j)=tempx(i);         
            y(2*j)=tempy(i);
            
            %apply offset and find local maximum
            x(2*j)=tempx(i)+handles.xoffset;                    
            y(2*j)=tempy(i)+handles.yoffset;
            
            %temp=handles.movie_all(y(2*j)-1:y(2*j)+1,x(2*j)-1:x(2*j)+1,(start_locate_don));
            %[maxy, maxx]=find(temp==max(max(max(max(temp)))))   %error happens if there are 2 values when temp==max(temp)?
            maxy=2;  % inserted here because line above gives trouble need to fix later
            maxx=2; % inserted here because line above gives trouble need to fix later
            
            x(2*j)=x(2*j)+maxx-2;
            y(2*j)=y(2*j)+maxy-2;
            donor_points(j,:)=[x(2*j-1) y(2*j-1)];
            acceptor_points(j,:)=[x(2*j) y(2*j)];
            value=0;
                       
      
            
        end
    end
  
    
    if j>3  
     %   tform = cp2tform(acceptor_points,donor_points,'affine');
     %   f = tform.tdata.Tinv;
     %   disp(f);
       % delete(findobj(gcf,'type','line'));
        for i=1:j,
     %       points=[x(2*i-1) y(2*i-1) 1]*f;
     %       points=round(points);
            
     %       x(2*i)=points(1);
     %       y(2*i)=points(2);
            
          %  line(x(2*i-1),y(2*i-1),'marker','o','color','w','EraseMode','background');
         
          
          line(x(2*i),y(2*i),'marker','o','color','w','EraseMode','background');
        end
        
        
        handles.x=x;
        handles.y=y;
        handles.num=j;
     %   handles.f=f;
        guidata(hObject,handles);    
    end
    
    
case 8
    if handles.i == 170
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 256
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 512
        squarewidth=5;
        NumPixels=16;
    end

    x=handles.x;
    y=handles.y;
    result=size(handles.image_t);
    %now read the real data

    regions=zeros(NumPixels,2,2*handles.num);
    regions_corr=zeros(NumPixels,2,2*handles.num);
    centroid=zeros(squarewidth,squarewidth);

    for m=1:2*handles.num,
        peak=handles.image_t(y(m)-floor(squarewidth/2):y(m)+floor(squarewidth/2),...
            x(m)-floor(squarewidth/2):x(m)+floor(squarewidth/2));
        center=reshape(peak,squarewidth*squarewidth,1);
        center=sort(center);
        [I,J]=find(peak>=center(squarewidth*squarewidth-NumPixels+1));
        A=I(1:NumPixels);
        B=J(1:NumPixels);
        regions(:,:,m)=[A+y(m)-floor(squarewidth/2)-1,B+x(m)-floor(squarewidth/2)-1];
        if mod(m,2)==1
            centroid=centroid+peak;
        end
        
        temp_traces = handles.movie(y(m)-floor(squarewidth/2):y(m)+floor(squarewidth/2),...
            x(m)-floor(squarewidth/2):x(m)+floor(squarewidth/2),:);
        mean_temp=mean(temp_traces,3);      
        max_mean=max(max(mean_temp));
        temp_center_trace = repmat(temp_traces(3,3,:),[2*floor(squarewidth/2)+1 2*floor(squarewidth/2)+1]);
        tempcorr = mean(temp_traces.*temp_center_trace,3)./(mean_temp*max_mean)-1;
    
        peak=10000*tempcorr;
        center=reshape(peak,squarewidth*squarewidth,1);
        center=sort(center);
        [I,J]=find(peak>=center(squarewidth*squarewidth-NumPixels+1));
        A=I(1:NumPixels);
        B=J(1:NumPixels);
        regions_corr(:,:,m)=[A+y(m)-floor(squarewidth/2)-1,B+x(m)-floor(squarewidth/2)-1];
    end
%--------------------------------------------------------------------------
% this will only work when handles.num is defined to be larger than 3
    fseek(handles.pmafile,4,-1);
    filename=strrep(handles.filename,'.pma',['(' num2str(NumPixels) ').traces']);
    filename_corr=strrep(handles.filename,'.pma',['(' num2str(NumPixels) 'corr).traces']);    
    current=cd;
    cd ..;
    parent=cd;
    newdir = [current(length(parent)+1:end) '(traces)'];
    arg = ['mkdir ' newdir];
    dummy = dos(arg);
    cd(newdir);
    
    fid = fopen(filename,'w');
    fid_corr = fopen(filename_corr,'w');
    
    fwrite(fid,handles.NumFrames,'int32');
    fwrite(fid,2*handles.num,'int16');
    
    fwrite(fid_corr,handles.NumFrames,'int32');
    fwrite(fid_corr,2*handles.num,'int16');    
    
    temp = repmat(uint16(0), result(1), result(2));
    temp2 = repmat(uint16(0), result(1), result(2));
    traces = zeros(1+2*handles.num,handles.NumFrames);
    traces_corr = zeros(1+2*handles.num,handles.NumFrames);
    for k=1:handles.NumFrames,
 
        traces(1,k)=fread(handles.pmafile,1,'uint16');
        traces_corr(1,k)=traces(1,k);
        temp2=fread(handles.pmafile,[result(1), result(2)],'uint16');
        temp=temp2'-handles.background;
  
        for m=1:2*handles.num,
            traces(m+1,k)=trace(temp(regions(:,1,m),regions(:,2,m)));
            traces_corr(m+1,k)=trace(temp(regions_corr(:,1,m),regions_corr(:,2,m)));
        end  
        fwrite(fid,traces(1:1+2*handles.num,k),'int16'); 
        fwrite(fid_corr,traces_corr(1:1+2*handles.num,k),'int16'); 
        set(handles.edit5,'String',int2str(100*k/handles.NumFrames));
        drawnow;
    end
    fclose(fid);
    fclose(fid_corr);
    cd(current);


case 80 %Save traces (switch to 8 to use this feature)
    %for 512X512, use squarewidth of 5 and NumPixels of 16
        
    if handles.i == 170
        handles.squarewidth=3;
        handles.NumPixels=5;
    elseif handles.i == 256
        handles.squarewidth=3;
        handles.NumPixels=4;
    elseif handles.i == 512
        handles.squarewidth=5;
        handles.NumPixels=16;
    end
    

    handles.hf=figure('position',[1          29        1024         672]);
    
    handles.hb_accept=uicontrol('Units','characters','Position',[98 28 15 3],'Style','pushbutton','String','Accept');    
    handles.hb_reject=uicontrol('Units','characters','Position',[98 24 15 3],'Style','pushbutton','String','Reject');
    
    set(handles.hb_accept,'Callback','gui3(''Accept_Callback'',gcbo,''yes'',guidata(gcbo))');
    set(handles.hb_reject,'Callback','gui3(''Accept_Callback'',gcbo,''no'',guidata(gcbo))');

    %openfig('gui3_sub.fig');
    subplot(2,2,1);
    handles.h_dimage = imshow(zeros(5,5));
    colormap(original);
    handles.ha_dimage = gca;
    set(handles.ha_dimage,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    handles.ht_d = text(1:handles.NumPixels,1:handles.NumPixels,'+','color',[0 1 0]);
    subplot(2,2,2);
    handles.h_aimage = imshow(zeros(5,5));
    colormap(original);
    handles.ha_aimage= gca;
    set(handles.ha_aimage,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    handles.ht_a = text(1:handles.NumPixels,1:handles.NumPixels,'+','color',[0 1 0]);
    subplot(2,2,3);
    handles.h_dcimage = imshow(zeros(5,5));
    colormap(original);
    handles.ha_dcimage = gca;
    handles.ht_dc = text(1:handles.NumPixels,1:handles.NumPixels,'+','color',[0 1 0]);
    subplot(2,2,4);
    handles.h_acimage = imshow(zeros(5,5));
    colormap(original);
    handles.ha_acimage = gca;
    handles.ht_ac = text(1:handles.NumPixels,1:handles.NumPixels,'+','color',[0 1 0]);
    pixval on;
    m=0;
    handles.m=m;
    handles.no_saved=m;
    handles.regions=zeros(handles.NumPixels,2,2*handles.num);
    
    guidata(h,handles);
    guidata(handles.hb_accept,handles);
    Accept_Callback(handles.hb_accept,'no',guidata(handles.hb_accept));    
    
case 5 % Finding the offset between donor and acceptor images
    
    
case 9 % For batch analysis on the entire directory based on donor molecules
    

case 10 % batch analysis on the entire directory based on acceptor molecules
    

case 11 % generates file information
    
        
case 12 % pick random background spots that are not above threshold
   
case 13 %save the total intensity decay of a movie.
  
case 14
  
case 15
   

case 16
    
    
    



end


% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(hObject, eventdata, handles, varargin)
global movieon;
fclose all;

if get(handles.checkbox5,'Value')==1
[datafile,datapath]=uigetfile('*.pma','Choose a PMA file');
end

if get(handles.checkbox6,'Value')==1 
[datafile,datapath]=uigetfile('*.pmb','Choose a PMA file');
end

if datafile==0, return; end

cd(datapath);
handles.pmafile=fopen(datafile,'r');
handles.filename=datafile;
imagesizex=fread(handles.pmafile,1,'uint16');
imagesizey=fread(handles.pmafile,1,'uint16');

s=dir(datafile);
NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2);
handles.movie_all = zeros(imagesizey, imagesizex, NumFrames);

for k=1:NumFrames,
    frame_no(k,1)=fread(handles.pmafile,1,'uint16');
    handles.movie_all(:,:,k) = fread(handles.pmafile,[imagesizex, imagesizey],'uint16')';
end


% Show first frame
handles.displayframe=1;
handles.numframes=NumFrames;

set(handles.edit9,'String',int2str(handles.displayframe));

low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));
high=ceil(high*1.5);
set(handles.slider1,'min',low);
set(handles.slider1,'max',high);
set(handles.slider1,'value',(high/4));
colormap(jet);
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);
handles.imagehandle=imshow(handles.movie_all(:,:,1),[low high]);

high=handles.numframes;
low=1;
set(handles.slider2,'SliderStep',[0.01 0.1]);
set(handles.slider2,'min',low);
set(handles.slider2,'max',high);

if (get(handles.slider2,'value')) > high
    set(handles.slider2,'value',(high));
end

if (get(handles.slider2,'value')) < low
    set(handles.slider2,'value',(low));
end

handles.xoffset=0;
handles.yoffset=0;
handles.i=imagesizex;
handles.j=imagesizey;

guidata(hObject,handles);
pixval on;
movieon=0;



function pushbutton8_Callback(hObject, eventdata, handles)
    if handles.displayframe<handles.numframes 
        handles.displayframe=handles.displayframe+1;
    end
low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));

colormap(jet);
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);
handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
set(handles.edit9,'String',int2str(handles.displayframe));
set(handles.slider2,'value',(handles.displayframe));
guidata(hObject,handles);



function pushbutton6_Callback(hObject, eventdata, handles)
    if handles.displayframe>1 
        handles.displayframe=handles.displayframe-1;
    end
low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));
%high=ceil(high*1.5);
%set(handles.slider1,'min',low);
%set(handles.slider1,'max',high);
%set(handles.slider1,'value',(high/4));

colormap(jet);
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);
handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
set(handles.edit9,'String',int2str(handles.displayframe));
set(handles.slider2,'value',(handles.displayframe));
guidata(hObject,handles);


function edit9_Callback(hObject, eventdata, handles)

handles.displayframe=sscanf(get(handles.edit9,'String'),'%d');

if handles.displayframe > handles.numframes 
    handles.displayframe=handles.numframes
end

if handles.displayframe < 1 
    handles.displayframe=1
end

  
    low=min(min(handles.movie_all(:,:,1)));
    high=max(max(handles.movie_all(:,:,1)));
    colormap(jet);
    set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    axes(handles.axes2);
    handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
    set(handles.edit9,'String',int2str(handles.displayframe));
    set(handles.slider2,'value',(handles.displayframe));
    guidata(hObject,handles);

    
    
function varargout = slider2_Callback(hObject, eventdata, handles, varargin)

high=handles.numframes;
low=1;
set(handles.slider2,'SliderStep',[0.01 0.1]);

if (get(handles.slider2,'value')) > high
    set(handles.slider2,'value',(high));
end

if (get(handles.slider2,'value')) < low
    set(handles.slider2,'value',(low));
end

handles.displayframe=round(get(handles.slider2,'value'));

    low=min(min(handles.movie_all(:,:,1)));
    high=max(max(handles.movie_all(:,:,1)));
    colormap(jet);
    set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    axes(handles.axes2);
    handles.imagehandle=imshow(handles.movie_all(:,:,handles.displayframe),[low get(handles.slider1,'value')]);
    set(handles.edit9,'String',int2str(handles.displayframe));
    guidata(hObject,handles);

guidata(hObject,handles);



% --------------------------------------------------------------------
function varargout = slider1_Callback(h, eventdata, handles, varargin)

high=get(handles.slider1,'max');
low=get(handles.slider1,'min');
set(handles.slider1,'SliderStep',[0.01 0.1]);

if (get(handles.slider1,'value')) > high
    set(handles.slider1,'value',(high));
end

if (get(handles.slider1,'value')) < low
    set(handles.slider1,'value',(low));
end

set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);






% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
threshold=sscanf(get(handles.edit1,'String'),'%d');
handles.threshold=threshold;
guidata(h, handles);

% --- Executes on button press in pushbutton2.
% this routine is for 128X128 ixon by andor technology
function pushbutton2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

threshold=sscanf(get(handles.edit2,'String'),'%d');
handles.threshold1=threshold;
guidata(hObject, handles);


% --------------------------------------------------------------------
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(jet);

% --------------------------------------------------------------------
function jet_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(jet);

% --------------------------------------------------------------------
function hot_Callback(hObject, eventdata, handles)
% hObject    handle to hot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(hot);

% --------------------------------------------------------------------
function gray_Callback(hObject, eventdata, handles)
% hObject    handle to gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(gray);

% --------------------------------------------------------------------
function cool_Callback(hObject, eventdata, handles)
% hObject    handle to cool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(cool);

% --------------------------------------------------------------------
function copper_Callback(hObject, eventdata, handles)
% hObject    handle to copper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(copper);

% --------------------------------------------------------------------
function pink_Callback(hObject, eventdata, handles)
% hObject    handle to pink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(pink);

% --------------------------------------------------------------------
function spring_Callback(hObject, eventdata, handles)
% hObject    handle to spring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(spring);

% --------------------------------------------------------------------
function summer_Callback(hObject, eventdata, handles)
% hObject    handle to summer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(summer);

% --------------------------------------------------------------------
function autumn_Callback(hObject, eventdata, handles)
% hObject    handle to autumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(autumn);

% --------------------------------------------------------------------
function winter_Callback(hObject, eventdata, handles)
% hObject    handle to winter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(winter);


% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function copy_Callback(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print -dmeta -noui;

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --------------------------------------------------------------------
function play_Callback(hObject, eventdata, handles)
    global movieon;
    if movieon==0
        movieon=1;
        set(hObject,'Label','Stop Movie');
        fseek(handles.pmafile,4,-1);
        temp=zeros(512,512);
        for k=1:handles.numframes,
            fread(handles.pmafile,1,'uint16');
            temp=fread(handles.pmafile,[handles.i, handles.j],'uint16');
            temp=temp';
            set(handles.imagehandle,'CData',temp);
            set(handles.edit5,'String',int2str(k));
            drawnow;
            if movieon==0 break; end
            
        end
        movieon=0;
        set(hObject,'Label','Play Movie');
    elseif movieon==1
        movieon=0;
        set(hObject,'Label','Play Movie');
    end
    
        


% --------------------------------------------------------------------
function saveavi_Callback(hObject, eventdata, handles)

    prompt = {'Begin at :','End at :'}; 
    dlg_title = 'Frame Info.';
    num_lines= 1;
    def     = {'1',num2str(handles.NumFrames)};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);

    
    if get(handles.checkbox5,'Value')==1
    aviobj=avifile(strrep(handles.filename,'.pma','.avi'),'compression','indeo5','fps',10); 
    elseif get(handles.checkbox6,'Value')==1
    aviobj=avifile(strrep(handles.filename,'.pmb','.avi'),'compression','indeo5','fps',10); 
    end
    

    fseek(handles.pmafile,4+(max([1 sscanf(answer{1},'%d')])-1)*(handles.i*handles.j*2+2),-1);
    for k=max([1 sscanf(answer{1},'%d')]):min([handles.NumFrames sscanf(answer{2},'%d')]),
        fread(handles.pmafile,1,'uint16');
        temp=fread(handles.pmafile,[handles.i, handles.j],'uint16');
        temp=temp';
        set(handles.imagehandle,'CData',temp);
        F=getframe(handles.axes2);
        aviobj=addframe(aviobj,F);
    end
    aviobj=close(aviobj); 



function checkbox1_Callback(hObject, eventdata, handles)


function checkbox5_Callback(hObject, eventdata, handles)
if get(handles.checkbox5,'Value')==1
set(handles.checkbox6,'Value',0);
end
guidata(hObject, handles);

function checkbox6_Callback(hObject, eventdata, handles)
if get(handles.checkbox6,'Value')==1
set(handles.checkbox5,'Value',0);
end
guidata(hObject, handles);

function checkbox7_Callback(hObject, eventdata, handles)
if get(handles.checkbox7,'Value')==1
set(handles.checkbox8,'Value',0);
end
guidata(hObject, handles);

function checkbox8_Callback(hObject, eventdata, handles)
if get(handles.checkbox8,'Value')==1
set(handles.checkbox7,'Value',0);
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function zoom_Callback(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom;

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pixval;

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

function Accept_Callback(hObject, answer, handles)
m=handles.m;
p=handles.no_saved;
x=handles.x;
y=handles.y;

if m == handles.num
    fseek(handles.pmafile,4,-1);
    filename=strrep(handles.filename,'.pma',['(' num2str(handles.NumPixels) ').traces']);
    current=cd;
    cd ..;
    parent=cd;
    newdir = [current(length(parent)+1:end) '(traces)'];
    arg = ['mkdir ' newdir];
    dummy = dos(arg);
    cd(newdir);
    
    fid = fopen(filename,'w');
    fwrite(fid,handles.NumFrames,'int32');
    fwrite(fid,p,'int16');
    
    temp = repmat(uint16(0), handles.i, handles.j);
    temp2 = repmat(uint16(0), handles.i, handles.j);
    traces = zeros(1+2*handles.num,handles.NumFrames);
    for k=1:handles.NumFrames,
        traces(1,k)=fread(handles.pmafile,1,'uint16');
        temp2=fread(handles.pmafile,[handles.i handles.j],'uint16');
        temp=temp2'-handles.background;
  
        for n=1:p,
            traces(n+1,k)=trace(temp(handles.regions(:,1,n),handles.regions(:,2,n)));
        end  
        fwrite(fid,traces(1:1+p,k),'int16'); 
        
        set(handles.edit5,'String',int2str(100*k/handles.NumFrames));
        drawnow;
    end
    fclose(fid);
    cd(current);
    m=0;
    p=0;
    close(handles.hf);
else
    if strcmp(answer,'yes');
        p=p+1;   
        handles.regions(:,:,p)=[handles.A_d+y(2*m-1)-floor(handles.squarewidth/2)-1,handles.B_d+x(2*m-1)-floor(handles.squarewidth/2)-1];        
        p=p+1;
        handles.regions(:,:,p)=[handles.A_a+y(2*m)-floor(handles.squarewidth/2)-1,handles.B_a+x(2*m)-floor(handles.squarewidth/2)-1];                
    end
    m=m+1;    
    image_t = handles.image_t-handles.background+mean2(handles.background);
    result=size(handles.movie);
    d_traces = handles.movie(y(2*m-1)-2:y(2*m-1)+2,x(2*m-1)-2:x(2*m-1)+2,:);
    a_traces = handles.movie(y(2*m)-2:y(2*m)+2,x(2*m)-2:x(2*m)+2,:);
    %d_traces = reshape(handles.movie(y(2*m-1)-1:y(2*m-1)+1,x(2*m-1)-1:x(2*m-1)+1,:),9,result(3));
    %a_traces = reshape(handles.movie(y(2*m)-1:y(2*m)+1,x(2*m)-1:x(2*m)+1,:),9,result(3));    
    
    mean_d=mean(d_traces,3);
    mean_a=mean(a_traces,3);
    
    d_center_trace = repmat(d_traces(3,3,:),[5 5]);
    dcorr = mean(d_traces.*d_center_trace,3)./(mean_d*mean_d(3,3))-1;
    set(handles.h_dimage,'CData',image_t(y(2*m-1)-2:y(2*m-1)+2,x(2*m-1)-2:x(2*m-1)+2),'CDataMapping','scaled'); 
    
    a_center_trace = repmat(a_traces(3,3,:),[5 5]);
    acorr = mean(a_traces.*a_center_trace,3)./(mean_a*mean_a(3,3))-1;
    set(handles.h_aimage,'CData',image_t(y(2*m)-2:y(2*m)+2,x(2*m)-2:x(2*m)+2),'CDataMapping','scaled');
    
    set(handles.h_dcimage,'CData',dcorr*10000);
    set(handles.ha_dcimage,'CLim',[min(min(dcorr*10000)) max(max(dcorr*10000))]);
    
    set(handles.h_acimage,'CData',acorr*10000);
    set(handles.ha_acimage,'CLim',[min(min(acorr*10000)) max(max(acorr*10000))]);
    %    centroid=zeros(squarewidth,squarewidth);
    
    peak=10000*dcorr(2:4,2:4);
    center=reshape(peak,handles.squarewidth*handles.squarewidth,1);
    center=sort(center);
    [I,J]=find(peak>=center(handles.squarewidth*handles.squarewidth-handles.NumPixels+1));
    handles.A_d=I(1:handles.NumPixels);
    handles.B_d=J(1:handles.NumPixels);
    peak=10000*acorr(2:4,2:4);
    center=reshape(peak,handles.squarewidth*handles.squarewidth,1);
    center=sort(center);
    [I,J]=find(peak>=center(handles.squarewidth*handles.squarewidth-handles.NumPixels+1));
    handles.A_a=I(1:handles.NumPixels);
    handles.B_a=J(1:handles.NumPixels);
    for i=1:handles.NumPixels,
        set(handles.ht_d(i),'position',[handles.B_d(i)+1,handles.A_d(i)+1]);
        set(handles.ht_dc(i),'position',[handles.B_d(i)+1,handles.A_d(i)+1]);
        
        set(handles.ht_a(i),'position',[handles.B_a(i)+1,handles.A_a(i)+1]);
        set(handles.ht_ac(i),'position',[handles.B_a(i)+1,handles.A_a(i)+1]);
    end
    handles.m=m;
    handles.no_saved=p;
    guidata(hObject,handles);    
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%appears not to be doing much
function varargout = pushbutton9_Callback(h, eventdata, handles, varargin)
clear all







