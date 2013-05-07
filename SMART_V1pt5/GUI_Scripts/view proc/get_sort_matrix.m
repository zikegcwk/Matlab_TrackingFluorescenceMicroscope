
function output = get_sort_matrix(imol_summary)

selected ={};
to_sort =[];
for i=1:size(imol_summary,1)
    
sort_dltg = imol_summary{i,5}.thresh;
sort_snr  = imol_summary{i,5}.ser_snr;
sort_total_i = imol_summary{i,5}.mean_total_i;

to_sort = [ to_sort; [sort_dltg sort_snr sort_total_i]];


selected = cat(1,selected,{false});

end

temp = cell2mat(imol_summary(:,1));
temp = temp(:,[3 2 10]);
to_sort = cat(2, temp, to_sort);



%selected = logical(ones(size(imol_summary,1),1));


% Just a Reminder 
table_name_settings =  { 'Movie' 'Group' 'Trace Length' 'dltg' 'STN' 'Total I'};

output = {to_sort table_name_settings selected};

