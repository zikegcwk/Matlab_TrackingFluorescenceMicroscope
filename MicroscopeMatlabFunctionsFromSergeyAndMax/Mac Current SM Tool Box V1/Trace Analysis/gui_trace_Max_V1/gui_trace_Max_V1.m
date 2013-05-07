function varargout = gui_trace_Max_V1(varargin)
% GUI_TRACE M-file for gui_trace.fig
%      GUI_TRACE, by itself, creates a new GUI_TRACE or raises the existing
%      singleton*.
%
%      H = GUI_TRACE returns the handle to a new GUI_TRACE or the handle to
%      the existing singleton*.
%
%      GUI_TRACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TRACE.M with the given input
%      arguments.
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

% Last Modified by GUIDE v2.5 04-Jun-2008 23:59:06

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

kenetibreakpoint = get(handles.edit7,'string');



% Choose default command line output for gui_trace
handles.output = hObject;
handles.fret_binwidth = 0.025;
handles.fretbin = -0.4:handles.fret_binwidth:1.4;
handles.low_th_1 =  str2num(kenetibreakpoint); %default for every trace %%Bernie changed this from 0.13 to 0
% bernie removed
% handles.high_th_1 = 0.53; %default for every trace
handles.low_th =  str2num(kenetibreakpoint);  %Bernie this one too
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
set(handles.axes2,'YLim',[-0.2 1.2],'Tag','reference','YGrid','on');


subplot(handles.axes4); % this is the kinetics plot
line3 = plot(1:100,zeros(1,100),'k');  %%initializes the plot, color k is black
handles.kinetics = line3;
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
        Data=fread(fid,[Ntraces+1 len],'int16');
        fclose(fid);
        handles.fps=40;
        nmapped=Ntraces/2;
        ndonor=Ntraces/2;
 

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
    letmesee = Data;
    letmeseemore = positiondata;
    letmeseefewtraces=0
end

%now set (the size of the axes)? or initialize these matrices?
time = zeros(1,len);
% donor = zeros(Ntraces/2,len);   %seems to assume the number of donor and acceptor traces are the same?
% acceptor = zeros(Ntraces/2,len);  %is this an historic thing?
donor = zeros(Ntraces,len); 
acceptor = zeros(Ntraces, len);
fret = zeros(1,len);

xtalk = get(handles.edit8,'string');
xtalknumb = str2num(xtalk);
handles.crosstalk = xtalknumb; % Bernie what does this do? It is the crosstalk.
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
max_intensity = temp(round(0.98*index));
    
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


end
%% bernie with correction, this is certainly making it harder to view the
% trace - i wonder if yun's program spits out corrected traces?
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
guidata(gcf, handles);

Update_Figure(gcf, handles);

function Update_Figure(hObject, handles)

switch handles.average      %this displays the averaged data by the method selected %%%this is messy - clips ends
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

xtalk = get(handles.edit8,'string');
handles.crosstalk = str2num(xtalk);


fret = (ydata2-handles.crosstalk*ydata1)./(ydata1+ydata2-handles.crosstalk*ydata1); % Bernie the cross talk comes in here for the FRET value
fret(isnan(fret)) = [0];

% % % ydata1 = yadata1holder;
% % % ydata2 = ydata2holder;
handles.modcrosstalk = handles.crosstalk;
total_I = (ydata1+ydata2-handles.modcrosstalk*ydata1); 

Imax = max(total_I);
handles.imax=Imax;
set(handles.text8,'String',num2str(handles.imax));
handles.total_I = total_I;

% Max 051708
% if Imax > 600
% total_I = [total_I]/Imax;
% elseif Imax < 601   %if the total signal is crappy, I force the total intensity to a small number,
% total_I = [total_I]/40000;
% elseif Imax > 2001   %if the total signal is unusually high, cut-off at 2000
% total_I = [total_I]/2000;
% else % is there anything else?
% total_I = [total_I]/Imax;
% end


% NaN values here are causing the program to barf.

% Added by max on 051707 to calculate a signal:noise.  The stratey
% implemented was modified from sergey

total_I_av = total_I;
Intensity_Threshold = str2double(get(handles.edit5,'String'));
total_I_signal = [];


ind_max = find(total_I,1,'last');%SergeyDec2007 made averaging before finding Imax, should avoide spikes better
for ind=20:(ind_max-10)
    if total_I(ind)>Intensity_Threshold%SERGEY - threshold for "real" signal, still better use human judgement here
        total_I_signal = [total_I_signal total_I(ind)];
    end
  total_I_av(1,ind) = sum(total_I(1,ind:ind+9))/10;%Sergey replaced with forward running average over 10 points
%(total_I(ind-2)+total_I(ind-1)+total_I(ind)+total_I(ind+1)+total_I(ind+2))/5;
end


%SERGEY try calculating SNR here
[total_I_hist,total_I_out] = hist(total_I_signal,30);

for p=2:30
    total_I_hist(p) = total_I_hist(p-1)+total_I_hist(p);
end
total_I_hist = total_I_hist/total_I_hist(30);
total_I_middle = total_I_out(find(total_I_hist>=0.5,1,'first'));
total_I_sigma = (total_I_out(find(total_I_hist>=0.83,1,'first')) - total_I_out(find(total_I_hist>=0.17,1,'first')))/2;

SNR = total_I_middle/total_I_sigma;
set(handles.text15,'String',num2str(SNR,2));
handles.SNR = SNR;











set(handles.donor,'XData',xdata);
set(handles.donor,'YData',ydata1);

set(handles.acceptor,'XData',xdata);
set(handles.acceptor,'YData',ydata2);

set(handles.fret,'XData',xdata);
set(handles.fret,'YData',fret);

set(handles.line_low,'XData',xdata);
set(handles.line_low,'YData',handles.low_th*ones(length(xdata),1));

set(handles.intensity,'XData',xdata);
set(handles.intensity,'YData',handles.total_I);

limits = get(handles.axes2,'Xlim');
if limits(1)<1
    limits(1)=1;
end

set(handles.zoompoints,'Xdata',limits);
whataremyzooms=limits;
whatisydata = size(ydata1);
set(handles.zoompoints,'Ydata',[ceil(ydata1(limits(1))) floor(ydata1(limits(2)))]);

%%bernie removed, no 2nd line

%set(handles.line_high,'XData',xdata);
%set(handles.line_high,'YData',handles.high_th*ones(length(xdata),1));

set(handles.kinetics,'XData',xdata);

refresh_hist(hObject, handles);
Update_Kinetics(hObject, handles);
handles.number_of_traces_selected = handles.number_of_molecules_selected / 2;
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
    %lets test this out for all keyboard friendly:
    %first: open next button 'pushbutton11'
   % case 'z',
    %    pushbutton11_Callback(handles.pushbutton11, eventdata, handles);
    case 'q', % pick for on and last red
        pushbutton16_Callback(handles.pushbutton16, eventdata, handles);
    case 'z', % save for Save Kinetics
        pushbutton5_Callback(handles.pushbutton5, eventdata, handles);
    case 'a', % Select
        pushbutton2_Callback(handles.pushbutton2, eventdata, handles);
    case 'w', % Laser on
        pushbutton13_Callback(handles.pushbutton13, eventdata, handles);
     case 'e', % Final
        pushbutton14_Callback(handles.pushbutton14, eventdata, handles);
     case 'r', % Last Red
        pushbutton15_Callback(handles.pushbutton15, eventdata, handles);
     case 'f', % Next Trace
         pushbutton7_Callback(handles.pushbutton7, eventdata, handles);
     case 'd', % Previous 
         pushbutton8_Callback(handles.pushbutton8, eventdata, handles); 
    case 's', % max 
         pushbutton9_Callback(handles.pushbutton9, eventdata, handles);   
    
    
    
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
        %handles.low_th = handles.low_th_1;
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
       % handles.low_th = handles.low_th_1;
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
 %       set(handles.slider1,'Value',handles.low_th_1); % Removed Max
 %       handles.low_th = handles.low_th_1;
            
        kenetibreakpoint = get(handles.edit7,'string');
        handles.low_th = str2num(kenetibreakpoint);
        temp = get(handles.line_low,'YData'); % Added Max
        set(handles.line_low,'YData',handles.low_th*ones(length(temp),1)); % Added Max
        temp = get(handles.edit7,'string');
        set( handles.slider1,'Value',str2num(temp));
    
       % handles.low_th = get(handles.slider1,'Value');
      %set(handles.low_th,'Value',0.8*);

%      Update_slider1
      
      
        guidata(hObject, handles);
        Update_Figure(hObject, handles);    
        %Update_Kinetics(gcf,handles);

end;
    
 
% handles.low_th = get(handles.slider1,'Value');
% temp = get(handles.line_low,'YData');
% 
% guidata(gcf,handles);
% Update_Kinetics(gcf,handles);




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        if handles.m > 1,
            handles.m=handles.m-1;
        
        kenetibreakpoint = get(handles.edit7,'string');
        handles.low_th = str2num(kenetibreakpoint);
        temp = get(handles.line_low,'YData'); % Added Max
        set(handles.line_low,'YData',handles.low_th*ones(length(temp),1)); % Added Max
        temp = get(handles.edit7,'string');
        set( handles.slider1,'Value',str2num(temp));
            
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
% shrunk by N && this is a problem 
%and this problem is fixed by tacking on a few repeats of the last point on
%the end    :) BDS
function averaged = meanaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = mean(temp);
for j=1:N
    averaged = [averaged averaged(end)+1];
end



% function to calculate median average trace. The length of the trace is
% shrunk by N
function averaged = medianaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = median(temp);
for j=1:N
    averaged = [averaged averaged(end)+1];
end

% --- Executes on button press in pushbutton2.  "select"
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.number_of_molecules_selected == 0
    handles.Newdata=handles.time(handles.first:handles.last);
end
% xlim=get(handles.axes1,'XLim');
% xdata=handles.time(handles.first:handles.last);
% left=min(find(xdata >= round(xlim(1))));
% right=max(find(xdata <= round(xlim(2))));
% donor_background = mean(handles.donor_all(handles.m,left:right));
% acceptor_background = mean(handles.acceptor_all(handles.m,left:right));

handles.Newdata(handles.number_of_molecules_selected+2,:)=handles.donor_all(handles.m,handles.first:handles.last);
handles.Newdata(handles.number_of_molecules_selected+3,:)=handles.acceptor_all(handles.m,handles.first:handles.last);
handles.number_of_molecules_selected = handles.number_of_molecules_selected+2;
handles.number_of_traces_selected = handles.number_of_molecules_selected / 2;
set(handles.text6,'String',[handles.filename ' : ' num2str(handles.m) ' out of ' num2str(handles.number) ' : ' num2str(handles.number_of_traces_selected) ' traces kept ' ]);

guidata(gcf,handles);
set(hObject, 'enable', 'off');


% --- Executes on button press in pushbutton3.  "select histogram"
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp_ydata = get(handles.histogram,'YData');
ydata = temp_ydata(2,:);
handles.histogram_data = handles.histogram_data + ydata;
handles.number_of_histograms_selected = handles.number_of_histograms_selected + 1;
%%  to keep raw hist data: but not all the data, just the zoomed in stuff.
temp_yrawdata = get(handles.fret,'YData');
ylimits = get(handles.axes2, 'XLim');
temp_yrawdata = temp_yrawdata(ylimits(1):ylimits(2));
% temp_yrawdata = handles.fret_rawdata;
% yrawdata = temp_yrawdata;
handles.histogram_rawdata = [handles.histogram_rawdata temp_yrawdata];
%%
guidata(gcf,handles);
%addded to fix histogram pile up
set(hObject, 'enable', 'off');
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
    
    filename2=strcat(handles.filename,'.tra2');     %gives a tra2 filename    
    fid2=fopen(filename2,'w');                      %opens that file
    fwrite(fid2,handles.last-handles.first+1,'int32');  %the first number is the number of frames
    fwrite(fid2,handles.fps,'float32');                     %the number of frames per second
    fwrite(fid2,handles.number_of_molecules_selected/2,'int16');  %the number of molecules
    fwrite(fid2,handles.number_of_molecules_selected,'int16');  %filler for the number of mapped mlcs
    fwrite(fid2,handles.number_of_molecules_selected,'int16');  %filler for the donor traces

%remove the 1st line of handles.Newdata to make the data array the same as
%a tra file
    holder = handles.Newdata;
    handles.Newdata(1,:) = [];
    
% fill up a fake positiondata array, lets say just the same as the data itself
fakepositions = zeros(2,handles.number_of_molecules_selected);
handles.fakeposition = fakepositions;
    fwrite(fid2,handles.fakeposition,'int16')
% then the actual data as a float    
    fwrite(fid2,handles.Newdata,'float')
% put the first line back onto Newdata
    
    handles.Newdata = holder;
    fclose(fid2);
end

set(handles.text4,'String','Traces SAVED','BackgroundColor','g');

% --------------------------------------------------------------------
function histograms_Callback(hObject, eventdata, handles)  % "save selected histograms"
% hObject    handle to histograms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.number_of_histograms_selected ~= 0
    A = [handles.fretbin' handles.histogram_data'];
    save(strcat(handles.filename,'(FRETDIST).dat'),'A','-ascii');
    B = [handles.histogram_rawdata'];
    save(strcat(handles.filename,'(RAWFRET).dat'),'B','-ascii');
end 
set(handles.text5,'String','Histograms SAVED','BackgroundColor','g');

% --- Executes on button press in Histogram.
function Histogram_Callback(hObject, eventdata, handles)
% hObject    handle to Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[datafile,datapath]=uigetfile('*.trace*','Choose a trace file','MultiSelect','On');
%%bernie changed this to tra
[datafile,datapath]=uigetfile('*.tra*','Choose a trace file','MultiSelect','On');







% --- Executes during object creation, after setting all properties.

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function edit7_Callback(hObject, eventdata, handles)
%set(hObject,'Value',handles.low_thb);
%guidata(gcf,handles);
% handles.breakpoint=0.5;
% set(hObject, 'String',handles.breakpoint);
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a
%        double
kenetibreakpoint = get(handles.edit7,'string');
handles.low_thb = str2num(kenetibreakpoint);
temp = get(handles.line_low,'YData');
set(handles.line_low,'YData',handles.low_thb*ones(length(temp),1));

%handles.low_th = get(handles.slider1,'Value');
set(handles.slider1,'Value',handles.low_thb);


%Update_Figure(hObject, handles);     
guidata(gcf,handles);
Update_Kinetics(gcf,handles);


%%handles.low_th = 0.15;
%%handles.high_th = 0.52;
%%bernie changes these too
 

%%removed by bernie
%%handles.high_th = 0.5;

%guidata(gcf,handles);
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%templowth = get(handles.edit7,'string');
%handles.low_th =str2num(templowth);
%set(hObject,'Min', -0.2, 'Max', 1.2, 'Value',handles.low_th,'SliderStep',[0.01 0.01]);


handles.low_th = get(handles.slider1,'Value');
temp = get(handles.line_low,'YData');
set(handles.line_low,'YData',handles.low_th*ones(length(temp),1));


handles.breakpoint = get(handles.edit7,'String');
%handles.edit7 = num2str(handles.low_th);
%set(handles.text17,'String',num2str(handles.low_th));


%handles.low_th = get(handles.slider1,'Value');
%set(handles.low_th,'Value',handles.low_thb);
%Update_Figure(hObject, handles);  










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
%                     % eventdata  reserved - to be defined in a future
%                     version of MATLAB
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
    %tempfilename=['(kinetics)' handles.filename '.dat'];    
    %tempfid=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2)' handles.filename '.dat'];
    %tempfid2=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2_cy5life)' handles.filename '.dat'];
    %tempfid3=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2_refold)' handles.filename '.dat'];
    %tempfid4=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2_reunfold)' handles.filename '.dat'];
    %tempfid5=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2_refoldshorten)' handles.filename '.dat'];
    %tempfid6=fopen(tempfilename,'a');
    tempfilename=['(kinetics_defmlc)' handles.filename '.dat'];
    tempfid7=fopen(tempfilename,'a');
    
    tempfilename=['(kinetics_defmlc_start)' handles.filename '.dat'];
    tempfid8=fopen(tempfilename,'a');
    tempfilename=['(kinetics_defmlc_end)' handles.filename '.dat'];
    tempfid9=fopen(tempfilename,'a');
    
    tempfilename=['(donor_acceptor_defmlc)' handles.filename '.dat'];
    tempfid10=fopen(tempfilename,'a');
 
    
    
else
    %tempfilename=['(kinetics_auto)' handles.filename '.dat'];    
    %tempfid=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2_auto)' handles.filename '.dat'];
    %tempfid2=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2auto_cy5life)' handles.filename '.dat'];
    %tempfid3=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2auto_refold)' handles.filename '.dat'];
    %tempfid4=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2auto_reunfold)' handles.filename '.dat'];
    %tempfid5=fopen(tempfilename,'a');
    %tempfilename=['(kinetics2auto_refoldshorten)' handles.filename '.dat'];
    %tempfid6=fopen(tempfilename,'a');
    tempfilename=['(kinetics_defmlc_auto)' handles.filename '.dat'];
    tempfid7=fopen(tempfilename,'a');
    
    tempfilename=['(kinetics_defmlc_start)' handles.filename '.dat'];
    tempfid8=fopen(tempfilename,'a');
    tempfilename=['(kinetics_defmlc_end)' handles.filename '.dat'];
    tempfid9=fopen(tempfilename,'a');
    
    tempfilename=['(donor_acceptor_defmlc)' handles.filename '.dat'];
    tempfid10=fopen(tempfilename,'a');

  
    
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
acceptor = get(handles.acceptor,'YData');
tempdonor = get(handles.donor,'YData');
templevel = zeros(length(tempx),1);

xtalk = get(handles.edit8,'string');
handles.crosstalk = str2num(xtalk);
meanintensity = mean((acceptor+tempdonor-handles.crosstalk*tempdonor));


fret = get(handles.fret,'YData');
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=min(find(tempx >= xlim(1)));
right=max(find(tempx <= xlim(2)));
k=left;
A=zeros(1,4);
% bernie took out high_th
%B=[handles.m handles.average left right handles.low_th handles.high_th];
B=[handles.m handles.average left right handles.low_th];
j=0;
        if handles.automatic_kinetics ~= 0
            laseron = find(acceptor >650 & fret >0.48, 1, 'last');
%             answer = inputdlg(num2str(right),'red limit', 1, {num2str(laseron)});
            answer = inputdlg(num2str(right),'red limit', 1, {num2str(right)});
            right = answer;
            handles.keepright = right;
           
            right = cell2mat(answer);
        end

%Added by max to dump deliniated FRET histograms and deleniated traces      
        
%choose to keep first and last dwell?
        
%drop first and last dewll 
%firstdwell =2;
%lastdwell =1;
        
%use these linesd to keep the last dwell
firstdwell = 1;
lastdwell = 0;
        
for i=left:right-lastdwell,
    if tempy(i)~=tempy(i+1)
        j=j+1;
        lifetime=i+1-k;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i)];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
    end
end

%discard the first and last event
foo = A(2:j,:);
foo = A(1:j,:);
bar = B


%fprintf(tempfid,'%d %d %4.3f %d\n',A(firstdwell:j ,:)');  
%fprintf(tempfid2,'%d %d %d %d %4.3f %4.3f\n',B');
%fclose(tempfid);
%fclose(tempfid2);

%put a row of 9's at the end of each molecule
fprintf(tempfid7,'%d %d %4.3f %d\n',[-9;-9;meanintensity;handles.SNR]);
fprintf(tempfid7,'%d %d %4.3f %d\n',A(firstdwell:j ,:)');
fprintf(tempfid7,'%d %d %4.3f %d\n',[9;9;9;9]);
fclose(tempfid7);



% Added by Max 051708 This will dump the kinetics data into two files.  One
% one before a specified time and one after a specified time

breakpoint = get(handles.edit4,'string');
breakpoint = str2num(breakpoint)-left;
findbreak=1;

 
while sum(A(firstdwell:findbreak,2))< breakpoint
    
    findbreak=findbreak+1;
end

beforeflow = A(firstdwell:(findbreak-1),:);
breakdwell = A((findbreak),:);
breakdwell(2) = A((findbreak),2)-(sum(A(firstdwell:(findbreak),2))-breakpoint);
beforeflow = [beforeflow ; breakdwell];

breakdwell = A((findbreak),:);
breakdwell(2) = (sum(A(firstdwell:(findbreak),2))-breakpoint);
afterflow = [breakdwell; A((findbreak+1):end,:)];

    
fprintf(tempfid8,'%d %d %4.3f %d\n',[-9;-9;-9;handles.SNR]);
fprintf(tempfid8,'%d %d %4.3f %d\n',beforeflow');
fprintf(tempfid8,'%d %d %4.3f %d\n',[9;9;9;9]);
fclose(tempfid8);

fprintf(tempfid9,'%d %d %4.3f %d\n',[-9;-9;-9;handles.SNR]);
fprintf(tempfid9,'%d %d %4.3f %d\n',afterflow);
fprintf(tempfid9,'%d %d %4.3f %d\n',[9;9;9;9]);
fclose(tempfid9);



%Added by Max Greenfeld 060308 to dump FRET and Donor and Acceptor Files

%kenetibreakpoint = get(handles.edit7,'string');
%handles.low_th = str2num(kenetibreakpoint);

fprintf(tempfid10,'%d %d %4.3f %d\n',[-9;-9;-9;get(handles.slider1,'Value')]);
fprintf(tempfid10,'%d %d %4.3f %d\n',[acceptor(left:right); tempdonor(left:right); fret(left:right); templevel(left:right)']);
fprintf(tempfid10,'%d %d %4.3f %d\n',[9;9;9;9]);
fclose(tempfid10);







% save the cy5 lifetime
AA=A;
cy5lifetime = [];
dog=size(AA,1)
for count=1:size(AA,1)
    if AA(count,1)>2.99
        fogtest=0;
        cval = AA(count,2);
        cy5lifetime = [cy5lifetime; cval];
    end
end
cy5lifetime = sum(cy5lifetime)

%fprintf(tempfid3,'%4.3f\n',cy5lifetime');
%fclose(tempfid3);
% refold & reunfolding
% reinitialize data
tempx = get(handles.kinetics,'XData');
tempy = get(handles.kinetics,'YData');
templevel = zeros(length(tempx),1);

fret = get(handles.fret,'YData');
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=min(find(tempx >= xlim(1)));
right=max(find(tempx <= xlim(2)));
% right = cell2mat(handles.keepright);
k=left;
A=zeros(1,6);  %% format: level, first, second, lifetime, meanfret, level
% bernie took out high_th
%B=[handles.m handles.average left right handles.low_th handles.high_th];
B=[handles.m handles.average left right handles.low_th];
j=0;
change=0;
firstdwell = 0;
firstlifetime = 0;
for i=left:right-1,
    if tempy(i)~=tempy(i+1)  % this finds the change in fret
        change=change+1;
        if change == 1
        firstlifetime = i+1-k;
        end
        if firstdwell == 0
            firstdwell = i+1;
        end
        
    end
    if change == 2
        j=j+1;
        lifetime=i+1-k;
        secondlifetime = lifetime-firstlifetime;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),firstlifetime, secondlifetime, lifetime,meanfret,templevel(i+1)-templevel(i)];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
        change = 0;
        firstlifetime=0;
    end
end

%%now the opposite way
% reinitialize data
tempx = get(handles.kinetics,'XData');
tempy = get(handles.kinetics,'YData');
templevel = zeros(length(tempx),1);

fret = get(handles.fret,'YData');
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=min(find(tempx >= xlim(1)));
right=max(find(tempx <= xlim(2)));
% right = cell2mat(handles.keepright);
k = firstdwell+1;
change=0;
for i=k:right-1,

    if tempy(i)~=tempy(i+1)  % this finds the change in fret
        change=change+1;
        if change == 1
        firstlifetime = i+1-k;
        end
        if firstdwell == 0
            firstdwell = i+1;
        end
        
    end
    if change == 2
        j=j+1;
        lifetime=i+1-k;
        secondlifetime = lifetime-firstlifetime;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),firstlifetime, secondlifetime, lifetime,meanfret,templevel(i+1)-templevel(i)];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
        change = 0;
        firstlifetime=0;
    end
end


%discard the first and last event
foo = A(2:j,:);
foo = A(1:j,:);
bar = B
%fprintf(tempfid4,'%d %d %d %d %4.3f %d\n',A(2:j,:)');  
%fprintf(tempfid5,'%d %d %d %d %4.3f %4.3f\n',B');
%fclose(tempfid4);
%fclose(tempfid5);

%%%%%%%%%%%half traces
% refold & reunfolding
% reinitialize data
tempx = get(handles.kinetics,'XData');
tempy = get(handles.kinetics,'YData');
templevel = zeros(length(tempx),1);

fret = get(handles.fret,'YData');
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=min(find(tempx >= xlim(1)));
right=max(find(tempx <= xlim(2)/2));
k=left;
A=zeros(1,6);  %% format: level, first, second, lifetime, meanfret, level
% bernie took out high_th
%B=[handles.m handles.average left right handles.low_th handles.high_th];
B=[handles.m handles.average left right handles.low_th];
j=0;
change=0;
firstdwell = 0;
firstlifetime = 0;
for i=left:right-1,
    if tempy(i)~=tempy(i+1)  % this finds the change in fret
        change=change+1;
        if change == 1
        firstlifetime = i+1-k;
        end
        if firstdwell == 0
            firstdwell = i+1;
        end
        
    end
    if change == 2
        j=j+1;
        lifetime=i+1-k;
        secondlifetime = lifetime-firstlifetime;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),firstlifetime, secondlifetime, lifetime,meanfret,templevel(i+1)-templevel(i)];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
        change = 0;
        firstlifetime=0;
    end
end

%%now the opposite way
% reinitialize data
tempx = get(handles.kinetics,'XData');
tempy = get(handles.kinetics,'YData');
templevel = zeros(length(tempx),1);

fret = get(handles.fret,'YData');
% labeling process of the FRET signal. high=3, medium=1, low=0, This will
% make things easier when I analyze branching ratios.

templevel(handles.low_index) = 0;
% bernie no medium level
%templevel(handles.medium_index) = 1;
templevel(handles.high_index) = 3;

xlim=get(handles.axes4,'XLim');
left=min(find(tempx >= xlim(1)));
right=max(find(tempx <= xlim(2)/2));
k = firstdwell+1;
change=0;
for i=k:right-1,

    if tempy(i)~=tempy(i+1)  % this finds the change in fret
        change=change+1;
        if change == 1
        firstlifetime = i+1-k;
        end
        if firstdwell == 0
            firstdwell = i+1;
        end
        
    end
    if change == 2
        j=j+1;
        lifetime=i+1-k;
        secondlifetime = lifetime-firstlifetime;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),firstlifetime, secondlifetime, lifetime,meanfret,templevel(i+1)-templevel(i)];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
        change = 0;
        firstlifetime=0;
    end
end


%discard the first and last event
foo = A(2:j,:);
foo = A(1:j,:);
bar = B

%fprintf(tempfid6,'%d %d %d %d %4.3f %d\n',A(2:j,:)');  
%fclose(tempfid6);

set(hObject, 'enable', 'off');
    
% pause

pushbutton3_Callback(handles.pushbutton3, eventdata, handles);
% zoom out
zoom_connect OUT;
%this doesnt work with the finding buttons...why?

handles = guidata(gcf);

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
[A, count] = fscanf(fid,'%d %d %d %f %f',inf);
% [A, count] = fscanf(fid,'%d %d %d %d %f %f',inf)
fclose(fid);

% B= reshape(A,6,count/6);
B= reshape(A,5,count/5);
B = B';
molecule_index = B(:,1)';
left = B(:,3)';
right = B(:,4)';

datafile=strrep(handles.kinetics_file,'(kinetics2)','');
datafile=strrep(datafile,'dat','tra2');

if  exist(datafile)==2 

%datafile=strrep(datafile,'dat','traces2');

handles.automatic_kinetics = 1;
handles.datafile = datafile;

%now open the corresponding traces2 file
Open_Callback(handles.Open, eventdata, handles);
handles = guidata(gcf);
% for i=1:length(molecule_index),
for i=1:size(molecule_index,2)
showme = [i size(molecule_index,2)]
%                                             %Leaf through until we hit the correct molecule_index
%                                              while(handles.m~=molecule_index(i)),    %what happens when handles.m>molecule_index?
%                                                 counter = handles.m;            %handles.m is the trace ID
%                                                 counter
%                                                 counter2 = molecule_index(i)    %for some reason this is > than max # traces
%                                                 set(gcf,'CurrentCharacter','');
%                                                 figure1_KeyPressFcn(gcf, eventdata, handles);
%                                                 handles = guidata(gcf);
%                                             end

    %Set the average points to 2
            %%WHY?
%     set(handles.popupmenu1,'Value',1);
%     popupmenu1_Callback(handles.popupmenu1, eventdata, handles);
%     handles = guidata(gcf);
%     drawnow;
    %Zoom into the part to be analyzed
%    left 
%    right
    xdata=get(handles.fret,'XData');
    set(handles.axes1,'XLim', [xdata(left(i)) xdata(right(i))]);
    set(handles.axes2,'XLim', [xdata(left(i)) xdata(right(i))]);
    set(handles.axes4,'XLim', [xdata(left(i)) xdata(right(i))]);
    refresh_hist(gcf,handles);
    %Set the average points to 2
            %%WHY?
    set(handles.popupmenu1,'Value',1);
    popupmenu1_Callback(handles.popupmenu1, eventdata, handles);
    handles = guidata(gcf);
    drawnow;
    
    
    Update_Kinetics(gcf,handles);    
    drawnow;
    %Optimize
% dont'% % %     pushbutton6_Callback(handles.pushbutton6, eventdata, handles);
%      % % %     handles = guidata(gcf);
    %Save Kinetics
    pushbutton5_Callback(handles.pushbutton5, eventdata, handles);
    handles = guidata(gcf);
    drawnow;
%     pause; No pausing
i
%advance
    set(gcf,'CurrentCharacter','');
 figure1_KeyPressFcn(gcf, eventdata, handles);
 handles = guidata(gcf);
end
    
    %Save histograms
foo =     handles.number_of_histograms_selected
if handles.number_of_histograms_selected ~= 0
    A = [handles.fretbin' handles.histogram_data'];
    fff=0
    save(strcat(handles.filename,'(FRETDIST_AUTO).dat'),'A','-ascii');
end 


end
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
        namestring=kinetics_files(i).name
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

handles.figureloopcounter  = floor(handles.figurecounter/8);
handles.figurecounter = handles.figurecounter+1-(8*handles.figureloopcounter);
handles.copyfigdisplay = handles.copyfigdisplay+1;

guidata(gcf,handles);

% % 
% % if handles.figureloopcounter ~= 0
% %     handles.figurecounter = handles.figurecounter-8;
% %     handles.figureloopcounter = 0;
% % end

if (handles.copyfigdisplay-1) == 0
    copygraphs = figure('Name','copies') 
%     handles.copyfigdisplay = handles.copyfigdisplay+1;
%    elseif handles.figurecounter ~= 0
%     figure(copygraphs)
end


handles.figurecounter = handles.figurecounter-1;
framerate = get(handles.edit3,'string')
framerate = str2num(framerate)
% framerate=str2num(framerate);
handles.fps = 1000/framerate;

copygraphs = findobj('Name','copies');
figure(copygraphs)
 


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

if handles.figurecounter > 3
position1 = handles.figurecounter+5;
position2 = handles.figurecounter+9;
else
position1 = handles.figurecounter+1;
position2 = handles.figurecounter+5;
end
%plot them
h1 = subplot(4,4,position1,'Ytick',[]), plot(copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r')
set (h1,'Xlim',[0 xdataend])
h2 = subplot(4,4,position2,'YLim',[0 1],'Ytick',[]), plot(copyxdata, copyFRET)
set(h2,'YLim', [0 1],'XLim',[0 xdataend]);

% % XLimMode('manual');
% % XLim(h1,'tight');
if handles.figurecounter == 0  | handles.figurecounter == 4
fretylabel = 'FRET (arb.)';
tracesylabel = 'Intensity';
xlabel = 'time (s)';

set(get(h2, 'ylabel'), 'string', fretylabel)
set(get(h1, 'ylabel'), 'string', tracesylabel)
set(get(h1, 'xlabel'), 'string', xlabel)
set(get(h2, 'xlabel'), 'string', xlabel)
end



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

scrsz = get(0,'ScreenSize')
scrsz(3) = floor(0.8*scrsz(3));
scrsz(4) = floor(0.8*scrsz(4));
copygraphs = figure('Name','correlation','Position',scrsz); 
% ylim('manual');


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
framerate = get(handles.edit3,'string')
framerate = str2num(framerate)
handles.fps = 1000/framerate;



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
% copyFRET = copyFRET-3;

% C = corrcoeff(copyydatadonor, copyydataacceptor);

% get the total intensity data
total_I = (copyydatadonor+copyydataacceptor-handles.crosstalk*copyydatadonor); 
Imax = max(total_I);
total_I = [total_I]/Imax;
% Imode = mode(total_I);

%plot them
% % h1 = subplot(3,1,1,'Ytick',[]), plot(copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r');
% % set (h1,'Xlim',[0 xdataend]);
% % h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot(copyxdata, copyFRET);
% % set(h2,'YLim', [0 1],'XLim',[0 xdataend]);
% % h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);
% set(h3,'YLim', [0 1],'XLim',[0 xdataend]);
h1 = subplot(2,1,1), plot(h1, copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r');
% set(h1, 'YLim', 'tight');
 
h2 = subplot(2,1,2), plot(h2, copyxdata, copyFRET, 'b');
set(h2,  'YLim', [0 1]);
% set (h1,'Xlim',[0 xdataend],'YLim', [-4 5]);
% h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot();
% set(h1,'YLim', [-4 Imax]);
% h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);



% --- Executes on button press in pushbutton13. "find laser on point"
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect reset;
% laseron = find(handles.total_I > 0.54 , 1, 'first');
highint = find(handles.total_I > 0.48);
laseron = find(highint >0, 1, 'first');
xlimits = get(handles.axes2, 'Xlim');
xlimits(1) = highint(laseron)-1;
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
acceptor = get(handles.acceptor, 'YData');
donor = get(handles.donor,'YData');
laseron = find(handles.total_I >0.3 & donor>550 , 1, 'last');
xlimits = get(handles.axes2, 'Xlim');
xlimits(2) = laseron-1;
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



% --- Executes on button press in pushbutton15. "then find last RED event"
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

connectaxes('-x',[handles.axes1 handles.axes2 handles.axes4]);    
% zoom_connect reset;
acceptor = get(handles.acceptor, 'YData');
fret = get(handles.fret, 'YData');
laseron = find(acceptor >550 & fret >0.19, 1, 'last');
xlimits = get(handles.axes2, 'Xlim');
xlimits(2) = laseron-1;
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


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


scrsz = get(0,'ScreenSize')
scrsz(3) = floor(0.8*scrsz(3));
scrsz(4) = floor(0.8*scrsz(4));
copygraphs = figure('Name','autocorrelation','Position',scrsz); 
%set the correct figure...
framerate = get(handles.edit3,'string')
framerate = str2num(framerate)
handles.fps = 1000/framerate;

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
% copyFRET = copyFRET-3;
% set the limits
xlimits = get(handles.axes2, 'XLim');
corrfret = copyFRET(xlimits(1):xlimits(2));
[aa,bb]=xcorr(corrfret,'coeff');
% get the total intensity data
%plot them
% % h1 = subplot(3,1,1,'Ytick',[]), plot(copyxdata, copyydatadonor/100, 'g', copyxdata, copyydataacceptor/100, 'r');
% % set (h1,'Xlim',[0 xdataend]);
% % h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot(copyxdata, copyFRET);
% % set(h2,'YLim', [0 1],'XLim',[0 xdataend]);
% % h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);
% set(h3,'YLim', [0 1],'XLim',[0 xdataend]);
posaa = aa(find(bb>=0));
posbb = bb(find(bb>=0));
                       options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000000,'MaxIter',1000,'Display','Final');

singlefithigh = lsqcurvefit(@expdecay,[10 0.1],posbb,posaa,[],[],options);
                        xvalues=posbb;
doublefithigh = lsqcurvefit(@expdoubledecay,[10 0.4 1 0.6],posbb,posaa,[],[],options);
                        ydouble=(expdoubledecay(doublefithigh,xvalues));
                        ysingle=(expdecay(singlefithigh,xvalues));

h1 = subplot(2,1,1), plot(bb,aa, 'or', xvalues, ysingle, 'g', xvalues, ysingle, 'b');
set(h1, 'XScale', 'log');
set(h1,  'xLim', [0.1 length(aa)/2]);
 
h2 = subplot(2,1,2), plot(h2, copyxdata, copyFRET, 'b', copyxdata(xlimits(1):xlimits(2)), corrfret, 'or');
set(h2,  'YLim', [0 1]);
% set (h1,'Xlim',[0 xdataend],'YLim', [-4 5]);
% h2 = subplot(3,1,2,'YLim',[0 1],'Ytick',[]), plot();
% set(h1,'YLim', [-4 Imax]);
% h3 = subplot(3,1,3,'YLim',[0 1],'Ytick',[],'YScale', 'log'), scatter(copyxdata, total_I, [20]);



% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % --- Executes during object creation, after setting all properties.
% function edit7_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit7 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 



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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

   

