% function data = GetAnalogData(AR, del),
function data = GetAnalogData(AR, del)
if nargin < 2,
    del = 1;
end;

%wait(AR{1}, AR{2} + 5);
stop(AR{1});
data = getdata(AR{1}, get(AR{1}, 'SamplesAvailable'));

if del,
    delete(AR{1});
end;

return;