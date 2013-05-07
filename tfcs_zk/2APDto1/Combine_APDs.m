%function Combine_APDs load data_filenum.mat, look into the tags and combine two
%APD signals into 1 and save it. 

function Combine_APDs(filenum)

disp(sprintf('processing data_%g.mat',filenum));
load(sprintf('data_%g.mat',filenum));


temp_tags=tags;

clear tags;

tags=cell(2,1);

%tags{1}=temp_tags{1};
%tags{2}=temp_tags{2};
tags{1}=sort([temp_tags{1} temp_tags{2}]);
tags{2}=sort([temp_tags{3} temp_tags{4}]);

save(sprintf('data_%g.mat',filenum+10000),'tags');
disp(sprintf('APDs are combined and saved to data_%g.', filenum+10000));
