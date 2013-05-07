function output =  get_unique_identifiers(imol_summary)


% this function identifies and calculates usefull parameters for sorting
% molecules



% sort_names  = {'gp_num'
%     'movie_num'
%     'movie_ser'
%     'fps'
%     'dltg'
%     'mean_total_i'
%     'logPx'
%     'BIC'
%     'C1_mean_diff'
%     'C2_mean_diff'
%     'SNR_1'};

sort_names  = {
    'movie_num'
    'movie_ser'
    'trace_num'
    'fps'
    'logPx'
    'dltg'
    'mean_total_i'    
    };









selected ={};
to_sort =[];


for i=1:size(imol_summary,1)
    
    
    
    temp_to_sort = NaN(size(sort_names))';
    for j=1:size(sort_names,1)
        
        
        if isfield(imol_summary{i,5}, sort_names{j})
         
             if ~isempty(getfield(imol_summary{i,5}, sort_names{j}))
            temp_to_sort(j) =  getfield(imol_summary{i,5}, sort_names{j});
            end
                
        elseif isfield(imol_summary{i,6}, sort_names{j})
            
            if ~isempty(getfield(imol_summary{i,6}, sort_names{j}))
            temp_to_sort(j) =  getfield(imol_summary{i,6}, sort_names{j});
            end
            
        elseif isfield(imol_summary{i,7}, sort_names{j})
            
                
             if ~isempty(getfield(imol_summary{i,7}, sort_names{j}))
            temp_to_sort(j) =  getfield(imol_summary{i,7}, sort_names{j});
             end
%         elseif isfield(imol_summary{i,7}, sort_names{j})
%             
%             temp_to_sort = [temp_to_sort , getfield(imol_summary{i,1}, sort_names{j})];
            
%         elseif strcmp('C1_mean_diff', sort_names{j})     
%             temp = abs(imol_summary{i,7}.E{1,1}(1) - imol_summary{i,7}.E{2,1}(1));
%             temp_to_sort = [temp_to_sort , temp];
%         elseif strcmp('C2_mean_diff', sort_names{j}) 
%             temp = abs(imol_summary{i,7}.E{1,2}(1) - imol_summary{i,7}.E{2,2}(1));
%             temp_to_sort = [temp_to_sort , temp];
%          
%         elseif strcmp('SNR_1', sort_names{j})
%    
%             temp_to_sort = [temp_to_sort , imol_summary{i,7}.SNRMat(1,2)];

        else
            
        end

       
    
    
        
    end
        
to_sort = [ to_sort;  temp_to_sort]  ;
    

selected = cat(1,selected,{false});
    
    
end


%table_name_settings =  fieldnames(imol_summary{1,1})';
table_name_settings =  sort_names';


output = {to_sort table_name_settings selected};