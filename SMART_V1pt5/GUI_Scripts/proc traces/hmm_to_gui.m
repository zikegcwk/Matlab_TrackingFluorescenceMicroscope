
function output = hmm_to_gui(hmm_output,fps)


% This converts the hmm output to something easially usalble for graphing
% this this also make the the continusou to discrete time conversion of the
% transition matrix.
% fps show be 0 for no conversion or any other value for real measurments.




    
    
 temp_trace =    hmm_output;
    
 % only plot non two way
 %{output.errorBoundsAuto.var2name}
    
 n_states = size(temp_trace.A,1);
 n_channels = size(temp_trace.fitChannelType,2);
 

 
 temp_errors  = struct2cell(temp_trace.errorBoundsAuto);
 
 %remove joint error bounds
 temp = find(cellfun(@isempty, temp_errors(3,:))==false);
 temp_errors(:,temp) = [];
 
 
 %signal_errors = reshape(temp_trace.E,size(temp_trace.E,1)*size(temp_trace.E,2),1)
 
 %cell2struct(temp_trace.E,{ 'c1' 'c2'},2)
 
 
 state_summary = struct;
 
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
    
    
    % generates differnt string if poisson or gauss
    num_sig_params = size(temp_trace.E{i,k},1);
    switch num_sig_params
        case 1
            temp_struct = struct(['state_' num2str(i) '_c' num2str(k) '_mean'], temp_trace.E{i,k}(1),['state_' num2str(i) '_c' num2str(k) '_mean_error' ], {error_mean});
            
        case 2
            
            temp_struct = struct(['state_' num2str(i) '_c' num2str(k) '_mean'], temp_trace.E{i,k}(1),['state_' num2str(i) '_c' num2str(k) '_mean_error' ], {error_mean},...
                ['state_' num2str(i) '_c' num2str(k) '_std'], temp_trace.E{i,k}(2), ['state_' num2str(i) '_c' num2str(k), '_std_error'], {temp_std});        
    end
    
    
    
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
        
    
    
    % if necessary conver from discrete to ccontinuosus time time
    temp_tmatrix = temp_trace.A;
    if fps ~=0
        
       temp_tmatrix =  DiscToContA(temp_tmatrix,fps);
       if ~isreal(temp_tmatrix)
          display('Discrete To Continuosus Conversion achieved by A*FPS')  
          temp_tmatrix  = temp_trace.A*fps;
       end
       
    end
    
    
    
    temp_rate_struct =  struct(['rate_' num2str(i) 'to' num2str(k) ], temp_tmatrix(i,k), ['rate_'  num2str(i) 'to' num2str(k) '_error'],{rate_error});
        
   f1 = fieldnames(rate_struct);
   f2 = fieldnames(temp_rate_struct);
   
   f= [f1; f2];
   
   d1 = struct2cell(rate_struct);
   d2 = struct2cell(temp_rate_struct);
   
   % convert the confidence intervals to FPS confidence intervlas
   if fps ~=0
   if iscell(d2{2})
       %
       d2{2}{4} = d2{2}{4}*fps;
       %display('Discrete To Continuosus Conversion of confidence intervalse achieved by A*FPS')
   end
   end
   
   
   d= [d1; d2];
   
   
   rate_struct = cell2struct(d,f,1);   
       
        

    

        
    end
    
    
    
    
    
    
    
    
    
   f = fieldnames(state_summary); 
   f1 = fieldnames(rate_struct);
   f2 = fieldnames(state_stats);
   
   f= [f; f1; f2];
   
   d = struct2cell(state_summary);
   d1 = struct2cell(rate_struct);
   d2 = struct2cell(state_stats);
   
   d= [d; d1; d2];
   
   
   state_summary = cell2struct(d,f,1);
   
   

     
     
 %  state_summary = cat(1, state_summary,{state_stats});

     
     
     
     
     
 end
 
 
   state_stats.auto_confInt = getfield(temp_trace, 'auto_confInt');
   state_stats.logPx = getfield(temp_trace, 'logPx');
   state_stats.BIC = getfield(temp_trace, 'BIC');
%   state_stats.P = getfield(temp_trace, 'postFit');
   state_stats.flags = getfield(temp_trace, 'flags');
   

 
 output = state_summary;
     
 

 
 
 

