function sm_analyze(handles)





% check if an FPS was entered

%question_fps = get(handles.uitable1, 'Data');
proc_data ={};

error_summary ={};


proc_spec = process_spec(handles);



%if isfield(handles,'group_data') == false
    
%    errordlg('Load Data')
    
%end







for i=1:size(handles.group_data,1)
    
    tStart = tic;
    temp_str = [ 'currently processing ' num2str(i) ' of ' num2str(size(handles.group_data,1)) '\n'];

    fprintf(1,temp_str)
    
    
    temp_summary = initialize_temp_summary;

    
    try
        
        temp_trace = handles.group_data{i,2};
        temp_trace_select = handles.group_data{i,3};
        
        if isempty(temp_trace_select)
            
            temp_trace = [];
            
        else
            
            %sum(double(temp_trace_select))
            temp_trace = double(temp_trace(temp_trace_select,:));
            %size(temp_trace,1)

            
            temp_summary.proc_spec = proc_spec;
            temp_summary.trace_info = handles.group_data{i,1};
            temp_summary.trace = temp_trace;
            

            % calculate the HHM Modeld
            if isfield(proc_spec, 'params') == true
                
                params = proc_spec.params;
                params.data = temp_trace;     
                params.plotPFits = false;
                params.showProgressBar = false;
                params.pause = false;
                hmm_output = TrainPostDec_(params);   
                
                
            
  
                
                
                % append the covariance matrix
                if ~isempty(params.cov_mats_string)
                hmm_output = AppendCovMatsToHMMFitOutput(hmm_output,params.data,params.cov_mats_string );
                end
                %A_disc = ContToDiscA(hmm_output.A,handles.table_spec.user_table2{1,2});
                %hmm_output.A_disc = A_disc;               
                hmm_output.P = getfield(hmm_output, 'postFit');
                hmm_output = rmfield(hmm_output, 'postFit');              
                hmm_output.reshape = hmm_to_gui(hmm_output,0);
                temp_summary.hmm_output = hmm_output;
                
                
                
            end
            
            
            if isfield(proc_spec, 'fret_spec') == true
                
                fret_spec =  proc_spec.fret_spec;
                fret_spec.temp = proc_spec.general_spec.temp;
                
                [mod_temp_trace fret_summary]  = fret_analysis(temp_trace,fret_spec);
                
                temp_summary.mod_temp_trace = mod_temp_trace;
                temp_summary.fret_summary = fret_summary;
                
                
                [thresh_kinetics] = imol_kinetics(temp_summary.mod_temp_trace,proc_spec.fret_spec);
                temp_summary.threshold_summary = thresh_kinetics;
            end
            
            final_summary = final_data_format(temp_summary);
            final_summary{1}(4) = 1; % if trace got thorugh without major errors
            
            proc_data = cat(1, proc_data, final_summary);
            
        end

 catch
     
    %rethrow(lasterror)
    temp_str = [ 'Error on trace ' num2str(i) ' of ' num2str(size(handles.group_data,1))];
    temp_str
  
    %proc_data = cat(1, proc_data, cell(1,7));
    
error_summary = cat(1, error_summary, temp_trace);

final_summary = final_data_format(temp_summary);
final_summary{1}(4) = 0; % zero when errors occure
proc_data = cat(1, proc_data, final_summary);
     
 end




% only print if the blok too time to run 
% it take time if there was a trace there
if round(toc(tStart)*10)/10> 0.01
temp_str = [ 'The last trace took ' num2str(round(toc(tStart)*10)/10) ' [sec] to process\n\n'];
fprintf(1,temp_str)
end

end


temp = findstr(handles.group_name,'.traces');
default_name = [handles.group_name(1:temp),'proc'];
save(default_name, 'proc_data');








