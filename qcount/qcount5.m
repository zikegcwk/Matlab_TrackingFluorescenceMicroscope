% QCOUNT5  Quick instantaneous photon count rates
%   QCOUNT5 checks for active photon counter channels and measures the
%   current count rate on each channel by averaging for 1 second.
%
%   QCOUNT5(chanVec), where chanVec is a vector containing channel indices
%   beginning with 0, allows specification of the channels to measure from.
%
%   QCOUNT5(chanVec, time) allows specification of the averaging time to
%   use.

function qcount5(Timeout);

global APDS;


if nargin < 1
    fprintf('No Timeout specified. Recording over 1s');
end;

if nargin > 2, 
    error('I dont understand. Too many input arguments');
end;

chanVec = find(APDS == 1);
for u = 1:length(chanVec),
    c = chanVec(u);
    if c > 4 | c < 1,
        fprintf('%d is not a valid channel. Ignoring.\n', c);
        chanVec = chanVec(chanVec ~= c);
    else
        if APDS(c) == 0,
            fprintf('Channel %d is not active. Ignoring.\n', c );
            chanVec = chanVec(chanVec ~= c);
        end
    end;
end;
            
    
if length(chanVec) == 0 & nargin == 0,
    error('No active channels!');
end;

chanArg0 = -1;
if APDS(1) || APDS(2),
    fprintf('Board 0: ');

    if APDS(1) && APDS(2),
        chanArg0 = 2;
        fprintf('Measuring fluorescence on both APDs.\n');
    else if APDS(1),
            chanArg0 = 0;
            fprintf('Measuring fluorescence on APD 0\n');
        else if APDS(2),
                chanArg0 = 1;
                fprintf('Measuring fluorescence on APD 1\n');
            end;
        end;
    end;
end;

chanArg1 = -1;
if APDS(3) || APDS(4),
    fprintf('Board 1: ');

    if APDS(3) && APDS(4),
        chanArg1 = 2;
        fprintf('Measuring fluorescence on both APDs.\n');
    else if APDS(3),
            chanArg1 = 0;
            fprintf('Measuring fluorescence on APD 0\n');
        else if APDS(4),
                chanArg1 = 1;
                fprintf('Measuring fluorescence on APD 1\n');
             end;
        end;
    end;
end;


if chan0 > -1 && chan1 > -1,
    numChan = 2 + (chan0 == 2) + (chan1 == 2);
    if numChan == 2,
        [time0, time1] = rttags_sync5(2e7, Timeout, chan0, chan1);
        tags = {time0, time1};
    else if numChan == 3,
            [time0, time1, time2] = rttags_sync5(2e7, Timeout, chan0, chan1);
            tags = {time0, time1, time2};
        else if numChan == 4,
                [time0, time1, time2, time3] = rttags_sync5(2e7, Timeout, chan0, chan1);
                tags = {time0, time1, time2, time3};
            end;
        end;
    end;
end;

if chan0 > -1 && chan1 == -1,
    chan = chan0;
    if chan == 2,
        [tags0, tags1] = rttags5(0, 2e7, Timeout, chan);
     
    else
        tags0 = rttags5(0, 2e7, Timeout, chan);
      
    end;
end;

if chan0 == -1 && chan1 > -1,
    chan = chan1;
    if chan == 2,
        [tags0, tags1] = rttags5(1, 2e7, Timeout, chan);
        
    else
        tags0 = rttags5(1, 2e7, Timeout, chan);
        
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
        [time0, time1] = rttags_sync5(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel %c: %g kphot/sec\nBoard 1, Channel %c: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time, chanArg1 + 'A', length(time1)/time);
    end;
    
    if chanArg0 == 2 & chanArg1 < 2,
        [time0, time1, time2] = rttags_sync5(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel A: %g kphot/sec\nBoard 0, Channel B: %g kphot/sec\n', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel %c: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time);
    end;
    
    if chanArg0 < 2 & chanArg1 == 2,
        [time0, time1, time2] = rttags_sync5(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel %c: %g kphot/sec\nBoard 1, Channel A: %g kphot/sec\n', chanArg0 + 'A', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel B: %g kphot/sec\n', length(time2)/time);
    end;
    
    if chanArg0 == 2 & chanArg1 == 2,
        [time0, time1, time2, time3] = rttags_sync5(2e6, time, chanArg0, chanArg1);
        fprintf('Board 0, Channel A: %g kphot/sec\nBoard 0, Channel B: %g kphot/sec\n', length(time0)/time, length(time1)/time);
        fprintf('Board 1, Channel A: %g kphot/sec\nBoard 1, Channel B: %g kphot/sec\n', length(time2)/time, length(time3)/time);
    end;
end;

return;
