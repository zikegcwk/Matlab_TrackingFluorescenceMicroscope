function HumanStruct = SRS2Human(SRSStruct)

gainVector = [20, 26, 34, 40, 46, 54, 60, 66, 74, 80, 86];
TcVector = [1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2 3e-2 1e-1 3e-1 1];
SlopeVector = [6 12 18 24];
XYResModVec = {'Maximum', 'Manual', 'Minimum'};
ZResModVec = {'Maximum', 'Normal', 'LowNoise'};

HumanStruct = struct('FreqXY', SRSStruct.FreqXY, ...
                'FreqZ', SRSStruct.FreqZ,...
                'PhaseXY', SRSStruct.PhaseXY,...
                'PhaseZ', SRSStruct.PhaseZ,...
                'GainXY', gainVector(SRSStruct.GainXY + 1),...
                'GainZ', gainVector(SRSStruct.GainZ + 1),...
                'TcXY', TcVector(SRSStruct.TcXY + 1),...
                'TcZ', TcVector(SRSStruct.TcZ + 1),...
                'SlopeXY', SlopeVector(SRSStruct.SlopeXY + 1),...
                'SlopeZ', SlopeVector(SRSStruct.SlopeZ + 1),...
                'ReserveModeXY', XYResModVec{SRSStruct.ReserveModeXY + 1}, ...
                'ReserveModeZ', ZResModVec{SRSStruct.ReserveModeZ + 1}, ...
                'ReserveXY', SRSStruct.ReserveXY,...
                'OffsetX', SRSStruct.OffsetX,...
                'OffsetY', SRSStruct.OffsetY,...
                'OffsetZ', SRSStruct.OffsetZ);
return;


