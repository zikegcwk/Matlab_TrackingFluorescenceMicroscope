function initParameters()
global SAMPLE_DESC;
global ACQ_PARAMS;
global LOCK_PARAMS;
global CHANNELS_DESC;
global SETTINGS;

SAMPLE_DESC=struct('title','','od','0',...
    'v1',0,'v1desc','','v2',0,'v2desc','','v3',0,'v3desc','',...
    'comments','');
ACQ_PARAMS=struct('sampRate',1000,'daqChannels',[],'noXYZ',0);
LOCK_PARAMS=struct('gainXY',0,'gainZ');
CHANNELS_DESC=struct('apd0','APD0','apd1','APD1','apd2','APD2','apd3','APD3',...
    'daq0','x','daq1','y','daq2','z','daq3','DAQ3',...
    'daq4','DAQ4','daq5','DAQ5','daq6','DAQ6','daq7','DAQ7');
SETTINGS=struct('prompt0D',1);
ec=1;
