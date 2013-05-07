function sorted = molecule_2_analyze(data,concatenate,slop, grouping,dltag,tracelength,signal_to_noise,...
    mean_intensity,new_id,signal_to_noise_method,movie_order)

sorted=data; %SERGEY temp solution
end
% sorted={};
% 
% 
% for i=1:size(grouping,1);
%    
%     tempgroup=grouping{i};
%     
%     for j=2:size(tempgroup,2)   
%     temp_sorted={};   
%     positions = find([data{:,1}]==tempgroup(1) &...
%         [data{:,3}]==tempgroup(j));
%     
% %        positions = find([data{:,1}]==tempgroup(1) &...
% %         [data{:,3}]==tempgroup(j) &...
% %         [data{:,2}]==movie_order);
% %     
%     
%     temp_sorted = data(positions,:);
%     sorted = cat(1, sorted, temp_sorted);
%     end
% end
% 
% sorted_p ={};
% for i=1:size(movie_order,2);
%    
%     
%     temp_sorted={};   
%     
%     positions = find([sorted{:,2}]==movie_order(i));  
%     
%     temp_sorted = data(positions,:);
%     sorted_p = cat(1, sorted_p, temp_sorted);
% 
% end
% 
% sorted={};
% sorted=sorted_p;
% 
% 
% 
% 
% 
% 
% % eliminatemolecules = find(sorted(:,sortparameter)<=3.5);
% % sorted(eliminatemolecules,:)=[];
% a=sorted;
%  [[a{:,1}]' [a{:,3}]' ]
% 
% temp_signal_to_noise = sorted(:,24); 
% signal_to_noise_types = cell2mat(sorted(:,24)); 
% sorting_signal = signal_to_noise_types(:,signal_to_noise_method);
% temp_cell = mat2cell( sorting_signal, ones(size(sorting_signal)), 1 );
% sorted(:,24)=temp_cell;
%  
% positions = find(   [sorted{:,12}]< dltag(1) |  [sorted{:,12}] >dltag(2)|...
%                     [sorted{:,13}]< tracelength(1) |  [sorted{:,13}] >tracelength(2) |...
%                     [sorted{:,24}]< signal_to_noise(1) |  [sorted{:,24}] >signal_to_noise(2) |...
%                     [sorted{:,25}]< mean_intensity(1) |  [sorted{:,25}] >mean_intensity(2) );            
% 
% sorted(positions,:)=[];
% 
% %sorted(:,24)=temp_signal_to_noise; % Reassigne the signal to noixe
% %parameters SERGEY: didn't it need to be commented out???
% 
% % 
% % positions = find(   [sorted{:,13}]< tracelength(1)  );            
% % sorted(positions,:)=[];
% %  
% % positions = find(   [sorted{:,13}] >tracelength(2)  );            
% 
% 
% % this section will add a numberialc 1 to n ID for arbitray groupoing of
% % which can then be used to overlay data
% % Setion added by Max on 100708 allows regrouping of molecules
% 
% if iscell(new_id) == true
%   
%     resorted={};
%     
%     for i =1:size(new_id,1)
%     
%         togroup = new_id{i};
%         
%         for k = 1:size(togroup,1)
%             
%             tempgroup =  togroup{k};
%         
%         for j=2:size(tempgroup,2)             
%             temp_sorted={};   
%             positions = find([sorted{:,1}]==tempgroup(1) & [sorted{:,3}]==tempgroup(j) );
%             temp_sorted = sorted(positions,:);
%         for l=1:size(temp_sorted,1)  
%             
%             temp_sorted{l,8}=i;
%         end
%         
%             resorted = cat(1, resorted, temp_sorted);      
%         end
%         end
%     end
%            
%            
%         sorted = resorted;
%             
% end
%         
%         
%         
% cat_molecules=[]; 
% if concatenate == true
%     
%  % start of code for concatenating molecules
% 
%  for g=1:size(grouping,1)
%      
%  temp_group = grouping{g};
%      
%       
%       
%     for j=2:size(temp_group,2)   
%     temp_sorted={};   
%     positions = find([sorted{:,1}]==temp_group(1) & [sorted{:,3}]==temp_group(j) );
%     temp_sorted = sorted(positions,:);
%     
%       
%     
%     i=1;
%       
%       
%  while  i <=size(temp_sorted,1)/2 %[sorted{i,1}] ~=5  i <=size(sorted,1)/2
%      
% %  temppositions = find(      [sorted{:,6}]>=[sorted{i,6}]-slop & ...
% %                             [sorted{:,6}]<=[sorted{i,6}]+slop & ...
% %                             [sorted{:,7}]>=[sorted{i,7}]-slop & ...
% %                             [sorted{:,7}]<=[sorted{i,7}]+slop & ...
% %                             [sorted{:,3}]==[sorted{i,3}]      & ...
% %                             [sorted{:,4}]==[sorted{i,4}]      & ...
% %                             [sorted{:,1}]~=[sorted{i,1}]      ) ;
%         
% %  temppositions = find(      [sorted{:,6}]>=[sorted{i,6}]-slop & ...
% %                             [sorted{:,6}]<=[sorted{i,6}]+slop & ...
% %                             [sorted{:,7}]>=[sorted{i,7}]-slop & ...
% %                             [sorted{:,7}]<=[sorted{i,7}]+slop & ...
% %                             [sorted{:,3}]==([sorted{i,3}]) & ...
% %                             [sorted{:,1}]~=[sorted{i,1}]      ) 
%                         
%                         
%                         
% temppositions = find(      [temp_sorted{:,6}]>=[temp_sorted{i,6}]-slop & ...
%                             [temp_sorted{:,6}]<=[temp_sorted{i,6}]+slop & ...
%                             [temp_sorted{:,7}]>=[temp_sorted{i,7}]-slop & ...
%                             [temp_sorted{:,7}]<=[temp_sorted{i,7}]+slop & ...
%                             [temp_sorted{:,3}]==([temp_sorted{i,3}])    &...
%                             [temp_sorted{:,2}]~=[temp_sorted{i,2}] )
%                          
% 
%                         
%                         
% % temppositions = find(      [sorted{:,6}]>=[sorted{i,6}]-slop & ...
% %                             [sorted{:,6}]<=[sorted{i,6}]+slop & ...
% %                             [sorted{:,7}]>=[sorted{i,7}]-slop & ...
% %                             [sorted{:,7}]<=[sorted{i,7}]+slop & ...
% %                             [sorted{:,3}]==[sorted{i,3}] & ...
% %                             [sorted{:,3}]==[sorted{i,3}]      ) ;
% 
%                         
%                    
% if isempty(temppositions) == false
%      
%     temp_cat        = cat(1,temp_sorted(i,:),temp_sorted(temppositions,:));
%     cat_molecules   = cat(1,cat_molecules,temp_cat);
%     temp_cat=[];
%     temppositions=[];
%     i=i+1;
% else
%     i=i+1;
% end  
% 
%     end
%  end
%  
%  end
% 
%  
%  
% sorted = [];
% sorted = cat_molecules;
% 
% end
% 
%         
%         
%     
%     
% 
% 
%  output=sorted;