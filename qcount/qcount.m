% QCOUNT  Quick instantaneous photon count rates
%   QCOUNT checks for active photon counter channels and measures the
%   current count rate on each channel by averaging for 1 second.
%
%   QCOUNT(chanVec), where chanVec is a vector containing channel indices
%   beginning with 0, allows specification of the channels to measure from.
%
%   QCOUNT(chanVec, time) allows specification of the averaging time to
%   use.

function qcount(chanVec, time);

global LineState;
global IntState;

if nargin < 2,
    time = 1;
end;

if nargin < 1
    disp('No channel list specified.  Using all active channels.');
    chanVec = find(LineState == 1);
    if chanVec,
        chanVec = chanVec - 1;
    end;
end;

if nargin > 2, 
    error('I dont understand.');
end;

for u = 1:length(chanVec),
    c = chanVec(u) + 1;
    if c > 4 | c < 1,
        fprintf('%d is not a valid channel. Ignoring.\n', c - 1);
        chanVec = chanVec(chanVec ~= c - 1);
    else
        if LineState(c) == 0,
            fprintf('Channel %d is not active. Ignoring.\n', c - 1);
            chanVec = chanVec(chanVec ~= c - 1);
        end
    end;
end;
            
    
if length(chanVec) == 0 & nargin == 0,
    error('No active channels!');
end;

if length(chanVec) == 9 & nargin > 0,
    error('No valid channels specified!');
end;

chanArg0 = -1;
if find(chanVec == 0) & find(chanVec == 1),
    chanArg0 = 2;
else if find(chanVec == 0)
        chanArg0 = 0;
    else if find(chanVec == 1)
            chanArg0 = 1;
        end;
    end;
end;

chanArg1 = -1;
if find(chanVec == 2) & find(chanVec == 3),
    chanArg1 = 2;
else if find(chanVec == 2)
        chanArg1 = 0;
    else if find(chanVec == 3)
            chanArg1 = 1;
        end;
    end;
end;

if chanArg0 > -1 & chanArg1 == -1,
    chanArg = chanArg0;
    if chanArg < 2, 
        [time0, I0] = rttrace(0, 2e6, time, 1e-3, 0, chanArg);
        fprintf('Board 0, Channel %c: %g kphot/sec\n', chanArg + 'A', mean(I0));
    else if chanArg == 2,
            [time0, I0, time1, I1] = rttrace(0, 2e6, time, 1e-3, 0, chanArg);
            fprintf('Board 0, Channel A: %g kphot/sec\n', mean(I0));
            fprintf('Board 0, Channel B: %g kphot/sec\n', mean(I1));
        end;
    end;
else if chanArg0 == -1 & chanArg1 > -1,
        chanArg = chanArg1;
        if chanArg < 2, 
            [time0, I0] = rttrace(1, 2e6, time, 1e-3, 0, chanArg);
            fprintf('Board 1, Channel %c: %g kphot/sec\n', chanArg + 'A', mean(I0));
        else if chanArg == 2,
                [time0, I0, time1, I1] = rttrace(1, 2e6, time, 1e-3, 0, chanArg);
                fprintf('Board 1, Channel A: %g kphot/sec\n', mean(I0));
                fprintf('Board 1, Channel B: %g kphot/sec\n', mean(I1));
            end;
        end;        
    end;
end;

if chanArg0 > -1 & chanArg1 > -1,
    if chanArg0 < 2 & chanArg1 < 2,
        [time0, time1] = rttags_sync(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel %c: %g kphot/sec\nBoard 1, Channel %c: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time, chanArg1 + 'A', length(time1)/time);
    end;
    
    if chanArg0 == 2 & chanArg1 < 2,
        [time0, time1, time2] = rttags_sync(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel A: %g kphot/sec\nBoard 0, Channel B: %g kphot/sec\n', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel %c: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time);
    end;
    
    if chanArg0 < 2 & chanArg1 == 2,
        [time0, time1, time2] = rttags_sync(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel %c: %g kphot/sec\nBoard 1, Channel A: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel B: %g kphot/sec\n', length(time2)/time);
    end;
    
    if chanArg0 == 2 & chanArg1 == 2,
        [time0, time1, time2, time3] = rttags_sync(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel A: %g kphot/sec\nBoard 0, Channel B: %g kphot/sec\n', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel A: %g kphot/sec\nBoard 1, Channel B: %g kphot/sec\n', length(time2)/time, length(time3)/time);
    end;
end;

return;
