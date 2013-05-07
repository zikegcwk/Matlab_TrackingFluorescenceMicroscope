function varargout = beads_map(varargin)
% BEADS_MAP M-file for beads_map.fig
%      BEADS_MAP, by itself, creates a new BEADS_MAP or raises the existing
%      singleton*.
%
%      H = BEADS_MAP returns the handle to a new BEADS_MAP or the handle to
%      the existing singleton*.
%
%      BEADS_MAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEADS_MAP.M with the given input arguments.
%
%      BEADS_MAP('Property','Value',...) creates a new BEADS_MAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beads_map_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beads_map_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help beads_map

% Last Modified by GUIDE v2.5 11-Aug-2006 14:18:42

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beads_map_OpeningFcn, ...
                   'gui_OutputFcn',  @beads_map_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before beads_map is made visible.
function beads_map_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beads_map (see VARARGIN)

% Choose default command line output for beads_map
handles.output = hObject;

% Update handles structure
guidata(gcf, handles);

% UIWAIT makes beads_map wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beads_map_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see gcf)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

high=get(handles.slider1,'max');
low=get(handles.slider1,'min');
set(handles.slider1,'SliderStep',[0.01 0.1]);

if (get(handles.slider1,'value')) > high
    set(handles.slider1,'value',(high));
end

if (get(handles.slider1,'value')) < low
    set(handles.slider1,'value',(low));
end

set(handles.axes1,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes1);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see gcf)
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see gcf)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
low=min(min(handles.movie_all(:,:)));
high=max(max(handles.movie_all(:,:)));
high=ceil(high*1.5);
set(handles.slider1,'min',low);
set(handles.slider1,'max',high);
set(handles.slider1,'value',(high/4));
colormap(jet); 
set(handles.axes1,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
axes(handles.axes1);
handles.imagehandle=imshow(handles.movie_all(:,:),[low high]);
handles.movie_all_image=handles.movie_all;
handles.movie_all=handles.movie_all';
handles.i=imagesizex;
handles.j=imagesizey;
handles.done=0;
handles.count_don=1;
handles.count_acc=1;
handles.donacc=0;
guidata(gcf,handles);
pixval on;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see gcf)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pixval off;

handles = guidata(gcf);
set(gcf,'WindowButtonMotionFcn',{@movement,guidata(gcf)});
set(gcf,'WindowButtonDownFcn',{@picking,guidata(gcf)});
guidata(gcf,handles);


function align(hObject, eventdata, handles);
 
 handles = guidata(gcf);
for k=1:6
 axes(handles.axes1);
 set(handles.text1,'String','Pick a donor molecule');
 don_x(k)=handles.donors_x(k);
 don_y(k)=handles.donors_y(k);
 max_donx=don_x(k);
 max_dony=don_y(k);
 

 %optimize donor spot position (6 molecules)
 handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5));
 max_value=max(max(handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5))));
   
   for i=(don_x(k)-5):(don_x(k)+5),
       for j=(don_y(k)-5):(don_y(k)+5),
           if  handles.movie_all(i,j) == max_value
                max_donx=i;
                max_dony=j;
            end
            
        end
   end
 
 don_x(k)=max_donx;
 don_y(k)=max_dony;
 
 line(don_x(k),don_y(k),'marker','o','color','b','EraseMode','background');
 
 acc_x(k)=handles.acc_x(k);
 acc_y(k)=handles.acc_y(k);
 max_accx=acc_x(k);
 max_accy=acc_y(k);
 
 %optimize acceptor spot position (6 molecules)
 max_value=max(max(handles.movie_all((acc_x(k)-5):(acc_x(k)+5),(acc_y(k)-5):(acc_y(k)+5))));
   for i=(acc_x(k)-5):(acc_x(k)+5),
       for j=(acc_y(k)-5):(acc_y(k)+5),
           if  handles.movie_all(i,j) == max_value
                max_accx=i;
                max_accy=j;
            end
            
        end
   end
 acc_x(k)=max_accx;
 acc_y(k)=max_accy;
 line(acc_x(k),acc_y(k),'marker','o','color','r','EraseMode','background');
 set(handles.text1,'String','');
end 

%2D gaussian fit (6 molecules donor 6 acceptor)
for k=1:6
    donor=handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5));
    acceptor=handles.movie_all((acc_x(k)-5):(acc_x(k)+5),(acc_y(k)-5):(acc_y(k)+5));
    a  = gaussfit(donor,'2d',1,'n');
    don_x(k)=don_x(k)+a(5);
    don_y(k)=don_y(k)+a(6);
    a  = gaussfit(acceptor,'2d',1,'n');
    acc_x(k)=acc_x(k)+a(5);
    acc_y(k)=acc_y(k)+a(6);
end

% fit donor to acceptor (6 spots)
 clear donor_points;
 clear acceptor_points;
 donor_points(:,:)=[don_x(:) don_y(:)];
 acceptor_points(:,:)=[acc_x(:) acc_y(:)];
 tform = cp2tform(acceptor_points,donor_points,'polynomial',2);
 f = tform.tdata

 
%locate donor molecules (all)
     result=[512 512];
     nn=2;
     imagesizex = 512;
     imagesizey = 512;
     den=16;
        for i=1:imagesizey/den,
              for j=1:imagesizex/den,
                  sort_temp = handles.movie_all(den*(i-1)+1:den*i,den*(j-1)+1:den*j);
                  sort_temp2 = reshape(sort_temp,1,den*den);
                  sort_temp2 = sort(sort_temp2);
                  temp(i,j) = sort_temp2(floor(den));
              end
        end
        handles.background =  imresize(temp,[imagesizex imagesizey],'bilinear');
        threshold = (100*std2(handles.background(1+3:result(1)-3,1+3:result(2)/2-3)))
   
    m_number=0;
    for i=12:244,
        for j=12:500,
            if (handles.movie_all(i,j) > threshold) & (handles.movie_all(i,j) == max(max(handles.movie_all(i-1:i+1,j-1:j+1)))) & (round(f(1,1) + f(2,1)*i + f(3,1)*j + f(4,1)*i*j + f(5,1)*i*i + f(6,1)*j*j) >268) & (round(f(1,1) + f(2,1)*i + f(3,1)*j + f(4,1)*i*j + f(5,1)*i*i + f(6,1)*j*j) <500) & (round(f(1,2) + f(2,2)*i + f(3,2)*j + f(4,2)*i*j + f(5,2)*i*i + f(6,2)*j*j) >12 ) & (round(f(1,2) + f(2,2)*i + f(3,2)*j + f(4,2)*i*j + f(5,2)*i*i + f(6,2)*j*j) <500 )             
                m_number=m_number+1;
                don_x(m_number)=i;
                don_y(m_number)=j;
            end
        end
    
    end
    
    
%2D gaussian fit (all donors)
  for k=1:m_number
    donor=handles.movie_all((don_x(k)-5):(don_x(k)+5),(don_y(k)-5):(don_y(k)+5));
    a  = gaussfit(donor,'2d',1,'n');
    don_x(k)=don_x(k)+a(5);
    don_y(k)=don_y(k)+a(6);
  end
    
    
 %   overlap=zeros(1,m_number);
 %   for i=1:m_number,
 %       for j=i+1:m_number,
 %           if don_y(j)-don_y(i) > nn
 %               break;
 %           end
 %           if (don_x(i)-don_x(j))^2+(don_y(i)-don_y(j))^2 < nn^2
 %               overlap(i)=1;
 %               overlap(j)=1;
 %           end
 %       end
 %   end

   
for k=1:m_number,             
    
    
    %if round(f(1,1) + f(2,1)*don_x(k) + f(3,1)*don_y(k) + f(4,1)*don_x(k)*don_y(k) + f(5,1)*don_x(k)*don_x(k) + f(6,1)*don_y(k)*don_y(k))<268
    %    overlap(k)=1;
    %end
    
    %if round(f(1,1) + f(2,1)*don_x(k) + f(3,1)*don_y(k) + f(4,1)*don_x(k)*don_y(k) + f(5,1)*don_x(k)*don_x(k) + f(6,1)*don_y(k)*don_y(k))>500
    %    overlap(k)=1;
    %end
  
    %if round(f(1,2) + f(2,2)*don_x(k) + f(3,2)*don_y(k) + f(4,2)*don_x(k)*don_y(k) + f(5,2)*don_x(k)*don_x(k) + f(6,2)*don_y(k)*don_y(k))<12
    %overlap(k)=1;
    %end
    
    %if round(f(1,2) + f(2,2)*don_x(k) + f(3,2)*don_y(k) + f(4,2)*don_x(k)*don_y(k) + f(5,2)*don_x(k)*don_x(k) + f(6,2)*don_y(k)*don_y(k))>500
    %overlap(k)=1;
    %end
    
    
    
    %if overlap(k)==0
    
    % find all aceptors based on the coefficient matrix of 6 molecules
    acc_x(k)=round(f(1,1) + f(2,1)*don_x(k) + f(3,1)*don_y(k) + f(4,1)*don_x(k)*don_y(k) + f(5,1)*don_x(k)*don_x(k) + f(6,1)*don_y(k)*don_y(k));
    acc_y(k)=round(f(1,2) + f(2,2)*don_x(k) + f(3,2)*don_y(k) + f(4,2)*don_x(k)*don_y(k) + f(5,2)*don_x(k)*don_x(k) + f(6,2)*don_y(k)*don_y(k));
    
    %optimize acceptor position (all)
    max_value=max(max(handles.movie_all((acc_x(k)-5):(acc_x(k)+5),(acc_y(k)-5):(acc_y(k)+5))));
        for i=(acc_x(k)-5):(acc_x(k)+5),
       for j=(acc_y(k)-5):(acc_y(k)+5),
           if  handles.movie_all(i,j) == max_value
                max_accx=i;
                max_accy=j;
           end
       end
    end
   
   acc_x(k)=max_accx;
   acc_y(k)=max_accy;
   
   
   %end
end

%2D gaussian fit (acceptor all)
  for k=1:m_number
    acceptor=handles.movie_all((acc_x(k)-5):(acc_x(k)+5),(acc_y(k)-5):(acc_y(k)+5));
    a  = gaussfit(acceptor,'2d',1,'n');
    acc_x(k)=acc_x(k)+a(5);
    acc_y(k)=acc_y(k)+a(6);
    line(don_x(k),don_y(k),'marker','o','color','c','EraseMode','background');
   line(acc_x(k),acc_y(k),'marker','o','color',[1,1.0,0.7],'EraseMode','background'); 
  end

  clear donor_points;
clear acceptor_points;

% use all donor and acceptors (gaussian fitted position) to create new
% coefficient matrix
donor_points2(:,:)=[don_x(:) don_y(:)]
acceptor_points2(:,:)=[acc_x(:) acc_y(:)]
tform = cp2tform(acceptor_points2,donor_points2,'polynomial',2);
f = tform.tdata;

for k=1:m_number,             
    %if overlap(k)==0
      acc_x(k)=f(1,1) + f(2,1)*don_x(k) + f(3,1)*don_y(k) + f(4,1)*don_x(k)*don_y(k) + f(5,1)*don_x(k)*don_x(k) + f(6,1)*don_y(k)*don_y(k);
      acc_y(k)=f(1,2) + f(2,2)*don_x(k) + f(3,2)*don_y(k) + f(4,2)*don_x(k)*don_y(k) + f(5,2)*don_x(k)*don_x(k) + f(6,2)*don_y(k)*don_y(k);
      line(don_x(k),don_y(k),'marker','o','color','c','EraseMode','background');  
      line(acc_x(k),acc_y(k),'marker','o','color','m','EraseMode','background'); 
    %end
end

handles.fmatrix=f;
guidata(gcf,handles);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see gcf)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%test for filtering using wiener...

handles = guidata(gcf);
set(gcf,'WindowButtonMotionFcn',{@movement,guidata(gcf)});
set(gcf,'WindowButtonDownFcn',{@picking,guidata(gcf)});
guidata(gcf,handles);


function movement(hObject,eventdata,handles)

handles = guidata(gcf);
axes(handles.axes1);
images = findobj(gcf, 'type', 'image');
axHandles = get(images, {'Parent'});
whichaxis=0;

for k=1:length(axHandles)
   XLim = get(axHandles{k}, 'XLim');
   YLim = get(axHandles{k}, 'YLim');
   if XLim(2)==512.5
    whichaxis=k;
   end
end

if whichaxis>0
axCurPt = get([axHandles{whichaxis}], {'CurrentPoint'});    
pt = axCurPt{1};
XLim = get(axHandles{whichaxis}, 'XLim');
YLim = get(axHandles{whichaxis}, 'YLim');
x = round(pt(1,1));
y = round(pt(1,2));
zoom=round(sscanf(get(handles.edit2,'String'),'%d'));

if XLim(2)== 512.5
    if x >= (XLim(1)+zoom) && x <= (XLim(2)-zoom) && y >= (YLim(1)+zoom) && y <= (YLim(2)-zoom)
    low=min(min(handles.movie_all(:,:)));
    high=max(max(handles.movie_all(:,:)));
    value=get(handles.slider1,'value');
    set(handles.axes2,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    axes(handles.axes2);
    handles.imagehandle2=imshow(handles.movie_all_image(y-zoom:y+zoom,x-zoom:x+zoom),[low value]);
    line((zoom+1),(zoom+1),'marker','o','color','g','MarkerSize',10,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','g','MarkerSize',30,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','g','MarkerSize',60,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','g','MarkerSize',90,'EraseMode','background'); 
    set(handles.axes3,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    value=get(handles.slider1,'value')-100;
    axes(handles.axes3);
    set(handles.axes3,'CLim',[get(handles.slider1,'min') get(handles.slider1,'value')]);
    if x>=(XLim/2)
    handles.imagehandle3=imshow(handles.movie_all_image(((y-zoom)):((y+zoom)),(x-zoom):(x+zoom)),[low value]);
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',10,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',30,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',60,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',90,'EraseMode','background'); 
    else
    handles.imagehandle3=imshow(handles.movie_all_image(((y-zoom)):((y+zoom)),(x-zoom+256):(x+zoom+256)),[low value]);
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',10,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',30,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',60,'EraseMode','background'); 
    line((zoom+1),(zoom+1),'marker','o','color','r','MarkerSize',90,'EraseMode','background'); 
    end
    
    end
end
end

if handles.count_acc>6 
    set(gcf,'WindowButtonDownFcn','');
    align(guidata(gcf));
    handles = guidata(gcf);
    handles.count_acc=1;
end
guidata(gcf,handles);



function picking(hObject,eventdata,handles)
 handles = guidata(gcf);
 images = findobj(gcf, 'type', 'image');
 axHandles = get(images, {'Parent'});
 whichaxis=0;

 for k=1:length(axHandles)
   XLim = get(axHandles{k}, 'XLim');
   YLim = get(axHandles{k}, 'YLim');
   if XLim(2)==512.5
    whichaxis=k;
   end
 end
 
 axCurPt = get([axHandles{whichaxis}], {'CurrentPoint'});    
 pt = axCurPt{1};
 XLim = get(axHandles{whichaxis}, 'XLim');
 YLim = get(axHandles{whichaxis}, 'YLim');
 x = round(pt(1,1));
 y = round(pt(1,2));
  
if handles.donacc==0
  line(x,y,'marker','o','color','g','EraseMode','background');
  line(x+256,y,'marker','o','color','w','EraseMode','background');
  handles.donors_x(handles.count_don)=x;
  handles.donors_y(handles.count_don)=y;
  handles.count_don = handles.count_don +1;
  handles.donacc=1;
  axes(handles.axes2);
  axes(handles.axes1);
else handles.donacc==1
  line(x,y,'marker','o','color','y','EraseMode','background');
  handles.acc_x(handles.count_acc)=x;
  handles.acc_y(handles.count_acc)=y;
  handles.count_acc = handles.count_acc +1;
  handles.donacc=0;
end
guidata(gcf,handles);



function pushbutton4_Callback(hObject, eventdata, handles)

handles = guidata(gcf);
fclose all;
file='beads_map_file.dat';
outputfile=fopen(file,'w');
for i=1:6
fprintf(outputfile,'%f ',handles.fmatrix(i,1));
fprintf(outputfile,'%f\n',handles.fmatrix(i,2));
end                       
fclose(outputfile);

load beads_map_file.dat;
beads_map_file










function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

