function varargout = mk_traces(varargin)
% MK_TRACES M-file for mk_traces.fig
%      MK_TRACES, by itself, creates a new MK_TRACES or raises the existing
%      singleton*.
%
%      H = MK_TRACES returns the handle to a new MK_TRACES or the handle to
%      the existing singleton*.
%
%      MK_TRACES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MK_TRACES.M with the given input arguments.
%
%      MK_TRACES('Property','Value',...) creates a new MK_TRACES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mk_traces_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mk_traces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mk_traces

% Last Modified by GUIDE v2.5 02-Jun-2009 19:02:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mk_traces_OpeningFcn, ...
                   'gui_OutputFcn',  @mk_traces_OutputFcn, ...
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


% --- Executes just before mk_traces is made visible.
function mk_traces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mk_traces (see VARARGIN)

% Choose default command line output for mk_traces
handles.output = hObject;

%  handles.split_pt = 68;
%  handles.raw_picture = ones(128,128);
%  handles.background = ones(128,128);
%  handles.bg_corrected = ones(128,128);

% Set the postion of the figure to a good location
set(gcf,'Position',[81    38   129    41])

handles.figure_contrast = 2;
handles.figure_binary = 3;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mk_traces wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mk_traces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Get the File Name
[filename, pathname] = uigetfile( ...
{'*.pma','*.pma';...
 '*.mat','*.mat';...
 '*.*',  'All Files (*.*)'}, ...
   'Pick a file');

% Save file name an stet the pat the the navagated path
handles.filename = filename;
handles.pathname = pathname;
% Don's have too many spaced in your path name matlab is up happy...
cd(handles.pathname) ;
set(gcf,'Name',handles.filename);



% If opening raw file. you save a .mat file for latter work
if  regexp(filename,'.pma') >= 1
pmafile=fopen(filename,'r');

imagesizex=fread(pmafile,1,'uint16');
imagesizey=fread(pmafile,1,'uint16');
imagesize = [imagesizex imagesizey];

s=dir(handles.filename);
num_frames=(s.bytes-4)/(imagesize(1)*imagesize(2)*2+2);

t_image = [];
f_image = uint16([]);
for k=1:num_frames
    temp=fread(pmafile,1,'uint16');
    t_image = fread(pmafile,[imagesize(1),imagesize(2)],'uint16');
    f_image = cat(3,f_image,t_image);
end

%Save File 
new_filename = strcat(filename(1:regexp(filename,'.pma')),'mat');
save(new_filename, 'imagesize','num_frames','f_image')


elseif regexp(filename,'.mat') >= 1
  
% Load a previous movie
load(filename)
        
else
    
error('file name strind does not match')
    
end

% Set important handles
handles.imagesize = imagesize;
handles.num_frames = num_frames;
handles.f_image =  f_image;
handles.display_stat = 1;
handles.disp_color = 'HSV';







% set slider range
set(handles.slider1, 'Max',handles.num_frames)
set(handles.slider1, 'Min',1)
set(handles.slider1, 'Value',250)
set(handles.text5,'String','250')

set(handles.slider2, 'Max',handles.num_frames)
set(handles.slider2, 'Min',1)
set(handles.slider2, 'Value',50)
set(handles.text4,'String','50')



guidata(hObject, handles)
%handles = raw_picture(hObject, eventdata, handles);
handles = raw_picture(handles);
%raw_picture(hObject, eventdata, handles);

%make the raw picture the curren picture
handles.d_picture =handles.raw_picture;



guidata(hObject, handles)
pict_update(hObject, eventdata, handles)






function pict_update(hObject, eventdata, handles)




display_image = handles.d_picture;

low=min(min(display_image));
high=max(max(display_image));

% Need to see if this is the first time I am moveing the plain
low_s = get(handles.slider3,'Min');
high_s =get(handles.slider3,'Max');
if low == low_s && high==high_s
plan_location = get(handles.slider3,'Value');
else
set(handles.slider3,'Min',low);
set(handles.slider3,'Value',low);
plan_location = low;
set(handles.slider3,'Max',high);
end

axes(handles.axes1);
imshow(display_image,[low high]);



colormap(handles.disp_color);
zoom on
axis image 

line([handles.split_pt handles.split_pt],[0 128],'Marker','none','LineStyle','-','Color','k','LineWidth', 2);


axes(handles.axes2);
cla
surf(double(display_image));
hold all
surf(double(uint16(ones(128, 128))*plan_location));
zoom on

binary_image_Callback(hObject, eventdata, handles)



%background = imopen(I,strel('disk',15));


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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

% Hint: edit controls usually have a white background on windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Make the position a integer for future opperations
temp_value = get(handles.slider1,'Value');
temp_value = round(temp_value);
set(handles.slider1,'Value',temp_value)
set(handles.text5,'String',num2str(temp_value))

handles = raw_picture(handles);
%handles.d_picture = handles.raw_picture;
%set(handles.popupmenu1, 'Value',1)

% display the new current picture
popupmenu1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%Make the position a integer for future opperations
temp_value = get(handles.slider2,'Value');
temp_value = round(temp_value);
set(handles.slider2,'Value',temp_value)
set(handles.text4,'String',num2str(temp_value))

handles = raw_picture(handles);
%handles.d_picture = handles.raw_picture;
%set(handles.popupmenu1, 'Value',1)

% display the new current picture


popupmenu1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


val = get(handles.popupmenu1,'Value');
switch val
    case 1
        handles.display_stat = 1;
        handles.d_picture = handles.raw_picture;
        pict_update(hObject, eventdata, handles)
    case 2
        handles.display_stat = 2;
        handles.d_picture = handles.background;
        pict_update(hObject, eventdata, handles)
    case 3
        handles.display_stat = 3;
        handles.d_picture = handles.bg_corrected;
        pict_update(hObject, eventdata, handles)
end

guidata(hObject, handles)




function output = raw_picture(hObject, eventdata, handles)

handles=hObject;
t_image = handles.f_image;

don_ave = str2double(get(handles.edit1,'string'));
don_open = get(handles.slider1,'Value');

acc_ave = str2double(get(handles.edit2,'string'));
acc_open = get(handles.slider2,'Value');


don_mean = mean(t_image(:,:,don_open:(don_open+don_ave)),3);
acc_mean = mean(t_image(:,:,acc_open:(acc_open+acc_ave)),3);


split_pt = str2double(get(handles.edit3,'string'));
handles.split_pt = split_pt;
% Make a composit image of the two halfs
d_image = uint16(cat(2, don_mean(1:split_pt,:)',acc_mean((split_pt+1):end,:)'));
handles.raw_picture   = d_image;


% Calculate the background image
background = imopen(d_image,strel('disk',15));
handles.background = uint16(background);

% Calculate the corrected image
bg_corrected = imsubtract(d_image,background);
handles.bg_corrected = uint16(bg_corrected);




% Calculate peak positions
%guidata(hObject, handles)

output = handles;




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


1






% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

val = get(handles.popupmenu2,'Value');
switch val
    case 1
        handles.disp_color = 'Jet';
    case 2
        handles.disp_color = 'HSV';
    case 3
        handles.disp_color = 'Hot';
    case 4
        handles.disp_color = 'Cool';
    case 5
        handles.disp_color = 'Spring';
    case 6
        handles.disp_color = 'Summer';
    case 7
        handles.disp_color = 'Autumn';
    case 8
        handles.disp_color = 'Winter';
    case 9
        handles.disp_color = 'Gray';
    case 10
        handles.disp_color = 'Bone';
    case 11
        handles.disp_color = 'Copper';
    case 12
        handles.disp_color = 'Pink';
    case 13
        handles.disp_color = 'Lines';

end

guidata(hObject, handles)
pict_update(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%

temp = get(handles.slider3, 'Value');
temp = round(temp);
set(handles.slider3, 'Value',temp);
pict_update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


box_position = get(handles.figure_contrast(2),'Position');
box_position(1) = round(get(handles.slider5, 'Value'));
set(handles.figure_contrast(2),'Position',box_position)

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

box_position = get(handles.figure_contrast(2),'Position');
box_position(3) = round(get(handles.slider6, 'Value'));
set(handles.figure_contrast(2),'Position',box_position)



% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function windows_Callback(hObject, eventdata, handles)
% hObject    handle to windows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


intens_profile = double(reshape(handles.d_picture,1,[]));
figure(handles.figure_contrast(1));
set(gcf,'Position',[12   673   345   265])
hist(intens_profile,200)
intens_min = min(intens_profile);
intens_max = max(intens_profile);

set(handles.slider5,'Min', intens_min)
set(handles.slider5,'Value', intens_min)
set(handles.slider5,'Max', intens_max)

set(handles.slider6,'Min', 0)
set(handles.slider6,'Value', (intens_max-intens_min))
set(handles.slider6,'Max', (intens_max-intens_min))


color_lim = get(handles.axes1,'CLim');
y_lim = get(gca, 'YLim');
rec_prop = rectangle( 'Position' , ...
    [color_lim(1),y_lim(1),(color_lim(2)-color_lim(1)),y_lim(2)],'LineWidth',3);
handles.figure_contrast(2) =  rec_prop;
hold all

guidata(hObject, handles)


% --------------------------------------------------------------------
function binary_image_Callback(hObject, eventdata, handles)
% hObject    handle to binary_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%figure_binary = figure;
%handles.figure_binary = figure_binary;
%end


% Creat a Binary Image of Spots Above a Given Intensity
bin_image = handles.d_picture;
intens_cutoff = get(handles.slider3,'Value');
threshold = find(bin_image <=intens_cutoff);
bin_image(threshold)=0;
threshold = find(bin_image ~=0);
bin_image(threshold)=1;
handles.bin_image = bin_image;




figure(handles.figure_binary)
set(gcf,'Position',[12   300   345   265])
I = mat2gray(handles.bin_image);
imshow(I,'InitialMagnification','Fit')
figure(handles.figure1)
guidata(hObject, handles)



