
function averaged_data = average_and_threshold(finalrawdata,average_method,two_state,threshold_method,threshold_range,x_talk)




% find the position of molecule in the data files
molecules_start = find(finalrawdata(:,1)==-9   & finalrawdata(:,2)==-9);
molecules_end   = find(finalrawdata(:,1)==9   & finalrawdata(:,2)==9 & finalrawdata(:,3)==9 & finalrawdata(:,4)==9);

new_raw_data =[];
new_kinetics =[];

for i=1:size(molecules_start,1);
    
    %extract a temp trace
    temptrace =  finalrawdata(molecules_start(i):(molecules_end(i)-1),:);
    
    temp_header = temptrace(1:10,:);
    temptrace(1:10,:) = [];


    %smooth the using an averag
    temptrace(:,1) = smooth(temptrace(:,1),average_method);
    temptrace(:,2) = smooth(temptrace(:,2),average_method);
    temptrace(:,4) = smooth(temptrace(:,3),average_method);
    temptrace(:,3) =  (temptrace(:,1)-x_talk*temptrace(:,2))./(temptrace(:,2)+temptrace(:,1)-x_talk*temptrace(:,2));

    
    % threshhold the data to extract the kinetic parameters
 a = find(temptrace(:,3)<threshold_range(1));
 a = [0*ones(size(a)),a,temptrace(a ,3)];
 
 b = find(temptrace(:,3)>=threshold_range(1) & temptrace(:,3)<= threshold_range(2));
 b = [1*ones(size(b)),b,temptrace(b ,3)];
 
 c = find(temptrace(:,3)>threshold_range(2));
 c = [3*ones(size(c)),c,temptrace(c ,3)];

 %generate a new kinetic file
newtrace = [a;b;c];
newtrace =  sortrows(newtrace,2);

kinetics = [];
%bin the dwells
j = 1;
while j < (size(newtrace,1));

    tempdwell = [];
    
    while newtrace(j,1)==newtrace((j+1),1)&& j < (size(newtrace,1)-1)
    
        tempdwell = [tempdwell;newtrace(j,:)];
        j=j+1;
    end
    if j == (size(newtrace,1)-1)
        
        tempdwell =  [tempdwell; newtrace(end,:)];
        dwell =  [tempdwell(1,1), size(tempdwell,1),0,0];
        kinetics = [kinetics;dwell];
        break
    end
   
    if     size(tempdwell) ==[0 0]
      
        tempdwell=[];
      % tempdwell = newtrace(j,:);
      % j=j+1;
    end
    
       
    tempdwell = [tempdwell;newtrace(j,:)];
    dwell =  [tempdwell(1,1), size(tempdwell,1),0,0];
    kinetics = [kinetics;dwell];
    j=j+1;
end
   
sum(kinetics(:,2))
size(newtrace,1)

% define for a particular dwell where it was
for k =1:size(kinetics,1)
    
    
 
   if k==1

       kinetics(k,3)= -5;
       kinetics(k,4)= 3;
   
   elseif k==size(kinetics,1)
    
       
       kinetics(k,3)= kinetics((k-1),1);
       if kinetics(k,1)==0
          kinetics(k,4)=3;
       else
           kinetics(k,4)=-3;
       end
   else

    %kinetics(k,3)= kinetics((k-1),1);
    %sum(kinetics(:,2))
    %size(temptrace,1)
    
    
    % Potential Folding Transitions
    if kinetics(k,1)==0 && kinetics(k+1,1)==1;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=1;
    elseif kinetics(k,1)==0 && kinetics(k+1,1)==3;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=3;
    elseif kinetics(k,1)==1 && kinetics(k+1,1)==3;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=3;   
            
    % Potential Unfolding Transitions        
    elseif kinetics(k,1)==3 && kinetics(k+1,1)==1;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=1;   
    elseif kinetics(k,1)==3 && kinetics(k+1,1)==0;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=0;             
    else
            %kinetics(k,1)==1 && kinetics(k+1,1)==0;
            kinetics(k,3)=kinetics(k-1,1);
            kinetics(k,4)=0;        
            
    end
   end
end

% put kinetic numbering back to the 'normal' hard to used scheme...
if two_state == true;

   positions_to_update =  find(kinetics(1:end,1)==3);
   kinetics(positions_to_update,4)=-3;
    
end

sum(kinetics(:,2))
size(temptrace,1)



% concatenate the data into the origional format
new_raw_data =[new_raw_data; temp_header;temptrace;[9,9,9,9]];
new_kinetics =[new_kinetics; temp_header;kinetics; [9,9,9,9]];

%[size(new_raw_data(11:end-1,2),1),sum(new_kinetics(11:end-1,2))]

end
 

averaged_data = {new_raw_data,new_kinetics};
