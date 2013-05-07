function output = make_cov_string(data)

% Make the covarances string for clusteriong
cov_string = [];
for i=1:size(data,1)
    
    temp_str = [];
    if ~strcmp(data{i,1},'N/A')
       for j=1:3
           if ~strcmp(data{i,j},'N/A')
           temp_str = [temp_str,data{i,j}];    
           end
       end 
    end
    
    if ~isempty(temp_str)
    temp_str = ['(' temp_str '),'];
    cov_string = [ cov_string temp_str];
    end
 
end

if isempty(cov_string)
cov_string = '';
else
cov_string(end)=[];
end
output = cov_string;




