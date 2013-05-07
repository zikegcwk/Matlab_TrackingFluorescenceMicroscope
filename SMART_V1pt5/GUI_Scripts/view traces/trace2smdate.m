function averagin_method = trace2smdate(table_data)


% Just wrapper to get function that are called by trace_viewer and sm_data
% gui to work together



averagin_method.process_description = 1;
averagin_method.thresh_method = 2;
averagin_method.table = { 
    'Cross Talk'           [table_data{1,2}]
    'Sequential Movies'    [     1]
    'Temp [k]'             [table_data{2,2}]
    'FPS'                  [table_data{3,2}]
    'dltG Method'          [1]
    'Noise Cutoff'         [table_data{4,2}]
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
    'Number of States'     [     2]
    'Lower Threshold'      [table_data{6,2}]
    'Upper Threshold'      [table_data{6,2}]
    'Averaging Window'     [table_data{5,2}]
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
                     ''          []
};





averagin_method = averagin_method;