function max_plot_dmi(final_data)


dmi_reshapes = [];

for i=1:size(final_data,1)
    
    
 temp_trace =    final_data{5,6};
    
 % only plot non two way
 %{output.errorBoundsAuto.var2name}
    
 n_states = size(temp_trace.A,1);
 n_channels = size(temp_trace.fitChannelType,2);
 
 temp_trace.E
 
 
 temp_errors  = struct2cell(temp_trace.errorBoundsAuto);
 
 %remove joint error bounds
 temp = find(cellfun(@isempty, temp_errors(3,:))==false);
 temp_errors(:,temp) = [];
 
 
 signal_errors = reshape(temp_trace.E,size(temp_trace.E,1)*size(temp_trace.E,2),1)
 
 %cell2struct(temp_trace.E,{ 'c1' 'c2'},2)
 
 
 state_summary = {};
 
 for i = 1:size(temp_trace.E,1)
     
     
     
     state_stats = struct;
     
     
    for k = 1:size(temp_trace.E,2)
        
    
    error_mean = cellfun(@(x) ~isempty(strfind(x,['e(' num2str(i) ',' num2str(k) ',1)'])),temp_errors(2,:));
    error_mean = temp_errors(:,error_mean);
    
    if isempty(error_mean)
        temp_std = [];
    end
    
    temp_std = cellfun(@(x) ~isempty(strfind(x,['e(' num2str(i) ',' num2str(k) ',2)'])),temp_errors(2,:)) ;
    temp_std = temp_errors(:,temp_std);
    
    if isempty(temp_std)
        temp_std = [];
    end
    
    
    temp_struct = struct(['c' num2str(k) '_mean'], temp_trace.E{i,k}(1),['c' num2str(k) '_mean_error' ], {error_mean},...
        ['c' num2str(k) '_std'], temp_trace.E{i,k}(1), ['c' num2str(k), 'std_error'], {temp_std});
   
   
    
   f1 = fieldnames(state_stats);
   f2 = fieldnames(temp_struct);
   
   f= [f1; f2];
   
   d1 = struct2cell(state_stats);
   d2 = struct2cell(temp_struct);
   
   d= [d1; d2];
   
   
   state_stats = cell2struct(d,f,1);
    
    
    end
    
    
    
    
    
    
    
    rate_struct = struct;
    
    for k = 1:size(temp_trace.A,2)
        
        
        
    rate_error = cellfun(@(x) ~isempty(strfind(x,['a(' num2str(i) ',' num2str(k)])),temp_errors(2,:));
    rate_error = temp_errors(:,rate_error);  
    
    if isempty(rate_error)
        rate_error = [];
    end
        
    temp_rate_struct =  struct(['rate_' num2str(i) 'to' num2str(k) ], temp_trace.A(i,k), ['rate_'  num2str(i) 'to' num2str(k) '_error'],{rate_error})
        
   f1 = fieldnames(rate_struct);
   f2 = fieldnames(temp_rate_struct);
   
   f= [f1; f2];
   
   d1 = struct2cell(rate_struct);
   d2 = struct2cell(temp_rate_struct);
   
   d= [d1; d2];
   
   
   rate_struct = cell2struct(d,f,1);   
       
        

    

        
    end
    
    
    
    
    
    
    
    
    
    
   f1 = fieldnames(rate_struct);
   f2 = fieldnames(state_stats);
   
   f= [f1; f2];
   
   d1 = struct2cell(rate_struct);
   d2 = struct2cell(state_stats);
   
   d= [d1; d2];
   
   
   state_stats = cell2struct(d,f,1);
   
   
   state_stats.auto_confInt = getfield(temp_trace, 'auto_confInt')
   state_stats.logPx = getfield(temp_trace, 'logPx')
   state_stats.BIC = getfield(temp_trace, 'BIC')
     
     
   state_summary = cat(1, state_summary,{state_stats});

     
     
     
     
     
 end
 
 
 dmi_reshapes = [dmi_reshapes;state_summary]
 
     
 
end
 
 
 

