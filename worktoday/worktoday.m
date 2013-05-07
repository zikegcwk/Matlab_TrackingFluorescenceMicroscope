function worktoday()

n=now;
rootDir='Y:/InitialData/';

%rootDir='W:/external/data'

if ispc, % Make sure the right directory is chosen if using Windows vs. Linux

    todayDir=sprintf('%s/%s/%s',rootDir,datestr(n,'yyyy'),datestr(n,'mmddyy'));

else 

    todayDir=sprintf('/mnt/firewire/data/%s/%s',datestr(n,'yyyy'),datestr(n,'mmddyy'));

end;



if exist(todayDir,'dir')

    cd(todayDir)

else

    display(sprintf('Creating directory %s',todayDir));

    mkdir(todayDir)

    cd(todayDir)

end