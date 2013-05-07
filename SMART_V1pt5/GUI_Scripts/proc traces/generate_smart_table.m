function output = generate_smart_table(handles,tableuse)


% genearte summary tables for SMART intervase the table tenerate will
% the table output will depend on the tableuse number this was made to
% replace 
%
% active_view_proc(handles) and get_unique_identifiers(handles.proc_data)
%
% table use = 1 will generate an active_view_proc(handles) output
% table use = 2 will generate an get_unique_identifiers(handles.proc_data) output
% table use = 3 is same as 1 but can be called outside the gui
%


% plot_types = { ...
%     ''
%     'movie_num'
%     'movie_ser'
%     'trace_num'
%     'spots_in_movie'
%     'accept_positions_x'
%     'accept_positions_y'
%     'fps'
%     'trace_length'
%     'dltg'
%     'mean_total_i'
%     'snr'
%     'logPx'
%     'BIC'};


plot_types = { ...
    ''
    'movie_num'
    'movie_ser'
    'trace_num'
    'spots_in_movie'
    'position_x'
    'position_y'
    'fps'
    'len'
    'nchannels'
    'dltg'
    'mean_total_i'
    'snr'
    'logPx'
    'BIC'};



error_names = {};
error_data ={};

toplot_names = {};
toplot_data =[];



switch tableuse
    case 1
        
        data = handles.selected_data;
        
        
    case 2
        
        data = handles.proc_data;
        
        % get ride of molecule that did no process correctly...
        errors_in_table = cell2mat(data(:,1));
        errors_in_table(:,1:3) = [];
        errors_in_table = logical(errors_in_table);
        data = data(errors_in_table,:);
        
                
        error_locations = find(errors_in_table==false);
        proc_data = handles.proc_data(error_locations,:); % save problem data for user to insped
        save problem_data.proc proc_data error_locations
        disp([num2str(size(error_locations,1)),' traces did not load becase there was a procssing error'])
        disp('See the problem_data.proc file in the current directory for problem traces' )
        
        
  
    case 3
        
        data = handles.selected_data;
        
end



for i=1:size(data,1)

   

if ~isempty(data{i,7}.A)
    

    try

        
    % tables are generated twice ... for sorting considers only continuous
    % time...
    if tableuse == 2   
    reshape = data{i,7}.reshape ;
    else
    
    % if user chooses conver form discrete to continuous time
    tfps = 0;
    
    % use isfiels so can call the function outside of smart.
    if isfield(handles, 'checkbox3')
        
    if get(handles.checkbox3,'Value') == true
     tfps = data{i,5}.fps;   
    end
    
    
    
    
    
    else
        
    if strcmp(handles.fps,'true')
     tfps = data{i,5}.fps;   
    end   
     
     
     
    end
    reshape = hmm_to_gui(data{i,7},tfps);   
    display('Discrete To Continuosus Conversion of confidence intervalse achieved by A*FPS')
    end
    
    
    temp_HMMnames = fieldnames(reshape);
    temp_HMMdata = struct2cell(reshape);
    
    % get rid of things that were not calculated
    temp = cellfun(@isempty, temp_HMMdata);
    temp_HMMdata(temp) = [];
    temp_HMMnames(temp) = [];

    % cells are error bounds grou
    temp = cellfun(@iscell, temp_HMMdata);
    % data with error bounds
    temp_error_data = temp_HMMdata(temp);
    temp_error_names = temp_HMMnames(temp);
    % all other data
    temp_HMMdata(temp) = [];
    temp_HMMnames(temp) = []; 

    %hmm_names = temp_names';
    %hmm_to_plot =cell2mat(temp_data)';
    

    
    extra_error_data = [];
    for k=1:size(temp_error_data,1)
  
    temp = [temp_error_data{k}{4} temp_error_data{k}{6}];
    extra_error_data = [ extra_error_data {temp}];

    end
   

    catch
  
    temp_str = [ 'Trace' num2str(i) ' has a differn number of fields in the HMM Part \n\n'];
    fprintf(1,temp_str)
    rethrow(err)  
    
    end   
end





% get non HMM data
temp_tsummary = NaN(1,size(plot_types,1));

for j=1:size(plot_types,1)
    
    try

        for k=4:7
            
            if isfield(data{i,k},plot_types{j,1})
                  
                if isnan(temp_tsummary(j))
                    
                    if ~isempty(getfield(data{i,k},plot_types{j,1}))
                        temp_tsummary(j) = getfield(data{i,k},plot_types{j,1});
                    end
                   
                else
                    error('multiple fields of the same name')
                end
            end
        end
        
    catch
        
        temp_str = [ 'Trace' num2str(i) 'Has multiple fields of the same name \n\n'];
        
        fprintf(1,temp_str)
        rethrow(err)      
    end
end


try


% concatentat all data   
error_names = [error_names; temp_error_names'];
error_data = [error_data; extra_error_data];


toplot_names = [toplot_names; [plot_types' temp_HMMnames']];
toplot_data = [toplot_data; [temp_tsummary cell2mat(temp_HMMdata)']];
    


catch
    
disp(['Fields in Trace ' num2str(i) ' do no match field of first trace'])
    
    
end


end



molsel = size(toplot_data,1);

forsort_data = toplot_data(:,2:end);
forsort_names = toplot_names(1,2:end);
forsort_logical = mat2cell(false(molsel,1),ones(1,molsel),1);



foractive_data = [mat2cell(toplot_data,ones(1,molsel),ones(size(toplot_data,2),1)) error_data];
foractive_names = [toplot_names(1,:)'; error_names(1,:)'];






switch tableuse
    case 1
        
        display_plot_types = cellfun(@(x) regexprep(x,'_',' ') , foractive_names,'uniformoutput',false);
        
        set(handles.popupmenu2,'String' ,{'x axis' display_plot_types{2:end}});
        set(handles.popupmenu3,'String' ,{'y axis' display_plot_types{2:end}});
        temp_output = {foractive_data foractive_names};
        
        
    case 2
        

        temp_output = {forsort_data forsort_names forsort_logical data};
        
    case 3
        
        
        display_plot_types = cellfun(@(x) regexprep(x,'_',' ') , foractive_names,'uniformoutput',false);
        temp_output = {foractive_data foractive_names};
      
       
end
   
   
    


 output = temp_output;




