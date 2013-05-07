% Gain = Sens2Gain(Sens)
% Returns the SRS lock-in amplifier gain setting that to the corresponds 
% to the input sensitivity setting.
%
% See also Gain2Sens
function Gain = Sens2Gain(Sens)

Gain = 20*log10(10/Sens); % in dB

return;