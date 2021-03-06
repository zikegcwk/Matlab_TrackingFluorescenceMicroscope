function output = final_data_format(temp_summary)



    
    
    clean_up_struct = { 'bytes', 'isdir' , 'datenum'};
    temp = temp_summary.trace_info;
    
    
    unique_identifiers = struct;
    
    for i=1:size(clean_up_struct,2)
    try
        
        temp = rmfield(temp,clean_up_struct(i));
        
     
        
    catch
        
    end
    end
    
    meta_struct = temp;
    
    
    meta_struct.fps = temp_summary.proc_spec.general_spec.fps;
    
    if isfield(temp_summary.proc_spec, 'fret_spec')
    
    meta_struct.fres_spec = temp_summary.proc_spec.fret_spec;    
    end
    
    if isfield(temp_summary.proc_spec,'params') == true
    meta_struct.params = temp_summary.proc_spec.params;
    end
    
    
    % Need To Manually Check for fields make sure I get a uniform output
    
    
    fret_trace = [];
    fret_summary = struct;
    threshold = struct;
    hmm_summary = struct;
    
    
    
    unique_identifiers.gp_num = meta_struct.gp_num ;
    unique_identifiers.movie_num   =  meta_struct.movie_num;
    unique_identifiers.movie_ser = meta_struct.movie_ser;
    
    
    if isfield(meta_struct,'accept_positions')
    
    unique_identifiers.position_x = meta_struct.accept_positions(1);
    unique_identifiers.position_y = meta_struct.accept_positions(2);
    
    
    end
    
    unique_identifiers.fps = meta_struct.fps;
    
    
    if isfield(temp_summary, 'mod_temp_trace')==true && isfield(temp_summary, 'fret_summary')==true
        
        fret_trace = temp_summary.mod_temp_trace;
        fret_summary = temp_summary.fret_summary;
        
        unique_identifiers.dltg = fret_summary.dltg;
        unique_identifiers.mean_total_i = fret_summary.mean_total_i;
        unique_identifiers.snr = fret_summary.snr;
        
        
        
        
    end
    
    
    
    if isfield(temp_summary, 'threshold_summary')==true 
        

         threshold = temp_summary.threshold_summary;
        
    end
    
    
    if isfield(temp_summary, 'hmm_output')==true 
        

         hmm_summary = temp_summary.hmm_output;
         unique_identifiers.logPx = hmm_summary.logPx;
         unique_identifiers.BIC = hmm_summary.BIC;
         unique_identifiers.mean_mean_SNRMat = mean(mean(hmm_summary.SNRMat));

         
        
    end
    
  %temp_data = struct2array(unique_identifiers);
  %temp_data = [temp_data , unique_identifiers];
    
  %unique_identifers = [groupnumber,movie_ser,movidnumber,tracenumber,...
   % acceptorpositionx,acceptorpositiony,donorpositionx,donorpositiony,fps,tracelength];  
    
  
    
    
  %final_summary = { unique_identifiers temp_summary.trace fret_trace fret_summary meta_struct threshold hmm_summary};
    
  
  

  threshold.snr = fret_summary.snr;
  threshold.mean_total_i = fret_summary.mean_total_i;
  threshold.dltg =  fret_summary.dltg;
  unique_serila = [meta_struct.movie_num meta_struct.movie_ser meta_struct.trace_num NaN]; 
  
  
  final_summary = { unique_serila temp_summary.trace fret_trace {} meta_struct threshold hmm_summary};
 
    

    
    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    



output = final_summary;



