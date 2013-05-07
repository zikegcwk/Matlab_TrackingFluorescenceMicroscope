function SRSStruct = Human2SRS(HumanStruct)

gainVector = [20, 26, 34, 40, 46, 54, 60, 66, 74, 80, 86];
TcVector = [1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2 3e-2 1e-1 3e-1 1];
SlopeVector = [6 12 18 24];
XYResModVec = {'Maximum', 'Manual', 'Minimum'};
ZResModVec = {'Maximum', 'Normal', 'LowNoise'};

if HumanStruct.FreqXY < 0.001 || HumanStruct.FreqZ < 0.001
    error('Frequencies must be greater than 1mHz.');
end;

if HumanStruct.FreqXY > 102000 || HumanStruct.FreqZ > 102000
    error('Maximum frequency is 102kHz.');
end;

if HumanStruct.PhaseXY < -360 || HumanStruct.PhaseZ < -360 ...
    || HumanStruct.PhaseXY > 360 || HumanStruct.PhaseZ > 360,
    error('Phase out of bounds.');
end;

if HumanStruct.OffsetX < -105 || HumanStruct.OffsetX > 105 ...
    || HumanStruct.OffsetY < -105 || HumanStruct.OffsetY > 105 ...
    || HumanStruct.OffsetZ < -105 || HumanStruct.OffsetZ > 105,
        error('Offset out of bounds.');
end;

XYResModMatch = strcmp(upper(HumanStruct.ReserveModeXY), upper(XYResModVec));
ZResModMatch = strcmp(upper(HumanStruct.ReserveModeZ), upper(ZResModVec));

if ~sum(XYResModMatch) || ~sum(ZResModMatch),
    error('Invalid reserve mode');
end;

if HumanStruct.ReserveXY < 0 || HumanStruct.ReserveXY > 6,
    error('Invalid XY reserve');
end;

SRSStruct = struct('FreqXY', HumanStruct.FreqXY,...
                   'FreqZ', HumanStruct.FreqZ,...
                   'PhaseXY', HumanStruct.PhaseXY,...
                   'PhaseZ', HumanStruct.PhaseZ,...
                   'GainXY', find(abs(gainVector - HumanStruct.GainXY)...
                        == min(abs(gainVector - HumanStruct.GainXY))) - 1,...
                   'GainZ', find(abs(gainVector - HumanStruct.GainZ)...
                        == min(abs(gainVector - HumanStruct.GainZ))) - 1,...
                   'TcXY', find(abs(TcVector - HumanStruct.TcXY) ...
                        == min(abs(TcVector - HumanStruct.TcXY))) - 1,...
                   'TcZ', find(abs(TcVector - HumanStruct.TcZ) ...
                        == min(abs(TcVector - HumanStruct.TcZ))) - 1,...
                   'SlopeXY', find(abs(SlopeVector - HumanStruct.SlopeXY) ...
                        == min(abs(SlopeVector - HumanStruct.SlopeXY))) - 1,...
                   'SlopeZ', find(abs(SlopeVector - HumanStruct.SlopeZ) ...
                        == min(abs(SlopeVector - HumanStruct.SlopeZ))) - 1,...
                   'ReserveModeXY', find(XYResModMatch) - 1,...
                   'ReserveModeZ', find(ZResModMatch) - 1,...
                   'ReserveXY', HumanStruct.ReserveXY,...
                   'OffsetX', HumanStruct.OffsetX,...
                   'OffsetY', HumanStruct.OffsetY,...
                   'OffsetZ', HumanStruct.OffsetZ);
return;