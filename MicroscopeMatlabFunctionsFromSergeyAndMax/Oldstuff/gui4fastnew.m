function varargout = gui4fast(varargin)

% Rejection of overlapping neighbors is utilized.
% HAROLD 8/24/04

% Background subtraction routine corrected.
% Previously it was not correctly done due to words missing
% HAROLD 9/20/04

% GUI4FAST Application M-file for gui4fast.fig
%    FIG = GUI4FAST launch gui4fast GUI.
%    GUI4FAST('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 24-Oct-2005 09:06:41
% HAROLD

% a major bug(mistake) is fixed 
% data for background subtraction is collected from the end of the data
% taken
% HAROLD 5/20/03
% batch analysis is expanded to work on subdirectories as well.
% HAROLD 5/27/03
% In caculating offset between two images, smaller areas of interest
% chosen.
% For some images, maximum crosscorrelation occurs on the boundary
% HAROLD 5/27/03
% menubar added for selecting colormaps
% HAROLD 8/22/03

% playing movie menu added
% can open file in any directory: error fixed
% where the file is opened becomes the working directory
% HAROLD 9/15/03 

% speed of finding peaks and saving traces is improved by a factor of 10
% almost. Number(%) shows the progress.
% if offset is larger than 5 pixels, it is set to 0.
% HAROLD 9/18/03

% when buffer is injected, the background becomes higher than the inital
% image. This makes it hard to visualize the peak finding process.
% In this case, background estimated from the first few frames must be
% used.
% HAROLD 1/22/04

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

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


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = popupmenu2_Callback(h, eventdata, handles, varargin)
val = get(h,'Value');
switch val
case 1
    
case 2 %background
    set(handles.imagehandle,'CData',handles.background);    
case 3 %Original image   
    set(handles.imagehandle,'CData',handles.image_t);
case 4 %Background subtracted image
    set(handles.imagehandle,'CData',handles.image_t-handles.background+mean2(handles.background));
%     pause,
%     image=handles.image_t-handles.background;
%     surf(image);
    
case 5 % Finding the offset between donor and acceptor images
    
    offsetx=0;
    offsety=0;
    
    image_t=handles.image_t-handles.background;
    result=size(handles.image_t);
    donor=image_t(20+offsety:result(1)-20+offsety,20+offsetx:result(2)/2-20+offsetx);
    acceptor=image_t(10:result(1)-10,result(2)/2+10:result(2)-10);

    cc = normxcorr2(donor,acceptor); 
%    temp=cc(100:200,40:80);
    [max_cc, imax] = max(cc(:));
    [ypeak, xpeak] = ind2sub(size(cc),imax(1));
%     [max_cc, imax] = max(temp(:));
%     [ypeak, xpeak] = ind2sub(size(temp),imax(1));
%     ypeak = ypeak + 99;
%     xpeak = xpeak + 39;
    yoffset=ypeak-size(donor,1)-10;
    xoffset=xpeak-size(donor,2)-10;
    
    if abs(xoffset) > 3 | abs(yoffset) > 3
        xoffset = -5.4;
        yoffset = 0.3;
    end
    handles.xoffset=xoffset;
    handles.yoffset=yoffset;
%     handles.xoffset=1;
%     handles.yoffset=0;
    
    guidata(h,handles);
    disp(xoffset);
    disp(yoffset);
    drawnow;
    
    %%%WEI's offset for decimal precision.    
% % %     cc = normxcorr2(donor,acceptor); 
% % %     %%cross coreelation checker
% % % %             size(cc)
% % % %             imshow(cc,[min(min(cc)),max(max(cc))]);pause
% % % %             mesh(cc);pause
% % % %             temp=cc(100:200,40:80);
% % % %     % end
% % %     cc(1:138,:)=0;
% % %     cc(144:end,:)=0;
% % %     cc(:,1:53)=0;
% % %     cc(:,59:end)=0;
% % %     
% % %     [max_cc, imax] = max(cc(:));
% % %     [ypeak, xpeak] = ind2sub(size(cc),imax(1));
% % % %     xoffset=xpeak-size(donor,2)-10
% % % %     yoffset=ypeak-size(donor,1)-10
% % % 
% % %     
% % %     centroid = 0;
% % %     mass = 0;
% % %     for i=-1:1,
% % %         for j=-1:1,
% % %             centroid = centroid + cc(ypeak+i,xpeak+j)*[i,j];
% % %             mass = mass + cc(ypeak+i,xpeak+j);
% % %         end
% % %     end
% % %     centroid = centroid/mass;
% % %     ypeak = ypeak + centroid(1);
% % %     xpeak = xpeak + centroid(2);
% % % 
% % % %     [max_cc, imax] = max(temp(:));
% % % %     [ypeak, xpeak] = ind2sub(size(temp),imax(1));
% % % %     ypeak = ypeak + 99;
% % % %     xpeak = xpeak + 39;
% % %     yoffset=ypeak-size(donor,1)-10;
% % %     xoffset=xpeak-size(donor,2)-10;
% % %     
% % % %     if abs(xoffset) > 10 | abs(yoffset) > 10
% % %     if abs(xoffset) > 3 | abs(yoffset) > 3
% % %         xoffset = 0;
% % %         yoffset = 0;
% % %     end
% % %     handles.xoffset=xoffset;
% % %     handles.yoffset=yoffset;
% % %     
% % %     guidata(h,handles);
% % %     disp(xoffset);
% % %     disp(yoffset);
% % %    
case 6 %Locating molecules based on donor image
    % This algorithm uses the image fluctuation, rather than the averaged
    % background, to assess and locate molecular spots.
    
    image_t=handles.image_t-handles.background;   
    
    
    result=size(image_t);
    axes(handles.axes2);
    
    % after correcting the background, the image_t is basically a gaussian
    % fluctuation around 0, plus those high peaks of molecular. those
    % molecular peaks deviate the distribution of image_t from a symmetric
    % gaussian form, but this deviation only effects on the positive half,
    % while the negative half is still gaussian (only half of gaussian
    % distribution. This negative half is selected, compensated to a full
    % gaussian distribution, and then utilized to calculated the
    % fluctuation noise of image_t.
    temp=image_t(:,1:85);
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    temp=[temp;-temp(temp<0)];
    sigma=std(temp);    % compensate to a full gaussian then...
    
    handles.threshold=sscanf(get(handles.edit1,'String'),'%d');
    nn=sscanf(get(handles.edit6,'String'),'%f');
    if handles.threshold == 0
%         threshold = 7*std2(handles.background(1+3:result(1)-3,1+3:result(2)/2-3));
        threshold = 5*sigma
    else
        threshold = handles.threshold-mean2(handles.background);
    end

    % find all peaks that are higher than the threshold.
    m_number=0;
    for i=1+3:result(1)-3,
        for j=1+3:result(2)/2-3,
            if image_t(i,j)>threshold & image_t(i,j) == max(max(image_t(i-1:i+1,j-1:j+1)))
                m_number=m_number+1;
                tempx(m_number)=j;
                tempy(m_number)=i;
            end
        end
    end
    
    
    % discard those peaks that are too close to other peaks.
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
            x(2*j-1)=tempx(i);         
            y(2*j-1)=tempy(i);
            
            %apply offset and find local maximum
            x(2*j)=tempx(i)+result(2)/2+handles.xoffset;                    
            y(2*j)=tempy(i)+handles.yoffset;
            temp=image_t(y(2*j)-1:y(2*j)+1,x(2*j)-1:x(2*j)+1);
            [maxy, maxx]=find(temp==max(max(temp)));
        %    line(x(2*j),y(2*j),'marker','+','color','y');
            x(2*j)=x(2*j)+maxx-2;
            y(2*j)=y(2*j)+maxy-2;
            
            donor_points(j,:)=[x(2*j-1) y(2*j-1)];
            acceptor_points(j,:)=[x(2*j) y(2*j)];
        end
    end
    
    if get(handles.checkbox1,'Value')==1
        disp(handles.f);
        for i=1:j,
            points=[x(2*i-1) y(2*i-1) 1]*handles.f;
            points=round(points);
            
            x(2*i)=points(1);
            y(2*i)=points(2);
%             
%             line(x(2*i-1),y(2*i-1),'marker','o','color','y','EraseMode','background');
%             line(x(2*i),y(2*i),'marker','o','color','w','EraseMode','background');
        end
[x;y]        
        
        handles.x=x;
        handles.y=y;
        handles.num=j;
        guidata(h,handles);    
                
    elseif j>3  
        tform = cp2tform(acceptor_points,donor_points,'affine');
%         tform = cp2tform(acceptor_points,donor_points,'projective');
        f = tform.tdata.Tinv;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:j,
            points=[x(2*i-1) y(2*i-1) 1]*f;
            points=round(points);
            
            x(2*i)=points(1);
            y(2*i)=points(2);
        end
        
        
        handles.x=x; % handles.x & y save the pixel coordinates of the 'good' molecules.
        handles.y=y;
        handles.num=j;  % handles.num saves the number of 'good' molecules.
        handles.f=f;
        guidata(h,handles);
    end
    
    % After this renormalized transform, some spots may go out to the
    % edge area. This edge_check function will discard those
    % out-of-range spots and return the good ones.    
    % By Wei Zhao 03/04/05.
        
    edge_check(handles);
        
case 7 % Locate molecules based on acceptor image
    % This algorithm uses the image fluctuation, rather than the averaged
    % background, to assess and locate molecular spots.
    
    image_t=handles.image_t-handles.background;    

    result=size(image_t)
    axes(handles.axes2);
    
    % after correcting the background, the image_t is basically a gaussian
    % fluctuation around 0, plus those high peaks of molecular. those
    % molecular peaks deviate the distribution of image_t from a symmetric
    % gaussian form, but this deviation only effects on the positive half,
    % while the negative half is still gaussian (only half of gaussian
    % distribution. This negative half is selected, compensated to a full
    % gaussian distribution, and then utilized to calculated the
    % fluctuation noise of image_t.
    %%the fact is that this is set for 170x170. so it should be tweaked.
    %% 
    test1 = get(gca,'Xlim');
    imagesizex = ceil(test1(2))
        test2 = get(gca,'YLim');
        imagesizey = ceil(test2(2))
     if imagesizey==170
    temp=image_t(:,86:170);
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    sigma=std([temp;-temp(temp<0)]);    % compensate to a full gaussian then...
     elseif imagesizey==111
    temp=image_t(:,56:168); %%using the 66p ROI, why isnt this 170?
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    sigma=std([temp;-temp(temp<0)]);    % compensate to a full gaussian then...
          elseif imagesizey==83
    temp=image_t(:,63:83); %%using the 66p ROI, 4x4 binning?
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    sigma=std([temp;-temp(temp<0)]);    % compensate to a full gaussian then...
    elseif imagesizey==129
    temp=image_t(:,65:128); %%using the 128x128, 1x1 binning
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    sigma=std([temp;-temp(temp<0)]);    % compensate to a full gaussian then...
     else
    temp=image_t(:,48:170);
    temp=temp(:);
    temp=temp(temp<=0); % negative half of guassian
    sigma=std([temp;-temp(temp<0)]);    % compensate to a full gaussian then...
    end
    
    
    handles.threshold1=sscanf(get(handles.edit2,'String'),'%d');
    nn=sscanf(get(handles.edit6,'String'),'%f');
    if handles.threshold1 == 0
        threshold = 5*sigma
    else
        threshold = handles.threshold1-mean2(handles.background)
    end
    
    % find all peaks that are higher than the threshold. 
    m_number=0;
    for i=1+3:result(1)-3,
        for j=result(2)/2+1+3:result(2)-3,
            if image_t(i,j)>threshold & image_t(i,j) == max(max(image_t(i-1:i+1,j-1:j+1)))
                centroid = 0;
                mass = 0;
                for p=-1:1
                    for q=-1:1
                        centroid = centroid + image_t(i+p,j+q)*[p,q];
                        mass = mass + image_t(i+p,j+q);
                    end
                end
                centroid = centroid/mass;
                %discard 'out-of-shape' molecules
                if abs(centroid(1))<0.5 & abs(centroid(2))<0.5
                    m_number=m_number+1;
                    tempx(m_number)=j+centroid(2);
                    tempy(m_number)=i+centroid(1);
                end
            end
        end
    end
    
    % discard those peaks that are too close to other peaks.
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
            
            x(2*j-1)=tempx(i)-result(2)/2-handles.xoffset;                    
            y(2*j-1)=tempy(i)-handles.yoffset;

            x(2*j)=tempx(i);
            y(2*j)=tempy(i);
        end
    end
    [x;y]
        handles.x=x;    % handles.x & y save the pixel coordinates of the 'good' molecules.
        handles.y=y;
        handles.num=j;  % handles.num saves the number of 'good' molecules.
        guidata(h,handles);

        
    % After this renormalized transform, some spots may go out to the
    % edge area. This edge_check function will discard those
    % out-of-range spots and return the good ones.    
    % By Wei Zhao 03/04/05.
        
    edge_check(handles);
%     debug = handles.i
    
case 8 % Save Traces for decimal locations
    if handles.i == 170
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 256
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 168
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 126
        squarewidth=3;
        NumPixels=4;
    elseif handles.i == 512
        squarewidth=5;
        NumPixels=16;
    elseif handles.i == 128
        squarewidth=3;
        NumPixels=4;
        dog = []
    end
%     The trouble is we no longer have a square..
    image_t = handles.image_t - handles.background;

    % the regions-defining section is vectorized (see the following part),
    % so comment this cycling part. by Wei Z. 06/10/05
% % % % 
% % % %     regions=zeros(NumPixels,2,2*handles.num);
% % % %     
% % % %     x=round(handles.x);
% % % %     y=round(handles.y);
% % % %     %now read the real data
% % % %     
% % % % % for each molecule, find the pixels that have larger signal as the
% % % % % molecular fluoresce illumination region. Note the coordinates of these
% % % % % pixels are in the image_t image, which has be transposed (see pre_calc),
% % % % % all following processes should transpose the frames read from the
% % % % % pma.files.
% % % %     points=zeros(6,2);
% % % %     for m=1:2*handles.num,
% % % % % % %         peak=image_t(y(m)-floor(squarewidth/2):y(m)+floor(squarewidth/2),...
% % % % % % %             x(m)-floor(squarewidth/2):x(m)+floor(squarewidth/2));
% % % % % % % %         center=reshape(peak,squarewidth*squarewidth,1);
% % % % % % % %         center=sort(center);
% % % % % % %         center=sort(peak(:));
% % % % % % %         [I,J]=find(peak>=center(squarewidth*squarewidth-NumPixels+1));
% % % % % % %         A=I(1:NumPixels);   % corresponding to y(m)
% % % % % % %         B=J(1:NumPixels);   % corresponding to x(m)
% % % % % % %         regions(:,:,m)=[A+y(m)-floor(squarewidth/2)-1,B+x(m)-floor(squarewidth/2)-1];
% % % % % % %         % regions(:,:,m) saves the coordinates of the 4 pixels of spot m.
% % % %         points(1,:)=[y(m),x(m)];
% % % %         points(4,:)=points(1,:)+sign([handles.y(m)-y(m),handles.x(m)-x(m)]);
% % % %         points(2,:)=[points(4,1),points(1,2)];
% % % %         points(3,:)=[points(1,1),points(4,2)];
% % % %         points(5,:)=2*points(1,:)-points(2,:);
% % % %         points(6,:)=2*points(1,:)-points(3,:);
% % % %         if image_t(points(4,1),points(4,2))<image_t(points(5,1),points(5,2))
% % % %             points(4,:)=points(5,:);
% % % %         end
% % % %         if image_t(points(4,1),points(4,2))<image_t(points(6,1),points(6,2))
% % % %             points(4,:)=points(6,:);
% % % %         end
% % % %         regions(:,:,m)=points(1:4,:);
% % % %     end
    
% Vectorizing the pattern-defining part. by Wei Z. 06/10/05 %% this picks 4
% pixels to acquire intensity vlaues.
    regions=zeros(6,2,2*handles.num);    
    x=round(handles.x);
    y=round(handles.y);
    regions(1,:,:)=[y;x];
    regions(4,:,:)=sign([handles.y-y;handles.x-x]);
    regions(4,:,:)=regions(4,:,:)+regions(1,:,:);
    regions(2,:,:)=[regions(4,1,:),regions(1,2,:)];
    regions(3,:,:)=[regions(1,1,:),regions(4,2,:)];
    regions(5,:,:)=2*regions(1,:,:)-regions(2,:,:);
    regions(6,:,:)=2*regions(1,:,:)-regions(3,:,:);
    [tm,tmi]=max(reshape(diag(image_t(regions(4:6,1,:),regions(4:6,2,:))),3,2*handles.num));
    regions(4,1,:)=diag(squeeze(regions(4+tmi(:)-1,1,:)));
    regions(4,2,:)=diag(squeeze(regions(4+tmi(:)-1,2,:)));
    % discard the 5th and 6th pixels if each region
    regions=regions(1:4,:,:);
% finished vectorizing. by Wei Z. 06/10/05
% regions(1:4,:,1:3)
    
%--------------------------------------------------------------------------
% this will only work when handles.num is defined to be larger than 3
    fseek(handles.pmafile,4,-1);
    filename=strrep(handles.filename,'.pma',['(' num2str(NumPixels) ').traces']);
%     filename_corr=strrep(handles.filename,'.pma',['(' num2str(NumPixels)
%     'corr).traces']);   
% removed by Bernie - directory playing is giving problems
% % % %     current=cd;
% % % %     cd ..;
% % % %     parent=cd;
% % % %     newdir = [current(length(parent)+1:end) '(traces)'];
% % % %     if newdir(1)~='\'
% % % %         newdir=['\' newdir];
% % % %     end
% % % %     newdir = [current newdir];  % 02/26/05 by Wei Z.
% % % %     
% % % %     arg = ['mkdir ' newdir];
% % % %     dummy = dos(arg);
% % % %     cd(newdir);
    
    % save positions of all molecules to *.mpos file
    mposfilename = strrep(handles.filename,'.pma',['(' num2str(NumPixels) ').mpos']);
    fid_mpos = fopen(mposfilename,'w');
    fwrite(fid_mpos,2*handles.num,'int16');
    fwrite(fid_mpos,x,'int16');
    fwrite(fid_mpos,y,'int16');
    fclose(fid_mpos);
    
    % save patterns of all molecules to *.mpatt file
    mpatnfilename = strrep(handles.filename,'.pma',['(' num2str(NumPixels) ').mpatn']);
    fid_mpatn = fopen(mpatnfilename,'w');
    fwrite(fid_mpatn,2*handles.num,'int16');
    fwrite(fid_mpatn,regions(1:4,:,:),'int16');
    fclose(fid_mpatn);
    
    % save traces
    fid = fopen(filename,'w');
    
    fwrite(fid,handles.NumFrames,'int32');
    fwrite(fid,2*handles.num,'int16');
    
    result=size(handles.image_t);
    temp = repmat(uint16(0), result(1), result(2));
    temp2 = repmat(uint16(0), result(1), result(2));
    traces = zeros(1+2*handles.num,handles.NumFrames);
    
    for k=1:handles.NumFrames,
        traces(1,k)=fread(handles.pmafile,1,'uint16');
        temp2=fread(handles.pmafile,[result(2), result(1)],'uint16')';
        % Note the matrix transpose; every frame should be transpose for getting right orientation; 
        % see function pre_calc. really?? usually a square...how to fix if
        % not?
%          debug = [size(handles.background) size(temp2)]
      temp=temp2-handles.background;
%         temp = temp2;
        for m=1:2*handles.num,
            traces(m+1,k)=trace(temp(regions(:,1,m),regions(:,2,m))); %%try to take the max value, not the diag sum here.
%             traces_corr(m+1,k)=trace(temp(regions_corr(:,1,m),regions_corr(:,2,m)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use the 7*7 square centered at the current spot to assess the local
% background. 3 = (7-1)/2; 49 = 7*7;
%            plot(sort(reshape(temp(x(m)-3:x(m)+3,y(m)-3:y(m)+3),49,1)));
%            grid on; pause
% plot(sort(reshape(temp(x(m)-2:x(m)+2,y(m)-2:y(m)+2),25,1)));
% grid on; pause

% A bad mistake is corrected on 03/05/05. The transposed image matrix temp
% has to be indexed in this way: temp(y(m),x(m))
            local_temp=sort(reshape(temp(y(m)-3:y(m)+3,x(m)-3:x(m)+3),49,1));
            
% average the middle part as an estimation of the local background.
% 16 = floor(1+7*7); 34 = ceil(1+7*7);

            local_background=mean(local_temp(16:34));
            % for some reason, this is negative
% NumPixels of signals was added to get as the signal of this molecule; the
% same number times of local_background should be subtracted;

            traces(m+1,k)=traces(m+1,k)-NumPixels*local_background;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        end
        fwrite(fid,traces(1:1+2*handles.num,k),'int16'); 
        set(handles.edit5,'String',int2str(100*k/handles.NumFrames));
        drawnow;
        size(traces);
    end
    fclose(fid);
%     cd(current);

case 9 % Batch analysis for decimal locations
    fclose all;
    
    fid_failed = fopen('Failed_Diverge.txt','a')
    
    pma_files=dir('*.pma');
    number=size(pma_files);
    for i=1:number(1),
        datafile=pma_files(i).name;
        handles.pmafile=fopen(datafile,'r');
        handles.filename=datafile;
        guidata(h,handles);
        
        pre_calc(handles);
        handles=guidata(handles.popupmenu2);
                
        refresh;
        
        set(handles.popupmenu2,'Value',4); % Background-substracted image
        popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
        handles=guidata(handles.popupmenu2);
        if get(handles.checkbox3,'Value')==0,
        set(handles.popupmenu2,'Value',5); % Find decimal offset
        popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
        handles=guidata(handles.popupmenu2);
        end
        set(handles.popupmenu2,'Value',7); % Locate acceptor molecules, decimal precision
        popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
        handles=guidata(handles.popupmenu2);
        
        set(handles.popupmenu4,'value',6); % iteration for 10 times, using 'affine'
        for i=1:30
            handles=guidata(handles.popupmenu2);
            donor_former=[handles.x(1:2:end)' handles.y(1:2:end)'];
            popupmenu4_Callback(handles.popupmenu4, eventdata, guidata(handles.popupmenu4));
            handles=guidata(handles.popupmenu4);
            donor_points=[handles.x(1:2:end)' handles.y(1:2:end)'];
            blah= 0
            if size(donor_points) == size(donor_former)
                donor_diff=donor_points-donor_former;
                donor_dist=max(sqrt(donor_diff(:,1).^2+donor_diff(:,2).^2));
                if donor_dist < 0.0001
                    break;
                end
            end
        end
        
        if donor_dist < 0.001
            set(handles.popupmenu2,'Value',8);
            popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
            handles=guidata(handles.popupmenu2);
        else
            fwrite(fid_failed,[datafile '\t']);
        end
    end    
    dir_info=dir;
    number=size(dir_info);
    
    for j=3:number(1),
        if dir_info(j).isdir 
            cd(dir_info(j).name); 
            set(handles.popupmenu2,'Value',9);
            popupmenu2_Callback(handles.popupmenu2, eventdata, guidata(handles.popupmenu2), varargin);
            handles=guidata(handles.popupmenu2);
            cd ..;
        end
    end
    fclose(fid_failed)
end
        
%---------------------------------------------------------------------
function varargout=edge_check(handles)
% After the renormalized transform, some spots may go out to the
% edge area. This edge_check function will discard those
% out-of-range spots and return the good ones.    
% By Wei Zhao 03/04/05.

axes(handles.axes2);
x = handles.x;
y = handles.y;
z = ones(size(x));
x_range = handles.i - 3;
y_range = handles.j - 3;
for j=1:2:length(x),
    if x(j)<4 | x(j)>x_range | y(j)<4 | y(j)>y_range ...
            | x(j+1)<4 | x(j+1)>x_range | y(j+1)<4 | y(j+1)>y_range
        z(j)=0;
        z(j+1)=0;
    end
end
handles.x = x(z==1);
handles.y = y(z==1);
handles.num = length(handles.x)/2;

marker(handles);

guidata(handles.axes2,handles);

% --------------------------------------------------------------------
function marker(handles)

delete(findobj(gcf,'type','line'));
handles.h_donor=line(handles.x(1:2:end),handles.y(1:2:end),'marker','o','color','y','EraseMode','background','LineStyle','none');
handles.h_acceptor=line(handles.x(2:2:end),handles.y(2:2:end),'marker','o','color','w','EraseMode','background','LineStyle','none');

set(gcf,'Name',[handles.filename ': ' num2str(handles.num) ' molecules located']);


% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global movieon;
fclose all;
[datafile,datapath]=uigetfile('*.pma','Choose a PMA file');
if datafile==0, return; end

cd(datapath);
handles.pmafile=fopen(datafile,'r');
handles.filename=datafile;

guidata(h,handles);
movieon=0;

pre_calc(handles);

% ---------------------------------------------------------------------
function varargout = pre_calc(handles)

% This function utilizes the sunfunction background_calc to
% calculate the background. To use this function, change its name to
% 'pre_calc'.

set(gcf,'Name',handles.filename);

imagesizex=fread(handles.pmafile,1,'uint16');
imagesizey=fread(handles.pmafile,1,'uint16');

s=dir(handles.filename);
NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2);

donor_start = str2num(get(handles.edit7,'string'));
acceptor_start = str2num(get(handles.edit8,'string'));

averagesize=min([10 (NumFrames-max(donor_start,acceptor_start)+1)]);

fseek(handles.pmafile,4 + (donor_start-1)*(imagesizex*imagesizey*2+2),-1);
image = zeros(imagesizex, imagesizey);
for k=1:averagesize,
    temp=fread(handles.pmafile,1,'uint16');
%     size(image)
%     [imagesizex,imagesizey]
%     image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
% Backwards???
     image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
end
if imagesizex==imagesizey
image_t = image'/averagesize;
elseif imagesizey==111
image_t = image'/averagesize;
else
    image_t = image/averagesize;
    image_t = image_t';
end
% note the end prime for matrix transpose; This is to show the image in
% the same orientation as what is seen in collecting data.

fseek(handles.pmafile,4 + (acceptor_start-1)*(imagesizex*imagesizey*2+2),-1);
image = zeros(imagesizey, imagesizex);
for k=1:averagesize,
    temp=fread(handles.pmafile,1,'uint16');
    % Backwards??? it wouldnt matter if this was a square...
%     image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
    image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
end
image = image'/averagesize;
size(image)
% is 86 = 170/2 +1??, ie imagsizey
% image_t(:,86:170) = image(:,86:170);
image_t(:,imagesizex/2:imagesizey) = image(:,imagesizex/2:imagesizey);
% note the end prime for matrix transpose; This is to show the image in
% the same orientation as what is seen in collecting data.


bg_image=background_calc(image_t);

% % % 
% % % averagesize=min([10 NumFrames]);
% % % z=0;
% % % fseek(handles.pmafile,-averagesize*(imagesizex*imagesizey*2+2),1);
% % % for k=1:averagesize,
% % %     frame_no(k,1)=fread(handles.pmafile,1,'uint16');
% % %     z=z+fread(handles.pmafile,[imagesizex, imagesizey],'uint16');
% % % end
% % % 
% % % bg_image=z'/averagesize; % note the prime for matrix transpose
% % % % hand=mesh(bg_image);axis tight;pause

low=min(min(image_t))
high=max(max(image_t))
%low=40;
%high=ceil(high*2);
if low >= high
    high = 13000;
    low = 0;
end

set(handles.slider1,'min',low);
set(handles.slider1,'max',2*high-low);
set(handles.slider1,'value',high);

axes(handles.axes2);
handles.image_t=image_t;
handles.NumFrames=NumFrames;

if imagesizex == 170
    den=5;
    set(handles.edit6,'String', 2.3);
elseif imagesizex == 168
    den=5;
    set(handles.edit6,'String', 2.3);
elseif imagesizex == 127
    den=5;
    set(handles.edit6,'String', 2.3);
elseif imagesizex == 256
    den=8;
    set(handles.edit6,'String', 2.5);
elseif imagesizex == 512
    den=16;
    set(handles.edit6,'String', 4.5);
elseif imagesizex == 128
    den=8;
    set(handles.edit6,'String', 2.3);

end
% % % 
% % % lft=floor((1+den*den)/3); rht=ceil((1+den*den)*2/3);
% % % for i=1:imagesizey/den,
% % %     for j=1:imagesizex/den,
% % %         sort_temp = bg_image(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
% % %         sort_temp2 = reshape(sort_temp,1,den*den);
% % %         sort_temp2 = sort(sort_temp2);
% % % %         temp(i,j) = sort_temp2(floor(den)); % This is Harold's backgound;
% % %         temp(i,j) = mean(sort_temp2(lft:rht)); % This is my definition; 03/01/05
% % %       %  temp(i,j)=median(median(bg_image(den*(i-1)+1:den*i,den*(j-1)+1)));
% % %     end
% % % end;
% % % bg_image = imresize(temp,[imagesizex imagesizey],'bicubic');


%this is the bottleneck.
handles.background=bg_image;
handles.imagehandle=imshow(image_t,[low high]);
% % % % % % 
% % %         handles.imagehandle=mesh(bg_image(4:167,4:167));
% % %         axis tight;
% % %         set(gca,'zlim',[low high],'zlimmode','manual');
        
%handles.imagehandle=imshow([1 imagesizex], [imagesizey 1], image,[low high]);
%set(handles.imagehandle,'XData',[1 size(CData,2)],'YData',[size(CData,1) 1]);
colormap(original);
if get(handles.checkbox3,'Value')==0,
handles.xoffset=0;
handles.yoffset=0;
end

handles.i=imagesizex;
handles.j=imagesizey;
handles.x=0;
handles.y=0;
handles.num=0;
handles.threshold=0;
handles.threshold1=0;
guidata(handles.axes2,handles);
% guidata(hObject,handles);
guidata(handles.text7,handles);

pixval on;
% 

% ---------------------------------------------------------------------
function background = background_calc(image)
%This subfunction calculates the given image matrix based on the median of
%local 7*7 square of each pixel.
% Note: This algorithm do not calculate the background of the boundary
% pixels whose distance to any edge are 3 pixels or shorter. These edge
% areas are not useful for locating the molecules, since any spots in the
% edge area is not counted.

sz=size(image);
half_den=zeros(sz);
% plot(half_den);pause

%%again, this is not always a square, so make sure the half_den is set
%%correctly
half_den(2:sz(1)-1,2:sz(2)-1)=1;
half_den(3:sz(1)-2,3:sz(2)-2)=2;
half_den(4:sz(1)-3,4:sz(2)-3)=3;
background=image;
for i=2:sz(1)-1
    for j=2:sz(2)-1
        pos = [i j];
        temp=image(i-half_den(i,j):i+half_den(i,j),j-half_den(i,j):j+half_den(i,j));
        temp=sort(temp(:));
%         temp=temp';
        background(i,j)=mean(temp(floor(length(temp)/3):ceil(length(temp)*2/3)));
% backwards again???
% length(temp)
%         background(i,j)=mean(temp(floor(length(temp)/3):ceil(length(temp)*2/3)));
%         sz(background)
%         if i>30 & j>30
%             plot(temp);pause
%         end
    end
end

% mesh(background);pause


% --------------------------------------------------------------------
function varargout = slider1_Callback(h, eventdata, handles, varargin)

%set(handles.axes2,'CDatamapping','scaled');
set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
set(handles.edit5,'String',{['colormap min:' num2str(get(handles.slider1,'min'))];...
        ['colormap max:' num2str(get(handles.slider1,'value'))]});

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
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(original);


% --------------------------------------------------------------------
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    donor_mean = zeros(1,handles.NumFrames);
    acceptor_mean = zeros(1,handles.NumFrames);
    
    global movieon;
    if movieon==0
        movieon=1;
        set(hObject,'Label','Stop Movie');
        fseek(handles.pmafile,4,-1);
        for k=1:handles.NumFrames,
            fread(handles.pmafile,1,'uint16');
            temp=fread(handles.pmafile,[handles.i, handles.j],'uint16');
            temp=temp';
            set(handles.imagehandle,'CData',temp);
            set(handles.edit5,'String',int2str(k));
            
            edge = 20;
            edgec = 60;
%             size(temp(edge:(handles.i-edge+1),edge:(handles.j/2-edge+1))),pause
%             size(temp(edge:(handles.i-edge+1),(handles.j/2+edge):(handles.j-edge+1))),pause
            donor_mean(k) = mean2(temp(edge:(handles.i-edge+1),edge:(handles.j/2-edge+1)));
            acceptor_mean(k) = mean2(temp(edge:(handles.i-edge+1),(handles.j/2+edge):(handles.j-edge+1)));
%             donor_point(k) = mean2(temp(edgec:(handles.i-edgec+1),edgec:(handles.j/2-edgec+1)));
%             acceptor_point(k) = mean2(temp(edgec:(handles.i-edgec+1),(handles.j/2+edgec):(handles.j-edgec+1)));

            set(handles.edit7,'String',int2str(donor_mean(k)));
            set(handles.edit8,'String',int2str(acceptor_mean(k)));
            
            drawnow; 
%             pause
            if movieon==0 break; end
        end
        
        set(handles.edit7,'String',int2str(1));
        set(handles.edit8,'String',int2str(1));
        figure(2);
        subplot(2,1,1); plot(donor_mean);donor_mean;
        subplot(2,1,2); plot(acceptor_mean);
        axes(handles.axes2);
        
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

    
    aviobj=avifile(strrep(handles.filename,'.pma','.avi'),'compression','indeo5','fps',10); 

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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


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
IMPIXELINFO;

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
    newdir = [current newdir];  % 02/26/05 by Wei Z.
    
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
       centroid=zeros(squarewidth,squarewidth);
    
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
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

image_t=handles.image_t-handles.background;

donor_points=[handles.x(1:2:end)' handles.y(1:2:end)'];
acceptor_points=[handles.x(2:2:end)' handles.y(2:2:end)'];

donor_former = donor_points;
donor_points=round(donor_points);

for i=1:handles.num
    temp=image_t(donor_points(i,2)-1:donor_points(i,2)+1,donor_points(i,1)-1:donor_points(i,1)+1);
    [maxy, maxx]=find(temp==max(max(temp)));
    donor_points(i,1)=donor_points(i,1)+maxx-2;
    donor_points(i,2)=donor_points(i,2)+maxy-2;
            
    centroid = 0;
    mass = 0;
    for p=-1:1
        for q=-1:1
            centroid = centroid + image_t(donor_points(i,2)+p,donor_points(i,1)+q)*[p,q];
            mass = mass + image_t(donor_points(i,2)+p,donor_points(i,1)+q);
        end
    end
    centroid = centroid/mass;
    donor_points(i,1)=donor_points(i,1)+centroid(2);
    donor_points(i,2)=donor_points(i,2)+centroid(1);
end             

val = get(hObject,'Value');

donor_diff=donor_points-donor_former;
% 
% figure(2);
% hl=plot(donor_diff(:,1),donor_diff(:,2));
% set(hl,'linestyle','none','marker','o');
% set(gca,'xlim',[-5,5]);
% set(gca,'ylim',get(gca,'xlim')*0.75);
% set(gca,'nextplot','add');
% set(gca,'dataaspectratio',[1 1 1]);
% x=[0:.1:2*pi];plot(sin(x),cos(x));
% x=[0:.1:2*pi];plot(0.7*sin(x),0.7*cos(x));
% set(gca,'nextplot','replace');
% axes(handles.axes2);

donor_dist=sqrt(donor_diff(:,1).^2+donor_diff(:,2).^2);
% 
% donor_dist=sort(donor_dist);
% figure(3);
% plot(donor_dist,'co:');
% axes(handles.axes2);

donor_good=donor_points(donor_dist<0.7,:);
acceptor_good=acceptor_points(donor_dist<0.7,:);
num=length(donor_good);

switch val
case 1 % Refine using 'affine' algorithm
    if num>3
        tform = cp2tform(donor_good,acceptor_good,'affine');
        f = tform.tdata.Tinv;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:handles.num,
            points=[acceptor_points(i,1) acceptor_points(i,2) 1]*f;
            donor_points(i,:)=points(1:2);
        end
    end    
                
case 2 % Refine using 'projective' algorithm
    if num>4
        t_proj = cp2tform(donor_good,acceptor_good,'projective');
                
        f = t_proj.tdata.Tinv;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:handles.num,
            points=[acceptor_points(i,1) acceptor_points(i,2) 1]*f;
            points=points/points(3);
            donor_points(i,:)=points(1:2);
        end
    end    
    
case 3 % Refine using '2nd order polynomial'
    if num>6
        t_poly_ord2 = cp2tform(donor_good,acceptor_good,'polynomial',2);
                
        f = t_poly_ord2.tdata;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:handles.num,
                x=acceptor_points(i,1);
                y=acceptor_points(i,2);
                points=[1 x y x*y x^2 y^2]*f;
                donor_points(i,:)=points(1:2);
        end
    end
        
case 4 % Refine using '3rd order polynomial'
    if num>10
        t_poly_ord3 = cp2tform(donor_good,acceptor_good,'polynomial',3);
                
        f = t_poly_ord3.tdata;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:handles.num,
            x=acceptor_points(i,1);
            y=acceptor_points(i,2);
            points=[1 x y x*y x^2 y^2 y*x^2 x*y^2 x^3 y^3]*f;
            donor_points(i,:)=points(1:2);
        end
    end
    
case 5 % Refine using '4th order polynomial'
    if num>15
        t_poly_ord4 = cp2tform(donor_good,acceptor_good,'polynomial',4);
                
        f = t_poly_ord4.tdata;
        disp(f);
        delete(findobj(gcf,'type','line'));
        for i=1:handles.num,
            x=acceptor_points(i,1);
            y=acceptor_points(i,2);
            points=[1 x y x*y x^2 y^2 y*x^2 x*y^2 x^3 y^3 x^3*y x^2*y^2 x*y^3 x^4 y^4]*f;
            donor_points(i,:)=points(1:2);
        end
    end
case 6 % 'Don't refine'    
donor_points(:,1)=handles.x(1:2:end);
acceptor_points(:,1)=handles.x(2:2:end);
donor_points(:,2)=handles.y(1:2:end);
acceptor_points(:,2)=handles.y(2:2:end);
   
end
    
handles.x(1:2:end)=donor_points(:,1);
handles.x(2:2:end)=acceptor_points(:,1);
handles.y(1:2:end)=donor_points(:,2);
handles.y(2:2:end)=acceptor_points(:,2);
guidata(hObject,handles);

edge_check(handles);


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xoffset = handles.xoffset+0.1;
set(handles.text6, 'String', handles.xoffset);
guidata(hObject,handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xoffset = handles.xoffset-0.1;
set(handles.text6, 'String', handles.xoffset);
guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.yoffset = handles.yoffset+0.1;
set(handles.text7, 'String', handles.yoffset);
guidata(hObject,handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.yoffset = handles.yoffset-0.1;
set(handles.text7, 'String', handles.yoffset);
guidata(hObject,handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


