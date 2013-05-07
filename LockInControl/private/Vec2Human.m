% HumanStruct = Vec2Human(axy, az) (private)
% converts the input pair of vectors (suitable for internet
% communication with the srsserv server) into a human-readable
% structure containing lockin parameters according to the LOCKIN_PARAMS
% global variable format.
%
% See also Human2Vec, GetLockInSettings, SetLockIn, LockInGUI
function HumanStruct = Vec2Human(axy, az)

gainVector = [20, 26, 34, 40, 46, 54, 60, 66, 74, 80, 86];
TcVector = [1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2 3e-2 1e-1 3e-1 1];
SlopeVector = [6 12 18 24];
XYResModVec = {'Maximum', 'Manual', 'Minimum'};
ZResModVec = {'Maximum', 'Normal', 'LowNoise'};

HumanStruct = struct('FreqXY', axy(2), ...
                'FreqZ', az(2),...
                'PhaseXY', axy(3),...
                'PhaseZ', az(3),...
                'GainXY', gainVector(axy(4) + 1),...
                'GainZ', gainVector(az(4) + 1),...
                'TcXY', TcVector(axy(5) + 1),...
                'TcZ', TcVector(az(5) + 1),...
                'SlopeXY', SlopeVector(axy(6) + 1),...
                'SlopeZ', SlopeVector(az(6) + 1),...
                'ReserveModeXY', XYResModVec{axy(7) + 1}, ...
                'ReserveModeZ', ZResModVec{az(7) + 1}, ...
                'ReserveXY', axy(8),...
                'OffsetX', axy(9),...
                'OffsetY', axy(10),...
                'OffsetZ', az(9));
return;


