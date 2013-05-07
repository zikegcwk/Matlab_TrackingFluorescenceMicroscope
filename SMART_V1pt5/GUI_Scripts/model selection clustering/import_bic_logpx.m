function output = import_bic_logpx( data )
% Function take in standard .proc files, where models 




% check that everything is the same size...

check_1 = [];
check_2 = [];

try

for i=1:size(data,2);
    
    tcheck_1 = [];
    tcheck_2 = [];
    
    for j=1:size(data{i},1);
        
    tcheck_1 = [tcheck_1;  data{i}{j,5}.position_x];
    tcheck_2 = [tcheck_2;  data{i}{j,5}.position_y];     
     
    end
    
    check_1 = [check_1 tcheck_1];
    check_2 = [check_2 tcheck_2];
    
    
end

catch

    fprintf('.proc files do not have the same number of rows \n')
    fprintf('each row must correspond to the same molecule  \n')
    
end

check_sum = [];
for i=1:size(data,2);

% Check that everything adds up to zero...
check_sum = [check_sum sum(check_1(:,1) - check_1(:,i))];
check_sum = [check_sum sum(check_2(:,1) - check_2(:,i))];   
       
end

check_sum = sum(check_sum);

if check_sum ~=0  
error('molecule are miss alligned') 
end


% coppy get the BIC & logPx




bic = [];
logpx = [];
length = [];

for i=1:size(data,2);
    
    tbic = [];
    tlogpx = [];
    tlength = [];
    
    for j=1:size(data{i},1);
        
        if isempty( data{i}{j,7}.BIC)
            data{i}{j,7}.BIC = NaN;
        end
        
        if isempty( data{i}{j,7}.logPx)
            data{i}{j,7}.logPx = NaN;
        end
        
        tbic = [tbic;  data{i}{j,7}.BIC];
        tlogpx = [tlogpx;  data{i}{j,7}.logPx];
        
        
        tlength = [tlength; size(data{i}{j,7}.P,2)];
        
    end
    
    bic = [bic tbic];
    logpx = [logpx tlogpx];
    length = [length tlength];
    
    
end



output.bic = bic;
output.logpx = logpx;
output.length = length;


