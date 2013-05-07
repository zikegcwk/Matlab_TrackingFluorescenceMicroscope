% RTTRACE  RealTimeTrace using mex interface
%   [time0, I0] = rttrace(ixBoard, numTimeTags, timeOut, sampTime) reads 
%   up to (numTimeTags) arrival times or up to (timeOut) seconds of data from 
%   GT658 board (ixBoard) and down-samples the arrival time data with sampling 
%   time (sampTime), storing the result (in kHz) in I0, and plotting the results.
%
%   [time0, I0] = rttrace(ixBoard, numTimeTags, timeOut, sampTime, plotOn)
%   will only plot I0 if (plotOn).
%
%   [time0, I0] = rttrace(ixBoard, numTimeTags, timeOut, sampTime, plotOn, ixChannel)
%   will make recordings from channel (ixChannel) of the GT658.
%
%   [time0, I0, time1, I1] = rttrace() records from both channels.
%   If specified, ixChannel is overridden.
%
%   See also rttags, capture3d, acquire
function [time0, I0, time1, I1] = rttrace(ixBoard, numTimeTags, timeOut, sampTime, plotOn, ixChannel);

global LineState;
global IntState;

% We need the board index, number of time tags, and timeOut
if nargin < 4,
    error('At least four inputs required');
end;

% PlotOn is the default
if nargin < 5,
    plotOn = 1;
end;

% Default is channel A when only one channel is being recorded from
if nargout < 3 & nargin < 6,
    ixChannel  = 0;
end;

% Override any value for ixChannel if both channels outputs are requested
if nargout > 2,
    ixChannel = 2;
end;

fprintf('Reading up to %d tags (for up to %gs) from GT658 board %d, ', numTimeTags, timeOut, ixBoard);
if ixChannel < 2,
    fprintf('channel %d.\n', ixChannel);
else
    fprintf('both channels.\n');
end;

% Must prepare a digital output structure for timed_read_mex to use to
% trigger the GuideTech boards.
dio = digitalio('nidaq', 'Dev1');
hline = addline(dio, [0:4,7], 'Out'); % Line 7 is the trigger out line
PreTrigLineState = [LineState, IntState, 0];
putvalue(dio, PreTrigLineState);
TrigLineState = [LineState, IntState, 1];

if ixChannel ~= 2,
    t0 = timed_read_mex(ixBoard, ixChannel, numTimeTags, timeOut, dio, TrigLineState);
else
    [t0, t1] = timed_read_mex(ixBoard, ixChannel, numTimeTags, timeOut, dio, TrigLineState);
end;

putvalue(dio, PreTrigLineState);

fprintf('Time tags read: ');
if(ixChannel < 2)
    fprintf('%d\n', length(t0));
else
    fprintf('                channel 0: %d\n                channel 1: %d\n', length(t0), length(t1));
end;

% Downsample time0?
if ixChannel <= 2,
    I0 = atime2bin(t0, sampTime);
    time0 = ((1:length(I0))-1/2)*sampTime; % midpoints of intervals
end;

% Downsample time1?
if ixChannel == 2,
    I1 = atime2bin(t1, sampTime);
    time1 = ((1:length(I1)) - 1/2)*sampTime; % midpoints of intervals
end;

if plotOn,
    td = 243e-9+25e-9; % Correction factor, got from Andy's code
    figure;
    if ixChannel ~= 2,
        Itmp0 = I0 / sampTime;
        plot(time0, Itmp0./(1-Itmp0*td), 'g-');
        xlabel('t(s)');
		ylabel('Count rate (Hz)');
		title(sprintf('Corrected Channel %d', ixChannel));

%        I0 = I0 / 1000;
        fprintf('%g kHz chan %d (corrected)\n', mean(Itmp0./(1-Itmp0*td))/1000, ixChannel);
    else
        Itmp0 = I0 / sampTime;
        Itmp1 = I1 / sampTime;
        
        subplot(2, 1, 1);
        plot(time0, Itmp0./(1-Itmp0*td), 'g-');
        xlabel('t(s)');
		ylabel('Count rate (Hz)');
		title(sprintf('Corrected Channel %d', ixChannel));

%        I0 = I0 / 1000;
        fprintf('%g kHz chan 0 (corrected)\n', mean(Itmp0./(1-Itmp0*td))/1000);
        
        subplot(2, 1, 2);
        plot(time1, Itmp1./(1-Itmp1*td), 'r-');
        xlabel('t(s)');
		ylabel('Count rate (Hz)');
		title(sprintf('Corrected Channel %d', ixChannel));
        
%        I1 = I1 / 1000;
        fprintf('%g kHz chan 1 (corrected)\n', mean(Itmp1./(1-Itmp1*td))/1000);
    end;
end;
return;
        
