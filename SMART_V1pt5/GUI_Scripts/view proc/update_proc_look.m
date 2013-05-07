function update_proc_look(handles)



val = get(handles.popupmenu1,'Value');


switch val
    
    case 3
        
        
raw_data = handles.view_data{2};

axes(handles.axes3)
cla;


length = (1:size(raw_data,1));
if strcmp(handles.cont_or_discA,'cont')
length = (1:size(raw_data,1))/handles.view_data{5}.fps;
end
trace_color = {'g' 'r' 'b' 'y'};

ts = get(handles.popupmenu4,'string');
tv = get(handles.popupmenu4,'value');
cto_plot = str2num(ts{tv});

if isempty(cto_plot)
for i=1:size(raw_data,2)
plot(handles.axes3,length,raw_data(:,i),trace_color{i})
hold(handles.axes3,'on')
end

else
    
plot(handles.axes3,length,raw_data(:,cto_plot),trace_color{cto_plot})
hold(handles.axes3,'on')
end

%ylim([0 max(max(raw_data))])
set(gca, 'XtickLabel', [])
set(gca,'Color','w')
ylabel('Intensity')

xlim( [ 0 size(length,2)])
if strcmp(handles.cont_or_discA,'cont')
xlim( [ 0 size(length,2)/handles.view_data{5}.fps])
end


axes(handles.axes2)
cla;
%p1= plot(length, handles.view_data{7}.P(1,:),stateColors{1})

hmm_size = size(handles.view_data{7}.A,1);
stateColors = varycolor(hmm_size);    

if isempty(cto_plot)
for i=1:hmm_size
hold(handles.axes2,'on');
p1 = plot(handles.axes2,length, handles.view_data{7}.P(i,:));
set(p1,'Color',stateColors(i,:));
end
else
p1 = plot(handles.axes2,length, handles.view_data{7}.P(cto_plot,:));
set(p1,'Color',stateColors(cto_plot,:));   
    
    
end



xlim( [ 0 size(length,2)])
if strcmp(handles.cont_or_discA,'cont')
xlim( [ 0 size(length,2)/handles.view_data{5}.fps])
end
ylim([-0.1 1.1])
ylabel('probability')

xlabel('Frames')
if strcmp(handles.cont_or_discA,'cont')
xlabel('Time [sec]')
end
 
hmm_output = handles.view_data{7};


table = cell(2,1);
axes(handles.axes5)
cla; 
if ~isempty(hmm_output.A)

    
    if strcmp(handles.cont_or_discA,'cont')
    
    %hmm_output.A = DiscToContA(hmm_output.A,handles.view_data{5}.fps);
    % error check for for DiscToConA
    temp_tmatrix =  DiscToContA(hmm_output.A,handles.view_data{5}.fps);
    if ~isreal(temp_tmatrix)
        display('Discrete To Continuosus Conversion achieved by A*FPS')
        temp_tmatrix  = hmm_output.A*handles.view_data{5}.fps;
    end
    hmm_output.A = temp_tmatrix;
    
    
    end
    
table = generate_dispaly_table(hmm_output);
table{2,3} = 'Confidence Interval';
table{2,4} = handles.view_data{5}.params.auto_confInt;
    
plot_emission_histogram(handles)
                
end       
      

% plot the confidence intervalse for the signal    
% if get(handles.checkbox1,'Value')
%     
% plot_gui_ci(handles)
% 
% end
            
           

    case 4

   
    % Section is used to generate the FRET table.


if ~isempty(handles.view_data{3})

    
raw_data = handles.view_data{3};

axes(handles.axes3)
cla;

length = (1:size(raw_data,1))/handles.view_data{5}.fps;
axes(handles.axes3)
plot(length,raw_data(:,2),'r',length,raw_data(:,1),'g')
ylim([0 max(max(raw_data))])
set(gca, 'XtickLabel', [])
set(gca,'Color','w')
ylabel('Intensity')
   

axes(handles.axes3)
cla
plot(length, raw_data(:,3))
ylim([-0.3 1.3])
xlim( [ 0 size(length,2)/handles.view_data{5}.fps]) 
%set(gca, 'XtickLabel', [])
hold on


end

table = generate_fret_threshold_table(handles);




end


%data_string = cellfun(@(c)num2str(c,'%.4f'),table,'un',0);
set(handles.uitable1,'RowName','','ColumnName','numbered');
set(handles.uitable1,'RowName','','ColumnName',{ '' '' '' '' ''});
set(handles.uitable1,'Data',table)  ;
set(handles.uitable1,'ColumnWidth',{130 130 100 80 80} ) ; 
set(handles.uitable1,'FontSize',12)    







