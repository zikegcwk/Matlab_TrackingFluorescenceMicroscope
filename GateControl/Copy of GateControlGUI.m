function varargout = GateControlGUI(varargin)
% GATECONTROLGUI M-file for GateControlGUI.fig
%      GATECONTROLGUI, by itself, creates a new GATECONTROLGUI or raises the existing
%      singleton*.
%
%      H = GATECONTROLGUI returns the handle to a new GATECONTROLGUI or the handle to
%      the existing singleton*.
%
%      GATECONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GATECONTROLGUI.M with the given input arguments.
%
%      GATECONTROLGUI('Property','Value',...) creates a new GATECONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GateControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GateControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GateControlGUI

% Last Modified by GUIDE v2.5 03-Apr-2006 16:43:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GateControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GateControlGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GateControlGUI is made visible.
function GateControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GateControlGUI (see VARARGIN)

% Choose default command line output for GateControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%ShutterState(532, 0);
APDGate(1, 0);
APDGate(2, 0);
APDGate(3, 0);
APDGate(4, 0);

% UIWAIT makes GateControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GateControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
toggleState = get(hObject, 'Value');
if toggleState,
    APDGate(1, 1);
    fprintf('Gate 1 opened\n');
else
    APDGate(1, 0);
    fprintf('Gate 1 closed\n');
end;

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
toggleState = get(hObject, 'Value');
if toggleState,
    APDGate(2, 1);
    fprintf('Gate 2 opened\n');
else
    APDGate(2, 0);
    fprintf('Gate 2 closed\n');
end;


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
toggleState = get(hObject, 'Value');
if toggleState,
    APDGate(3, 1);
    fprintf('Gate 3 opened\n');
else
    APDGate(3, 0);
    fprintf('Gate 3 closed\n');
end;


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
toggleState = get(hObject, 'Value');
if toggleState,
    APDGate(4, 1);
    fprintf('Gate 4 opened\n');
else
    APDGate(4, 0);
    fprintf('Gate 4 closed\n');
end;

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

toggleState = get(hObject, 'Value');
if toggleState
    %ShutterState(532, 1);
    set(hObject, 'String', 'Shutter Open');
    fprintf('532nm Shutter opened.\n');
else 
    %ShutterState(532, 0);
    set(hObject, 'String', 'Shutter Closed');
    fprintf('532nm Shutter closed.\n');
end;
