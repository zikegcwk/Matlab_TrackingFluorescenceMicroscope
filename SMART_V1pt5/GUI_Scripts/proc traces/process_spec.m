function output = process_spec(handles)




%temp_names  =  get(handles.uitable1,'RowName');
%temp_data  =  get(handles.uitable1,'Data');
%table_data = cat(2, temp_names, temp_data);


proc_spec = struct;


% Check to see if HHM is being used
if strmatch('yes', handles.table_spec.user_table1{1,2}, 'exact')


table_data = handles.table_spec.user_table1;

  
params.maxIterEM = table_data{2,2};      %maximum number of iterations for EM to converge
params.threshEMToConverge = table_data{2,4};


params.auto_boundsMeshSize = table_data{4,2};
params.auto_MeshSpacing = table_data{5,2};
params.auto_confInt = table_data{4,4};

params.tryPerms = 1;
params.imposeDetailedBalance = table_data{6,2};

% Values to assign in the future

params.paramsErrorToBoundManual = '';
params.ManualBoundRegions = [];

params.pi = 0; %true hidden state, leave this at 0 when working with real data

params.returnFit = 1;
params.SNRwarnthresh = 1;


params.nStates = table_data{12,2};




temp_table = table_data(9:10,2:5);
temp1 = find(cellfun(@isempty,temp_table(1,:))==false);
params.nChannels = temp1(end);%number of states in model 
params.fitChannelType = temp_table(1,temp1);

signal_error = {};

for i=1:size(temp_table(1,temp1),2)
    
    for t_stat=1:params.nStates
    
    if temp_table{2,i} == 1
        
    signal_error = cat(2,signal_error,[',e(', num2str(t_stat), ',', num2str(i),',1)'])    ;
        
    end
    
    
    if strmatch(temp_table{1,i},'gauss')
    
    signal_error = cat(2,signal_error,[',e(', num2str(t_stat), ',', num2str(i),',2)'])  ;
        
    end
    end
      
end




% Not full implemented but allows the user to defin alterative intial
% codition 
if strmatch('manual', table_data{3,2}, 'exact')
    input('Will load emission matris from cd file overiede_params.mat');
    load override_parms
    
    if isfield(override_parms,'Einitial') == false
        error('Einitial is not in override_parms')
    end
    params.Einitial = E;
    params.trainE = false;
    
    
elseif strmatch('auto', table_data{3,2}, 'exact')
    params.Einitial = table_data{5,2};
    params.trainE = true;   
else
    
    error('Einitial must be set to manula or auto')    
end

       
        
if strmatch('manual', table_data{3,4}, 'exact')
    input('Will load emission matris from cd file overiede_params.mat');
    load override_parms
    
    if isfield(override_parms,'Einitial') == false
        error('Einitial is not in override_parms')
    end
    params.Ainitial = A;
    params.trainA = false;
  
elseif strmatch('auto', table_data{3,4}, 'exact')
    params.Ainitial = table_data{3,4};
    params.trainA = true;
    
else    
    error('Ainitial must be set to manula or auto')   
end




% find position in the matrix that are equla to 0, these are no hops
temp_table = table_data(15:24,2:11);
noHops = [];
temp_str ={};
for i=1:10
    for j=1:10
      if i~=j
        if temp_table{i,j} == 0   
           noHops = [noHops; [i j]]; 
        elseif temp_table{i,j} == 2 
           temp_str = [temp_str ,[',a(',num2str(i),',',num2str(j),')']]; 
        else
        end
        
    end
end
end 


params.noHops = noHops;
params.sameHops = [];
params.discStates = LongerToShorter_DS(cell2mat(table_data(13,2:end)));

% combine transtion matrix and signel error confideince interval dfiions
temp = [temp_str{:} signal_error{:}];

if isempty(temp) == true    
    params.paramsErrorToBoundAuto = '';    
else    
    temp(1) = [];
    params.paramsErrorToBoundAuto = temp;  
end

% combine clustering parameters
% if statment allows the function to be called manually easially.
if isfield(handles,'uitable2')
cov_data =get(handles.uitable2,'Data');
else
cov_data = handles.cov_data;
    
end
cov_string = make_cov_string(cov_data);
params.cov_mats_string = cov_string;

proc_spec.params = params;




end









table_data = handles.table_spec.user_table2;


% Get the frame rate
if isempty(table_data{1,2})==true
    
        errordlg('Enter FPS')
        error('Enter FPS')
end


general_spec.fps =  table_data{1,2};
general_spec.temp = table_data{2,2};

proc_spec.general_spec = general_spec;






if strmatch('yes', table_data{7,2}, 'exact')


fret_spec.x_talk = table_data{8,2};
fret_spec.smooth = table_data{9,2};
%fret_spec.dltg_method = table_data{10,2};
fret_spec.threshold = table_data{10,2};
fret_spec.fret_cutoff(1) = table_data{11,2};
fret_spec.fret_cutoff(2) = table_data{11,3};

proc_spec.fret_spec=fret_spec ;

end









output = proc_spec;
