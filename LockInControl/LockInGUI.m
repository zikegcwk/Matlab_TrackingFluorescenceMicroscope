function varargout = LockInGUI(varargin)
% LOCKINGUI M-file for LockInGUI.fig
%      LOCKINGUI, by itself, creates a new LOCKINGUI or raises the existing
%      singleton*.
%
%      H = LOCKINGUI returns the handle to a new LOCKINGUI or the handle to
%      the existing singleton*.
%
%      LOCKINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCKINGUI.M with the given input arguments.
%
%      LOCKINGUI('Property','Value',...) creates a new LOCKINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LockInGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LockInGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LockInGUI

% Last Modified by GUIDE v2.5 04-Oct-2008 15:38:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LockInGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LockInGUI_OutputFcn, ...
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


% --- Executes just before LockInGUI is made visible.
function LockInGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LockInGUI (see VARARGIN)

% Choose default command line output for LockInGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% set(hObject, 'WindowStyle', 'docked');

% UIWAIT makes LockInGUI wait for user response (see UIRESUME)
% uiwait(handles.LockInGUI);


% --- Outputs from this function are returned to the command line.
function varargout = LockInGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% For reasons that I do not understand, the following command to update the
% GUI based on instrument settings must be called here, in the output
% function, instead of in the previous function, to avoid an error message.
UpdateLockInGUI(GetLockInSettings());
% Something always goes wrong here when addressing the RetrieveText handle.
% I don't know why, but it seems like the following lines might work
% together:
RetrieveTextHandle = findobj(get(get(hObject, 'Parent'), 'Parent'), 'Tag', 'RetrieveText');
set(RetrieveTextHandle, 'Visible', 'off');
set(handles.RetrieveText, 'Visible', 'off');

% --- Executes on slider movement.
function GainXY_Callback(hObject, eventdata, handles)
% hObject    handle to GainXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.GainXY, 'Value'));
set(handles.GainXY, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function GainXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GainXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function XYGain_Text_Callback(hObject, eventdata, handles)
% hObject    handle to GainXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GainXY_Text as text
%        str2double(get(hObject,'String')) returns contents of GainXY_Text as a double


% --- Executes during object creation, after setting all properties.
function GainXY_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GainXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XYSens_Text_Callback(hObject, eventdata, handles)
% hObject    handle to SensXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensXY_Text as text
%        str2double(get(hObject,'String')) returns contents of SensXY_Text as a double


% --- Executes during object creation, after setting all properties.
function SensXY_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function GainZ_Callback(hObject, eventdata, handles)
% hObject    handle to GainZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = round(get(handles.GainZ, 'Value'));
set(handles.GainZ, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function GainZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GainZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ZGain_Text_Callback(hObject, eventdata, handles)
% hObject    handle to GainZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GainZ_Text as text
%        str2double(get(hObject,'String')) returns contents of GainZ_Text as a double


% --- Executes during object creation, after setting all properties.
function GainZ_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GainZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZSens_Text_Callback(hObject, eventdata, handles)
% hObject    handle to SensZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensZ_Text as text
%        str2double(get(hObject,'String')) returns contents of SensZ_Text as a double


% --- Executes during object creation, after setting all properties.
function SensZ_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TcXY_Callback(hObject, eventdata, handles)
% hObject    handle to TcXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.TcXY, 'Value'));
set(handles.TcXY, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));


% --- Executes during object creation, after setting all properties.
function TcXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TcXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function XYTc_Text_Callback(hObject, eventdata, handles)
% hObject    handle to TcXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TcXY_Text as text
%        str2double(get(hObject,'String')) returns contents of TcXY_Text as a double

% --- Executes during object creation, after setting all properties.
function TcXY_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TcXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TcZ_Callback(hObject, eventdata, handles)
% hObject    handle to TcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.TcZ, 'Value'));
set(handles.TcZ, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));


% --- Executes during object creation, after setting all properties.
function TcZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ZTc_Text_Callback(hObject, eventdata, handles)
% hObject    handle to TcZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TcZ_Text as text
%        str2double(get(hObject,'String')) returns contents of TcZ_Text as a double


% --- Executes during object creation, after setting all properties.
function TcZ_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TcZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SlopeXY.
function SlopeXY_Callback(hObject, eventdata, handles)
% hObject    handle to SlopeXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SlopeXY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SlopeXY

SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function SlopeXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlopeXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SlopeZ.
function SlopeZ_Callback(hObject, eventdata, handles)
% hObject    handle to SlopeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SlopeZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SlopeZ

SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function SlopeZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlopeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ReserveModeXY.
function ReserveModeXY_Callback(hObject, eventdata, handles)
% hObject    handle to ReserveModeXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ReserveModeXY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ReserveModeXY

SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function ReserveModeXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReserveModeXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ReserveModeZ.
function ReserveModeZ_Callback(hObject, eventdata, handles)
% hObject    handle to ReserveModeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ReserveModeZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ReserveModeZ

SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function ReserveModeZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReserveModeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ReserveXY.
function ReserveXY_Callback(hObject, eventdata, handles)
% hObject    handle to ReserveXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ReserveXY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ReserveXY

SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function ReserveXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReserveXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function OffsetX_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.OffsetX, 'Value')*100)/100;
set(handles.OffsetX, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function OffsetX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function OffsetY_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.OffsetY, 'Value')*100)/100;
set(handles.OffsetY, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function OffsetY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function OffsetZ_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue = round(get(handles.OffsetZ, 'Value')*100)/100;
set(handles.OffsetZ, 'Value', sliderValue);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function OffsetZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function FreqZ_Callback(hObject, eventdata, handles)
% hObject    handle to FreqZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FreqZ as text
%        str2double(get(hObject,'String')) returns contents of FreqZ as a double

SetLockIn(Handles2Human(handles));


% --- Executes during object creation, after setting all properties.
function FreqZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PhaseZ_Text_Callback(hObject, eventdata, handles)
% hObject    handle to PhaseZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PhaseZ_Text as text
%        str2double(get(hObject,'String')) returns contents of PhaseZ_Text as a double

newPhaseZ = round(str2double(get(handles.PhaseZ_Text, 'String'))*100)/100;
set(handles.PhaseZ_Text, 'String', newPhaseZ);
set(handles.PhaseZ, 'Value', newPhaseZ);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function PhaseZ_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PhaseZ_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FreqXY_Callback(hObject, eventdata, handles)
% hObject    handle to FreqXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FreqXY as text
%        str2double(get(hObject,'String')) returns contents of FreqXY as a double

SetLockIn(Handles2Human(handles));


% --- Executes during object creation, after setting all properties.
function FreqXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PhaseXY_Callback(hObject, eventdata, handles)
% hObject    handle to PhaseXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PhaseXY_Text as text
%        str2double(get(hObject,'String')) returns contents of PhaseXY_Text as a double

newPhaseXY = round(100*get(handles.PhaseXY, 'Value'))/100;
set(handles.PhaseXY, 'Value', newPhaseXY);
set(handles.PhaseXY_Text, 'String', newPhaseXY);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function PhaseXY_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PhaseXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in UpdateButtonY.
function UpdateButtonY_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateButtonY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RetrieveTextHandle = findobj(get(get(hObject, 'Parent'), 'Parent'), 'Tag', 'RetrieveText');
set(RetrieveTextHandle, 'Visible', 'on');
drawnow;
UpdateLockInGUI(GetLockInSettings());
set(RetrieveTextHandle, 'Visible', 'off');
guidata(hObject, handles);


% --- Executes on button press in UpdateButtonX.
function UpdateButtonX_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateButtonX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RetrieveTextHandle = findobj(get(get(hObject, 'Parent'), 'Parent'), 'Tag', 'RetrieveText');
set(RetrieveTextHandle, 'Visible', 'on');
drawnow;
UpdateLockInGUI(GetLockInSettings());
set(RetrieveTextHandle, 'Visible', 'off');
guidata(hObject, handles);


% --- Executes on slider movement.
function PhaseZ_Callback(hObject, eventdata, handles)
% hObject    handle to PhaseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

newPhaseZ = round(get(handles.PhaseZ, 'Value')*100)/100;
set(handles.PhaseZ, 'Value', newPhaseZ);
set(handles.PhaseZ_Text, 'String', newPhaseZ);
SetLockIn(Handles2Human(handles));

% --- Executes during object creation, after setting all properties.
function PhaseZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PhaseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function PhaseXY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PhaseXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function PhaseXY_Text_Callback(hObject, eventdata, handles)
% hObject    handle to PhaseXY_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PhaseXY_Text as text
%        str2double(get(hObject,'String')) returns contents of PhaseXY_Text as a double

newPhaseXY = round(str2double(get(handles.PhaseXY_Text, 'String'))*100)/100;
set(handles.PhaseXY_Text, 'String', newPhaseXY);
set(handles.PhaseXY, 'Value', newPhaseXY);
SetLockIn(Handles2Human(handles));
