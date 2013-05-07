function output = sort_sm_molecules(handles)





autoselected = updatae_select_molecules(handles);
%handles.selected_data = output{1};
autoselected = cell2mat(autoselected{2});

%final check to grab manually selected molecules
selected = cell2mat(handles.sort_spec.uitable1.Data(:,1));

ft = [autoselected  selected];


if sum(autoselected) == 0 && sum(selected) == 0
    selected_data = handles.proc_data; 
else
    selected_data = handles.proc_data(selected,:);   
end







% if isfield(handles,'selected_data') ==  false 
%  handles.selected_data = handles.proc_data;
% end
% 
% selected_data = handles.selected_data;
% 
% 
% 
% 
% %
% selected_data = selected_data(selected,:);
% 
% if isempty(selected_data) == true
%     selected_data = handles.proc_data(selected,:);
%     selected_data = handles.proc_data;
% end









num_selected = size(selected_data,1);

a_click(1) = 1/num_selected;
a_click(2) = a_click(1)*4;

if a_click == [Inf Inf]
   a_click = [ 0 1];
end

if num_selected == 1
    num_selected = 1.1;
end

set(handles.slider1,'SliderStep',a_click)
set(handles.slider1, 'Max',num_selected)
set(handles.slider1, 'Min',1)
set(handles.slider1, 'Value',1)



output = selected_data;