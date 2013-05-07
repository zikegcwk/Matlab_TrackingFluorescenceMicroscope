%   ACQUIRE2  acquires 3d tracking data and saves it in the current
%   directory.
%
%   Acquire2(file_start, file_end, run_time) acquires (file_end -
%   file_start) segments of data, each of duration run_time.  Data is saved
%   to files named as 'data_filenum' where filenum is a number between
%   file_start and file_end.
%
%   Acquire2(file_start, file_end, run_time, field, value)
%
%   See also capture3d, rttags, rttrace, drawplots3d
%
% Version 1.1 Updated Oct 1, 2008 by CL
function Acquire6(nruns, run_time,varargin)
global DAQ_PARAMS;
global LOCKIN_PARAMS;
global SAMPLE_DESC;
global CHANNELS_DESC;
global LineState;
global APDS;

if(nruns>99)
    warning('MATLAB:paramAmbiguous','Aquisition limited to 99 runs. 99 runs will be recorded');
    nruns=99;
end
AQ_MODE=2;
if nargin>3
    [gainXYspan,gainZspan]=setParameters(varargin{:});
else
    if (AQ_MODE==2)
        gainXYspan=LOCKIN_PARAMS.GainXY;
        gainZspan=LOCKIN_PARAMS.GainZ;
    else
        gainXYspan=0;
        gainZspan=0;
    end
end
nspanXY=length(gainXYspan);
nspanZ=length(gainZspan);
nsettings=nspanXY*nspanZ;
ntotalaq=nsettings*nruns;

%find where to start numerotation of files
files=dir('data_*.mat');
file_start=0;
if not(isempty(files))
    filesnamesCell=struct2cell(files);
    [a,n]=size(filesnamesCell);
    M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end
    lastfile=max(M);
    file_start=100+lastfile-mod(lastfile,100);
end

caq=1;
for i=1:nspanXY
    if(AQ_MODE==2)
        LOCKIN_PARAMS.GainXY=gainXYspan(i);
    end
    for j=1:nspanZ
        cstart=file_start+((i-1)*nspanZ+j-1)*100;
        %aquisitionTag=datestr(now,'yyyymmdd_HHMMSS'); Moved on 08/23/09 by
        %CL, so that each data file as a unique identifier
        if(AQ_MODE==2)
            LOCKIN_PARAMS.GainZ=gainZspan(j);
            LOCKIN_PARAMS=SetLockIn(LOCKIN_PARAMS);
            display(sprintf('Setting gains to GainXY=%g, GainZ=%g.\nAcquiring %g runs with these settings',gainXYspan(i),gainZspan(j),nruns));
        end
        
        for u = 1:nruns
            fprintf('Beginning acquisition %g/%g (%g/%g)...\n',caq,ntotalaq,u,nruns)
            aquisitionTag=datestr(now,'yyyymmdd_HHMMSS'); %Moved on 08/23/09 by
        %CL, so that each data file as a unique identifier
            [tags, t0, x0, y0, z0, daq_out] = Capture3D6(run_time, DAQ_PARAMS.SampRate, DAQ_PARAMS.DaqChannels);
            cfile=cstart+u-1;
            filename=sprintf('data_%g.mat',cfile);
            fprintf('Acquisition %g/%g complete.  Saving to file %s.\n\n', caq,ntotalaq,filename);


            save(filename, 'tags', 'x0', 'y0', 'z0', 't0', 'daq_out','SAMPLE_DESC','DAQ_PARAMS','LOCKIN_PARAMS','CHANNELS_DESC','LineState','APDS','run_time','aquisitionTag');

            caq=caq+1;
        end
    end
end
APDGate5([0,0,0,0,0,0],DAQ_PARAMS.Integrate); 
updateGateControlGUI5();
display('ALL AQUISITIONS COMPLETED.');
end

