
function output = align_data_files(metadata,movie_groups,ncat, slop)

% Some of this code was jacked from the gui traces_concatenta, though I
% don't need to always look at the data in the same way

% get the slop parameter
%slop = get(handles.edit9,'string');
%amountofslop = str2num(slop);


number_of_groups = size(movie_groups,2);
number_of_movies = size(metadata,3);

movienumber ={};
moleculeposition={};
temp_molecules = {};
concatenated_molecules ={};
molecule_id = 1;

for i=1:number_of_groups
    
    
    %tempgroup = [];
    %tempgroup = movie_groups(number_of_groups);
        
        %start_movie =  movie_groups{1}; 
orderfound =1;
temp_movie_group = movie_groups{i};
number_of_movies = size(metadata,3);




for k=1:size(temp_movie_group,2)
    
 %   temp_molecules=[];
    
% refrence_molecule  = [];
%other_molecules    =[];
 
    for j=1:number_of_movies
      
        temp = [];
        temp = metadata{9,:,j}; 
        locations =[];
        locations = find([temp{:,2}]==temp_movie_group(k));
    if isempty(locations) == false
        a = {orderfound};
        b ={};
        for z=1:size(locations,2)
            
            b = cat(1,b,a);
        end
        
        temp = cat(2,temp(locations,:),b);
        temp_molecules = cat(1,temp_molecules, temp);
        orderfound = orderfound +1;
    end
    end
end
   
temp_refrence = find([temp_molecules{:,23}]==1); % find the position of the refrence molecule
refrence_molecule = temp_molecules(temp_refrence,:);
other_molecules = temp_molecules; 
other_molecules(temp_refrence,:)=[]; % delete the refrence from the temp matrix


for k=1:size(refrence_molecule,1)
    
    % refrence_molecule(i,5)

temppositons =find(   [other_molecules{:,5}]>=refrence_molecule{k,5}-slop & ...
        [other_molecules{:,5}]<=refrence_molecule{k,5}+slop & ...
        [other_molecules{:,6}]>=refrence_molecule{k,6}-slop & ...
        [other_molecules{:,6}]<=refrence_molecule{k,6}+slop  ) ;
        
    if isempty(temppositons)== false && size(temppositons,2)== ncat-1
    
        
        temp_cat=[] ; 
        temp_cat= cat(2, refrence_molecule(k,:), {molecule_id});
        %for y=1:ncat-1    % An error might show up if there are multipuls molecules 
        temp_cat_2 = cat(2, other_molecules(temppositons,:), {molecule_id});
        
        temp_cat =  cat(3,temp_cat, temp_cat_2);
       
        concatenated_molecules =  cat(1,concatenated_molecules, temp_cat);
        molecule_id = molecule_id+1;
%         movie2positions(:,3)>=movie1positions(i,3)-slop & ...
%         movie2positions(:,3)<=movie1positions(i,3)+slop & ...
%         movie2positions(:,4)>=movie1positions(i,4)-slop & ...
%         movie2positions(:,4)<=movie1positions(i,4)+slop );
    end
end
   
refrence_molecule  = [];
other_molecules    =[];    
temp_molecules =[];
end



      output = concatenated_molecules;


