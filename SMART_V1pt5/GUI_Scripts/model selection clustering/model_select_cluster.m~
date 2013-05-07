




% Load data to make BIC plot


data = {};
data_name = {};

reply = 'y';
while strcmpi(reply, 'y')
[load_name load_path] = uigetfile({'*.proc*','Choose a (.proc) file'});
% get rid of an error
if isstr(load_path) ==true
    cd(load_path);
    load(load_name,'-mat')
    
end    

data_name = cat(2,data_name,{load_name});
data = cat(2,data,{proc_data(:,[5 7])});


reply = input('Do you want to load more files? Y/N [Y]: ', 's');


end



% check that everything is the same size...

check_1 = [];
check_2 = [];

for i=1:size(data,2);
    
    tcheck_1 = [];
    tcheck_2 = [];
    
    for j=1:size(data{i},1);
        
    tcheck_1 = [tcheck_1;  data{i}{j,1}.accept_positions_x];
    tcheck_2 = [tcheck_2;  data{i}{j,1}.accept_positions_y];     
     
    end
    
    check_1 = [check_1 tcheck_1];
    check_2 = [check_2 tcheck_2];
    
    
end


% coppy get the BIC & logPx




bic = [];
logpx = [];

for i=1:size(data,2);
    
    tbic = [];
    tlogpx = [];
    
    for j=1:size(data{i},1);
        
    tbic = [tbic;  data{i}{j,2}.BIC];
    tlogpx = [tlogpx;  data{i}{j,2}.logPx];     
     
    end
    
    bic = [bic tbic];
    logpx = [logpx tlogpx];
    
    
end





figure
ax(1) = axes;


to_plot = bic;


for i=1:size(bic,1)
p1 = plot(ax(1),1:size(to_plot,2),to_plot(i,:));
set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
hold(ax(1),'on')
end

