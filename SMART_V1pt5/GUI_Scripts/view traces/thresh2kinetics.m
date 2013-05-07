function output1 = thresh2kinetics(thresh_data)


data_2 = thresh_data;

% Need the X values for kinetics
temp_indexed_kinetics=data_2(1:end-1,:);
temp_kinetics =[];
temp_kinetics = [temp_indexed_kinetics(1,:),temp_indexed_kinetics(1,2)];
for i=2:size(temp_indexed_kinetics,1)
temp_kinetics = [temp_kinetics; [temp_indexed_kinetics(i,:) (temp_kinetics((i-1),5)+temp_indexed_kinetics((i),2))]];
end
temp_kinetics = [temp_kinetics, temp_kinetics(:,1).*temp_kinetics(:,4)/-9];

A=[[1:sum(temp_indexed_kinetics(:,2))]', zeros(sum(temp_indexed_kinetics(:,2)),4)];
A(temp_kinetics(:,5),[2 3 4])= temp_kinetics(:,[1  3 4]) ;

low_to_high = find(A(:,2)==3 & A(:,4)==-3) ;
A(low_to_high,5) = 0.1;

high_to_low = find(A(:,2)==0 & A(:,4)==3) ;
A(high_to_low,5) = 0.9;

temp = [];
j=1;
for i=1:size(A,1)-1
    
    if A(i+1,5)== 0.9
        
       temp = [temp, A(i,5)];
       A(j:i,5)=ones(size(temp))'*0.1;
        
       
       temp=[];
       j=i+1;
    elseif A(i+1,5)== 0.1
        
       temp = [temp, A(i,5)];
       A(j:i,5) = ones(size(temp))'*0.9 ;
       
       temp=[];
       j=i+1;
    else
        
       temp = [temp, A(i,5)];
        
    
    end
end


output1 = A;