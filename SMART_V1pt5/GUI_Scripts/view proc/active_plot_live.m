function output = active_plot_live(handles)


val(1) = get(handles.popupmenu2,'Value');
val(2) = get(handles.popupmenu3,'Value');


cla(handles.axes1)

if val(1) ~= 1 && val(2) ==1
% Plot A Histogram of the Data
    
    

hist(handles.axes1,handles.to_plot(:,val(1)));
temp = get(handles.popupmenu3,'String');
xlabel(handles.axes1,temp(val(1)))
ylabel(handles.axes1,'Number of Molecules')
 
    
elseif val(1) ==1 && val(2) ~=1
% Plot a ranked stem plot of the data

%cla(handles.axes1)
s1 = stem(handles.axes1,sort(handles.to_plot(:,val(2))),'Color','k','LineStyle','none','MarkerSize',3);
xlabel(handles.axes1,'Molecule in Ranks Order')
temp = get(handles.popupmenu3,'String');
ylabel(handles.axes1,temp(val(2)))





else
% plot a scatter plot of the two variables
   
%cla(handles.axes1)
scatter(handles.axes1,handles.to_plot(:,val(1)),handles.to_plot(:,val(2)),'MarkerEdgeColor', 'k',...
    'MarkerFaceColor', 'k')
%tempy = get(gca, 'ylim');
%tempx = get(gca, 'xlim');
%hold
hold(handles.axes1, 'on');

s1 = scatter(handles.axes1,handles.to_plot(handles.index,val(1)),handles.to_plot(handles.index,val(2)),'MarkerEdgeColor', 'r',...
    'MarkerFaceColor', 'r');
%ylim(tempy)
%xlim(tempx)

temp = get(handles.popupmenu2,'String');
xlabel(handles.axes1,temp(val(1)))
temp = get(handles.popupmenu3,'String');
ylabel(handles.axes1,temp(val(2)))

 
    
    
end


output = s1




