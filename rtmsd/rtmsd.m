% RTMSD Compute MSD curve in real time.
%   [dt, dx, dy, dz] = rtmsd(timeout) Takes data for duration specified by 
%    timeout, then displays the MSD curve for the data.

function [dt, dx, dy, dz] = rtmsd(Timeout);

if nargin == 0,
    Timeout = 5;
    fprintf('Defaulting to 5 sec timeout\n');
end;

ReadChan = 0:2;
SampRate = 1000;
ar = SetupAnalogRead(ReadChan, SampRate, Timeout);
TriggerAnalogRead(ar);

pause(Timeout);

data = GetAnalogData(ar);

x = data(:, 1) * 10;
y = data(:, 2) * 10;
z = data(:, 3) * 4;
t = (0:(length(x)-1))./SampRate;

[dt, dx, dy, dz] = msd3d(t, x, y, z);

return;
