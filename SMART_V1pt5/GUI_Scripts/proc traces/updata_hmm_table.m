function output = updata_hmm_table(handles)

% the nState listed in the table to that of the handles to see if things
% have changed.
table_data = get(handles.uitable1,'Data');

if table_data{12,1} ~= handles.HMMsize;

    handles.HMMsize = table_data{12,1};
    
    if table_data{12,1}>10
        
       h = errordlg('SMART interface only handles upto 10 states. For more states use TrainPostDec_ see instruction manual'); 
       handles.HMMsize = 10;
       table_data{12,1} = 10;
       uiwait(h)
       %pause
    end
    


% update the disc states
% table_data(20,:) = [ {0} {0} {0} {0}];
table_data(13,:) = cell(1,10);
    for i=1:handles.HMMsize    
      table_data{13,i} = i;     
    end
    
    
    tmatrix = cell(10,10);
for i=1:handles.HMMsize
    for j=1:handles.HMMsize
        if i ~=j
           
        tmatrix{i,j}=1;    
            
        end
    end
end
table_data(15:24,:) = tmatrix;
    
    
    
    
    

end


% reset the transtion matrix

set(handles.uitable1,'Data',table_data)


temp_names = get(handles.uitable1,'RowName');
temp_data = get(handles.uitable1,'data');
handles.table_spec.user_table1 = cat(2,temp_names, temp_data); 

%handles.table_spec.user_table1 = table_data;
output = handles;
