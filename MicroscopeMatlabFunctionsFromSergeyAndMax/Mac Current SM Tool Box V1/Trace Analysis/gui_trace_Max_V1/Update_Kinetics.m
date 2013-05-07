function Update_Kinetics_3state(hObject, handles)

xlim=get(handles.axes2,'XLim');
xdata=get(handles.fret,'XData');
ydata=get(handles.fret,'YData');

left=min(find(xdata >= xlim(1)));
right=max(find(xdata <= xlim(2)));
fret = ydata(left:right);


%       ORIGiNAL
%             handles.high_index = find( ydata(left:right)>= handles.high_th) + left - 1;
%             handles.medium_index = find(ydata(left:right) >= handles.low_th & fret < handles.high_th) + left - 1;
%             handles.low_index = find(ydata(left:right) < handles.low_th) + left - 1;

handles.high_index = find( ydata(left:right)>= handles.low_th) + left - 1;
%        handles.medium_index = find(ydata(left:right) >= handles.low_th & fret < handles.high_th) + left - 1;
handles.low_index = find(ydata(left:right) < handles.low_th) + left - 1;

%       ORIGNIAL
%             handles.high_value = mean(ydata(handles.high_index));
%             handles.medium_value = mean(ydata(handles.medium_index));
%             handles.low_value = mean(ydata(handles.low_index));
test = ydata(handles.high_index);
test = sum(test);
if test<0.0001
        handles.high_value = 0.8;
else
handles.high_value = mean(ydata(handles.high_index));
end
%             handles.medium_value = mean(ydata(handles.medium_index));
%% keep getting a divide by zero error message if this index is empty.
%% so to fix:
test = ydata(handles.low_index);
test = sum(test);
if test<0.0001
    handles.low_value = 0.1;
else
    
handles.low_value = mean(ydata(handles.low_index));
end

temp = zeros(length(xdata),1);
temp(handles.low_index) = handles.low_value;
%   bernie, commented out
%       temp(handles.medium_index) = handles.medium_value;

temp(handles.high_index) = handles.high_value;

set(handles.kinetics,'YData',temp);
% if exist('text9')==1
    set(handles.text9,'String',num2str(handles.high_value));
% end
guidata(hObject,handles);
