function output = generate_clusters(handles)



tv = get(handles.popupmenu3,'Value');
ts = get(handles.popupmenu3,'String');


numClusterList = 1:get(handles.popupmenu4,'Value');
clustFitOutputs = GetClustsRatesMult_v2(handles.selected_data(:,7),ts{tv},numClusterList); 


t_string = [];
for i=1:numClusterList(end)
   
    t_string = [t_string {[num2str(i) ' Cluster Fit']}];
end

t_string = [t_string {'BIC and LogPx'}];
t_string = [t_string {'Cluster Size Bar'}];

set(handles.popupmenu2,'Visible','on','Value',1,'String',t_string);
set(handles.popupmenu2,'Position',[0.3    0.2500    0.1000    0.0400]);

output = clustFitOutputs;

