function output = group_traces(gui_state)

% concatenates mtraces files
%  
% output = concat_mtraces(gui_state)
% gui_state is a structu
% 
% gui_state.uitable1_Data =[movie_start movie_end  group_start group_end]
% example gui_state.uitable1_Data = [ 0 10 1 1;...]  
% example gui_state.uitable1_Data = [ 0 10 1 1;12 15 1 1] 
%
% gui_state.edit1_String = 'save name'
% 
% output = gui_state.edit1_String
%
% will save a .concat file of the concatenated mtraces files in the current
% directionr


%Movies to Concatenate
movie_to_get = gui_state.uitable1_Data;



% Only Sort For Selected Molecules
temp = find(movie_to_get(:,1)==0 & movie_to_get(:,2)==0 & movie_to_get(:,3)==1 & movie_to_get(:,4)==1);
movie_to_get(temp,:)=[];


    no_traces = {};
    final_group_data ={};
    imported_data =[];
    imported_group =[];


for k = 1:size(movie_to_get,1)
    
    movie_numbers = [  movie_to_get(k,1):movie_to_get(k,2) ];
    s_movie = [  movie_to_get(k,3) movie_to_get(k,4) ];
    
    
    % generate names that look like movie  names from the imput movie numbers
    

            
    file_names = generate_file_name(movie_numbers,s_movie, '.traces');
            
     
    number_of_movies = size(file_names,1);
    


    
    
    
    
    for i=1:number_of_movies
        
        
        try
            
            % generate names for the raw and kinetic files
            %new_names = track_filename(core_file_name{i},s_movie);
            
            
            % import raw data if the file exists
            
            
            load(file_names{i,1},'-mat')
            
            final_group_data = cat(1,final_group_data, group_data);
            
            imported_data = [imported_data, file_names{i,2}];
            imported_group = [imported_group, file_names{i,3}];
            
        catch
            
            no_traces = cat(1, no_traces, file_names{i,1});
            
        end
        
        
        
    end
end
    

no_traces    
    

if isempty(final_group_data) == true
   
    errordlg('No Files Found','File Error');
    
    
else



group_data = final_group_data;

% save the concatenated data
%default_name =[''];
save_name =gui_state.edit1_String;
if strmatch(save_name, 'Default Name    movie[X X X ]_group[X X X].traces', 'exact') == true
    
    save_name = ['movie_' , mat2str(unique(imported_data)),'_group[',mat2str(unique(imported_group)),'].traces'];
    %default_name  = save_name;
    % added for manual calling
    gui_state.save_name = save_name;
    
else
    
    temp = findstr(save_name, '.traces') ;
    
    if isempty(temp)==true
        save_name = [save_name,'.traces'];
    end
    
    
end

save(save_name,  'group_data')

save_name

%gui_state.edit1_String = save_name;


end


output =  gui_state;

