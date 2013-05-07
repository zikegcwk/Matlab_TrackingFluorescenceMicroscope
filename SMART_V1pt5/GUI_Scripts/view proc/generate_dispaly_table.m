function output = generate_dispaly_table(hmm_output)


hmm_size  = size(hmm_output.A,1);

tgap = 1;
%if strmatch(hmm_output.fitChannelType{1},'gauss')
tgap = 2  ;
%end

emis_lable = [];
stat_lable = [];
etable = [];

for i=1:hmm_size
    
    
    emis_lable = [emis_lable; {['State ' num2str(i) ' \mu']}];
    stat_lable = [stat_lable; {['State ' num2str(i)]}];
    if tgap == 2
        emis_lable = [emis_lable; {['State ' num2str(i) ' \sigma']}];
    end
    
    temp_etable = cell(1,11);
    for j =1:4
        try
            temp_etable{1,j+1}  = round(hmm_output.E{i,j}(1));
        catch
        end
    end
    etable = [etable;  temp_etable];
    
    temp_etable = cell(1,11);
    if tgap == 2
        for j =1:4
            try
                temp_etable{1,j+1}  = round(hmm_output.E{i,j}(2));
            catch
            end
        end
    end
    etable = [etable;  temp_etable];
    
end
    
etable = cellfun(@(c)num2str(c,'%.1f'),etable,'un',0);

clist = cell(1,11);
for i=1:size(hmm_output.E,2)
clist{i+1} =    ['C' num2str(i)];
end


tlist = cell((hmm_size+1),11);
tlist(1,2:(hmm_size+1)) = stat_lable;
tlist(2:end,1) = stat_lable;
tlist(2:end,(2:hmm_size+1)) = mat2cell(hmm_output.A,ones(hmm_size,1),ones(hmm_size,1));
 
etable(:,1) = emis_lable;


meta_table = [tlist ;cell(1,11);clist;etable];




local_table = cell(3,11);

local_table{1,1} = 'logPx';
local_table{1,2} = hmm_output.logPx;

local_table{1,3} = 'BIC';
local_table{1,4} = hmm_output.BIC;

local_table{2,1} = 'mean mean SNRMat';
local_table{2,2} = mean(mean(hmm_output.SNRMat));


        
meta_table = [ local_table ; meta_table];







output = meta_table;

