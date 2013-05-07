% [tags, t, x, y, z, modx, mody, ex1, ex2] = Capture3D_mod(Timeout, SampRate);
%   tags returns fluorescence photon time tags
%   t returns xyz sample times
%   x, y, z return stage position
%   Timeout in seconds, defaults to 10
%   SampRate in Hz, defaults to 1000
%
%   See also capture3d, rttags, rttrace
function [tags, t, x, y, z, modx, mody, ex1, ex2] = Capture3D_mod(Timeout, SampRate);

global LineState;

if LineState(1) & LineState(2),
    chan = 2;
    fprintf('Measuring fluorescence on both APDs.\n');
else if LineState(1),
        chan = 0;
        fprintf('Measuring fluorescence on APD 0\n');
    else if LineState(2),
            chan = 1;
            fprintf('Measuring fluorescence on APD 1\n');
        else
            error('You should probably turn a detector on first.');
        end;
    end;
end;
   

if nargin < 2,
    SampRate = 1000;
end;

if nargin == 0,
    Timeout = 10;
end;

Timeout = min([Timeout, 100]);

%gt65x_init(0);
ReadChan = 0:(2+nargout - 5);

ar = SetupAnalogRead(ReadChan, SampRate, Timeout);
TriggerAnalogRead(ar);

if chan == 2,
    [tags0, tags1] = rttags(0, 2e7, Timeout, chan);
    tags = {tags0, tags1};
else
    tags0 = rttags(0, 2e7, Timeout, chan);
    tags = {tags0};
end;


data = GetAnalogData(ar);

x = data(:, 1) * 10;
y = data(:, 2) * 10;
z = data(:, 3) * 4;
t = (0:(length(x)-1))./SampRate;
if nargout > 5,
    ex1 = data(:, 4);
end;

if nargout > 6,
    ex2 = data(:, 5);
end;
return;