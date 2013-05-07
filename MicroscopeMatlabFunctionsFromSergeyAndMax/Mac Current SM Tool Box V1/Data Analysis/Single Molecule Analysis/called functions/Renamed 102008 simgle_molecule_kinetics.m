function data = single_molecule_kinetics(trace_locations,movie_numbers,fps,simulated_traces,rethreshold_traces,average_method,threshold_method)


% trace_locations = {'F:\090208\090208 No Movies';...
%    'F:\090108\090108 No Movies' };
% movie_numbers={[106:108];[50:53]};
% 
% fps = 100;
% minimumlifetime =1;

if iscell(simulated_traces) == false


data = [];
for j= 1:size(movie_numbers,1)

% if isempty(core_file_name)==true 
cd(trace_locations{j});
core_file_name = generate_core_file_name(movie_numbers{j});
% end

%I want to clean this up some but not right now 072908
%get_data(core_file_name,fps,minimumlifetime)

number_of_movies = size(core_file_name,1);


for i=1:number_of_movies
new_names = track_filename(core_file_name{i});

%rawdatatoimport = char(new_names{1});
%tobeimported = char();

finalrawdata = importdata(new_names{1});
finaldata = importdata(new_names{2});

%data = single_molecule_fits_new_header(importdata(new_names{2}),importdata(new_names{1},fps,minimumlifetime);
if rethreshold_traces == true;

averaged_data = average_and_threshold(finaldata,finalrawdata);

end

tempdata = single_molecule_fits_new_header(finaldata,finalrawdata,fps{j},j,new_names);

data = cat(1, data, tempdata);
end
end

elseif iscell(simulated_traces) == true
    
   finaldata = simulated_traces{1};
   finalrawdata = simulated_traces{2};
   
   j   = 1;
   new_names = track_filename(1);
   
    data = single_molecule_fits_new_header(finaldata,finalrawdata,fps{1},j,new_names);

    
    
    
    
    
end




output = data;
%
%rawdatatoimport = '(donor_acceptor_defmlc)cascade24.26.27.28.29.30.32.33.34.35.(070908 P4P6 WT 20 mM Ba and 100 mM Na With Break End mM)(4).dat'; %(donor_acceptor_defmlc)
%tobeimported ='(kinetics_defmlc)cascade24.26.27.28.29.30.32.33.34.35.(070908 P4P6 WT 20 mM Ba and 100 mM Na With Break End mM)(4).dat'; %(kinetics_defmlc)


%finaldata = importdata(tobeimported);
%finalrawdata = importdata(rawdatatoimport);

%data = single_molecule_fits(finaldata,finalrawdata,fps,minimumlifetime);
%data = single_molecule_fits_new_header(finaldata,finalrawdata,fps,minimumlifetime);
%fps = finalrawdata(2,4);

% 
%
% numberofmolecules = data{1};
% meanfractionfolede = data{2};
% meantracelength = data{3};
% meankfold = data{4};
% meankunfold = data{5};
% sorted = data{6};
% bulkdata = data{7};
% rawbulkdata = data{8};
% newsorted = data{9};
% sorted2 = sorted;

% this was updated on 072908 to that that this is steped through correctly
%
%
% numberofmolecules = [];
% meanfractionfolede = [];
% meantracelength = [];
% meankfold = [];
% meankunfold = [];
% sorted = {};
% bulkdata = {};
% rawbulkdata = {};
% newsorted = {};
% 
% for i=1:number_of_movies
% numberofmolecules = [numberofmolecules data{1,1,i}];
% meanfractionfolede = [meanfractionfolede data{2,1,i}];
% meantracelength = [meantracelength data{3,1,i}];
% meankfold = [meankfold data{4,1,i}];
% meankunfold = [meankunfold data{5,1,i}];
% sorted = cat(2,sorted, {data{6,1,i}});
% bulkdata = cat(2,bulkdata, {data{7,1,i}});
% rawbulkdata =cat(2,rawbulkdata,  {data{8,1,i}});
% newsorted = cat(2,newsorted, {data{9,1,i}});
% sorted2 = sorted;
% end

  %% assign sorted to default unsorted values
%sorted = sorted2;