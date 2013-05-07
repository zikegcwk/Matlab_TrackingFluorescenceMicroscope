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

    
    imagesizex=handles.i;
    imagesizey=handles.j;
    
   
   if get(handles.checkbox7,'Value')==1
       handles.filename_old=handles.filename;
       
       if get(handles.checkbox5,'Value')==1
            file=strrep(handles.filename,'.pma','.background');
        end
    
        if get(handles.checkbox6,'Value')==1
            file=strrep(handles.filename,'.pmb','.background');
        end
        
        if get(handles.checkbox9,'Value')==1
           return;
        end
        
        
        
        file;
        handles.filename=file;
        outputfile=fopen(file,'w');
       
        
        fwrite(outputfile,imagesizex,'uint16');
        fwrite(outputfile,imagesizey,'uint16');
        
        if imagesizex == 128
          den=8;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         set(handles.edit6,'String', 4.5);
        end

        

        for h=1:handles.numframes,
          handles.movie_all=read_frame(handles.filename_old,h,hObject); 
          
           for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = handles.movie_all(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(16)); % replaced pixel 16 with 100
                  %just for checking histograms of background
                  %of 16x16
                  %hist(sort_temp2,50);
                  %set(gca,'YLim',[0 20]);               
                  %set(gca,'XLim',[1000 1500]);
                  
                 
              end
           end
          
             
             %hist(temp(:,:),50);
             %set(gca,'YLim',[0 35]);               
             %set(gca,'XLim',[1000 1800]);
             %pause
           
           
         outputfile=fopen(file,'a');
         bg_image =  imresize(temp,[imagesizex imagesizey],'bilinear');
         stand=std2(bg_image);
         handles.movie_all(:,:)=handles.movie_all(:,:)-bg_image;
         fwrite(outputfile,h,'uint16');
         fwrite(outputfile,handles.movie_all(:,:),'uint16');
         end

        low=min(min(handles.movie_all(:,:)));
        high=max(max(handles.movie_all(:,:)));
        set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
        axes(handles.axes2);
        fclose all;

                     
        handles.movie_all=read_frame(file,handles.displayframe,hObject);
        handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low get(handles.slider1,'value')]);
        guidata(hObject,handles);
    
   elseif get(handles.checkbox8,'Value')==1
        tahis='not implemented yet'
   end

    fclose all;
    
    
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
    
    
    load './beads_map_file.dat';
    f=beads_map_file;

    fclose all;
    axes(handles.axes2);
    handles.threshold=sscanf(get(handles.edit1,'String'),'%d');
    start_locate_don=sscanf(get(handles.edit19,'String'),'%d');
    
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pma')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'pmb')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'background')==1
     
        
        
        file=strrep(handles.filename,'.background','.pma');
        
        if fopen(file,'r')==-1
          file=strrep(handles.filename,'.background','.pmb');
        end
        
        handles.pmafile=fopen(file,'r');
    
    else
     message='Do not have a file to open not pmb or background file' 
    end
    
    handles.filename
    handles.pmafile
    
    
    fseek(handles.pmafile,(start_locate_don*(handles.i*handles.j*2+2)+4)-(512*512*2),-1);
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16');
    
       
    result=size(handles.movie_all(:,:));
    imagesizex=handles.i;
    imagesizey=handles.j;

        if imagesizex == 128
          den=8;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         set(handles.edit6,'String', 4.5);  % change here the number of pixels for overlap
        end

        nn=sscanf(get(handles.edit6,'String'),'%f');
        
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(16)); % changed pixel number after sort to 100 from 16
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    fclose all;
    
    handles.movie_all=read_frame(handles.filename,start_locate_don,hObject); 
    
    if strcmp(extension,'pma')==1 | strcmp(extension,'pmb')==1
     handles.movie_all(:,:)=handles.movie_all(:,:)-handles.background;
     %handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
     
%      %added on Feb25
        low=min(min(handles.movie_all(:,:)));
        high=max(max(handles.movie_all(:,:)));
        set(handles.slider1,'min',low);
        set(handles.slider1,'max',high);
        set(handles.slider1,'value',round(((high-low)*0.25)+low));
        set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);

       handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
    end
   
    %Calculate median of the background of the new background substracted image
        
       for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp3 = handles.movie_all(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp4 = reshape(sort_temp3,1,den*den);
                  sort_temp4 = sort(sort_temp4);
                  temp2(i,j) = sort_temp4(floor(16)); % chnaged pixel number after sort from 16 to 100
              end
       end
        
%        background2= imresize(temp2,[imagesizex imagesizey],'bilinear');
%        a=mean2(background2(1:256,1:512))
%        if a<0 
%            a=1;
%        end
       
      linear_image=reshape(handles.movie_all(1:(imagesizex/2),1:imagesizey),1,(imagesizex*(imagesizey/2)));
      a=median(linear_image)
        
     if handles.threshold == 0
        threshold = (1 * a) + std2(handles.background(5:((imagesizex/2)-5),5:(imagesizey-5)))
        %threshold2 = (a * 49) + (5 * std2(handles.background(5:((imagesizex/2)-5),5:(imagesizey-5))))
        %threshold2 = (a) + (5 * std2(handles.background(5:((imagesizex/2)-5),5:(imagesizey-5))))
         threshold = handles.threshold
         got='here'
     else
        threshold = (4* a) + handles.threshold*std2(handles.background(5:((imagesizex/2)-5),5:((imagesizey-5))))
        %threshold2 = (a * 49) + (5 * handles.threshold*std2(handles.background(5:((imagesizex/2)-5),5:(imagesizey-5))))
        %threshold2 = (a) + (5 * std2(handles.background(5:((imagesizex/2)-5),5:(imagesizey-5))))
        threshold2=0;
        threshold = handles.threshold
     end
       
     
     
     
          
     
     
    m_number=0;
    for i=5:((imagesizex/2)-5),
        for j=5:(imagesizey-5),
            if handles.movie_all(i,j)>threshold & handles.movie_all(i,j) == max(max(handles.movie_all(i-2:i+2,j-2:j+2)))   
                m_number=m_number+1;
                don_x(m_number)=i;
                don_y(m_number)=j;
                %line(don_x(m_number),don_y(m_number),'marker','o','color','w','EraseMode','background');  
            end
        end
    
    end
    
    
    m_number
    % creating mass threshold
    handles.spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];            
    
    overlap=zeros(1,m_number);         
    
    
    for k=1:m_number
           value=0;   
           spotx=1;
           for min_x=don_x(k)-3:don_x(k)+3
               spoty=1;
               for min_y=don_y(k)-3:don_y(k)+3
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
           end
          
           
            if value > threshold2
             line(don_x(k),don_y(k),'marker','o','color','y','EraseMode','background'); 
            else
              overlap(k)=1;
            end
       
    end
    
    m_number
    
    for i=1:m_number,
        for j=i+1:m_number
                if (don_x(i)-don_x(j))^2+(don_y(i)-don_y(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
                end
        end
    end
    
    
    % creating new matrix of m_numbers, kicking out the ones that
    % overlapped
    l=0;
    for i=1:m_number,
        if overlap(i)==0
        l=l+1;
        don_x_new(l)=don_x(i);
        don_y_new(l)=don_y(i);
        end
    end
    m_number=l
    don_x=don_x_new(:);
    don_y=don_y_new(:);
    
    
    

    %2D gaussian fit (all donors)
  for k=1:m_number
    donor=handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5));
    a  = gaussfit(donor,'2d',1,'n');
    don_x(k)=don_x(k)+a(5);
    don_y(k)=don_y(k)+a(6);
  end
    
   %Text file printing of highest value
    
    %file=strrep(handles.filename,'.background','.donors');
    
    
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pmb')==1
     file=strrep(handles.filename,'.pmb','.donors');
    elseif strcmp(extension,'pma')==1
     file=strrep(handles.filename,'.pma','.donors');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.donors');
    end
    
   
    
    j=0;
    outputfile=fopen(file,'w');
   
    for k=1:m_number,             
        
          
            value=0;
           
            
            acc_x(k)=round(f(1,1) + f(2,1)*don_x(k) + f(3,1)*don_y(k) + f(4,1)*don_x(k)*don_y(k) + f(5,1)*don_x(k)*don_x(k) + f(6,1)*don_y(k)*don_y(k));
            acc_y(k)=round(f(1,2) + f(2,2)*don_x(k) + f(3,2)*don_y(k) + f(4,2)*don_x(k)*don_y(k) + f(5,2)*don_x(k)*don_x(k) + f(6,2)*don_y(k)*don_y(k));
            %line(don_x(k),don_y(k),'marker','o','color','c','EraseMode','background');  
            line(acc_x(k),acc_y(k),'marker','o','color','m','EraseMode','background'); 
    
            don_x(k)=round(don_x(k));
            don_y(k)=round(don_y(k));
            
            
                     
           %This block adds 5x5 around located spot and then prints to a
           %file the values for histograms.
           
           % 5x5 integrated spot modified to resemble circle, matrix
           % handles.spot. "Value" represents integrated spots at a desired
           % frame, and "values2" integrated spots 6 frames later. This was
           % written for comparing calcein intensities in the last frame of
           % blue and the first frame of green (shutter switching seems to
           % take ~ 6 frames). 
           
                     
           %handles.spot=[ 0 0 1 0 0
                   %0 1 1 1 0
                   %1 1 1 1 1
                   %0 1 1 1 0
                   %0 0 1 0 0];
                   
%             handles.spot= [0 0 0 0 1 0 0 0 0 
%        0 0 0 1 1 1 0 0 0
%        0 0 1 1 1 1 1 0 0
%        0 1 1 1 1 1 1 1 0
%        1 1 1 1 1 1 1 1 1
%        0 1 1 1 1 1 1 1 0
%        0 0 1 1 1 1 1 0 0
%        0 0 0 1 1 1 0 0 0
%        0 0 0 0 1 0 0 0 0];
       
       handles.spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];            
       
       
           spotx=1;
           
           for min_x=don_x(k)-3:don_x(k)+3
               spoty=1;
               for min_y=don_y(k)-3:don_y(k)+3
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                %If you want blue/green uncoment next line six frames later
                %value2=value2+(handles.spot(spotx,spoty)*(handles.movie_all(min_y,min_x,(start_locate_don+6))));
                spoty=spoty+1;
               end
              spotx=spotx+1;
            end
            
            fprintf(outputfile,'%f\n ',value); 
            %fprintf(outputfile,'%f\n',value2);
        
    end
   
    fclose(outputfile);
      
 handles.don_x=don_x(:);
 handles.don_y=don_y(:);
 handles.acc1_x=acc_x(:);
 handles.acc1_y=acc_y(:);
 handles.n_number=m_number;
 guidata(hObject,handles);
 
 set(handles.text20,'String',['#donors:',num2str(handles.n_number)]);
     
    
case 7 % Locate molecules based on acceptor image
    handles = guidata(hObject);
    axes(handles.axes2);
    imagesizex=handles.i;
    imagesizey=handles.j;
    
    handles.threshold=sscanf(get(handles.edit2,'String'),'%d');
    start_locate_don=sscanf(get(handles.edit19,'String'),'%d')
    start_locate_acc=sscanf(get(handles.edit20,'String'),'%d');
   
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pma')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'pmb')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'background')==1
   
        file=strrep(handles.filename,'.background','.pma');
        if fopen(file,'r')==-1
          file=strrep(handles.filename,'.background','.pmb');
        end
     
     handles.pmafile=fopen(handles.filename,'r');
    else
     message='Do not have a file to open not pma or pmb or background file' 
    end
    
    fseek(handles.pmafile,(start_locate_acc*(handles.i*handles.j*2+2)+4)-(imagesizex*imagesizey*2),-1);
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16');
    result=size(handles.movie_all(:,:));
    
    %handles.movie_all(350:360,373:380)
    
    
    value=0;
    value2=0;
    
    nn=sscanf(get(handles.edit6,'String'),'%f');
        if imagesizex == 128
          den=8;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=16;
         if nn==2
          set(handles.edit6,'String', 4.5);      % change here the number of pixels for overlap
         end
         
        end

    
        
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(16)); % changed pixel number from 16 to 100
              end
        end
     
   handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
   
   fclose all;
  
   handles.movie_all=read_frame(handles.filename,start_locate_acc,hObject); 
       
    if strcmp(extension,'pma')==1 | strcmp(extension,'pmb')==1
     handles.movie_all(:,:)=handles.movie_all(:,:)-handles.background;
     
        low=min(min(handles.movie_all(:,:)));
        high=max(max(handles.movie_all(:,:)));
        set(handles.slider1,'min',low);
        set(handles.slider1,'max',high);
        set(handles.slider1,'value',round(((high-low)*0.25)+low));
        set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);


     
     handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
     
    end     
   
   
    linear_image=reshape(handles.movie_all(((imagesizex/2)+1):imagesizex,1:imagesizey),1,(imagesizex*((imagesizey/2))));
    a=median(linear_image)
        
     if handles.threshold == 0
        threshold = (4 * a) + std2(handles.background(((imagesizex/2)+5):(imagesizex-5),5:(imagesizey-5)))
        threshold2 = (a * 49) + (5*std2(handles.background(((imagesizex/2)+5):(imagesizex-5),5:(imagesizey-5))))
     else
        threshold = (4 * a) + handles.threshold*std2(handles.background(((imagesizex/2)+5):(imagesizex-5),5:(imagesizey-5)))
        threshold2 = (a * 49) + (5 * handles.threshold*std2(handles.background(((imagesizex/2)+5):(imagesizex-5),5:(imagesizey-5))))
    end
       
     
            
 

% if handles.threshold == 0
%        threshold = 100*std2(handles.background(270:490,20:490))
%    else
%        %threshold = handles.threshold-mean2(handles.background);
%        threshold = handles.threshold*std2(handles.background(270:490,20:490));
%    end
%
%    if get(handles.checkbox10,'Value')==1 
%        treshold2 = 9 * mean2(handles.background(270:490,20:490))
%    end
    
        

      
    m_number=0;
    
        
    
     for i=((imagesizex/2)+5):(imagesizex-5)
         for j=5:(imagesizey-5)
                if handles.movie_all(i,j)>threshold & handles.movie_all(i,j) == max(max(handles.movie_all(i-3:i+3,j-3:j+3)))   %modified to include 5x5 instead of 3x3
                m_number=m_number+1;
                acc_x(m_number)=i;
                acc_y(m_number)=j;
            end
        end
    
    end
    
    m_number

% creating mass threshold
    handles.spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];            
    
    overlap=zeros(1,m_number);         
    
    
    for k=1:m_number
           value=0;   
           spotx=1;
           for min_x=acc_x(k)-3:acc_x(k)+3
               spoty=1;
               for min_y=acc_y(k)-3:acc_y(k)+3
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
           end
          
           
            if value > threshold2
             %line(acc_x(k),acc_y(k),'marker','o','color','y','EraseMode','background'); 
            else
              overlap(k)=1;
            end
       
    end


    
    for i=1:m_number,
        for j=i+1:m_number
                if (acc_x(i)-acc_x(j))^2+(acc_y(i)-acc_y(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
                end
        end
    end

  % creating new matrix of m_numbers, kicking out the ones that
    % overlapped
    l=0;
    for i=1:m_number,
        if overlap(i)==0
        l=l+1;
        acc_x_new(l)=acc_x(i);
        acc_y_new(l)=acc_y(i);
         %line(acc_x(i),acc_y(i),'marker','o','color','r','EraseMode','background');
        end
    end
    m_number=l
    acc_x=acc_x_new(:);
    acc_y=acc_y_new(:);
    
   
    
  %2D gaussian fit (all donors)
  
  for k=1:m_number
    acceptor=handles.movie_all((acc_x(k)-5):(acc_x(k)+5),(acc_y(k)-5):(acc_y(k)+5));
    a  = gaussfit(acceptor,'2d',1,'n');
    acc_x(k)=round(acc_x(k)+a(5));
    acc_y(k)=round(acc_y(k)+a(6));
    line(acc_x(k),acc_y(k),'marker','o','color','w','EraseMode','background');
  end

   
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pmb')==1
     file=strrep(handles.filename,'.pmb','.acceptors');
    elseif strcmp(extension,'pma')==1
     file=strrep(handles.filename,'.pma','.acceptors');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.acceptors');
    end
    outputfile=fopen(file,'w');
  
    spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];
  
    for k=1:m_number
     
      value=0;
        spotx=1;
            for min_x=acc_x(k)-3:acc_x(k)+3
               spoty=1;
               for min_y=acc_y(k)-3:acc_y(k)+3
                value=value+(spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
            end
            
            fprintf(outputfile,'%f\n ',value);
     
    end
    fclose(outputfile);
  
    
   % check for the matching between donors and acceptors
        
    l=0;
    
    for i=1:m_number
       for j=1:handles.n_number
          for k=(acc_x(i)-3):(acc_x(i)+3)
            for h=(acc_y(i)-3):(acc_y(i)+3)
              if handles.acc1_x(j)== k & handles.acc1_y(j)==h
              l=l+1;
              matched_x(l)=acc_x(i);
              matched_y(l)=acc_y(i);
              matched_don_x(l)=handles.don_x(j);
              matched_don_y(l)=handles.don_y(j);
             % line(matched_x(l),matched_y(l),'marker','o','color','y','EraseMode','background');
              line(matched_don_x(l),matched_don_y(l),'marker','o','color','b','EraseMode','background');
              end
            end
          end
        end
     
     
    end
    
    
    %write matched donor and acceptor pair
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pmb')==1
     file=strrep(handles.filename,'.pmb','.matched');
    elseif strcmp(extension,'pma')==1
     file=strrep(handles.filename,'.pma','.matched');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.matched');
    end
    
        
    outputfile2=fopen(file,'w');
  
    % writes file of integrated, matched acceptors
    for k=1:l
     if l==0
         break;
     end
     
     
      value2=0; 
      value3=0;
      spotx=1;
      handles.movie_all=read_frame(handles.filename,start_locate_acc,hObject); 
      
              for min_x=matched_x(k)-3:matched_x(k)+3
               spoty=1;
               for min_y=matched_y(k)-3:matched_y(k)+3
                value2=value2+(spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
                
               end
              spotx=spotx+1;
            end
         
      spotx=1;   
      handles.movie_all=read_frame(handles.filename,start_locate_don,hObject); 
            for min_x=matched_don_x(k)-3:matched_don_x(k)+3
               spoty=1;
               for min_y=matched_don_y(k)-3:matched_don_y(k)+3
                value3=value3+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
                
               end
              spotx=spotx+1;
            end
            
            
            fprintf(outputfile2,'%f  ',value3);
            fprintf(outputfile2,'%f\n',value2);
            
            
    end
    fclose(outputfile2);
    
    if l>0
    handles.matched_x=matched_x;
    handles.matched_y=matched_y;
    handles.matched_don_x=matched_don_x;
    handles.matched_don_y=matched_don_y;
    end
    
    handles.acc_x=acc_x;
    handles.acc_y=acc_y;
    
    handles.matched_number=l;
    handles.acceptor_number=m_number;
    guidata(hObject,handles);
    
    set(handles.text21,'String',['#acceptors:',num2str(handles.acceptor_number),' #matched:',num2str(handles.matched_number)]),
 
    
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
  
case 14  %Batch Bacground Substraction
  
    
    
    fclose all;
   % pma_files=dir('*.pmb');
    pma_files=dir('*.pma');
    number=size(pma_files)
    number(1)
    
    for i=1:number(1),
        datafile=pma_files(i).name;
        handles.pmafile=fopen(datafile,'r');
        handles.filename=datafile;
        s=dir(datafile);
        imagesizex=fread(handles.pmafile,1,'uint16');
        imagesizey=fread(handles.pmafile,1,'uint16');
        NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2)
        z='got here'
        handles.numframes=NumFrames;
        handles.i=imagesizex;
        handles.j=imagesizey;
        handles.xoffset=0;
        handles.yoffset=0; 
        handles.displayframe=1;
        guidata(hObject, handles);
        set(handles.popupmenu2,'Value',2);
        popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
       
    end  
     
    dir_info=dir
    number=size(dir_info)
  

    for j=3:number(1),
        if dir_info(j).isdir
            cd(dir_info(j).name); 
            set(handles.popupmenu2,'Value',14);
            popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
            cd ..;
        end
    end
    
    
    
case 15  %Save Traces Marija
 
 [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
 if strcmp(extension,'pmb')==1
 file=strrep(handles.filename,'.pmb','.traces');
 elseif strcmp(extension,'pma')==1
 file=strrep(handles.filename,'.pma','.traces');
 elseif strcmp(extension,'background')==1
 file=strrep(handles.filename,'.background','.traces');
 end
   
 outputfile=fopen(file,'w');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',i);
  fprintf(outputfile,'%i ',i);
 end
 
 for i=1:handles.acceptor_number
  fprintf(outputfile,'%i ',i);
 end
 
 for i=1:handles.matched_number
  fprintf(outputfile,'%i ',i);
  fprintf(outputfile,'%i ',i);
 end
 
 fprintf(outputfile,'\n');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',handles.don_x(i));
  fprintf(outputfile,'%i ',handles.acc1_x(i));
 end
 
 for i=1:handles.acceptor_number
  fprintf(outputfile,'%i ',handles.acc_x(i));
 end
 
 for i=1:handles.matched_number
  fprintf(outputfile,'%i ',handles.matched_don_x(i));
  fprintf(outputfile,'%i ',handles.matched_x(i));
 end
 
 fprintf(outputfile,'\n');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',handles.don_y(i));
  fprintf(outputfile,'%i ',handles.acc1_y(i));
 end
 
 for i=1:handles.acceptor_number
  fprintf(outputfile,'%i ',handles.acc_y(i));
 end
 
 for i=1:handles.matched_number
  fprintf(outputfile,'%i ',handles.matched_don_y(i));
  fprintf(outputfile,'%i ',handles.matched_y(i));
 end
 
 fprintf(outputfile,'\n');
 
  got='here'
 
 fclose all;
 
 for i=1:handles.numframes
 handles.movie_all=read_frame(handles.filename,i,hObject); 
 
 [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
 if strcmp(extension,'pmb')==1
 file=strrep(handles.filename,'.pmb','.traces');
 elseif strcmp(extension,'pma')==1
 file=strrep(handles.filename,'.pma','.traces');
 elseif strcmp(extension,'background')==1
 file=strrep(handles.filename,'.background','.traces');
 end
 outputfile=fopen(file,'a');
 
 fprintf(outputfile,'%i ',i); 
 
 got='here2'
 
  for k=1:handles.n_number,             
    value=0;
    spotx=1;
    for min_x=handles.don_x(k)-3:handles.don_x(k)+3
     spoty=1;
     for min_y=handles.don_y(k)-3:handles.don_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  
    
     got='here interm'
    
    
    value=0;
    spotx=1;
    for min_x=handles.acc1_x(k)-3:handles.acc1_x(k)+3
     spoty=1;
     for min_y=handles.acc1_y(k)-3:handles.acc1_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  end
  
  got='here3'
 
  
  for k=1:handles.acceptor_number,             
    value=0;
    spotx=1;
    for min_x=handles.acc_x(k)-3:handles.acc_x(k)+3
     spoty=1;
     for min_y=handles.acc_y(k)-3:handles.acc_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  end
  
   got='here4'
  
  for k=1:handles.matched_number,             
    value=0;
    spotx=1;
    for min_x=handles.matched_don_x(k)-3:handles.matched_don_x(k)+3
     spoty=1;
     for min_y=handles.matched_don_y(k)-3:handles.matched_don_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  
    
    
    value=0;
    spotx=1;
    for min_x=handles.matched_x(k)-3:handles.matched_x(k)+3
     spoty=1;
     for min_y=handles.matched_y(k)-3:handles.matched_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  end

 fprintf(outputfile,'\n'); 
 end
fclose all; 
 
    
   
case 16   %calcein calibration; comparing blue/green intensities
    
    fclose all;
    axes(handles.axes2);
    handles.threshold=sscanf(get(handles.edit1,'String'),'%d');
    start_locate_don=sscanf(get(handles.edit19,'String'),'%d');
    
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pma')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'pmb')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.pmb');
     handles.pmafile=fopen(file,'r');
    else
     message='Do not have a file to open not pmb or background file' 
    end
    
      
    fseek(handles.pmafile,(start_locate_don*(handles.i*handles.j*2+2)+4)-(imagesizex*imagesizey*2),-1);
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16');
   
       
    result=size(handles.movie_all(:,:));
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
         set(handles.edit6,'String', 9);
        end

        nn=sscanf(get(handles.edit6,'String'),'%f');
        
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    fclose all;
        
        
        
    if handles.threshold == 0
        threshold = 25*std2(handles.background(12:244,12:500));
    else
        %threshold = handles.threshold-mean2(handles.background);
        threshold = handles.threshold*std2(handles.background(12:244,12:500));
    end
    
    
    handles.movie_all=read_frame(handles.filename,start_locate_don,hObject); 
    
    
    if strcmp(extension,'pma')==1 | strcmp(extension,'pmb')==1
     handles.movie_all(:,:)=handles.movie_all(:,:)-handles.background;
     handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
    end
    
        
    m_number=0;
    for i=60:180,
        for j=80:420,
            if handles.movie_all(i,j)>threshold & handles.movie_all(i,j) == max(max(handles.movie_all(i-4:i+4,j-4:j+4)))   
                m_number=m_number+1;
                don_x(m_number)=i;
                don_y(m_number)=j;
            end
        end
    
    end
    
    overlap=zeros(1,m_number);
    for i=1:m_number,
        for j=i+1:m_number
                if (don_x(i)-don_x(j))^2+(don_y(i)-don_y(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
                end
        end
    end
    
        
    % creating new matrix of m_numbers, kicking out the ones that
    % overlapped
    
    l=0;
    for i=1:m_number,
        if overlap(i)==0
        l=l+1;
        don_x_new(l)=don_x(i);
        don_y_new(l)=don_y(i);
        
        end
    end
    m_number=l;
    don_x=don_x_new(:);
    don_y=don_y_new(:);
    
   
    for k=1:m_number,             
        value(k)=0;
        %handles.spot=[ 0 0 1 0 0
         %          0 1 1 1 0
          %         1 1 1 1 1
           %        0 1 1 1 0
            %       0 0 1 0 0];
         
                    handles.spot= [0 0 0 0 1 0 0 0 0 
       0 0 0 1 1 1 0 0 0
       0 0 1 1 1 1 1 0 0
       0 1 1 1 1 1 1 1 0
       1 1 1 1 1 1 1 1 1
       0 1 1 1 1 1 1 1 0
       0 0 1 1 1 1 1 0 0
       0 0 0 1 1 1 0 0 0
       0 0 0 0 1 0 0 0 0];
           spotx=1;
          
           for min_x=don_x(k)-4:don_x(k)+4
               spoty=1;
               for min_y=don_y(k)-4:don_y(k)+4
                value(k)=value(k)+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
           end
    end
 

    
    
    %now for green
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pma')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'pmb')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.pmb');
     handles.pmafile=fopen(file,'r');
    else
     message='Do not have a file to open not pmb or background file' 
    end
   
    start_locate_green=sscanf(get(handles.edit21,'String'),'%d');
    
    fseek(handles.pmafile,(start_locate_green*(handles.i*handles.j*2+2)+4)-(512*512*2),-1);
    image=fread(handles.pmafile,[handles.i, handles.j],'uint16');
    
    result=size(handles.movie_all(:,:));
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

        nn=sscanf(get(handles.edit6,'String'),'%f');
        
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    fclose all;
        
    
    handles.movie_all=read_frame(handles.filename,start_locate_green,hObject); 
    
    
    if strcmp(extension,'pma')==1 | strcmp(extension,'pmb')==1
     handles.movie_all(:,:)=handles.movie_all(:,:)-handles.background;
     handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
    end
    
    for k=1:m_number,             
        line(don_x(k),don_y(k),'marker','o','color','w','EraseMode','background');  
        value2(k)=0;
       %handles.spot=[ 0 0 1 0 0
        %           0 1 1 1 0
         %          1 1 1 1 1
          %         0 1 1 1 0
           %        0 0 1 0 0];
                    handles.spot= [0 0 0 0 1 0 0 0 0 
       0 0 0 1 1 1 0 0 0
       0 0 1 1 1 1 1 0 0
       0 1 1 1 1 1 1 1 0
       1 1 1 1 1 1 1 1 1
       0 1 1 1 1 1 1 1 0
       0 0 1 1 1 1 1 0 0
       0 0 0 1 1 1 0 0 0
       0 0 0 0 1 0 0 0 0];
           
       spotx=1;
          
           for min_x=don_x(k)-4:don_x(k)+4
               spoty=1;
               for min_y=don_y(k)-4:don_y(k)+4
                value2(k)=value2(k)+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
           end
    end
    
  
    
    
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pmb')==1
     file=strrep(handles.filename,'.pmb','.bluegreen');
    elseif strcmp(extension,'pma')==1
     file=strrep(handles.filename,'.pma','.bluegreen');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.bluegreen');
    end
    
    
    
   outputfile=fopen(file,'w');
    for k=1:m_number,    
      fprintf(outputfile,'%f  ',value(k)); 
      fprintf(outputfile,'%f\n',value2(k)); 
    end
        
    fclose(outputfile);
    
    % printed out, not saved in the file. manually input don_x2, don_y2
   
    don_x2=188
    don_y2=336
    bckg=0
    spotx2=1
    for bckg2_x=(don_x2-4):(don_x2+4)
               spoty2=1;
               for bckg2_y=(don_y2-4):(don_y2+4)
                bckg=bckg+(handles.movie_all(bckg2_x,bckg2_y));
                spoty2=spoty2+1;
                
               end
              spotx2=spotx2+1;
              
           end
    spoty2
    spotx2
    bckg



case 17  %Batch Avi
  
    
  
    fclose all;
   % pma_files=dir('*.pmb');
    pma_files=dir('*.pma');
    number=size(pma_files)
    number(1)
    
    for i=1:number(1),
        datafile=pma_files(i).name;
        handles.pmafile=fopen(datafile,'r');
        handles.filename=datafile;
        s=dir(datafile);
        imagesizex=fread(handles.pmafile,1,'uint16');
        imagesizey=fread(handles.pmafile,1,'uint16');
        NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2)
        z='got here'
        handles.numframes=NumFrames;
        handles.i=imagesizex;
        handles.j=imagesizey;
        handles.xoffset=0;
        handles.yoffset=0; 
        handles.displayframe=1;
        guidata(hObject, handles);
             
        saveavi_Callback(hObject, eventdata, handles);
        
    end  
     
    dir_info=dir
    number=size(dir_info)
  

    for j=3:number(1),
        if dir_info(j).isdir
            cd(dir_info(j).name); 
            set(handles.popupmenu2,'Value',17);
            popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
            cd ..;
        end
    end
    

case 18  %Whole_screen_locate_spots
    
    fclose all;
    axes(handles.axes2);
    handles.threshold=sscanf(get(handles.edit1,'String'),'%d');
    start_locate_don=sscanf(get(handles.edit19,'String'),'%d');
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pma')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'pmb')==1
     handles.pmafile=fopen(handles.filename,'r');
    elseif strcmp(extension,'background')==1
     
        
        
        file=strrep(handles.filename,'.background','.pma');
        
        if fopen(file,'r')==-1
          file=strrep(handles.filename,'.background','.pmb');
        end
        
        handles.pmafile=fopen(file,'r');
    
    else
     message='Do not have a file to open not pmb or background file' 
    end
    
    handles.filename
    handles.pmafile
    
    image=zeros(512,512);
    for i=start_locate_don:(start_locate_don+5)
      fseek(handles.pmafile,(i*(handles.i*handles.j*2+2)+4)-(512*512*2),-1);
      image=image+fread(handles.pmafile,[handles.i, handles.j],'uint16');
    end
    image=image/5;
    
    
       
    result=size(handles.movie_all(:,:));
    imagesizex=handles.i;
    imagesizey=handles.j;

        if imagesizex == 128
          den=8;
          set(handles.edit6,'String', 2.3);
        elseif imagesizex == 256
          den=8;
           set(handles.edit6,'String', 2.5);
        elseif imagesizex == 512
         den=8;                                %changed from 16 to test dark blobs on iXon
         set(handles.edit6,'String', 4.5);  % change here the number of pixels for overlap
        end

        nn=sscanf(get(handles.edit6,'String'),'%f');
        
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(16)); % changed pixel number after sort to 100 from 16
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        
    fclose all;
    
            %this was changed to use 5 image average instead of single
            %frame
    handles.movie_all=image;                                 %read_frame(handles.filename,start_locate_don,hObject); 
    
    if strcmp(extension,'pma')==1 | strcmp(extension,'pmb')==1
     handles.movie_all(:,:)=handles.movie_all(:,:)-handles.background;
     %handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
     
%      %added on Feb25
        low=min(min(handles.movie_all(:,:)));
        high=max(max(handles.movie_all(:,:)));
        set(handles.slider1,'min',low);
        set(handles.slider1,'max',high);
        set(handles.slider1,'value',round(((high-low)*0.25)+low));
        set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);

       handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
    end
   
    %Calculate median of the background of the new background substracted image
        
       for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp3 = handles.movie_all(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp4 = reshape(sort_temp3,1,den*den);
                  sort_temp4 = sort(sort_temp4);
                  temp2(i,j) = sort_temp4(floor(16)); % chnaged pixel number after sort from 16 to 100
              end
       end
        
%        background2= imresize(temp2,[imagesizex imagesizey],'bilinear');
%        a=mean2(background2(1:256,1:512))
%        if a<0 
%            a=1;
%        end
       
      linear_image=reshape(handles.movie_all(1:(imagesizex),1:imagesizey),1,(imagesizex*(imagesizey)));
      a=median(linear_image);
        
     if handles.threshold == 0
        threshold = (4 * a) + std2(handles.background(5:((imagesizex)-5),5:(imagesizey-5)))
        %threshold2 = (a * 49) + (5 * std2(handles.background(5:((imagesizex)-5),5:(imagesizey-5))))
        threshold2 = (a) + (5 * std2(handles.background(5:((imagesizex)-5),5:(imagesizey-5))))
        % threshold = handles.threshold
        
     else
        %threshold = (4* a) + handles.threshold*std2(handles.background(5:((imagesizex)-5),5:((imagesizey-5))))
        %threshold2 = (a * 49) + (5 * handles.threshold*std2(handles.background(5:((imagesizex)-5),5:(imagesizey-5))))
        threshold2 = (a) + (5 * std2(handles.background(5:((imagesizex)-5),5:(imagesizey-5))))
        threshold = handles.threshold
     end
       
     
     
     
          
     
     
    m_number=0;
    for i=10:((imagesizex)-10),
        for j=10:(imagesizey-10),
            if handles.movie_all(i,j)>threshold & handles.movie_all(i,j) == max(max(handles.movie_all(i-2:i+2,j-2:j+2)))   
                m_number=m_number+1;
                don_x(m_number)=i;
                don_y(m_number)=j;
                %line(don_x(m_number),don_y(m_number),'marker','o','color','w','EraseMode','background');  
            end
        end
    
    end
    
    
    m_number
    % creating mass threshold
    handles.spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];            
    
    overlap=zeros(1,m_number);         
    
    
    for k=1:m_number
           value=0;   
           spotx=1;
           for min_x=don_x(k)-3:don_x(k)+3
               spoty=1;
               for min_y=don_y(k)-3:don_y(k)+3
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
           end
          
           
            if value > threshold2
             line(don_x(k),don_y(k),'marker','o','color','y','EraseMode','background'); 
            else
              overlap(k)=1;
            end
       
    end
    
    m_number
    
    for i=1:m_number,
        for j=i+1:m_number
                if (don_x(i)-don_x(j))^2+(don_y(i)-don_y(j))^2 < nn^2
                overlap(i)=1;
                overlap(j)=1;
                end
        end
    end
    
    
    % creating new matrix of m_numbers, kicking out the ones that
    % overlapped
    l=0;
    for i=1:m_number,
        if overlap(i)==0
        l=l+1;
        don_x_new(l)=don_x(i);
        don_y_new(l)=don_y(i);
        end
    end
    m_number=l
    don_x=don_x_new(:);
    don_y=don_y_new(:);
    
    
    

    %2D gaussian fit (all donors)
  for k=1:m_number
    donor=handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5));
    a  = gaussfit(donor,'2d',1,'n');
    don_x(k)=don_x(k)+a(5);
    don_y(k)=don_y(k)+a(6);
  end
    
   %Text file printing of highest value
    
    %file=strrep(handles.filename,'.background','.donors');
    
    
    
    [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
    if strcmp(extension,'pmb')==1
     file=strrep(handles.filename,'.pmb','.allspots');
    elseif strcmp(extension,'pma')==1
     file=strrep(handles.filename,'.pma','.allspots');
    elseif strcmp(extension,'background')==1
     file=strrep(handles.filename,'.background','.allspots');
    end
    
   
    
    j=0;
    outputfile=fopen(file,'w');
   
    for k=1:m_number,             
        
          
            value=0;
           
            don_x(k)=round(round(don_x(k)))
            don_y(k)=round(round(don_y(k)))
            
            
                     
           %This block adds 5x5 around located spot and then prints to a
           %file the values for histograms.
           
           % 5x5 integrated spot modified to resemble circle, matrix
           % handles.spot. "Value" represents integrated spots at a desired
           % frame, and "values2" integrated spots 6 frames later. This was
           % written for comparing calcein intensities in the last frame of
           % blue and the first frame of green (shutter switching seems to
           % take ~ 6 frames). 
           
                     
           %handles.spot=[ 0 0 1 0 0
                   %0 1 1 1 0
                   %1 1 1 1 1
                   %0 1 1 1 0
                   %0 0 1 0 0];
                   
%             handles.spot= [0 0 0 0 1 0 0 0 0 
%        0 0 0 1 1 1 0 0 0
%        0 0 1 1 1 1 1 0 0
%        0 1 1 1 1 1 1 1 0
%        1 1 1 1 1 1 1 1 1
%        0 1 1 1 1 1 1 1 0
%        0 0 1 1 1 1 1 0 0
%        0 0 0 1 1 1 0 0 0
%        0 0 0 0 1 0 0 0 0];
       
       handles.spot=[ 0 0 0 1 0 0 0
                   0 0 1 1 1 0 0
                   0 1 1 1 1 1 0
                   1 1 1 1 1 1 1
                   0 1 1 1 1 1 0
                   0 0 1 1 1 0 0
                   0 0 0 1 0 0 0];            
       
       
           spotx=1;
           
           
           for min_x=don_x(k)-3:don_x(k)+3
               spoty=1;
               for min_y=don_y(k)-3:don_y(k)+3
                value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
                spoty=spoty+1;
               end
              spotx=spotx+1;
            end
            
            fprintf(outputfile,'%f\n ',value); 
        
        
    end
   
    fclose(outputfile);
      
 handles.don_x=don_x(:);
 handles.don_y=don_y(:);
 handles.n_number=m_number;
 guidata(hObject,handles);
 
 set(handles.text20,'String',['#donors:',num2str(handles.n_number)]);
     

 
 
 %%%%%%%%%%%%%%%%5 Saving Whole screen traces %%%%%%%%%%%%%%%%%%%%5
 [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
 if strcmp(extension,'pmb')==1
 file=strrep(handles.filename,'.pmb','.allspottraces');
 elseif strcmp(extension,'pma')==1
 file=strrep(handles.filename,'.pma','.allspottraces');
 elseif strcmp(extension,'background')==1
 file=strrep(handles.filename,'.background','.allspottraces');
 end
   
 outputfile=fopen(file,'w');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',i);
 end
 
 fprintf(outputfile,'\n');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',handles.don_x(i));
 end
 
 fprintf(outputfile,'\n');
 
 fprintf(outputfile,'%i ',0);
 for i=1:handles.n_number
  fprintf(outputfile,'%i ',handles.don_y(i));
 end
 
 
 fprintf(outputfile,'\n');
 
 fclose all;
 
 for i=1:handles.numframes
 handles.movie_all=read_frame(handles.filename,i,hObject); 
 
 [base,extension]=strread(handles.filename,'%s %s','delimiter','.');
 if strcmp(extension,'pmb')==1
 file=strrep(handles.filename,'.pmb','.allspottraces');
 elseif strcmp(extension,'pma')==1
 file=strrep(handles.filename,'.pma','.allspottraces');
 elseif strcmp(extension,'background')==1
 file=strrep(handles.filename,'.background','.allspottraces');
 end
 outputfile=fopen(file,'a');
 
 fprintf(outputfile,'%i ',i); 
 
 
  for k=1:handles.n_number,             
    value=0;
    spotx=1;
    for min_x=handles.don_x(k)-3:handles.don_x(k)+3
     spoty=1;
     for min_y=handles.don_y(k)-3:handles.don_y(k)+3
      value=value+(handles.spot(spotx,spoty)*(handles.movie_all(min_x,min_y)));
      spoty=spoty+1;
     end
     spotx=spotx+1;
    end
    fprintf(outputfile,'%i ',value); 
  
        
  end
  
  
  fprintf(outputfile,'\n'); 
 end
fclose all; 
  i
end








% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(hObject, eventdata, handles, varargin)
global movieon;
fclose all;

if get(handles.checkbox5,'Value')==1
[datafile,datapath]=uigetfile('*.pma','Choose a PMA file');
end

if get(handles.checkbox6,'Value')==1 
[datafile,datapath]=uigetfile('*.pmb','Choose a PMB file');
end

if get(handles.checkbox9,'Value')==1 
[datafile,datapath]=uigetfile('*.background','Choose a background file');
end


if datafile==0, return; end

cd(datapath);
handles.pmafile=fopen(datafile,'r');
handles.filename=datafile;
s=dir(datafile);

imagesizex=fread(handles.pmafile,1,'uint16')
imagesizey=fread(handles.pmafile,1,'uint16')

NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2)
handles.NumFrames=NumFrames;
handles.movie_all=read_frame(datafile,1,hObject);   %added h0object



% Show first frame
handles.displayframe=1;
handles.numframes=NumFrames;
set(handles.slider1,'SliderStep',[0.01 0.1]);
set(handles.edit9,'String',int2str(handles.displayframe));
low=min(min(min(handles.movie_all(:,:))));
high=max(max(max(handles.movie_all(:,:))));
high=ceil(high*1.5);
set(handles.slider1,'min',low);
set(handles.slider1,'max',high);
set(handles.slider1,'value',round(((high-low)*0.25)+low));
colormap(jet);

get(handles.slider1,'value')

'got to begin of reading'


set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);
handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low high]);

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

handles.i=imagesizex;
handles.j=imagesizey;
handles.xoffset=0;
handles.yoffset=0;
handles.datafile=datafile;

guidata(hObject,handles);
pixval on;
movieon=0;

get(handles.slider1,'min') 
get(handles.slider1,'value')
get(handles.slider1,'max')



'got to end of reading'


function pushbutton8_Callback(hObject, eventdata, handles)
    if handles.displayframe<handles.numframes 
        handles.displayframe=handles.displayframe+1;
    end
low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));

handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);

colormap(jet);
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);

%     low=min(min(handles.movie_all(:,:)));
%         high=max(max(handles.movie_all(:,:)));
%         set(handles.slider1,'min',low);
%         set(handles.slider1,'max',high);
%         set(handles.slider1,'value',round(((high-low)*0.25)+low));
%         set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
% 


handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low get(handles.slider1,'value')]);
set(handles.edit9,'String',int2str(handles.displayframe));
set(handles.slider2,'value',(handles.displayframe));
guidata(hObject,handles);



function pushbutton6_Callback(hObject, eventdata, handles)
   
    if handles.displayframe>1 
        handles.displayframe=handles.displayframe-1;
    end
low=min(min(handles.movie_all(:,:,1)));
high=max(max(handles.movie_all(:,:,1)));
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes2);

handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);

%         low=min(min(handles.movie_all(:,:)));
%         high=max(max(handles.movie_all(:,:)));
%         set(handles.slider1,'min',low);
%         set(handles.slider1,'max',high);
%         set(handles.slider1,'value',round(((high-low)*0.25)+low));
%         set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);



handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low get(handles.slider1,'value')]);
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

  
    low=min(min(handles.movie_all(:,:)));
    high=max(max(handles.movie_all(:,:)));
    set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    axes(handles.axes2);
    handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);
    handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low get(handles.slider1,'value')]);
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
handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);

    low=min(min(handles.movie_all(:,:,1)));
    high=max(max(handles.movie_all(:,:,1)));
    colormap(jet);
    set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    axes(handles.axes2);
    handles.imagehandle=imshow(((handles.movie_all(:,:))'),[low get(handles.slider1,'value')]);
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


get(handles.slider1,'min')
get(handles.slider1,'value')

'got to before set of slider1'


set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')])

'got to end of slider1'






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
         
        for k=1:handles.numframes,
            handles.movie_all=read_frame(handles.filename,k,hObject); 
            handles.imagehandle=imshow(((handles.movie_all(:,:))'),[get(handles.slider1,'min') get(handles.slider1,'value')]);
            drawnow;
            if movieon==0 break; end
            set(handles.edit9,'String',int2str(k));
           
        end
        movieon=0;
        set(hObject,'Label','Play Movie');
    elseif movieon==1
        movieon=0;
        set(hObject,'Label','Play Movie');
    end
    
        


% --------------------------------------------------------------------
function saveavi_Callback(hObject, eventdata, handles)
  fclose all;
  handles.pmafile=fopen(handles.filename,'r');
  
  
  prompt = {'Begin at :','End at :','Save every :'}; 
    dlg_title = 'Frame Info.';
    num_lines= 1;
    def     = {'1',num2str(handles.NumFrames),'1'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    [filename,pathname]=uiputfile('.avi','Save the movie into ',strrep(handles.filename,'pma','avi'));
    cdirec = cd;
    cd(pathname);
    
    aviobj=avifile(filename,'compression','Cinepak','fps',10); 
    startframe=max([1 sscanf(answer{1},'%d')]);
    endframe=min([handles.NumFrames sscanf(answer{2},'%d')]);
    interframe=max([1 sscanf(answer{3},'%d')]);
    
    handles.x=handles.i;
    handles.y=handles.j;
   
    fseek(handles.pmafile,4+(startframe-1)*(handles.x*handles.y*2+2),-1);
    
    
    
    for k= startframe : interframe : endframe,
        k
        fseek(handles.pmafile,4+k*(handles.x*handles.y*2+2),-1);
        fread(handles.pmafile,1,'uint16');
        temp=fread(handles.pmafile,[handles.x, handles.y],'uint16');
        temp=temp';
        set(handles.imagehandle,'CData',temp);
        F=getframe(handles.axes2);
        aviobj=addframe(aviobj,F);
    end
    aviobj=close(aviobj); 
    cd(cdirec);
fclose all;


function checkbox1_Callback(hObject, eventdata, handles)


function checkbox5_Callback(hObject, eventdata, handles)
if get(handles.checkbox5,'Value')==1
set(handles.checkbox6,'Value',0);
set(handles.checkbox9,'Value',0);
end
guidata(hObject, handles);

function checkbox6_Callback(hObject, eventdata, handles)
if get(handles.checkbox6,'Value')==1
set(handles.checkbox5,'Value',0);
set(handles.checkbox9,'Value',0);
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

function checkbox9_Callback(hObject, eventdata, handles)
if get(handles.checkbox9,'Value')==1
set(handles.checkbox5,'Value',0);
set(handles.checkbox6,'Value',0);
end
guidata(hObject, handles);

function checkbox11_Callback(hObject, eventdata, handles)
got='here'
if get(handles.checkbox11,'Value')==1
set(handles.checkbox12,'Value',0);
end
handles.locked=handles.movie_all;
guidata(hObject, handles);

function checkbox12_Callback(hObject, eventdata, handles)
if get(handles.checkbox12,'Value')==1
set(handles.checkbox11,'Value',0);
end
handles.locked=handles.movie_all;
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



function movie = read_frame(filename,frame_number,hObject) 
  
handles.pmafile=fopen(filename,'r');

imagesizex=fread(handles.pmafile,1,'uint16');
imagesizey=fread(handles.pmafile,1,'uint16');




%fclose all;
  
  %locking of screens
  handles = guidata(hObject);
  outputfile=fopen(filename,'r');   
  a=fseek(outputfile,((((frame_number)*(imagesizex*imagesizey*2+2)+4))-(imagesizex*imagesizey*2)),-1);
  
  if get(handles.checkbox11,'Value')==1
     set(handles.checkbox12,'Value',0);
     movie(:,:) = fread(outputfile,[imagesizex, imagesizey],'uint16');
     movie(1:(imagesizex/2),1:imagesizey)=handles.locked(1:(imagesizex/2),1:imagesizey);
   
  elseif get(handles.checkbox12,'Value')==1
     set(handles.checkbox11,'Value',0);  
     movie(:,:) = fread(outputfile,[imagesizex, imagesizey],'uint16');
     movie((imagesizex/2):imagesizex,1:imagesizey)=handles.locked((imagesizex/2):imagesizex,1:imagesizey);
  
  else
     movie(:,:)=zeros(imagesizex,imagesizey);
     movie(:,:) = fread(outputfile,[imagesizex, imagesizey],'uint16');
  end
  fclose (outputfile);
 
  
  
  
  
function pushbutton10_Callback(hObject, eventdata, handles)
    
    total_intensity=0;
    imagesizex=handles.i;
    imagesizey=handles.j;
    handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);
    
    for i=5:((imagesizex/2)-5)
        for j=5:(imagesizey-5)
           total_intensity=total_intensity+handles.movie_all(i,j);
        end
    end
    
    total_intensity
    

function pushbutton11_Callback(hObject, eventdata, handles)
    
    total_intensity=0;
    imagesizex=handles.i;
    imagesizey=handles.j;
    handles.movie_all=read_frame(handles.filename,handles.displayframe,hObject);
    
    for i=((imagesizex/2)+5):(imagesizex-5)
        for j=5:(imagesizey-5)
           total_intensity=total_intensity+handles.movie_all(i,j);
        end
    end
    
    total_intensity
    

  
  
  
  
  
  
  
