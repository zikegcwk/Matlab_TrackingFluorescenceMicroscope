% Sens = Gain2Sens(Gain)
% Returns the SRS lock-in amplifier sensitivity setting that corresponds to
% the input gain setting.
% 
% See also Sens2Gain
function Sens = Gain2Sens(Gain)

Sens = 10^(1-Gain/20); % in volts

return;
