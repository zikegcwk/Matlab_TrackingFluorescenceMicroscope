% RTTRACE  Reads time tags from GT658 using mex interface
%   [time0, time1, time2, time3] = rttags_sync(...
%       numTimeTags, timeOut, ixChannel0, ixChannel1)
%   Reads from both GT658 boards, channels given by 
%   indices ixChannel0 and ixChannel1.
%
%   See also rttags
function [time0, time1, time2, time3] = rttags_sync5(numTimeTags, timeOut, ixChannel0, ixChannel1);
global LineState;
global IntState;
% We need the board index, number of time tags, and timeOut
if nargin ~= 4,
    error('Four inputs required');
end;



%ixChannel0 and ixChannel1 can only be 0 or 1. 
if ixChannel0 > 2 | ixChannel0 < 0 | ixChannel1 > 2 | ixChannel1 < 0,
    error('Invalid channel specifications. Note: for single-channel measurements, use rttags() instead.');
end;

% % fprintf('Reading up to %d tags (for up to %gs) from both GT658 boards.\n', numTimeTags, timeOut);
% % fprintf('\tBoard 0 active channels: ');
% % if ixChannel0 < 2,
% %     fprintf('channel %c.\n', 'A' + ixChannel0);
% % else
% %     fprintf('both.\n');
% % end;
% % 
% % fprintf('\tBoard 1 active channels: ');
% % if ixChannel1 < 2,
% %     fprintf('channel %c.\n', 'A' + ixChannel1);
% % else
% %     fprintf('both.\n');
% % end;

% Must prepare a digital output structure for timed_read_mex to use to
% trigger the GuideTech boards.
dio = digitalio('nidaq', 'Dev1');
hline = addline(dio, [0:6,7], 'Out'); % Line 7 is the trigger out line
PreTrigLineState = [LineState, IntState, 0];
putvalue(dio, PreTrigLineState);
TrigLineState = [LineState, IntState, 1];

numOutputs = 2 + (ixChannel0 == 2) + (ixChannel1 == 2);

% Finally, read the times from the GT658
if numOutputs == 2,
    [time0, time1] = sync_timed_read_mex(ixChannel0, ixChannel1, numTimeTags, timeOut, dio, TrigLineState);
else if numOutputs == 3,
        [time0, time1, time2] = sync_timed_read_mex(ixChannel0, ixChannel1, numTimeTags, timeOut, dio, TrigLineState);
    else
        if numOutputs == 4,
                    [time0, time1, time2, time3] = sync_timed_read_mex(ixChannel0, ixChannel1, numTimeTags, timeOut, dio, TrigLineState);
        end;
    end;
end;

putvalue(dio, PreTrigLineState); % Reset line to pre-triggered value

fprintf('Time tags read:\n');
fprintf('Board 0: ');
if(ixChannel0 < 2)
    fprintf('channel %c: %d\n', 'A' + ixChannel0, length(time0));
    fprintf('\t%g kHz on channel %c (uncorrected)\n', length(time0)/timeOut/1000, 'A' + ixChannel0); 
else
    fprintf('channel A: %d\tchannel B: %d\n', length(time0), length(time1));
    fprintf('\t%g kHz on channel A (uncorrected)\n', length(time0)/timeOut/1000);
    fprintf('\t%g kHz on channel B (uncorrected)\n', length(time1)/timeOut/1000);
end;

fprintf('Board 1: ');
if(ixChannel1 < 2)
    if ixChannel0 < 2,
        fprintf('channel %c: %d\n', 'A' + ixChannel1, length(time1));
        fprintf('\t%g kHz on channel %c (uncorrected)\n', length(time1)/timeOut/1000, 'A' + ixChannel1); 
    else
        fprintf('channel %c: %d\n', 'A' + ixChannel1, length(time2));
        fprintf('\t%g kHz on channel %c (uncorrected)\n', length(time2)/timeOut/1000, 'A' + ixChannel1); 
    end;
else
    if ixChannel0 < 2,
        fprintf('channel A: %d\tchannel B: %d\n', length(time1), length(time2));
        fprintf('\t%g kHz on channel A (uncorrected)\n', length(time1)/timeOut/1000);
        fprintf('\t%g kHz on channel B (uncorrected)\n', length(time2)/timeOut/1000);
    else
        fprintf('channel A: %d\tchannel B: %d\n', length(time2), length(time3));
        fprintf('\t%g kHz on channel A (uncorrected)\n', length(time2)/timeOut/1000);
        fprintf('\t%g kHz on channel B (uncorrected)\n', length(time3)/timeOut/1000);
    end;
end;

%fprintf('\n');
return;
        