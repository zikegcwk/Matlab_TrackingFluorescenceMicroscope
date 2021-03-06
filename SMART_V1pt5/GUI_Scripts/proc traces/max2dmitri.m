function [output1 output2] = max2dmitri( table_data, temp_trace )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here




ave_gui_p.table = {
    'Cross Talk'           [str2num(table_data.table{1,2})]
    'Sequential Movies'    [str2num(table_data.table{2,2})]
    'Temp [k]'             [str2num(table_data.table{3,2})]
    'FPS'                  [str2num(table_data.table{4,2})]
    'dltG Method'          [str2num(table_data.table{5,2})]
    'Noise Cutoff'         [str2num(table_data.table{6,2})]
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []};
        
        
ave_gui_p.thresh_method = 'Not Applicable';
ave_gui_p.process_description = table_data.process_description;






% specify fit type for each channel, red then green
fitChannelType = table_data.table(10,2:end);
temp = cellfun('isempty',fitChannelType);
fitChannelType(temp)=[];
params.fitChannelType = fitChannelType; %each channel must be 'exp' or 'gauss'



params.nChannels = size(fitChannelType,2); %number of channels, red is 1, green is 2



params.nStates = str2num(table_data.table{9,2}); %number of states in model 

% set Ainitial = 'auto', Einitial 'auto' or set them to a particular value
params.Ainitial = table_data.table{11,2}; %could have A = [0.98 0.02 ; 0.01 0.99]
params.Einitial = table_data.table{13,2}; %could have E = cell([2 2]); E{2,1} = [5 ; 3] means state 2, channel 1 (red) has mean 5, stdev 3, etc



% specify data
params.data = temp_trace{2}; %x is T by 2, column 1 is acceptor (red), column 2 is donor (green)
                 %x can have any number of channels, one per column
params.pi = 0; %true hidden state, leave this at 0 when working with real data

% paramters related to training

params.trainA = str2num(table_data.table{12,2}); %set to false if want to never change initial guess for A
params.trainE = str2num(table_data.table{14,2}); %set to false if want to never change initial guess for E

params.maxIterEM = str2num(table_data.table{15,2});      %maximum number of iterations for EM to converge
params.threshEMToConverge = str2num(table_data.table{16,2});   %likelihood threshold for EM to converge, don't make lower than this to avoid strange behavior

% parameters related to parameter error bounds estimation

%these strings are in the format
%(a(i1,i2),a(i3,i4)),e(i5,i6,i7),(e(i8,i9,i10),a(i11,i12)),a(i13,ai14), ...
%letters that are grouped like (p(),q()) are given bounds jointly on a 2D plot
%letters that are grouped like ...,p(),... are given bound on a 1D plot
%e(n,c,p) = value of parameter #p of channel c (1 is red, 2 is green) in
%hidden state n (2 is high, 1 is low)
%p = 1 corresponds to mean, p = 2 corresponds to stdev
%a(r,c) = value of transition rate from hidden state r to hidden state c

%params.paramsErrorToBoundAuto = ['(' table_data.table{17,2} ',' table_data.table{17,3} '),' table_data.table{17,4} ',' table_data.table{17,5}]; %a's are plotted together on 2-d plot, e's are plotted on 1-d plots
params.paramsErrorToBoundAuto = table_data.table{17,2};
params.paramsErrorToBoundManual = table_data.table{18,2};%set to empty for now, but is of same format as paramsErrorToBoundAuto
                                      %could try 'a(1,2),(e(2,1,1),e(2,2,1))';
params.auto_boundsMeshSize = str2num(table_data.table{19,2});  %how finely do we want to explore param region for confidence bounds
                                 %computation times scales as the square of this number 
                                 %must be at least 3 to later run ShowErrorBounds(output,'auto') 
params.auto_MeshSpacing =table_data.table{20,2}; %can be 'square' for equally spaced rectangles  
                                  %only affects the parameters that are automatically estimated
params.auto_confInt = str2num(table_data.table{21,2});       %within what confidence interval do we want to explore parameters

% the number of entries here must correspond to number of parameters in paramsErrorToBoundManual string
%params.ManualBoundRegions = str2num(table_data.table{22,2});
%params.ManualBoundRegions{1} = table_data.table{22,2};
%params.ManualBoundRegions{2} = table_data.table{22,3};
 
 
 params.ManualBoundRegions{1} = {[linspace(str2num(table_data.table{22,2}),str2num(table_data.table{22,3}),str2num(table_data.table{22,4}))],...
     [linspace(str2num(table_data.table{23,2}),str2num(table_data.table{23,3}),str2num(table_data.table{23,4}))]};
params.ManualBoundRegions{2} = [linspace(str2num(table_data.table{24,2}),str2num(table_data.table{24,3}),str2num(table_data.table{24,4}))];
 
 
 

% other parameters
params.plotPFits = str2num(table_data.table{25,2});     %true if want to plot fit as EM computation progresses, false otherwise
params.showProgressBar = false;  
params.pause = false;


output1 = params;
output2 = ave_gui_p;



