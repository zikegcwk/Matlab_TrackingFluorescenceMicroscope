function [AR, ActualRate, blocksize] = SetupAnalogRead(ChanIndex, SampRate, Timeout);

ai = analoginput('nidaq', 'Dev1');

addchannel(ai, [ChanIndex]);

set(ai, 'SampleRate', SampRate);

ActualRate = get(ai, 'SampleRate');

if SampRate ~= ActualRate,
    fprintf('Sampling at %gHz\n', ActualRate);
end;

set(ai, 'SamplesPerTrigger', Timeout * ActualRate);
blocksize = get(ai, 'SamplesPerTrigger');

if blocksize ~= Timeout * ActualRate,
    fprintf('Actual timeout is %gs.\n', blocksize / ActualRate);
end;

set(ai, 'TriggerType', 'HwDigital');
set(ai, 'TriggerCondition', 'PositiveEdge');

% The following lines pre-set the buffer size to use for data acquisition.
% I think that, in the past, I have not been able to acquire data for
% longer than about 40 seconds because the CPU could not keep up with both
% emptying the buffers of the timer boards and running the matlab
% auto-buffer code which, presumably, also requires the buffer on the
% NI-DAQ to be emptied before being overwritten by the board, which
% probably writes to the buffer in a loop.  This was causing errors from
% NI-DAQmx that stated that data in the buffer that was now being requested
% had been overwritten.
set(ai, 'BufferingMode', 'Manual');
BufferLength = 2 * length(ChanIndex) * Timeout * SampRate;
set(ai, 'BufferingConfig', [2048 max([2 ceil(BufferLength/2048)])]);

start(ai);

AR = {ai, blocksize / ActualRate};

return;

