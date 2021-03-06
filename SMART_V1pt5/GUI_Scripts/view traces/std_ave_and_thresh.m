
function [output1 output2] = std_ave_and_thresh(raw_data,ave_param)




%extract a temp trace
temps_spce = raw_data{1};
temptrace  =  raw_data{2};



%smooth the using the specified averaging method

switch ave_param.process_description
    case 1

temptrace(:,1) = smooth(temptrace(:,1),ave_param.table{15,2});
temptrace(:,2) = smooth(temptrace(:,2),ave_param.table{15,2});
    case 2
    
haransspec.window = ave_param.table{15,2};
haransspec.p = ave_param.table{16,2};
haransspec.m = ave_param.table{17,2};

    
temptrace = nl_filter_harans(temptrace,haransspec);
    
    case 3 % not taking as an imput manually if desire

temptrace(:,1) = smooth(temptrace(:,1),1);
temptrace(:,2) = smooth(temptrace(:,2),1);

        
        
end


% calculate fret
x_talk = ave_param.table{1,2};
tempfret =  (temptrace(:,2)-x_talk*temptrace(:,1))./(temptrace(:,2)+temptrace(:,1)-x_talk*temptrace(:,1));


anomolous = find(tempfret < -0.3);
tempfret(anomolous) = -0.3;
anomolous = find(tempfret > 1.3);
tempfret(anomolous) = 1.3;


temptrace(:,3) = tempfret;
    

if ave_param.process_description == 1 || ave_param.process_description == 2
switch ave_param.thresh_method
    
    case 1
        
    case 2
        
        % The historic Chu version > gui_tracep
        th_param(1)= ave_param.table{13,2};
        th_param(2)= ave_param.table{14,2};   
        thresholded = threshold_std(temptrace,th_param);
        
        
    case 3
        
        % Max Version work in progress
        th_param(1)= ave_param.table{13,2};
        th_param(2)= ave_param.table{14,2};
        th_param(3)= ave_param.table{12,2};
        thresholded = threshold_max(temptrace,th_param);
        

        
end
else
        thresholded =[];
    
end
 

output1  = temptrace;
output2  = thresholded;
