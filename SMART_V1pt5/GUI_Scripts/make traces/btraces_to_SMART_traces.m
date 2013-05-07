function btraces_to_SMART_traces(filename)



handles.datafile = filename;
n=findstr(handles.datafile,'.');
handles.filename=handles.datafile(1:n-1);


fid=fopen(handles.datafile,'r');


type_of_traces = 1;

% type_of_traces = 1 old chu group .traces example included
% type_of_traces = 2 TJ Ha IDL scripts .traces

switch type_of_traces
    case 1
        
        fid=fopen(handles.datafile,'r');
        len=fread(fid,1,'int32');
        Ntraces=fread(fid,1,'int16');
        Data=fread(fid,[Ntraces+1 len],'int16');
        Data(1,:) = [];
        fclose(fid);
        Ntraces = Ntraces /2 ;
        
    case 2
        
        len=fread(fid,1,'int32');   %reads the first 32 bit integer as the number of frames
        %%Ntraces=fread(fid,1,'int16');   %reads the second 16 bit integer as the number of traces
        %%bernie changed to 32 to try to read tra file
        two_Ntraces=fread(fid,1,'int16');     %the tra file containts the number of fps
        Ntraces = two_Ntraces/2;
        
        Data=fread(fid,[Ntraces*2 len ],'int16');    %reads in the data based on these two numbers, i hope i got this right
        fclose(fid);    %closes the file
                
end



group_data = cell(Ntraces,3);
i=1;
for j=1:2:Ntraces*2

%Fill in first cell
group_data{i,1}.name = handles.datafile;
group_data{i,1}.gp_num = NaN;
group_data{i,1}.movie_num = 1;
group_data{i,1}.movie_ser = 1;
group_data{i,1}.trace_num = i;
group_data{i,1}.spots_in_movie = Ntraces;
group_data{i,1}.position_x = 1;
group_data{i,1}.position_y = i;

% Not necessary but lest molecule plotted at times better in interface
temp_ones = ones(Ntraces,4); 
temp_ones(:,2)=1:Ntraces;
group_data{i,1}.positions = ones(Ntraces,4);
group_data{i,1}.positions = temp_ones;
group_data{i,1}.fps = NaN;

% fill in datta
temp_data = Data(j:(j+1),:)';
group_data{i,2} = int16(temp_data);
%group_data{i,3} = false(size(temp_data,1),1);
group_data{i,3} = [];

group_data{i,1}.len = size(group_data{i,2},1);
group_data{i,1}.nchannels = size(group_data{i,2},2);


i = i+1;
end


save(['SMART_' filename], 'group_data')





