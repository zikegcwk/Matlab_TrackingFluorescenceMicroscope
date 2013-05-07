% HumanStructOut = SetLockIn(HumanStructIn)
% Sets the lock-in amplifier states to match the settings contained in the
% human-readable input argument structure.  Invalid input settings
% are adjusted to match their closest valid settings, and a structure
% containing the instrument settings is returned.
%
% See also GetLockInSettings, LockInGUI
function HumanStructOut = SetLockIn(HumanStructIn)

global LOCKIN_PARAMS;

[axy, az] = Human2Vec(HumanStructIn); % Does checks and conversions to valid parameters
HumanStructOut = Vec2Human(axy, az); % Return this so that any parameter modifications are known
LOCKIN_PARAMS = HumanStructOut;

srsset_mex('overload.stanford.edu', 12000, axy);
srsset_mex('overload.stanford.edu', 12001, az);

UpdateLockInGUI(HumanStructOut);

return;