% HumanStruct = Handles2Human(handles) (private)
% takes as its input the graphics handles for a LockInGUI object and scans
% those handles for the appropriate values to use for creating a
% human-readable output structure.
%
% See also LockInGUI, GetLockInSettings, SetLockIn
function HumanStruct = Handles2Human(Handles)

gainVector = [20, 26, 34, 40, 46, 54, 60, 66, 74, 80, 86];
TcVector = [1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2 3e-2 1e-1 3e-1 1];
SlopeVector = [6 12 18 24];
XYResModVec = {'Maximum', 'Manual', 'Minimum'};
ZResModVec = {'Maximum', 'Normal', 'LowNoise'};

% If somehow phase setting do not match between edit box and slider bar,
% slider bar takes priority.
if str2double(get(Handles.PhaseXY, 'String')) ~= get(Handles.PhaseXY, 'Value'),
    set(Handles.PhaseXY_Text, 'String', get(Handles.PhaseXY, 'Value'));
end;

if str2double(get(Handles.PhaseZ, 'String')) ~= get(Handles.PhaseZ, 'Value'),
    set(Handles.PhaseZ_Text, 'String', get(Handles.PhaseZ, 'Value'));
end;

HumanStruct = struct(   'FreqXY', 1000*str2double(get(Handles.FreqXY, 'String')),...
                        'FreqZ', 1000*str2double(get(Handles.FreqZ, 'String')),...
                        'PhaseXY', get(Handles.PhaseXY, 'Value'),...
                        'PhaseZ', get(Handles.PhaseZ, 'Value'),...
                        'GainXY', gainVector(get(Handles.GainXY, 'Value')),...
                        'GainZ', gainVector(get(Handles.GainZ, 'Value')),...
                        'TcXY', TcVector(get(Handles.TcXY, 'Value')),...
                        'TcZ', TcVector(get(Handles.TcZ, 'Value')),...
                        'SlopeXY', SlopeVector(get(Handles.SlopeXY, 'Value')),...
                        'SlopeZ', SlopeVector(get(Handles.SlopeZ, 'Value')),...
                        'ReserveModeXY', XYResModVec(get(Handles.ReserveModeXY, 'Value')),...
                        'ReserveModeZ', ZResModVec(get(Handles.ReserveModeZ, 'Value')),...
                        'ReserveXY', get(Handles.ReserveXY, 'Value')-1,...
                        'OffsetX', get(Handles.OffsetX, 'Value'),...
                        'OffsetY', get(Handles.OffsetY, 'Value'),...
                        'OffsetZ', get(Handles.OffsetZ, 'Value'));

return;