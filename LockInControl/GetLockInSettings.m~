% HumanStruct = GetLockInSettings()
% Polls the lock-in amplifiers and returns a human-readable structure
% containing all of the settings that may be adjusted by the LockInGUI
% interface.
%
% See also SetLockIn, LockInGUI
function HumanStruct = GetLockInSettings
global LOCKIN_PARAMS;    
    axy = srspoll_mex('overload.stanford.edu', 12000);
    az = srspoll_mex('overload.stanford.edu', 12001);
    
    HumanStruct = Vec2Human(axy, az);
    LOCKIN_PARAMS = HumanStruct;
return;