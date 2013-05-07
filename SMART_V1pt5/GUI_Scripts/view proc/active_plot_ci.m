function active_plot_ci(handles)


if isfield(handles, 'popupmenu2')
temp_str1 = get(handles.popupmenu2,'String');
temp_str2 = get(handles.popupmenu3,'String');

val(1) = get(handles.popupmenu2,'Value');
val(2) = get(handles.popupmenu3,'Value');
plot_string = {temp_str1{val(1)}; temp_str2{val(2)}};

else
   
    % replace the gui controls
    plot_string = handles.temp_plot_string;
    
    
end



plot_types = cellfun(@(x) regexprep(x,'_',' ') , handles.plot_types,'uniformoutput',false);


temp = cellfun(@(x) ~isempty(strfind(x,plot_string{1})),plot_types);
xdata = handles.to_plot(:,temp');

temp = cellfun(@(x) ~isempty(strfind(x,plot_string{2})),plot_types);
ydata = handles.to_plot(:,temp');


if isempty(xdata)
  
    [A B] = sort(cell2mat(ydata(:,1)));
    sorted_ydata = ydata(B,:);
    
    
end



ci_value = 1-handles.view_data{5}.params.auto_confInt;



for i=1:size(handles.to_plot,1)

    
    if size(xdata,2) == 2    
    temp = xdata{i,2};
    to_keep = find(temp(:,2)>ci_value);
    temp = temp(to_keep,:);
    temp_x = temp(1,1);
    temp([1 end],1);
    line(temp([1 end],1)',[ydata{i,1} ydata{i,1}],'LineStyle','-','Color','k');   
    end
    
    if size(ydata,2) == 2

    
    if isempty(xdata)
    
        temp = sorted_ydata{i,2};
        to_keep = find(temp(:,2)>ci_value);
        temp = temp(to_keep,:);
        temp_y = temp(1,1);
        temp([1 end],1);
        line([i i],temp([1 end],1)','LineStyle','-','Color','k');
        
        
        
    else
        
        temp = ydata{i,2};
        to_keep = find(temp(:,2)>ci_value);
        temp = temp(to_keep,:);
        temp_y = temp(1,1);
        temp([1 end],1);
        line([xdata{i,1} xdata{i,1}],temp([1 end],1)','LineStyle','-','Color','k');
    
    end
    
    end


end











