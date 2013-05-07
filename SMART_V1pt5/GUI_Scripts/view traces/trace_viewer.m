function varargout = trace_viewer(varargin)
% TRACE_VIEWER M-file for trace_viewer.fig
%      TRACE_VIEWER, by itself, creates a new TRACE_VIEWER or raises the existing
%      singleton*.
%
%      H = TRACE_VIEWER returns the handle to a new TRACE_VIEWER or the
%      handle to
%      the existing singleton*.
%
%      TRACE_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACE_VIEWER.M with the given input arguments.
%
%      TRACE_VIEWER('Property','Value',...) creates a new TRACE_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trace_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trace_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trace_viewer

% Last Modified by GUIDE v2.5 01-Jun-2011 08:18:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trace_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @trace_viewer_OutputFcn, ...
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


% --- Executes just before trace_viewer is made visible.
function trace_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trace_viewer (see VARARGIN)


% Choose default command line output for trace_viewer
handles.output = hObject;

% variagle to initalize
handles.index  =1;
handles.nummol =[];
handles.molecule_spec.dltg =[];
handles.molecule_spec.ser_snr =[];
handles.filename = '';
handles.calc_good_trace = 0;

%handles.tv_settings = trace_viewer_settings();
handles.tv_settings = default_tv_settiongs;

update_textbox(hObject, handles)
trace_viewer_look(handles,1)
guidata(hObject, handles);


%guidata(hObject, handles);
% UIWAIT makes trace_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trace_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% % --------------------------------------------------------------------
% function open_Callback(hObject, eventdata, handles)
% % hObject    handle to open (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)





function mypostcallback(obj,evd,handles)


update_figure(gcf, handles);


function output = update_figure(hObject, handles)


index    = handles.index;
%current_position = [handles.data{index,1}.position_x handles.data{index,1}.position_y];

current_position = handles.data{index,1}.positions(index,1:2);

temp_trace = handles.data{index,2};
temp_trace = double(temp_trace);
temp_select = handles.data{index,3};
length = size(temp_trace,1);

% Calculate values for the selected region of the trace using the function
% % proably shoudl take out.
averaging_method = trace2smdate(handles.tv_settings);


% automatically select region of intrest
roi = [1 2];
if handles.calc_good_trace ==1
    
    
    %output = fit_entire_movie(handles);
    roi = good_trace(trace, handles.tv_settings);
    set(handles.axes2,'XLim',roi)
    handles.calc_good_trace = 0;
    
    if roi(2)-roi(1) >=10
        
        handles.selected(index) = 1;
        selected_region = ones(1,length);
        current_xlim = roi;
        selected_region(1:current_xlim(1))=0;
        selected_region(current_xlim(2):end)=0;
        handles.selected_region(index,:) = selected_region;
    end
end


% Plot a bar corresponding to the selected region of the trace
% and Update for the next figure
%selected_region = handles.selected_region(index,:);

if handles.selected(index) == true
    
    selected_region = find(handles.selected_region{index}==1);
    current_xlim(1)=selected_region(1);
    current_xlim(2)=selected_region(end);
    selected_region=handles.selected_region{index};
    
    
else
    selected_region = ones(1,length);
    current_xlim = round(get(handles.axes2,'XLim'));
    selected_region(1:current_xlim(1))=0;
    selected_region(current_xlim(2):end)=0;
    handles.selected_region{index} = selected_region;
end



current_xlim_raw = round(get(handles.axes1,'XLim'));
plotall = get(handles.checkbox2,'value');
p2v = get(handles.popupmenu2,'value');
p3v = get(handles.popupmenu3,'value');
 
cla(handles.axes1);
set(handles.axes1, 'Color', 'k')
hold(handles.axes1,'on')
color_order = {'g','r','b','m','y'};
% plot top plot
tax=[];
if plotall == true
    for i=1:size(temp_trace,2)
        plot(handles.axes1,1:length,temp_trace(:,i)',color_order{i});
        hold(handles.axes1,'on')
    end
else
    i = p2v;
    plot(handles.axes1,1:length,temp_trace(:,i)',color_order{i});
    hold(handles.axes1,'on')
end

if handles.tv_settings{11,2} == true
    if size(temp_trace,2) ~=1
        total_intentist = sum(temp_trace')';
        total_intentist = total_intentist +300; % offset to make viewing easire...
        plot(handles.axes1,1:length,total_intentist ,'y');
    end
end
plot(handles.axes1,1:length,selected_region*150 ,':sc');
xlim(handles.axes1,current_xlim_raw)

% Plot bottom plot
cla(handles.axes2);
if plotall == true
    
    % check to see if FRET shoud be ploted
    if handles.tv_settings{12,2}
        
        fret_spec.smooth = 'no';
        
        fret_spec.threshold = 0.5;
        fret_spec.x_talk = 0.05;
        fret_spec.fret_cutoff = [-0.2 1.2];
        fret_spec.temp = 298;
        [output1 output2]  = fret_analysis(temp_trace,fret_spec);
        plot(handles.axes2,1:length,output1(:,3)','b');
        hold(handles.axes2,'on')
        
    else
    
    
    for i=1:size(temp_trace,2)
        plot(handles.axes2,1:length,temp_trace(:,i)',color_order{i});
        hold(handles.axes2,'on')
    end
    end
else
    i = p2v;
    plot(handles.axes2,1:length,temp_trace(:,i)',color_order{i});
    hold(handles.axes2,'on')
    
end

% find the largest 95% of the data and sex axes acording to that
t95 = sort(temp_trace(:,i)');
p25size = round(size(t95,2)*.025);
t95(1:p25size)=[];
t95(end-p25size:end) = [];
 

plot(handles.axes2,length,ones(size(length))*handles.tv_settings{6,2},'r')
xlim(handles.axes2,current_xlim)
ylim(handles.axes2,[t95(1) t95(end)])
ylim(handles.axes2,'auto')

%Plot a histogram only of the selected fret
% fret_to_plot is no longer fret...but 
fret_to_plot = find(selected_region == 1)';

% plots a histogram of the selected date in one of the channels
cla(handles.axes3);
[y x] = hist(handles.axes3,temp_trace(fret_to_plot,p2v));
bar(handles.axes3,x,y,'EdgeColor',color_order{p2v},'FaceColor',color_order{p2v},'barwidth',1);


% plots correlation between the select region of two chanells
cla(handles.axes4);

if p2v ~= p3v
    s = scatter(handles.axes4,temp_trace(fret_to_plot,p2v)',temp_trace(fret_to_plot,p3v)');
    set(s,'SizeData',10,'MarkerEdgeColor','b','MarkerFaceColor','b')
    ps2 = get(handles.popupmenu2,'String');
    ps3 = get(handles.popupmenu3,'String');
    xlabel(handles.axes4,ps2(p2v))
    ylabel(handles.axes4,ps3(p3v))
end


% Show where there are molecules
cla(handles.axes5);
scatter(handles.axes5,handles.positions(:,1),handles.positions(:,2),'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',[12])
hold(handles.axes5, 'on');
scatter(handles.axes5,current_position(1),current_position(2),'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',[30] );
hold(handles.axes5, 'on');
scatter(handles.axes5,handles.positions(:,1).*handles.selected,handles.positions(:,2).*handles.selected,'Marker','o','MarkerEdgeColor','y','MarkerFaceColor','y','SizeData',[12])
set(handles.axes5, 'Color', 'k','YTickLabel',[],'XTickLabel',[]);


% Update visula clues
if handles.selected(index) == true   
    bg_color = 'w';
else   
    bg_color = 'k';
end
% update the background color
set(handles.axes2, 'Color', bg_color)
set(handles.axes3, 'Color', bg_color)
set(handles.axes4, 'Color', bg_color)
set(handles.axes7, 'Color', bg_color)
set(handles.axes1, 'Color', bg_color)

% linkaxes([handles.axes2, handles.axes3],'x'), % connect the axes of FRET and Kinetics
% h = zoom;
% set(h,'ActionPostCallback',@(hObject,eventdata)trace_viewer('mypostcallback',hObject,eventdata,guidata(hObject)));


if handles.selected(index) == true
    zoom(handles.figure1,'off')
else
  
h = zoom;
set(h,'Motion','both','Enable','on');
   
setAxesZoomMotion(h,handles.axes1,'both')
setAxesZoomMotion(h,handles.axes2,'both')
setAllowAxesZoom(h,handles.axes4,false)
setAllowAxesZoom(h,handles.axes4,false)
setAllowAxesZoom(h,handles.axes5,false)


% the following is valid while zoom is active
% trick to get things to work from 
% http://groups.google.ca/group/comp.soft-sys.matlab/msg/db42cf51392b442a
hManager = uigetmodemanager(handles.figure1);
set(hManager.WindowListenerHandles,'Enable','off'); 
set(handles.figure1,'KeyPressFcn',@(hObject,eventdata)trace_viewer('figure1_KeyPressFcn',hObject,eventdata,guidata(hObject)));
end


guidata(gcf, handles);
update_textbox(hObject, handles)
output = handles;





function update_textbox(hObject, handles)




data_info = {
    ['File Name',' ', handles.filename]    
    ['trace',' ', num2str(handles.index),' out of', ' ',num2str(handles.nummol)]
    []
    []
    [handles.tv_settings{2,1},'  ', num2str(handles.tv_settings{2,2})]
    [handles.tv_settings{4,1},'  ', num2str(handles.tv_settings{4,2})]
    [handles.tv_settings{5,1},'  ', num2str(handles.tv_settings{5,2})]
    };


set(handles.listbox1,'String',data_info)





% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.calc_good_trace = 1;
%guidata(gcf, handles);
update_figure(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% step backwords in the traces file
% if handles.index ~= 1    
%     handles.index = handles.index-1;
%     guidata(gcf, handles);
%     update_figure(gcf, handles)
% end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.selected(handles.index) == 0
    handles.selected(handles.index) = 1;
    
    len = size(handles.data{handles.index,2},1);
    selected_region = ones(1,len);
    current_xlim = round(get(handles.axes2,'XLim'));
    selected_region(1:current_xlim(1))=0;
    selected_region(current_xlim(2):end)=0;
    handles.selected_region{handles.index} = selected_region;
    
    
else
    handles.selected(handles.index) = 0;
end

guidata(gcf, handles);
update_figure(gcf, handles);



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

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




keypressed=get(hObject,'CurrentCharacter');
switch keypressed
    %lets test this out for all keyboard friendly:

    
    case 'f', % Next Trace
        %pushbutton1_Callback(hObject, eventdata, handles);
        temp  = get(handles.slider1,'Value');
        temp = temp + 1;
        % To prevent errors at the ends
        if temp > get(handles.slider1,'Max')
        temp = get(handles.slider1,'Max');
        end
        set(handles.slider1,'Value',temp);
        slider1_Callback(hObject, eventdata, handles)
        
    case 'd', % Previous Trace
        %pushbutton2_Callback(hObject, eventdata, handles);
        
        temp  = get(handles.slider1,'Value');
        temp = temp - 1;
        % to prevent errors at the end
        if temp < 1
        temp = 1;
        end
            
        set(handles.slider1,'Value',temp);
        slider1_Callback(hObject, eventdata, handles)
        
    case 'r', % Select Trace
        pushbutton3_Callback(hObject, eventdata, handles);
        
    case 'g', % Select Trace
        pushbutton1_Callback(hObject, eventdata, handles);

end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function settings_Callback(hObject, eventdata, handles)
% hObject    handle to settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


   handles.tv_settings = trace_viewer_settings(handles.tv_settings );
   guidata(gcf, handles);
   update_textbox(hObject, handles)
   


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


q_vs = get(handles.checkbox1,'Value');
new_position = round(get(handles.slider1,'Value'));

if q_vs==true
   
selected_mol = find(handles.selected~=0);
handles.index = selected_mol(new_position);

else

handles.index = new_position;

end

len=size(handles.data{handles.index,2},1);
% An uper limit on the axes need to be set
xlim(handles.axes1,[0 len])
xlim(handles.axes2,[0 len])

guidata(hObject, handles);
update_figure(hObject, handles);





% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



% Hint: get(hObject,'Value') returns toggle state of checkbox1

val = get(handles.checkbox1,'value');


if val == 0
  
a_click(1) = 1/handles.nummol;
a_click(2) = a_click(1)*4;

set(handles.slider1,'SliderStep',a_click)
set(handles.slider1, 'Max',handles.nummol)
set(handles.slider1, 'Min',1)    
set(handles.slider1, 'Value',1)     
  
else 
num_selected = size(find(handles.selected==1),1);

 if num_selected == 0
 set(handles.checkbox1,'Value',0)
 else


a_click(1) = 1/num_selected;
a_click(2) = a_click(1)*4;

if a_click == [Inf Inf]
   a_click = [ 0 1];
end


set(handles.slider1,'SliderStep',a_click)
set(handles.slider1, 'Max',num_selected)
set(handles.slider1, 'Min',1)
set(handles.slider1, 'Value',1)
end

end

slider1_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --------------------------------------------------------------------
function open2_Callback(hObject, eventdata, handles)
% hObject    handle to open2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_any_Callback(hObject, eventdata, handles)
% hObject    handle to open_any (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% This is the generic opening function it is being rewrittent to make
% opening files saved as .mat the most efficient for as well as to include
% older file formats.
% currently supported



[filename, pathname] = uigetfile( ...
{'*.traces','*.traces';...
 '*.tracesp','*.tracesp'});


% Save file name an stet the pat the the navagated path
handles.filename = filename;
handles.pathname = pathname;
% Don's have too many spaced in your path name matlab is up happy...
%cd(handles.pathname) ;

handles.auto_select = get(handles.checkbox1,'Value');
set(handles.checkbox1,'Value',0)
guidata(gcf, handles);

open_movie(hObject, eventdata, handles)

% Automatically select molecule upon opening
if handles.auto_select == true
    
    for i=1:handles.nummol
       
    handles.index = i;
    handles.calc_good_trace =1;
    handles = update_figure(gcf, handles);
    guidata(gcf, handles);    
    
    end
    
    
    handles.index = 1;
    guidata(gcf, handles)
    set(handles.slider1,'Value',1)
    slider1_CreateFcn(hObject, eventdata, handles)
    
    
end




% --------------------------------------------------------------------
function open_next_Callback(hObject, eventdata, handles)
% hObject    handle to open_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handls and user data (see GUIDATA)

if strmatch('.tracesp',handles.movie_type, 'exact') == 1

    number = 1+handles.movie_number;
   
    handles.filename = ['cascade',num2str(number),'(4)', handles.movie_type];
    guidata(gcf, handles);
    
    open_movie(hObject, eventdata, handles)

else
   
    display(' only works for .tracesp files')
    
end


% --------------------------------------------------------------------
function open_series_Callback(hObject, eventdata, handles)
% hObject    handle to open_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function open_movie(hObject, eventdata, handles)


[token, suffix] = strtok(handles.filename, '.');
 
if strmatch('.tracesp',suffix, 'exact') == 1; 
    
% As of April 2009 this has been the standard way th imput files. This
% should change with better
% Integration of gui4fast2.  Sergey Created this file structure.



% Get the frame rate
framerate = []; % In the future FPS is not automaticly defined during movie extraction
if isempty(framerate)
    framerate = input('Enter Camera Acquisition Rate in FPS  ');
end
handles.fps = framerate;

% Define a movie number for open next
bp = strfind(token,'(4)');
handles.movie_number = token(8:(bp-1));
handles.movie_series = token((bp+1):(end-1));

handles.movie_number = str2num(handles.movie_number);
handles.movie_series = str2num(handles.movie_series);

handles.movie_type = '.tracesp';

fid=fopen(handles.filename,'r');
len=fread(fid,1,'int32');
Ntraces=fread(fid,1,'int16');
handles.nummol = Ntraces/2; % The number of molecules
Positions = fread(fid,[Ntraces+1 2],'int16'); %SERGEY - position matrix read here. NOTE that absolute positions
reshap_positions = [Positions(2:2:end,:) Positions(3:2:end,:)]; % Molecule Positions
handles.positions = reshap_positions;
%of spots on the CCD are given and donor will not overalp with
%acceptor because of the offsets!!!
Data=fread(fid,[Ntraces+1 len],'int16');
fclose(fid);
handles.data = int16(Data(2:end,:)); % Having an odd number of rows makes counting difficult latter

group_data = cell(handles.nummol,3);
i=1;
for j = 1:2:handles.nummol*2
    
    group_data{i,2} = [handles.data(j,:)' handles.data(j+1,:)'];
    group_data{i,1}.name = handles.filename;
    group_data{i,1}.gp_num = NaN;
    group_data{i,1}.movie_num = handles.movie_number;
    group_data{i,1}.movie_ser = handles.movie_series;
    group_data{i,1}.trace_num = i;
    group_data{i,1}.spots_in_movie = Ntraces;
    group_data{i,1}.position_x = handles.positions(i,3);
    group_data{i,1}.position_y = handles.positions(i,4);
    group_data{i,1}.positions = reshap_positions;
    group_data{i,1}.fps = handles.fps;
    group_data{i,1}.len = size(group_data{i,2},1);
    group_data{i,1}.nchannels = size(group_data{i,2},2);
    
    i=i+1;
end

handles.data = group_data;
% Fix the Position format

%handles.positions = [Positions(2:2:end,:) Positions(3:2:end,:)]; % Molecule Positions [
handles.selected =zeros(handles.nummol,1); % Is a Molecule Selected
% Selected regions of a trace
handles.selected_region = mat2cell(ones(handles.nummol,len),ones(handles.nummol,1),len);


handles.index = 1; % Assign an intex for the movies
figure(gcf)

cstring = {};
for i=1:2
    cstring = [cstring ['Channel ' num2str(i)]];
    
end

set(handles.popupmenu2,'String',cstring,'Value',1)
set(handles.popupmenu3,'String',cstring,'Value',1)

    
elseif strmatch('.traces',suffix, 'exact') == 1
    

    % loading the .traces file as SMART matlab formated
    load(handles.filename,'-mat');
    handles.movie_type = '.trace';
    handles.nummol = size(group_data,1);
    
    data =[];
    positions =[];
    selected =[];
    selected_region =[];
       
    positions = [];
    for i=1:handles.nummol
        
        positions = [ positions; [group_data{i,1}.position_x group_data{i,1}.position_y]];
        
        if isempty(group_data{i,3})
            selected = [ selected; 0];
            selected_region = [selected_region ; {zeros(1,size(group_data{i,2},1))}] ;
        else
            selected = [ selected; 1];
            selected_region = [selected_region ; {double(group_data{i,3})'}] ;
        end
    end
    
    nchanells = size(group_data{1,2},2);
    cstring = {};
    for i=1:nchanells
        cstring = [cstring ['Channel ' num2str(i)]];   
    end
    
    set(handles.popupmenu2,'String',cstring,'Value',1)
    set(handles.popupmenu3,'String',cstring,'Value',1)
    
    handles.data = group_data;
    handles.positions = positions;
    handles.selected = selected;
    handles.selected_region = selected_region;
    handles.index = 1; % Assign an intex for the movies
             
    
else
    
    display('not supported traces format')

end

trace_viewer_look(handles,2)


if handles.tv_settings{10,2} == false
    linkaxes([handles.axes2, handles.axes2],'x');   
else 
    linkaxes([handles.axes1, handles.axes2],'x'); % connect the axes of FRET and Kinetics   
end

h = zoom;
set(h,'ActionPostCallback',@(hObject,eventdata)trace_viewer('mypostcallback',hObject,eventdata,guidata(hObject)));


guidata(gcf, handles);

% Update the figure to show the first trace
checkbox1_Callback(hObject, eventdata, handles)
update_figure(gcf, handles);


% --------------------------------------------------------------------
function save_traces_Callback(hObject, eventdata, handles)
% hObject    handle to save_traces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% import the selected molecule and regions
selected_molecules = handles.selected;
group_data = handles.data;

for j =1:handles.nummol
    
    select_region = find(handles.selected_region{j}==1);
    
    if handles.selected(j)
        
        final_selected = false(size(handles.data{j,2},1),1);
        final_selected(select_region) = true;
        
    else
        final_selected = [];
    end
    group_data{j,3} =final_selected;
    
end


tempfilename = handles.filename;

% If files are from Bernies time...apend the file name since they are
% sufxied with .traces...but those traces are not .mat files
if strcmp(handles.movie_type,'.tracesp')
    
    tempfilename = handles.filename;
    tempfilename = ['movie',num2str(handles.movie_number),'(1).traces'];
end


save(tempfilename, 'group_data');

set(handles.slider1,'Value',1);
slider1_Callback(hObject, eventdata, handles)

guidata(gcf, handles);

data_info = {
    ['Traces Saved']
    ['File Name ',' ', tempfilename]
    };

set(handles.listbox1,'String',data_info)

   


% --------------------------------------------------------------------
function save_trace_Callback(hObject, eventdata, handles)
% hObject    handle to save_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




group_data  = handles.data(handles.index,:);

fig1 = figure;
titlename = [handles.filename(1:end-7),' ', 'trace',' ', num2str(handles.index),'of',num2str(handles.nummol)];
set(fig1,'Name',titlename)
clipboard('copy',titlename);


%length = get(handles.cd.donor,'XData')/handles.fps;
ax1 = subplot(1,1,1);

color_order = {'g','r','b','m','y'};
for i=1:group_data{1}.nchannels
plot(1:group_data{1}.len,group_data{2}(:,i),color_order{i});
hold(ax1,'on')
end

ylabel('Intensity')
xlabel('Frame')

% save the data
user_entry = input('Press return to continue or enter a name to safe the current data (enter [d] for a default name) ', 's');

if isempty(user_entry) == false
    
    if strmatch('d',user_entry, 'exact') == 1
        save_name = [titlename,'.traces'];
    else
        save_name = [user_entry,'.traces'];
    end
    save(save_name, 'group_data')
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

update_figure(gcf, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
update_figure(gcf, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

update_figure(gcf, handles);
