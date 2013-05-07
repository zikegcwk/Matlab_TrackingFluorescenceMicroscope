function refresh_hist(hObject, handles)


%H_axis=findobj(H_fig,'Tag','reference');
%if isempty(H_axis), return, end
%H_line=findobj(H_axis,'Type','line');
%xlim=get(H_axis,'XLim');
xlim=get(handles.axes2,'XLim');
%xdata=get(H_line(3),'XData');
xdata=get(handles.fret,'XData');
%ydata=get(H_line(3),'YData');
ydata=get(handles.fret,'YData');

left=min(find(xdata >= round(xlim(1))));
right=max(find(xdata <= round(xlim(2))));

%H_patch=findobj(H_fig,'Tag','refreshable');
%if isempty(H_patch), return, end
%fretbin = get(H_patch,'UserData');
fret = ydata(left:right);
% handles.fret_rawdata= fret;
[Y,I]=hist(fret,handles.fretbin);
%set(H_patch,'YData', [zeros(1,length(Y)); Y; Y; zeros(1,length(Y))]);
tempx=handles.fretbin - (handles.fretbin(2)-handles.fretbin(1))/2;
tempx=[tempx handles.fretbin(end)+(handles.fretbin(2)-handles.fretbin(1))/2];
patch_x = [tempx(1:end-1); tempx(1:end-1); tempx(2:end); tempx(2:end)];

set(handles.histogram,'XData',[tempx(1:end-1); tempx(1:end-1); tempx(2:end); tempx(2:end)]);
set(handles.histogram,'YData', [zeros(1,length(Y)); Y; Y; zeros(1,length(Y))]);
ydatafinder = get(handles.histogram,'YData');
ydatafinder = ydatafinder(2,:);
xdatafinder = get(handles.histogram,'XData');
xdatafinder = xdatafinder(2,:);
pos = find(xdatafinder > handles.low_th, 1);
totaltime = sum(ydatafinder);
hightime = sum(ydatafinder(pos(1):end));
%     if isempty(totaltime) =  1
%         handles.fractionhigh = 0;
%     else
        floor(hightime*100/totaltime);
        handles.fractionhigh = num2str(floor(hightime*100/totaltime));
%     end

set(handles.text7,'String',[handles.fractionhigh ' % ' ]);
guidata(hObject,handles);
