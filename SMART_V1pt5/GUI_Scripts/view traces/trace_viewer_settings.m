function varargout = trace_viewer_settings(varargin)
% TRACE_VIEWER_SETTINGS M-file for trace_viewer_settings.fig
%      TRACE_VIEWER_SETTINGS, by itself, creates a new TRACE_VIEWER_SETTINGS or raises the existing
%      singleton*.
%
%      H = TRACE_VIEWER_SETTINGS returns the handle to a new TRACE_VIEWER_SETTINGS or the handle to
%      the existing singleton*.
%
%      TRACE_VIEWER_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACE_VIEWER_SETTINGS.M with the given input arguments.
%
%      TRACE_VIEWER_SETTINGS('Property','Value',...) creates a new TRACE_VIEWER_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trace_viewer_settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trace_viewer_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trace_viewer_settings

% Last Modified by GUIDE v2.5 24-Jul-2009 19:12:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trace_viewer_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @trace_viewer_settings_OutputFcn, ...
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


% --- Executes just before trace_viewer_settings is made visible.
function trace_viewer_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trace_viewer_settings (see VARARGIN)

% Choose default command line output for trace_viewer_settings
handles.output = hObject;



if  isempty(varargin) == true
    
temp = pushbutton1_Callback(hObject, eventdata, handles);
%handles.averagin_method = temp.averagin_method;
handles.table_data = temp.table;
guidata(hObject, handles);
figure1_CloseRequestFcn(hObject, eventdata, handles)

    
else

    
handles.table_data = varargin{1};    
    
%handles.averagin_method = temp.averagin_method;


set(handles.uitable1, 'rowName', handles.table_data(:,1))
set(handles.uitable1, 'data', handles.table_data(:,2))
set(handles.uitable1, 'ColumnEditable',[true])


% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);


end

% UIWAIT makes trace_viewer_settings wait for user response (see UIRESUME)



% --- Outputs from this function are returned to the command line.
function varargout = trace_viewer_settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure



table_data = cat(2,get(handles.uitable1,'RowName'),get(handles.uitable1,'Data'));

varargout{1} = table_data;
delete(hObject);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume(handles.figure1)


% --- Executes on button press in pushbutton1.
function output = pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








handles.tv_settings.table = {
    'Cross Talk'           [0.0500]
    'Temp [k]'             [   293]
    'FPS'                  [   NaN]
    'Noise Cutoff'         [   500]
    'Averaging Window'     [     1]
    'Threshold'            [0.5000]
    'Min Trace Length'     [100]
    'Total Intensity'      [500]
    'Red Intensity'        [300]
    'Zoom All'             [false]
    'Total Intensity'      [true]
};



set(handles.uitable1, 'rowName', handles.tv_settings.table(:,1))
set(handles.uitable1, 'data', handles.tv_settings.table(:,2))
set(handles.uitable1, 'ColumnEditable',[true])

output = handles.tv_settings;

guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


uiresume(handles.figure1)

