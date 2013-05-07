function varargout = proc_traces(varargin)
% PROC_TRACES M-file for proc_traces.fig
%      PROC_TRACES, by itself, creates a new PROC_TRACES or raises the existing
%      singleton*.
%
%      H = PROC_TRACES returns the handle to a new PROC_TRACES or the handle to
%      the existing singleton*.
%
%      PROC_TRACES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROC_TRACES.M with the given input
%      arguments.
%
%      PROC_TRACES('Property','Value',...) creates a new PROC_TRACES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proc_traces_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proc_traces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proc_traces

% Last Modified by GUIDE v2.5 15-Apr-2010 18:13:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proc_traces_OpeningFcn, ...
                   'gui_OutputFcn',  @proc_traces_OutputFcn, ...
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


% --- Executes just before proc_traces is made visible.
function proc_traces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proc_traces (see VARARGIN)

% Choose default command line output for proc_traces
handles.output = hObject;


handles.table_spec = display_process;

%set(handles.figure1,'Position', [40 25 137 40])

% Update handles structure
guidata(hObject, handles);
set(gcf,'Position',[156.2857   33.0714  129.0000   37.5714]);

% UIWAIT makes proc_traces wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proc_traces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



[load_name load_path] = uigetfile({'*.traces*','Choose a (.traces) file'});
% get rid of an error
if isstr(load_path) ==true
    cd(load_path);
    load(load_name,'-mat')

if ~isempty(findstr(load_name,'.traces'))
    
    handles.group_data = group_data ;
    handles.group_name = load_name;
    
    displayname = ['Current File: ', load_name];
    set(handles.text1,'Visible','on','FontSize', 12,'FontWeight','Normal','String', displayname);
    

    handles.analysis_gui = 'process';
    guidata(gcf, handles);
    
    
    process_Callback(hObject, eventdata, handles)
    
    
else
    
    errordlg( 'Non Supported File Format')
end

end















% --------------------------------------------------------------------
function c_raw_data_Callback(hObject, eventdata, handles)
% hObject    handle to c_raw_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Idenfity analysis gui
handles.analysis_gui = 'combine';

set(handles.uitable1,'Visible','on')
set(handles.uitable1,'Data',[zeros(10,2) ones(10,2)])
set(handles.uitable1, 'ColumnEditable', [ true true true true ]);
set(handles.uitable1,'ColumnName',{'Movie Start' 'Movie End' 'Group Start' 'Group End'})
%set(handles.uitable1, 'CellEditCallback', @guess_name)
set(handles.uitable1,'RowName',{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'})

set(handles.uitable1,'Position',[0.05 0.4 0.9 0.5])
set(handles.edit1,'Position', [0.1 0.2 0.7 0.1])

set(handles.popupmenu1,'Position',[ 0.02 0.05 0.2  0.01])

set(handles.text1,'Visible','off')

set(handles.edit1, 'Visible','on','String','Default Name    movie[X X X ]_group[X X X].traces')
set(handles.popupmenu1,'Visible','off','String',{'Save'})

set(handles.popupmenu1,'Position',[ 0.02 0.05 0.2  0.01])
set(handles.pushbutton1,'Visible','on','Position',[ 0.3 0.015 0.2 0.05],'String','Save')





guidata(gcf, handles);

ls




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% Checke the status of the analysis window

        
current_val = get(handles.popupmenu1,'Value');
% need to clear the table if coming form concatenation

% Check by size the state the table is comming frome
temp(1:2) =  size(get(handles.uitable1,'Data'));

if  temp(1)==4 && temp(2)==2 || temp(1)==10 && temp(2)==4
% Initialize the table...    
set(handles.uitable1,'RowName', handles.table_spec.user_table1(:,1))
set(handles.uitable1,'Data', handles.table_spec.user_table1(:,2:end))
handles.HMMsize = 2;
set_cluster_table(handles) % set up cluster table




else


switch current_val
    
    case 1
        
        
        temp_names = get(handles.uitable1,'RowName');
        % compare to see if table is actuall being updated
        if strcmp(temp_names{1},handles.table_spec.user_table2{1,1})
        temp_data = get(handles.uitable1,'data');
        handles.table_spec.user_table2 = cat(2,temp_names, temp_data);
        end
        
        set(handles.uitable1,'RowName', handles.table_spec.user_table1(:,1))
        set(handles.uitable1,'Data', handles.table_spec.user_table1(:,2:end))
      
        
        set(handles.uitable1,'ColumnWidth',{50 50 50 50 50 50 50 50 50 50 50})
        set(handles.axes1,'visible','on')
        set(handles.uitable2,'Visible','on')
        
        
    case 2
        
        temp_names = get(handles.uitable1,'RowName');
        
        % compare to see if table is actuall being updated
        if strcmp(temp_names{1},handles.table_spec.user_table1{1,1})
        temp_data = get(handles.uitable1,'data');
        handles.table_spec.user_table1 = cat(2,temp_names, temp_data);
        end
        
        
        set(handles.uitable1,'RowName', handles.table_spec.user_table2(:,1))
        set(handles.uitable1,'Data', handles.table_spec.user_table2(:,2:end))
 
        
        cla
        set(handles.axes1,'visible','off')
        set(handles.uitable2,'Visible','off') 
        
    case 3
        
    handles.table_spec.user_table1 = handles.table_spec.default_table1;
    handles.table_spec.user_table2 = handles.table_spec.default_table2;    
        
    set(handles.uitable1,'RowName', handles.table_spec.user_table1(:,1))
    set(handles.uitable1,'Data', handles.table_spec.user_table1(:,2:end))

    set(handles.popupmenu1,'Value', 1)
    cla
    set(handles.axes1,'visible','on')
    set(handles.uitable2,'Visible','on')   
        
end

end



guidata(gcf, handles);
uitable1_CellEditCallback(hObject, eventdata, handles)






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


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% Checke the status of the analysis window


    v1 = get(handles.popupmenu1,'value');
    s1 = get(handles.popupmenu1,'string');

if strmatch(s1(v1),'HMM')
    
        output = updata_hmm_table(handles);
        handles = output;
        guidata(gcf, handles);
        
        
        temp_names = get(handles.uitable1,'RowName');
        temp_data = get(handles.uitable1,'data');
        handles.table_spec.user_table1 = cat(2,temp_names, temp_data);   
        cla(handles.axes1)
        updata_hmm_fit(handles)
        set_cluster_table(handles)
                    
end
                    


% --------------------------------------------------------------------
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






if isfield(handles,'group_data') == false
    
    errordlg('Load Data')
    
else
    
    handles.analysis_gui = 'process';
    
    
    set(handles.popupmenu1,'Position',[ 0.02 0.05 0.2  0.01])
    set(handles.popupmenu1,'Visible','on','String',{'HMM' 'FRET and Threshold' 'Default'},'Value',1)
    
    set(handles.pushbutton1,'Position',[ 0.3 0.015 0.1 0.05],'Visible', 'on', 'String','Fit')
    
    
    
    set(handles.uitable1,'Position',[0.05 0.08 0.55 0.85])
    set(handles.uitable1,'RowName','','RearrangeableColumns','off','Visible','on')
    columnformat = {'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char'};
    set(handles.uitable1,'columnName', 'numbered', 'ColumnFormat', columnformat)
    set(handles.uitable1, 'ColumnEditable', [ true true true true true true true true true true]);
    
    set(handles.axes1,'Visible','on','Position',[0.62    0.3    0.35    0.5],'Xtick',[],'Ytick',[],'Box','on','XLim',[-2 2],'YLim',[-2 2]) 
    
    set(handles.edit1, 'Visible','off')


    guidata(gcf, handles);

    popupmenu1_Callback(hObject, eventdata, handles)

    updata_hmm_fit(handles)


end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strmatch('combine', handles.analysis_gui, 'exact')


gui_state.uitable1_Data = get(handles.uitable1,'Data');
gui_state.edit1_String = get(handles.edit1,'String');
        
gui_state = group_traces(gui_state);
%set(handles.edit1,'String',gui_state.edit1_String)

elseif strmatch('process', handles.analysis_gui, 'exact')
    
    
    temp = get(handles.popupmenu1, 'Value');
    
    
    % get the last position of the table
    if temp == 1
       
        temp_names = get(handles.uitable1,'RowName');
        temp_data = get(handles.uitable1,'data');
        handles.table_spec.user_table1 = cat(2,temp_names, temp_data);   

        
    else
        
        temp_names = get(handles.uitable1,'RowName');
        temp_data = get(handles.uitable1,'data');
        handles.table_spec.user_table2 = cat(2,temp_names, temp_data);
    
         
    end
    
    
    
    
    
    sm_analyze(handles)
    
    set(handles.uitable1,'visible','off');
    set(handles.uitable2,'visible','off')
    set(handles.popupmenu1,'visible','off');
    set(handles.pushbutton1,'visible','off');
    set(handles.text1,'Visible', 'off');
    cla(handles.axes1)
    set(handles.axes1,'visible','off')
    rmfield(handles, {'group_data','group_name'});
    
    
    

    
else 
end

guidata(gcf, handles);
