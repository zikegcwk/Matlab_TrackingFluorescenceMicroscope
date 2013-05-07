% DRAWPLOTS3D Plots raw data from 3D tracking experiments.
% DrawPlots3D(filenum, dt, time_begin, time_end, plotformat)  
%[tags0, t0, x0, y0, z0, I0] = DrawPlots3D(filenum)
%   Loads the data stored in the file named 'data_(filenum)' and returns it
%   in the return arguments.  By default, the raw data is plotted in Figure
%   1010. Plots will consist of 2 to 3 panels. The top panel will always be
%   the fluorescence, and the middle will always be the tracking stage
%   positions. The lower panel will be used if additional NIDAQ channels
%   were monitored and saved to the data file. Descriptive data contained
%   in the data file will be displayed on the command prompt.
%
%   DrawPlots3D(filenum, dt) allows specification of the bin time dt for
%   down-sampling fluorescence data, both for the plot and for the returned
%   quantity I0.
%
%   See also msd3d, lfcs
%
% Version 1.1 May 15, 2008 by KM: Updated for new file formats 
%         1.2 May 29, 2008 by KM: Add feature that colors fluorescence data
%            black if z stage was stuck on its upper rail.
%         1.3 June 10, 2009 by ZK: add for plotting at specific time window.


function [tags, t0, x0, y0, z0, t, I] = DrawPlots3D(varargin),

% different number of inputs, plot differently. 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if nargin == 1,
    filenum = varargin{1};
    filename =sprintf('data_%g.mat', filenum);
    filename2 =sprintf('./data_%g.mat', filenum);
    
    if ~exist(filename2),
        error(strcat(filename, ': File does not exist.'));
    end;
    load_data = load(filename);

    plotformat = 'default';
end

if nargin == 2,
    filenum = varargin{1};
    filename = sprintf('./data_%g.mat', filenum);
    
    if ~exist(filename),
        error(strcat(filename, ': File does not exist.'));
    end;
    
    load_data = load(filename);
        
    if ~strcmp(class(varargin{2}), 'char'),
        default_dt = varargin{2};
        plotformat = 'default';
    else
        plotformat = lower(varargin{2});
    end;
end
  
if nargin==5,% DrawPlots3D(filenum, dt, time_begin, time_end, plotformat)
        if strcmp(varargin{5},'tfret');
            plotformat=varargin{5};
        else 
            error('we cannot plot other than tfret format with these many of arguments yet.')
        end
        
        filenum = varargin{1};
        filename = sprintf('./data_%g.mat', filenum);
    
        if ~exist(filename),
            error(strcat(filename, ': File does not exist.'));
        end;
           
        load_data = load(filename);
end

if nargin ~=1 & nargin ~=2 & nargin ~=5
    error('not the right number of inputs (can only be 1, 2 and 5). see the m file.')
end


% different number of inputs, plot differently. 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    


if exist('tags0')
    disp('Old data file type.\n');
    if exist('tags0') && exist('tags1'),
        tags = cell(2,1);
        tags{1} = tags0;
        tags{2} = tags1;
        clear tags0, tags1;
    elseif exist('tags0'),
            tags = cell(1,1);
            tags{1} = tags0;
            clear tags0;
    elseif exist('tags1'),
                tags = cell(1,1);
                tags{1} = tags1;
                clear tags1;
     end;
end;

if isfield(load_data, 'tags'),
    tags = load_data.tags;
end;

if ~isempty(load_data.x0),
    trackdata = 1;
    t0 = load_data.t0;
    stage_pos = [load_data.x0, load_data.y0, load_data.z0];
else
    trackdata = 0;
    stage_pos = [];
    t0 = [];
end;

daqdata = 0;
daq_out = [];

 if isfield(load_data, 'NIDAQ_Out') & ~isempty(load_data.NIDAQ_Out),
    daqdata = 1;
    daq_out = load_data.NIDAQ_Out;
    t0 = load_data.t0;
else
    if isfield(load_data, 'exI'), 
        daqdata = 1;
        daq_out = load_data.exI;
        t0 = load_data.t0;
        
        if isfield(load_data, 'ex2'),
            daq_out = [daq_out, load_data.ex2];
        end;
        
        if isfield(load_data, 'ex3'),
            daq_out = [daq_out, load_data.ex3];
        end;
    else
        if isfield(load_data, 'daq_out') & ~isempty(load_data.daq_out),
            daqdata = 1;
            daq_out = load_data.daq_out;
            t0 = load_data.t0;
        end;
    end;
end;
if strcmp(plotformat, 'tfret') | strcmp(plotformat,'tfret_single'),
    %figure('Name',cd); clf;
else
    figure('Name',cd); clf;
end



    
if strcmp(plotformat, 'default'),
    default_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end;

if strcmp(plotformat, 'dna'),
    dna_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end;

if strcmp(plotformat, 'dnaendlabel'),
    dnaEndLabel_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end;

if strcmp(plotformat, 'dnaendlabelx'),
    dnaEndLabelX_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end;


if strcmp(plotformat, 'nodaq'),
    nodaq_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end;


if strcmp(plotformat,'tfret_single')
    tFRET_singlefigure_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end

if strcmp(plotformat,'tfret')
    tFRET_format(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end


if strcmp(plotformat,'tfret2')
    tFRET_format2(tags, trackdata, t0, stage_pos, daqdata, daq_out, nargin, varargin);
end


if nargout == 0,
    clear tags t0 x0 y0 z0 t I; % so that returned values are not displayed
end;

return;
