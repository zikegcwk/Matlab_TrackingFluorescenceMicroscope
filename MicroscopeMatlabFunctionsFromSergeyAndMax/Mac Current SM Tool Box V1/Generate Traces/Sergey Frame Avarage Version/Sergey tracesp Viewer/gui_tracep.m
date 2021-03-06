function varargout = gui_tracep(varargin)
% GUI_TRACE M-file for gui_trace.fig
%      GUI_TRACE, by itself, creates a new GUI_TRACE or raises the existing
%      singleton*.
%
%      H = GUI_TRACE returns the handle to a new GUI_TRACE or the handle to
%      the existing singleton*.
%
%      GUI_TRACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TRACE.M with the given input arguments.
%
%      GUI_TRACE('Property','Value',...) creates a new GUI_TRACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_trace_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_trace_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_trace

% Last Modified by GUIDE v2.5 19-Feb-2008 19:42:15

%SERGEY June2008: Implemented minimalist modification following suggestions by Max G.:
%1) All I do here is save "real data" part, i.e. donor and acceptor intensities between
%"laser on" and "laser off"
%2) Drop the SNR analysis here, much easier done post-processively on "real
%data" parts
%3) 
%
%Sergey_Feb2008: Saved kinetics files have the following info:
% Title: value of a frame (ms)
% For each molecules:
% Row 1) 9(to indicate a break)/<I> (average intensity)/Signal-to-Noise
% ratio (from sigma for total intensity)
% Rows 2-n-1: All the dwells, including first and last, are saved; For each dwell: type of dwell (0 for low FRET, 3 for High FRET), <FRET>, ; 
% 4) Last row is a row of 9's 
%Sergey_March2008: FRET distributions are also saved individually for each
%molecule. FREDIST files have now the same number of rows with FRET bins,
%but columns 2:Nmol+1 have distributions for each molecule individually.

% SERGEY: right now finding buttons are set in such way that they find the
% next frame after the one fulfilling the search conditions (because
% acceptor and fret arrays are numbered from 1, not from 0). I prefer to
% keep it this way to make counting the last dwell easier. The last actual
% dwell is tossed in the for...if loop, and I don't see how to count it
% easily. Now I can find the first dwell not corresponding to FRET state,
% count in dwell time analysis upto the j-1, i.e. one-before-last actual
% dwell, and in full dwell histogram - upto j, i.e. the last counted dwell.
% Yet, it does not write the last dwell either into kientics or into
% kineticsplus. Is 1 dwell not enough? I'll try extending it by 1 more.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_trace_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_trace_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_trace is made visible.
function gui_trace_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_trace (see VARARGIN)

% set directory?
%SergeysWarning = 'Check if all SERGEYTEMP parameters are set correctly'
% Choose default command line output for gui_trace
handles.output = hObject;
handles.fret_binwidth = 0.025;
handles.fretbin = -0.4:handles.fret_binwidth:1.4;
handles.low_th_1 = 0.65; %default for every trace %%Bernie changed this from 0.13 to 0%Sergey changed to 0.65 for P1 docking
% bernie removed
% handles.high_th_1 = 0.53; %default for every trace
handles.low_th = 0.65;  %Bernie this one too
%bernie removed
%handles.high_th = 0.53;
handles.automatic_kinetics = 0;
handles.batch_analysis = 0;
handles.opennext=0;



set(gcf,'Renderer','painters','DoubleBuffer','on');
subplot(handles.axes1); %this is the traces plot
line1 = plot(1:100,zeros(1,100),'g',...
    1:100,zeros(1,100),'r',1:100,ones(1,100),':sc','MarkerSize',10,'MarkerEdgeColor','c','MarkerFaceColor','w');
% scatter1 = scatter(
handles.donor = line1(1);
handles.acceptor = line1(2);
handles.zoompoints = line1(3);
set(handles.axes1, 'color','k');

subplot(handles.axes2); %this is the FRET plot
%%lets take out that 2nd line
%%line2 = plot(1:100,zeros(1,100),'b',1:100,zeros(1,100)*handles.low_th,'c',1:100,zeros(1,100)*handles.high_th,'m');
line2 = plot(1:100,zeros(1,100),'b',1:100,zeros(1,100)*handles.low_th,'c',1:100,zeros(1,100),'.y', 'MarkerSize',4);
set(handles.axes2, 'color','k');

%% colors, b is blue, c is cyan, m is magenta
handles.fret = line2(1);
handles.line_low = line2(2); %this sets the initial position of the handles
handles.intensity = line2(3);
%%removed by bernie
%handles.line_high = line2(3);
set(handles.axes2,'YLim',[-0.4 1.4],'Tag','reference','YGrid','on');


subplot(handles.axes4); % this is the kinetics plot 
line3 = plot(1:100,zeros(1,100),'k');  %%initializes the plot, color k is black SERGEY HERE 3(1)
%SERGEY_Oct17
%line3(2) = plot(1:100,zeros(1,100),'b');
handles.kinetics = line3;%and here 3(1)
%handles.fractionf = line3(2); %SERGEY_Oct17 and here
set(handles.axes4,'YLim',[-0.2 1.2]);

subplot(handles.axes3);     %this is the fret histogram plot
[Y,I]=hist(1,handles.fretbin);
tempx=handles.fretbin - (handles.fretbin(2)-handles.fretbin(1))/2;
tempx=[tempx handles.fretbin(end)+(handles.fretbin(2)-handles.fretbin(1))/2];

patch_x = [tempx(1:end-1); tempx(1:end-1); tempx(2:end); tempx(2:end)];
patch_y = [zeros(1,length(Y)); Y; Y; zeros(1,length(Y))];

histogram = patch(patch_x, patch_y, [0 0 1]);
set(histogram,'Tag','refreshable','UserData',handles.fretbin);
handles.histogram = histogram;
handles.average = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_trace wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_trace_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);     
if handles.opennext == 1,
    handles.datafile = handles.datafilenamenext;
end

if handles.automatic_kinetics ~= 1
%[handles.datafile,handles.datapath]=uigetfile('*.trace*','Choose a trace file');
%bernie changed this to tra*, but really it will only read tra files now,
%for traces files, use gui_trace...i wonder what about traces2
if handles.opennext~=1
    [handles.datafile,handles.datapath]=uigetfile('*.tra*','Choose a trace file');
end
end
if handles.datafile==0,
    connectaxes('+x',[handles.axes1 handles.axes2 handles.axes4]);     
    zoom_connect on;
    return; 
end



cd(handles.datapath);
n=findstr(handles.datafile,'.');
handles.filename=handles.datafile(1:n-1);
handles.suffix=handles.datafile(n+1:end);
j=handles.suffix
k=strmatch('tra',handles.suffix, 'exact')
set(handles.text4,'String','traces','BackgroundColor','r');
set(handles.text5,'String','Histograms','BackgroundColor','r');
if strmatch('traces',handles.suffix, 'exact') == 1 % to read tir2 traces files into the tir1 format
        fid=fopen(handles.datafile,'r');
        len=fread(fid,1,'int32');
        Ntraces=fread(fid,1,'int16');
        %Positions = fread(fid,[Ntraces+1 2],'int16'); %SERGEY - position matrix read here. NOTE that absolute positions 
        %of spots on the CCD are given and donor will not overalp with
        %acceptor because of the offsets!!!
        Data=fread(fid,[Ntraces+1 len],'int16');
        fclose(fid);
        framerate = get(handles.edit3,'string'); %SERGEY inserted assignment of fps here
        framerate = str2double(framerate);
        handles.fps = 1000/framerate;
        handles.framerate = framerate;
        nmapped=Ntraces/2;
        ndonor=Ntraces/2;
        %handles.positions = Positions(2:end,:);
 
elseif strmatch('tracesp',handles.suffix, 'exact') == 1; %Sergey: to read position-stampted traces
        fid=fopen(handles.datafile,'r');
        len=fread(fid,1,'int32')
        Ntraces=fread(fid,1,'int16')
        Positions = fread(fid,[Ntraces+1 2],'int16'); %SERGEY - position matrix read here. NOTE that absolute positions 
        %of spots on the CCD are given and donor will not overalp with
        %acceptor because of the offsets!!!
        Data=fread(fid,[Ntraces+1 len],'int16');
        fclose(fid);
        framerate = get(handles.edit3,'string'); %SERGEY inserted assignment of fps here
        framerate = str2double(framerate);
        handles.fps = 1000/framerate;
        handles.framerate = framerate;
        nmapped=Ntraces/2;
        ndonor=Ntraces/2;
        handles.positions = [];
        handles.positions = Positions(2:end,:);
%         size(Data)
        %tellmeifimwrong = size(handles.positions)
elseif strmatch('tra',handles.suffix, 'exact') == 1 %the tir1 file format
        %title(handles.filename);
        %handles.pmafile=fopen(datafile,'r');
        %handles.filename=datafile;
        fid=fopen(handles.datafile,'r');
        len=fread(fid,1,'int32')   %reads the first 32 bit integer as the number of frames
        %%Ntraces=fread(fid,1,'int16');   %reads the second 16 bit integer as the number of traces
        %%bernie changed to 32 to try to read tra file
        fps=fread(fid,1,'float32')     %the tra file containts the number of fps
        Ntraces=fread(fid,1,'int16')   %well actually, this is the number of molecules  
        nmapped=fread(fid,1,'int16')    %lets see if i need to read in all the numbers number of mapped molecules
        ndonor=fread(fid,1,'int16') %number of donor traces
        %good job! now read in the the position array of all the traces

        positiondata=fread(fid,[2 Ntraces*2],'int16'); 
      
        handles.fps = fps;
        handles.positiondata = positiondata;
        Data=fread(fid,[Ntraces*2 len],'float');    %reads in the data based on these two numbers, i hope i got this right
        fclose(fid);    %closes the file
elseif  strmatch('tra2',handles.suffix, 'exact') == 1 %the post processing tra2 format
        fid=fopen(handles.datafile,'r');
        len=fread(fid,1,'int32')   %reads the first 32 bit integer as the number of frames
        %%Ntraces=fread(fid,1,'int16');   %reads the second 16 bit integer as the number of traces
        %%bernie changed to 32 to try to read tra file
        fps=fread(fid,1,'float32')     %the tra file containts the number of fps
        Ntraces=fread(fid,1,'int16')   %well actually, this is the number of molecules  
        nmapped=fread(fid,1,'int16')    %lets see if i need to read in all the numbers number of mapped molecules
        ndonor=fread(fid,1,'int16') %number of donor traces
        %good job! now read in the the FAKE position array of all the
        %traces from zeros(2,numberofmolecules)

        positiondata=fread(fid,[2 Ntraces*2],'int16'); 
        foo = size(positiondata)
      
        handles.fps = fps;
        handles.positiondata = positiondata;
        Data=fread(fid,[Ntraces*2 len],'float');    %reads in the data based on these two numbers, i hope i got this right
        fclose(fid);    %closes the file       
    
end
       handles.opennext = 0;
if Ntraces<=1,
    letmesee = Data
    letmeseemore = positiondata
end

%now set (the size of the axes)? or initialize these matrices?
time = zeros(1,len);
% donor = zeros(Ntraces/2,len);   %seems to assume the number of donor and acceptor traces are the same?
% acceptor = zeros(Ntraces/2,len);  %is this an historic thing?
donor = zeros(Ntraces,len); 
acceptor = zeros(Ntraces, len);
fret = zeros(1,len);

handles.crosstalk = 0.09; % Bernie what does this do? It is the crosstalk. SERGEY changes based on bleached state 
handles.first = 1;
handles.last = len;
handles.m = 1;


if strmatch('traces',handles.suffix, 'exact') == 1 % to read tir2 traces files into the tir1 format
handles.time = Data(1,:);
handles.number = Ntraces/2;
index = Ntraces*len;
temp = reshape(Data(2:end,:),1,index);
temp = sort(temp);
min_intensity = temp(round(0.01*index));
max_intensity = temp(round(0.999*index));%Sergey-what a strange way...tweaked here

elseif strmatch('tracesp',handles.suffix, 'exact') == 1 % to read tir2 traces files into the tir1 format
handles.time = Data(1,:);
handles.number = Ntraces/2;
index = Ntraces*len;
temp = reshape(Data(2:end,:),1,index);
temp = sort(temp);
min_intensity = temp(round(0.01*index));
max_intensity = temp(round(0.999*index));

else
handles.time = [0:len];
%handles.time = Data(1,:);  %sets the handle.time to an array of 1 to the number of columns in Data but what it wants is the number of frames
%bernie try to correct this - perfecto!
handles.number = Ntraces/1;     %sets the handle.number to the number of traces/2
% foo = handles.number
index = (Ntraces*2-1)*len;            %sets the index as the number of frames*the number of mlcs without the 1st column for some reason?
temp = reshape(Data(2:end,:),1,index);      % reforms the Data matrix. the problem here is that the Data matrix does not have index elements
temp = sort(temp);          %sort this array
min_intensity = temp(round(0.01*index)) %find the 1st and 98th percentile as the basic limits for the traces graph
max_intensity = temp(round(0.98*index))
end
% subplot(handles.axes1);
% line1 = plot(handles.time(handles.first:handles.last),donor(handles.m,handles.first:handles.last),'g',...
%     handles.time(handles.first:handles.last),acceptor(handles.m,handles.first:handles.last),'r');  
% handles.donor = line1(1);
% handles.acceptor = line1(2);

%%this is where the graph is actaully initialized
%Data(1,:)  
%Data(:,1)
set(handles.axes1,'XLim',[handles.time(1) handles.time(end)]);
zoom_connect on;
set(handles.axes1,'YLim',[min_intensity max_intensity],'YGrid','on');

set(handles.axes2,'XLim',[handles.time(1) handles.time(end)]);
zoom_connect reset;

set(handles.axes4,'XLim',[handles.time(1) handles.time(end)]);
zoom_connect reset;
connectaxes('+x',[handles.axes1 handles.axes2 handles.axes4]);   
%zoom_connect reset;

% subplot(handles.axes2);
% line2 = plot(handles.time(handles.first:handles.last),fret(handles.first:handles.last));
% handles.fret = line2;
% set(handles.axes2,'YLim',[-0.2 1.2],'Tag','reference','YGrid','on');
% 
% connectaxes('+x',[handles.axes1 handles.axes2]);     

% subplot(handles.axes3);
% [Y,I]=hist(fret(handles.first:handles.last),handles.fretbin);
% tempx=handles.fretbin - (handles.fretbin(2)-handles.fretbin(1))/2;
% tempx=[tempx handles.fretbin(end)+(handles.fretbin(2)-handles.fretbin(1))/2];
% 
% patch_x = [tempx(1:end-1); tempx(1:end-1); tempx(2:end); tempx(2:end)];
% patch_y = [zeros(1,length(Y)); Y; Y; zeros(1,length(Y))];
% 
% histogram = patch(patch_x, patch_y, [0 0 1]);
% set(histogram,'Tag','refreshable','UserData',handles.fretbin);
% handles.histogram = histogram;
% set(handles.axes3,'Xlim',[-0.2 1.2],'XGrid','on');

%%Bernie - there is a b/g correction here,
%temp = mean(Data(2:2:Ntraces+1,floor(0.9*len):len),2);
%donor_background = repmat(temp,1,len);
%temp = mean(Data(3:2:Ntraces+1,floor(0.9*len):len),2);
%acceptor_background = repmat(temp,1,len);

%these two lines put all the donors into 1 array, and all the acceptors
%into another
%handles.donor_all = Data(2:2:Ntraces+1,:)-donor_background;
%handles.acceptor_all = Data(3:2:Ntraces+1,:)-acceptor_background;
%handles.sum_all = handles.donor_all + handles.acceptor_all;
%bernie try to modify this, this is harolds b/g correction algorhythm
if regexp(handles.suffix,'traces') == 1 % to read tir2 traces files into the tir1 format
temp = mean(Data(2:2:Ntraces+1,floor(0.9*len):len),2);
donor_background = repmat(temp,1,len);
temp = mean(Data(3:2:Ntraces+1,floor(0.9*len):len),2);

% no correction
% acceptor_background = repmat(temp,1,len);
% handles.donor_all = Data(2:2:Ntraces+1,:)-donor_background;
% handles.acceptor_all = Data(3:2:Ntraces+1,:)-acceptor_background;
handles.donor_all = Data(2:2:Ntraces+1,:);
handles.acceptor_all = Data(3:2:Ntraces+1,:);


else
temp = mean(Data(1:2:end,floor(0.9*len):len),2);
donor_background = repmat(temp,1,len);
temp = mean(Data(2:2:end,floor(0.9*len):len),2);
acceptor_background = repmat(temp,1,len);

%%bernie - no correction

handles.donor_all = Data(1:2:end,:);
handles.acceptor_all = Data(2:2:end,:);
handles.positions = Positions(2:end,:)

end
%% bernie with correction, this is certainly making it harder to view the
%% trace - i wonder if yun's program spits out corrected traces?
%%handles.donor_all = Data(1:2:end,:)-donor_background;
%%handles.acceptor_all = Data(2:2:end,:)-acceptor_background;
handles.figurecounter = 0;
handles.figureloopcounter = 0;
handles.copyfigdisplay = 0;
handles.number_of_molecules_selected = 0; 
handles.number_of_histograms_selected = 0;
handles.Newdata = 0;
handles.histogram_data = 0;
handles.histogram_rawdata = 0;
handles.fret_rawdata = 0;
%handles.positions = 0;
guidata(gcf, handles);

Update_Figure(gcf, handles);

function Update_Figure(hObject, handles)

switch handles.average      %this displays the averaged data by the method selected
    case 1
        xdata = handles.time(handles.first:handles.last);
        ydata1 = handles.donor_all(handles.m,handles.first:handles.last);
        ydata2 = handles.acceptor_all(handles.m,handles.first:handles.last);
    case 2
        xdata = meanaverage(handles.time(handles.first:handles.last),2);
        ydata1 = medianaverage(handles.donor_all(handles.m,handles.first:handles.last),2);
        ydata2 = medianaverage(handles.acceptor_all(handles.m,handles.first:handles.last),2);
    case 3
        xdata = meanaverage(handles.time(handles.first:handles.last),2);
        ydata1 = meanaverage(handles.donor_all(handles.m,handles.first:handles.last),2);
        ydata2 = meanaverage(handles.acceptor_all(handles.m,handles.first:handles.last),2);
    case 4
        xdata = meanaverage(handles.time(handles.first:handles.last),3);
        ydata1 = medianaverage(handles.donor_all(handles.m,handles.first:handles.last),3);
        ydata2 = medianaverage(handles.acceptor_all(handles.m,handles.first:handles.last),3);
    case 5
        xdata = meanaverage(handles.time(handles.first:handles.last),3);
        ydata1 = meanaverage(handles.donor_all(handles.m,handles.first:handles.last),3);
        ydata2 = meanaverage(handles.acceptor_all(handles.m,handles.first:handles.last),3);
    case 6
        xdata = meanaverage(handles.time(handles.first:handles.last),4);
        ydata1 = medianaverage(handles.donor_all(handles.m,handles.first:handles.last),4);
        ydata2 = medianaverage(handles.acceptor_all(handles.m,handles.first:handles.last),4);
    case 7 
        xdata = meanaverage(handles.time(handles.first:handles.last),4);
        ydata1 = meanaverage(handles.donor_all(handles.m,handles.first:handles.last),4);
        ydata2 = meanaverage(handles.acceptor_all(handles.m,handles.first:handles.last),4);
    case 8
        xdata = meanaverage(handles.time(handles.first:handles.last),5);
        ydata1 = medianaverage(handles.donor_all(handles.m,handles.first:handles.last),5);
        ydata2 = medianaverage(handles.acceptor_all(handles.m,handles.first:handles.last),5);
    case 9
        xdata = meanaverage(handles.time(handles.first:handles.last),5);
        ydata1 = meanaverage(handles.donor_all(handles.m,handles.first:handles.last),5);
        ydata2 = meanaverage(handles.acceptor_all(handles.m,handles.first:handles.last),5);
end
% NaN values here are causing the program to barf.
% replace with 1's to clean up, then add back in
% % % yadata1holder = ydata1;
% % % ydata2holder = ydata2;
% % % ydata1 = ydata1(~isnan(ydata1));
% % % ydata2 = ydata2(~isnan(ydata2));
fret = (ydata2-handles.crosstalk*ydata1)./(ydata1+ydata2-handles.crosstalk*ydata1); % Bernie the cross talk comes in here for the FRET value
fret(isnan(fret)) = [0];

% % % ydata1 = yadata1holder;
% % % ydata2 = ydata2holder;
handles.modcrosstalk = 0.09; %Sergey-what the heck is this? Why not same crosstalk as line 243?
total_I = (ydata1+ydata2-handles.modcrosstalk*ydata1); 
total_I_av = total_I;
%Intensity_Threshold = str2double(get(handles.edit5,'String'));
%total_I_signal = [];
%size(total_I)
ind_max = find(total_I,1,'last');%SergeyDec2007 made averaging before finding Imax, should avoide spikes better
for ind=11:(ind_max-10)
%     if total_I(ind)>Intensity_Threshold%SERGEY - threshold for "real" signal, still better use human judgement here
%         total_I_signal = [total_I_signal total_I(ind)];
%     end
  total_I_av(1,ind) = sum(total_I(1,ind:ind+2))/3;%Sergey replaced with forward running average over 5 points
%(total_I(ind-2)+total_I(ind-1)+total_I(ind)+total_I(ind+1)+total_I(ind+2))/5;
end

%SERGEY was calculating SNR here
% [total_I_hist,total_I_out] = hist(total_I_signal,30);
% %cfun = fit(total_I_out,total_I_hist,gaussian); Let's try a simpler
% %algorithm, w/o fit here: construct cumulative distribution and find
% %intensities when cumulative is 0.17, 0.5 and 0.83 (corresponding to normal dist -sigma..mu...+sigma). Use 0.5 as a proxy for
% %the middle, and (0.83-0.17)/2 as sigma
% for p=2:30
%     total_I_hist(p) = total_I_hist(p-1)+total_I_hist(p);
% end
% total_I_hist = total_I_hist/total_I_hist(30);
% total_I_middle = total_I_out(find(total_I_hist>=0.5,1,'first'))
% total_I_sigma = (total_I_out(find(total_I_hist>=0.83,1,'first')) - total_I_out(find(total_I_hist>=0.17,1,'first')))/2
% 
% SNR = total_I_middle/total_I_sigma
% set(handles.text17,'String',num2str(SNR,2));
% handles.total_I_middle = total_I_middle;
% handles.SNR = SNR;
handles.total_I = total_I_av;%SERGEY_June2008 After commenting SNR made a change here
Intensity_Threshold = str2double(get(handles.edit5,'String'));
handles.total_I_norm = handles.total_I/(3*Intensity_Threshold);
Imax = max(total_I_av);
handles.Imax = Imax;

set(handles.donor,'XData',xdata);
set(handles.donor,'YData',ydata1);

set(handles.acceptor,'XData',xdata);
set(handles.acceptor,'YData',ydata2);

set(handles.fret,'XData',xdata);
set(handles.fret,'YData',fret);

set(handles.line_low,'XData',xdata);
set(handles.line_low,'YData',handles.low_th*ones(length(xdata),1));

set(handles.intensity,'XData',xdata);
set(handles.intensity,'YData',handles.total_I_norm);

limits = get(handles.axes2,'Xlim');
if limits(1)<1
    limits(1)=1
end

set(handles.zoompoints,'Xdata',limits);

set(handles.zoompoints,'Ydata',[floor(ydata1(limits(1))) floor(ydata1(limits(2)))]);

%%bernie removed, no 2nd line

%set(handles.line_high,'XData',xdata);
%set(handles.line_high,'YData',handles.high_th*ones(length(xdata),1));

set(handles.kinetics,'XData',xdata);

refresh_hist(hObject, handles);
Update_Kinetics(hObject, handles);
handles.number_of_traces_selected = handles.number_of_molecules_selected / 2;

handles.currentpositionx = handles.positions(2*handles.m,1);
handles.currentpositiony = handles.positions(2*handles.m,2);
set(handles.text20,'String',[num2str(handles.currentpositionx) '/' num2str(handles.currentpositiony)]);

set(gcf,'Name',[handles.filename ' : ' num2str(handles.m) ' out of ' num2str(handles.number) ' : ' num2str(handles.number_of_traces_selected) ' traces kept ' ]);
set(handles.text6,'String',[handles.filename ' : ' num2str(handles.m) ' out of ' num2str(handles.number) ' : ' num2str(handles.number_of_traces_selected) ' traces kept ' ]);
set(handles.pushbutton2, 'enable', 'on');
set(handles.pushbutton5, 'enable', 'on');
%added to fix histogram pile up
set(handles.pushbutton3, 'enable', 'on');
%set(handles.pushbutton7, 'enable', 'on');
%set(handles.pushbutton6, 'enable', 'on');



% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%Bernie This defines the key movement through the traces. Down and Right
%%reset the levels, up and left do not

keypressed=get(hObject,'CurrentCharacter');
switch keypressed
    case '',
        %disp('left arrow pressed');
        if handles.m > 1, handles.m=handles.m-1; end;
        guidata(hObject, handles);
        Update_Figure(hObject, handles);
        return;
    case '',
        %disp('up arrow pressed');
        if handles.m > 1, handles.m=handles.m-1; end;
        guidata(hObject, handles);
        Update_Figure(hObject, handles);        
        return;
    case '',
        %disp('right arrow pressed');
        if handles.m < handles.number, handles.m=handles.m+1; end;
        set(handles.slider1,'Value',handles.low_th_1);
%removed by bernie
%set(handles.slider2,'Value',handles.high_th_1);
        handles.low_th = handles.low_th_1;
%removed by bernie
%handles.high_th = handles.high_th_1;
        guidata(hObject, handles);
        Update_Figure(hObject, handles);                
        return;
    case '',
        %disp('down arrow pressed');
        if handles.m < handles.number, handles.m=handles.m+1; end;
        set(handles.slider1,'Value',handles.low_th_1);
 %removed by bernie
 %set(handles.slider2,'Value',handles.high_th_1);
        handles.low_th = handles.low_th_1;
 %removed by bernie
 %handles.high_th = handles.high_th_1;
        guidata(hObject, handles);
        Update_Figure(hObject, handles);                        
        return;
end



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.m < handles.number,
    handles.m=handles.m+1;

%showme = handles.m
        set(handles.slider1,'Value',handles.low_th_1);
        handles.low_th = handles.low_th_1;
        guidata(hObject, handles);
        Update_Figure(hObject, handles);                        
end;
%SERGEY try inserting finding here, so that I don't have to click them every time. NOPE. Smth doesn't work so far.    


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        if handles.m > 1,
            handles.m=handles.m-1;
        
        guidata(hObject, handles);
        Update_Figure(hObject, handles);        
        
        end;
        
        
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(hObject,'Value');
switch val
     case 1
        handles.average = 1;
    case 2
        handles.average = 2;
    case 3
        handles.average = 3;
    case 4
        handles.average = 4;
    case 5
        handles.average = 5;
    case 6
        handles.average = 6;
    case 7 
        handles.average = 7;
    case 8
        handles.average = 8;
    case 9
        handles.average = 9;
end
guidata(gcf,handles);
Update_Figure(gcf,handles);

% function to calculate mean average trace. The length of the trace is
% shrunk by N
function averaged = meanaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = mean(temp);

% function to calculate median average trace. The length of the trace is
% shrunk by N
function averaged = medianaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = median(temp);


% --- Executes on button press in pushbutton2.  "select"
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.number_of_molecules_selected == 0
    handles.Newdata=handles.time(handles.first:handles.last);
    handles.newpositions(1,:)=zeros(1,2);
end
% xlim=get(handles.axes1,'XLim');
% xdata=handles.time(handles.first:handles.last);
% left=min(find(xdata >= round(xlim(1))));
% right=max(find(xdata <= round(xlim(2))));
% donor_background = mean(handles.donor_all(handles.m,left:right));
% acceptor_background = mean(handles.acceptor_all(handles.m,left:right));

handles.Newdata(handles.number_of_molecules_selected+2,:)=handles.donor_all(handles.m,handles.first:handles.last);
handles.Newdata(handles.number_of_molecules_selected+3,:)=handles.acceptor_all(handles.m,handles.first:handles.last);
%Sergey - want position information too
handles.newpositions(handles.number_of_molecules_selected+2,:) = handles.positions(2*handles.m-1,:);
handles.newpositions(handles.number_of_molecules_selected+3,:) = handles.positions(2*handles.m,:);
%tellmehere = handles.newpositions
handles.number_of_molecules_selected = handles.number_of_molecules_selected+2;
handles.number_of_traces_selected = handles.number_of_molecules_selected/2;

    %Sergey - try saving individual&combined histograms here
        temp_ydata = get(handles.histogram,'YData');%SERGEY_march2008
        ydata = temp_ydata(2,:);
        if handles.histogram_data == 0;
            handles.histogram_data = zeros(1,length(handles.fretbin));
        else
        end
        handles.histogram_data = [handles.histogram_data;ydata];
        handles.number_of_histograms_selected = handles.number_of_histograms_selected + 1;
        guidata(gcf,handles);
        %addded to fix histogram pile up
        set(hObject, 'enable', 'off');

set(handles.text6,'String',[handles.filename ' : ' num2str(handles.m) ' out of ' num2str(handles.number) ' : ' num2str(handles.number_of_traces_selected) ' traces kept ' ]);

guidata(gcf,handles);
set(hObject, 'enable', 'off');
% --- Executes on button press in pushbutton3.  "select histogram"
%Sergey_2008 try commenting this out, useless so far
% function pushbutton3_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% temp_ydata = get(handles.histogram,'YData');%SERGEY_march2008
% ydata = temp_ydata(2,:);
% if handles.histogram_data == 0;
%     handles.histogram_data = zeros(1,length(handles.fretbin));
% else
% end
% handles.histogram_data = [handles.histogram_data;ydata];
% handles.number_of_histograms_selected = handles.number_of_histograms_selected + 1;
% % % %%  to keep raw hist data
% % % temp_yrawdata = handles.fret_rawdata;
% % % yrawdata = temp_yrawdata;
% % % handles.histogram_rawdata = handles.histogram_rawdata + yrawdata;
% % % %%
% guidata(gcf,handles);
% %addded to fix histogram pile up
% set(hObject, 'enable', 'off');
% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function traces_Callback(hObject, eventdata, handles)
% hObject    handle to traces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%  ORIGINAL
%             if handles.number_of_molecules_selected ~= 0
%    %creates filename
%                 filename2=strcat(handles.filename,'.traces2');
%    %creats file and overwrites existing
%                 fid2=fopen(filename2,'w');
%    %writes 3 numbers. a 4 bit integer, that is the number of frames
%                 fwrite(fid2,handles.last-handles.first+1,'int32');
%    %the number of traces, as a 2 bit integer
%                 fwrite(fid2,handles.number_of_molecules_selected,'int16');
%    %and finally the data
%                 fwrite(fid2,handles.Newdata,'int16');
%    %then we close this puppy up
%                 fclose(fid2);
%             end


if handles.number_of_molecules_selected ~= 0
    
    filename2=strcat(handles.filename,'(sel).tracesp');    %Sergey - now it will have same extension and same format %gives a tra2 filename    
    fid2=fopen(filename2,'w');                      %opens that file
    fwrite(fid2,handles.last-handles.first+1,'int32');  %the first number is the number of frames
    %Old code (Sergey)
%     fwrite(fid2,handles.fps,'float32');                     %the number of frames per second
%     fwrite(fid2,handles.number_of_molecules_selected/2,'int16');  %the number of molecules
%     fwrite(fid2,handles.number_of_molecules_selected,'int16');  %filler for the number of mapped mlcs
%     fwrite(fid2,handles.number_of_molecules_selected,'int16');  %filler for the donor traces
    fwrite(fid2,handles.number_of_molecules_selected,'int16');  %the number of molecules
    fwrite(fid2,handles.newpositions,'int16');
    fwrite(fid2,handles.Newdata,'int16');
    fclose(fid2);
%   More old code (Sergey)  
% %remove the 1st line of handles.Newdata to make the data array the same as
% %a tra file
%     holder = handles.Newdata;
%     handles.Newdata(1,:) = [];
%     
% % fill up a fake positiondata array, lets say just the same as the data itself
% fakepositions = zeros(2,handles.number_of_molecules_selected);
% handles.fakeposition = fakepositions;
%     fwrite(fid2,handles.fakeposition,'int16')
% % then the actual data as a float    
%     fwrite(fid2,handles.Newdata,'float')
% % put the first line back onto Newdata
%     
%     handles.Newdata = holder;
%     fclose(fid2);
end

set(handles.text4,'String','Traces SAVED','BackgroundColor','g');

if handles.number_of_histograms_selected ~= 0
    handles.compiled_FRET = sum(handles.histogram_data);
    handles.histogram_data(1,:) = handles.compiled_FRET;
    A = [handles.fretbin' handles.histogram_data'];
    %A(:,2) = sum(A,2);
% for i = 1:length(handles.fretbin)
%     A(i,2) = sum(A(i,:))-A(i,1);
% end
    save(strcat(handles.filename,'(FRETDIST).dat'),'A','-ascii');
% % %     B = [handles.histogram_rawdata'];
% % %     save(strcat(handles.filename,'(RAWFRET).dat'),'B','-ascii');
end 
set(handles.text5,'String','Histograms SAVED','BackgroundColor','g');

% --------------------------------------------------------------------
function histograms_Callback(hObject, eventdata, handles)  % "save selected histograms"
% hObject    handle to histograms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if handles.number_of_histograms_selected ~= 0
    handles.compiled_FRET = sum(handles.histogram_data);
    handles.histogram_data(1,:) = handles.compiled_FRET;
    A = [handles.fretbin' handles.histogram_data'];
    %A(:,2) = sum(A,2);
% for i = 1:length(handles.fretbin)
%     A(i,2) = sum(A(i,:))-A(i,1);
% end
    save(strcat(handles.filename,'(FRETDIST).dat'),'A','-ascii');
% % %     B = [handles.histogram_rawdata'];
% % %     save(strcat(handles.filename,'(RAWFRET).dat'),'B','-ascii');
%end 
set(handles.text5,'String','Histograms SAVED','BackgroundColor','g');
%SERGEY_May2008

% nbins = ceil((max(handles.donor_all(:)) - min(handles.donor.all(:)))/100);
% Donor_bins = min(handles.donor.all(:)):100:(min(handles.donor.all(:)+100*nbins));
Donor_bins = -3000:100:30000;
Donor_hist = hist(handles.donor_all(:),Donor_bins);
B = [Donor_bins' Donor_hist'];
save(strcat(handles.filename,'(DonorDIST).dat'),'B','-ascii');
% --- Executes on button press in Histogram.
function Histogram_Callback(hObject, eventdata, handles)
% hObject    handle to Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[datafile,datapath]=uigetfile('*.trace*','Choose a trace file','MultiSelect','On');
%%bernie changed this to tra
[datafile,datapath]=uigetfile('*.tra*','Choose a trace file','MultiSelect','On');


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[0 1 1]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%handles.low_th = 0.15;
%%handles.high_th = 0.52;
%%bernie changes these too
handles.low_th = 0.48;

%%removed by bernie
%%handles.high_th = 0.5;
set(hObject,'Min', -0.2, 'Max', 1.2, 'Value',handles.low_th,'SliderStep',[0.01 0.01]);
guidata(gcf,handles);
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.low_th = get(hObject,'Value');
temp = get(handles.line_low,'YData');
set(handles.line_low,'YData',handles.low_th*ones(length(temp),1));
guidata(gcf,handles);
Update_Kinetics(gcf,handles);
%     Bernie took out this slider                % --- Executes during object creation, after setting all properties.
%                     function slider2_CreateFcn(hObject, eventdata, handles)
%                     % hObject    handle to slider2 (see GCBO)
%                     % eventdata  reserved - to be defined in a future version of MATLAB
%                     % handles    empty - handles not created until after all CreateFcns called
% 
%                     % Hint: slider controls usually have a light gray background, change
%                     %       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
%                    usewhitebg = 1;
%                     if usewhitebg
%                         set(hObject,'BackgroundColor',[1 .5 1]);
%                     else
%                         set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%                     end
% 
%                     %%Bernie, changed these... why is this the same as slider1?
%                     %%handles.low_th = 0.25;
%                     %%handles.high_th = 0.55;
%                     handles.low_th = 0.0;
%                     handles.high_th = 0.5;
% 
% 
%                     set(hObject,'Min', -0.2, 'Max', 1.2, 'Value',handles.high_th,'SliderStep',[0.01 0.01]);
%                     guidata(gcf,handles);
%                     % --- Executes on slider movement.
%                     function slider2_Callback(hObject, eventdata, handles)
%                     % hObject    handle to slider2 (see GCBO)
%                     % eventdata  reserved - to be defined in a future version of MATLAB
%                     % handles    structure with handles and user data (see GUIDATA)
% 
%                     % Hints: get(hObject,'Value') returns position of slider
%                     %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%                     handles.high_th = get(hObject,'Value');
%                     temp = get(handles.line_high,'YData');
%                     set(handles.line_high,'YData',handles.high_th*ones(length(temp),1));
%                     guidata(gcf,handles);
%                     Update_Kinetics(gcf,handles);
% 

% --- Executes on button press in pushbutton5.  "Save Kinetics"
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% in automatic kinetics mode, use a different name
if handles.automatic_kinetics ~= 1 
    tempfilename=['(kin', num2str(handles.framerate) ')' handles.filename '.dat'];    
    tempfid=fopen(tempfilename,'a');
    tempfilename2=['(proc_traces' num2str(handles.framerate) ')' handles.filename '.dat'];
    tempfid2=fopen(tempfilename2,'a');
%     tempfilename=['(kineticsfirst)' handles.filename '.dat']; %Sergey added
%     tempfid3=fopen(tempfilename,'a');%Sergey added
%     tempfilename=['(kineticslast)' handles.filename '.dat']; %Sergey added
%     tempfid4=fopen(tempfilename,'a');%Sergey added
%     tempfilename=['(kineticsall)' handles.filename '.dat']; %Sergey added
%     tempfid5=fopen(tempfilename,'a');%Sergey added
%     tempfilename=['(flifetime)' handles.filename '.dat']; %Sergey added to record fluorescence lifetime
%     tempfid6=fopen(tempfilename,'a');%Sergey added
%     tempfilename=['(frhigh)' handles.filename '.dat']; %Sergey added to record average time in high FRET per molecule
%     tempfid7=fopen(tempfilename,'a');%Sergey added
else
    tempfilename=['(kinetics_auto)' handles.filename '.dat'];    
    tempfid=fopen(tempfilename,'a');
    tempfilename=['(kinetics2_auto)' handles.filename '.dat'];
    tempfid2=fopen(tempfilename,'a');
end
   
% otherindex = sort([handles.low_index handles.medium_index]);
% temp = diff(otherindex);
% lifetime_high = temp(find(temp > 1));
% 
% otherindex = sort([handles.low_index handles.high_index]);
% temp = diff(otherindex);
% lifetime_medium = temp(find(temp > 1));
% 
% otherindex = sort([handles.medium_index handles.high_index]);
% temp = diff(otherindex);
% lifetime_low = temp(find(temp > 1));

tempx = get(handles.kinetics,'XData');
tempy = get(handles.kinetics,'YData');
templevel = zeros(length(tempx),1);

fret = get(handles.fret,'YData');
datadonor = get(handles.donor,'YData');
datadonor = datadonor';
dataacceptor = get(handles.acceptor,'YData');
dataacceptor = dataacceptor';
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=find(tempx >= xlim(1), 1 );%Sergey07 changed here min and max as suggested by Matlab
right=find(tempx <= xlim(2), 1, 'last' );
k=left;
%p=left;%Sergey to mark the end of the previous dwell%SergeyDec2007 removed
A=zeros(1,3);
B=zeros(1,3);
A(1,1) = 9;
B(1,1) = 9;
framelength = get(handles.edit3,'string');%SergeyDec2007 - if conflict with fps, it's probably here:)
framelength = str2double(framelength);
handles.framelength = framelength;
currentpositions = get(handles.text20,'string');
n = findstr(currentpositions,'/');
currentx = str2double(currentpositions(1:n-1));
currenty = str2double(currentpositions(n+1:end));
A(1,2) = currentx;%Sergey_June2008: these two positions will be x and y
A(1,3) = currenty;
B(1,2) = currentx;%Sergey_June2008: these two positions will be x and y
B(1,3) = currenty;
% bernie took out high_th
%B=[handles.m handles.average left right handles.low_th handles.high_th];
%B=[handles.m handles.average left right handles.low_th];
%flifetime=zeros(1,1);
%FractionHigh=zeros(1,1);%SERGEY To record per-molecule-averaged fraction of time in high FRET
j=1;
for i=left:right-1,
    if tempy(i)~=tempy(i+1)
        j=j+1;
        lifetime=i+1-k;
        meanfret=mean(fret(k:i));        
 
        A(j,:) = [templevel(i),lifetime,meanfret];
 
        k=i+1;
    end
    B(i-left+2,1) = datadonor(i,1);
    B(i-left+2,2) = dataacceptor(i,1);
    B(i-left+2,3) = fret(i);%For lack of a better use
end

%SERGEY Try adding the last dwell here
j=j+1;
lifetime=i+1-k;

meanfret=mean(fret(k:i));

A(j,:) = [templevel(i),lifetime,meanfret];%SergeyDec2007 here
A(j+1,:)  = 9;
size(B)
B=[B;9*ones(1,3)];
fprintf(tempfid,'%d %d %4.3f\n',A');
fclose(tempfid);
fprintf(tempfid2,'%6.2f %6.2f %4.3f\n',B');
fclose(tempfid2);
set(hObject, 'enable', 'off');
    
%pushbutton3_Callback(handles.pushbutton3, eventdata, handles);% commentout
%temporarily while pushbutton3 itself is out
% zoom out
zoom_connect OUT;
%this doesnt work with the finding buttons...why?

%handles = guidata(gcf); Sergey tried here
guidata(gcf,handles);
% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles) %   the FRET bin width handle
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

handles.fret_binwidth = 0.005;
set(hObject,'Min', 0.005, 'Max', 0.025, 'Value',handles.fret_binwidth,'SliderStep',[0.005 0.005]);
guidata(gcf,handles);


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.fret_binwidth = get(hObject,'Value');
handles.fretbin = -0.4:handles.fret_binwidth:1.4;
guidata(gcf,handles);
refresh_hist(gcf,handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Update_Kinetics_Auto(gcf,handles);
%set(hObject, 'enable', 'off');


% --------------------------------------------------------------------
function kinetics_Callback(hObject, eventdata, handles)   % Extract kinetics
% hObject    handle to kinetics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.batch_analysis ~= 1
    [handles.kinetics_file,handles.datapath]=uigetfile('(kinetics2)*.dat','Choose a (kinetics2) datafile');
    if handles.kinetics_file==0, 
        return; 
    end
    cd(handles.datapath);
end
fid=fopen(handles.kinetics_file,'r');
% [A, count] = fscanf(fid,'%d %d %d %d %f %f',inf)
[A, count] = fscanf(fid,'%d %d %d %f %f',inf)
fclose(fid);

% B= reshape(A,6,count/6);
B= reshape(A,5,count/5);
B = B';
molecule_index = B(:,1)';
left = B(:,3)';
right = B(:,4)';

datafile=strrep(handles.kinetics_file,'(kinetics2)','');
datafile=strrep(datafile,'dat','tra2');


%datafile=strrep(datafile,'dat','traces2');

handles.automatic_kinetics = 1;
handles.datafile = datafile;

%now open the corresponding traces2 file
Open_Callback(handles.Open, eventdata, handles);
handles = guidata(gcf);
for i=1:length(molecule_index),
 showme = length(molecule_index)
%                                             %Leaf through until we hit the correct molecule_index
%                                              while(handles.m~=molecule_index(i)),    %what happens when handles.m>molecule_index?
%                                                 counter = handles.m;            %handles.m is the trace ID
%                                                 counter
%                                                 counter2 = molecule_index(i)    %for some reason this is > than max # traces
%                                                 set(gcf,'CurrentCharacter','');
%                                                 figure1_KeyPressFcn(gcf, eventdata, handles);
%                                                 handles = guidata(gcf);
%                                             end
    set(gcf,'CurrentCharacter','');
 figure1_KeyPressFcn(gcf, eventdata, handles);
 handles = guidata(gcf);
    %Set the average points to 2
            %%WHY?
    set(handles.popupmenu1,'Value',1);
    popupmenu1_Callback(handles.popupmenu1, eventdata, handles);
    handles = guidata(gcf);
    drawnow;
    %Zoom into the part to be analyzed
   
    xdata=get(handles.fret,'XData');
    set(handles.axes1,'XLim', [xdata(left(i)) xdata(right(i))]);
    set(handles.axes2,'XLim', [xdata(left(i)) xdata(right(i))]);
    set(handles.axes4,'XLim', [xdata(left(i)) xdata(right(i))]);
    refresh_hist(gcf,handles);
    
    Update_Kinetics(gcf,handles);    
    drawnow;
    %Optimize
% dont'% % %     pushbutton6_Callback(handles.pushbutton6, eventdata, handles);
%      % % %     handles = guidata(gcf);
    %Save Kinetics
    pushbutton5_Callback(handles.pushbutton5, eventdata, handles);
    handles = guidata(gcf);
    drawnow;
    
end
    
    %Save histograms
    
% % if handles.number_of_histograms_selected ~= 0
% %     A = [handles.fretbin' handles.histogram_data'];
% %     save(strcat(handles.filename,'(FRETDIST_AUTO).dat'),'A','-ascii');
% % end 
% % 


%When done, go back to manual mode
handles.automatic_kinetics = 0;
guidata(gcf,handles);


% --------------------------------------------------------------------
function batch_Callback(hObject, eventdata, handles)
% hObject    handle to batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.batch_analysis = 1;
handles.datapath = uigetdir('', 'Pick a Directory with (kinetics2) files');
cd(handles.datapath);

kinetics_files=dir('(kinetics2)*.dat');
number=size(kinetics_files);
totalfret=0;
totalnumber=0;
for i=1:number(1),
    handles.kinetics_file=kinetics_files(i).name;
    guidata(gcf,handles);
    kinetics_Callback(handles.kinetics, eventdata, handles);    
end
handles.batch_analysis = 0;









% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
intensity = get(handles.axes1,'YLim');
intensity = intensity*1.1;
set(handles.axes1,'YLim',intensity,'YGrid','on')

guidata(gcf,handles);





% --- Executes on button press in pushbutton10. "to copy the trace and fret
% graphs into a new window for use in other applications"
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Sergey - while I learn how it works, disable. not the most necessary
%feature
%handles.figureloopcounter  = floor(handles.figurecounter/8);
%handles.figurecounter = handles.figurecounter+1-(8*handles.figureloopcounter);
%handles.copyfigdisplay = handles.copyfigdisplay+1;

%guidata(gcf,handles);

% % 
% % if handles.figureloopcounter ~= 0
% %     handles.figurecounter = handles.figurecounter-8;
% %     handles.figureloopcounter = 0;
% % end

%if (handles.copyfigdisplay-1) == 0
%    copygraphs = figure('Name','copies') 
%     handles.copyfigdisplay = handles.copyfigdisplay+1;
%    elseif handles.figurecounter ~= 0
%     figure(copygraphs)
%end


%handles.figurecounter = handles.figurecounter-1;
framerate = get(handles.edit3,'string');
%framerate = str2double(mat2str(cell2mat(framerate)));
framerate = str2double(framerate);
handles.fps = 1000/framerate;

%copygraphs = findobj('Name','copies');
%figure(copygraphs)
 
figure

%   generates a figure outside the gui
% 
% set(handles.donor,'XData',xdata);
% set(handles.donor,'YData',ydata1);
% 
% set(handles.acceptor,'XData',xdata);
% set(handles.acceptor,'YData',ydata2);
% 
% set(handles.fret,'XData',xdata);
% set(handles.fret,'YData',fret);
%set the correct figure...



%get the x axis
copyxdata = get(handles.donor,'XData');
copyxdata = copyxdata/handles.fps;
xdataend = max(copyxdata);
% get the donor
copyydatadonor = get(handles.donor,'YData');
% get the acceptor
copyydataacceptor = get(handles.acceptor,'YData');

% get the FRET data
copyFRET = get(handles.fret,'YData');

%if handles.figurecounter > 3
%position1 = handles.figurecounter+5;
%position2 = handles.figurecounter+9;
%else
%position1 = handles.figurecounter+1;
%position2 = handles.figurecounter+5;
%end
%plot them
%h1 = subplot(4,4,position1,'Ytick',[]), plot(copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r')
h1 = subplot(2,1,1), plot(copyxdata, copyydatadonor, 'g', copyxdata, copyydataacceptor, 'r')
set (h1,'Xlim',[0 xdataend])
%h2 = subplot(4,4,position2,'YLim',[0 1],'Ytick',[]), plot(copyxdata, copyFRET)
h2 = subplot(2,1,2,'YLim',[0 1]), plot(copyxdata, copyFRET)
set(h2,'YLim', [0 1],'XLim',[0 xdataend]);

% % XLimMode('manual');
% % XLim(h1,'tight');
%if handles.figurecounter == 0  | handles.figurecounter == 4
fretylabel = 'FRET (arb.)';
tracesylabel = 'Intensity';
xlabel = 'time (s)';

set(get(h2, 'ylabel'), 'string', fretylabel)
set(get(h1, 'ylabel'), 'string', tracesylabel)
set(get(h1, 'xlabel'), 'string', xlabel)
set(get(h2, 'xlabel'), 'string', xlabel)
%end



% % % % TRY THIS BUTTON:

% --- Executes on button press in pushbutton11. "Open next"
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

olddatafile=handles.filename;
handles.opennext=1;
[mat idx] = regexp(olddatafile, '\d\d\d\d', 'match', 'start' );
mat=cell2mat(mat);
foo=4;
if isempty(mat) == 1,
    [mat idx] = regexp(olddatafile, '\d\d\d', 'match', 'start' );
    mat=cell2mat(mat);
foo=3;
end
if isempty(mat) ==1,
    [mat idx] = regexp(olddatafile, '\d\d', 'match', 'start' );
    mat=cell2mat(mat);
foo=2;
end
if isempty(mat) ==1,
    [mat idx] = regexp(olddatafile, '\d', 'match', 'start' )
    mat=cell2mat(mat(1));
foo=1;
end
matnum = str2num(mat);
newmatnum=matnum+1;
newmat = num2str(newmatnum);
newdatafile = regexprep(olddatafile, mat, newmat);
newdatafile = [newdatafile '.' handles.suffix];
handles.datafilenamenext = newdatafile;

if exist(handles.datafilenamenext)==0,
    set(handles.text3, 'String', 'does not exist');
    handles.opennext=0;
else
    set(handles.text3, 'String', handles.datafilenamenext);
end
drawnow;
guidata(gcf,handles);

% % % % 






% --- Executes on button press in pushbutton12. "correlation"
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% scrsz = get(0,'ScreenSize')
% scrsz(3) = floor(0.8*scrsz(3));
% scrsz(4) = floor(0.8*scrsz(4));
% copygraphs = figure('Name','correlation','Position',scrsz); 
% % ylim('manual');
% 
% 
% %   generates a figure outside the gui
% % 
% % set(handles.donor,'XData',xdata);
% % set(handles.donor,'YData',ydata1);
% % 
% % set(handles.acceptor,'XData',xdata);
% % set(handles.acceptor,'YData',ydata2);
% % 
% % set(handles.fret,'XData',xdata);
% % set(handles.fret,'YData',fret);
% %set the correct figure...
% framerate = get(handles.edit3,'string');
% framerate = str2num(framerate);
% handles.fps = 1000/framerate;
% 
% 
% 
% %get the x axis
% copyxdata = get(handles.donor,'XData');
% copyxdata = copyxdata/handles.fps;
% xdataend = max(copyxdata);
% % get the donor
% copyydatadonor = get(handles.donor,'YData');
% % get the acceptor
% copyydataacceptor = get(handles.acceptor,'YData');
% 
% % get the FRET data
% copyFRET = get(handles.fret,'YData');
% % copyFRET = copyFRET-3;
% 
% % C = corrcoeff(copyydatadonor, copyydataacceptor);
% 
% % get the total intensity data
% total_I = (copyydatadonor+copyydataacceptor-handles.crosstalk*copyydatadonor); 
% Imax = max(total_I);
% total_I = [total_I]/Imax;
% total_I_av = total_I;
% ind_max = find(total_I,1,'last');
% for ind=3:ind_max-2
% total_I_av(ind) = (total_I(ind-2)+total_I(ind-1)+total_I(ind)+total_I(ind+1)+total_I(ind+2))/5;
% end
% handles.total_I = total_I_av; %SERGEY not sure if I really need this here, but for consistency
% handles.total_I = total_I_av;
% % Imode = mode(total_I);
% 
% %plot them
% % % h1 = subplot(3,1,1,'Ytick',[]), plot(copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r');
% % % set (h1,'Xlim',[0 xdataend]);
% % % h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot(copyxdata, copyFRET);
% % % set(h2,'YLim', [0 1],'XLim',[0 xdataend]);
% % % h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);
% % set(h3,'YLim', [0 1],'XLim',[0 xdataend]);
% h1 = subplot(2,1,1), plot(h1, copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r');
% % set(h1, 'YLim', 'tight');
%  
% h2 = subplot(2,1,2), plot(h2, copyxdata, copyFRET, 'b');
% set(h2,  'YLim', [0 1]);
% % set (h1,'Xlim',[0 xdataend],'YLim', [-4 5]);
% % h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot();
% % set(h1,'YLim', [-4 Imax]);
% % h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);
% 
% %make binned %folded plot

% --- Executes on button press in pushbutton13. "find laser on point"
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect reset;
Intensity_Threshold = str2double(get(handles.edit5,'String'));
laseron = find(handles.total_I(11:length(handles.total_I)) >2*Intensity_Threshold, 1, 'first');
xlimits = get(handles.axes2, 'Xlim');
xlimits(1) = laseron+11;%SERGEYTEMP
set(handles.axes2, 'XLim', xlimits);
% set(handles.axes1, 'XLim', xlimits);
set(handles.axes4, 'XLim', xlimits);
% zoom_connect reset;
connectaxes('+x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect on;
guidata(gcf,handles);
refresh_hist(hObject, handles);
Update_Figure(hObject, handles); 
Update_Kinetics(hObject, handles);


% --- Executes on button press in pushbutton14. "find last fret event"
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect reset;
%fret = get(handles.fret, 'YData');%Sergey added
Intensity_Threshold = str2double(get(handles.edit5,'String'));
laseron = find(handles.total_I(11:length(handles.total_I)) >2*Intensity_Threshold, 1, 'first');
% The idea is to find on-event, re-write intensities before that as 1, and
% find the first instance when intensity drops below threshold (blink or
% bleach).
% for i=1:laseron
%     handles.total_I(i)=1;
% end
lightsoff = find(handles.total_I(laseron+10:length(handles.total_I)) <Intensity_Threshold, 1, 'first')%SERGEYTEMP
xlimits = get(handles.axes2, 'Xlim');
    if lightsoff>laseron
    xlimits(2) = lightsoff+laseron;%Sergey changed 
    end
set(handles.axes2, 'XLim', xlimits);
% set(handles.axes1, 'XLim', xlimits);
set(handles.axes4, 'XLim', xlimits);%
% zoom_connect reset;
connectaxes('+x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect on;
guidata(gcf,handles);
refresh_hist(hObject, handles);
Update_Figure(hObject, handles);     
Update_Kinetics(hObject, handles);



% --- Executes on button press in pushbutton15. "then find last RED event"
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect reset;
%acceptor = get(handles.acceptor, 'YData');
Intensity_Threshold = str2double(get(handles.edit5,'String'));
fret = get(handles.fret, 'YData');
redoff = find(handles.total_I >2*Intensity_Threshold & fret >0.5, 1, 'last');%SERGEYTEMP
xlimits = get(handles.axes2, 'Xlim');
xlimits(2) = redoff-1; %Sergey back to -1
set(handles.axes2, 'XLim', xlimits);
% set(handles.axes1, 'XLim', xlimits);
set(handles.axes4, 'XLim', xlimits);
% zoom_connect reset;
connectaxes('+x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect on;
guidata(gcf,handles);
refresh_hist(hObject, handles);
Update_Figure(hObject, handles);     
Update_Kinetics(hObject, handles);





function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton16. "Laser on + last red"
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton13_Callback(handles.pushbutton13, eventdata, handles);
%     dog = 0
pushbutton15_Callback(handles.pushbutton15, eventdata, handles);
%     cat = 0
handles = guidata(gcf);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
Intensity_Threshold = str2double(get(handles.edit5,'String'))

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


