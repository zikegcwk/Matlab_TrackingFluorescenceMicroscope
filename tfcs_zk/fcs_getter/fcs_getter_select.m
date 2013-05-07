function fcs_getter_select(root,taumin,taumax,tauN)

if nargin==0
    root=cd;
    taumin=-5;
    taumax=0;
    tauN=100;
end

w=dir;
wname=struct2cell(w);

for j=3:1:size(wname,2)
    subdir{1,j-2}=wname{1,j};
end

for j=1:1:length(subdir)
    dir_FCS{1,j}=strcat(root,'\',subdir{1,j});
end

k=1;
for j=1:1:length(subdir)
    cd(dir_FCS{1,j});
    if exist(strcat(subdir{1,j},'_siglist.mat'))==2
        
        display('will work on:')
        display(subdir{1,j});

        real_dir_FCS{1,k}=dir_FCS{1,j};
        real_subdir{1,k}=subdir{1,j};
        k=k+1;
    else
        
        display('will skip on:')
        display(subdir{1,j});
    end
end


for j=1:1:size(real_dir_FCS,2)
    cd(real_dir_FCS{1,j});
    load(strcat(real_subdir{1,j},'_siglist.mat'))
    [tau,g2{j,1},g2{j,2},g2{j,3},g2{j,4},g2{j,5},g2{j,6},g2{j,8},g2{j,9},g2{j,10}]=FCS_ZK_select(siglist,taumin,taumax,tauN);
    saveas(gcf,strcat(real_subdir{1,j},'_fcsfigure.fig'))
    save(strcat(real_subdir{1,j},'.mat'),'tau','g2','real_dir_FCS');
    g2{j,7}=real_subdir{1,j};
    cd(strcat(root,'\results'));
    save(strcat(date,'_FCS.mat'),'tau','g2','real_dir_FCS')
    
end

