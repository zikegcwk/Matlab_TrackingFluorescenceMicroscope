function generate_dot_traces(file_name)

temp_data = dlmread(file_name);


i=1;
group_data = cell(i,3);
%Fill in first cell
group_data{i,1}.name = '';
group_data{i,1}.gp_num = NaN;
group_data{i,1}.movie_num = 1;
group_data{i,1}.movie_ser = 1;
group_data{i,1}.trace_num = 1;
group_data{i,1}.spots_in_movie = 1;
group_data{i,1}.position_x = 1;
group_data{i,1}.position_y = 1;
group_data{i,1}.positions = [1 1 1 1];
group_data{i,1}.fps = NaN;
% fill in datta
group_data{i,2} = temp_data;
group_data{i,3} = true(size(temp_data,1),1);

group_data{i,1}.len = size(group_data{i,2},1);
group_data{i,1}.nchannels = size(group_data{i,2},2);

tok = strfind(file_name,'.txt');

save([file_name(1:tok),'traces'], 'group_data')

