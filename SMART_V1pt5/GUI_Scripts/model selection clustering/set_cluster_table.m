function set_cluster_table(handles)





set(handles.uitable2,'visible','on')
set(handles.uitable2,'Position',[0.62    0.1    0.35    0.18]) 

clust_rate_table = [{'N/A'}];
% potentla rates to cluster
cimatrix =  handles.table_spec.user_table1(15:24,2:11);
for i=1:10
    for j=1:10
        if ~isempty(cimatrix{i,j})
            if cimatrix{i,j}~=0
                clust_rate_table = [clust_rate_table {['a(',num2str(i),',',num2str(j),')']}];
            end
        end
    end
end



temp_table = handles.table_spec.user_table1(9:10,2:5);
params.nStates = handles.table_spec.user_table1{12,2};

temp1 = find(cellfun(@isempty,temp_table(1,:))==false);
params.nChannels = temp1(end);%number of states in model 
params.fitChannelType = temp_table(1,temp1);

signal_error = {};
for i=1:size(temp_table(1,temp1),2)
    for t_stat=1:params.nStates
    if temp_table{2,i} == 1    
    signal_error = cat(2,signal_error,['e(', num2str(t_stat), ',', num2str(i),',1)']);      
    end
    if strmatch(temp_table{1,i},'gauss')  
    signal_error = cat(2,signal_error,['e(', num2str(t_stat), ',', num2str(i),',2)']);       
    end
    end
end
clust_rate_table = [ clust_rate_table signal_error];



dat =  { 'N/A', 'N/A',  'N/A';...
         'N/A', 'N/A',  'N/A';... 
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A';...  
         'N/A', 'N/A',  'N/A'};
columnname =   {'Param 1', 'Param 2', 'Param 3'};
columnformat = {clust_rate_table, clust_rate_table, clust_rate_table};
columneditable =  [ true true true]; 
set(handles.uitable2, 'Data', dat,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', columneditable);
        
        

