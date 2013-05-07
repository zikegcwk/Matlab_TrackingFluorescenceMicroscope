function [axy, az] = SRSStruct2Vec(SRSStruct)

axy = [2, SRSStruct.FreqXY, SRSStruct.PhaseXY, SRSStruct.GainXY,...
    SRSStruct.TcXY, SRSStruct.SlopeXY, SRSStruct.ReserveModeXY, ...
    SRSStruct.ReserveXY, SRSStruct.OffsetX, SRSStruct.OffsetY];

az = [0, SRSStruct.FreqZ, SRSStruct.PhaseZ, SRSStruct.GainZ,...
    SRSStruct.TcZ, SRSStruct.SlopeZ, SRSStruct.ReserveModeZ,0,...
    SRSStruct.OffsetZ, 0.0];

return;