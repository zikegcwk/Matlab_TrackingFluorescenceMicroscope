function ec=initDefault()
global SAMPLE_DESC;
global ACQ_PARAMS;
global LOCK_PARAMS;
global CHANNELS_DESC;
global SETTINGS;

SAMPLE_DESC=struct('title','','OD','0',...
    'f1',0,'f1_desc','','f2',0,'f2desc','','f3',0,'f3desc','',...
    'comments','');
ACQ_PARAMS=struct('SampRate',1000,'NIDAQ_channels',[1 1 1 0 0 0 0 0]);
LOCK_PARAMS=struct('GainXY',0,'GainZ');
CHANNELS_DESC=struct('apd0','APD0','apd1','APD1','apd2','APD2','apd3','APD3',...
    'nidaq0','x','nidaq1','y','nidaq2','z','nidaq3','NIDAQ3',...
    'nidaq4','NIDAQ4','nidaq5','NIDAQ5','nidaq6','NIDAQ6','nidaq7','NIDAQ7');
SETTINGS=struct('prompt0D',1);
ec=1;
