function fcs_getter(root,taumin,taumax,tauN)

if nargin==0
    root=cd;
    taumin=-9;
    taumax=0;
    tauN=90;
end

w=dir;
wname=struct2cell(w);


 for j=1:1:size(wname,2)
     temp{1,j}=wname{1,j};
 end
temp
 
y=input('Enter sequence for FCS: ');

for j=1:1:size(y,2)
    subdir{1,j}=temp{1,y(j)};
end
disp('will work on:')
subdir



for j=1:1:length(subdir)
    dir_FCS{1,j}=strcat(root,'\',subdir{1,j});
   
end

for j=1:1:length(dir_FCS)
    cd(dir_FCS{1,j})
    [tau,g2{j,1},g2{j,2},g2{j,3},g2{j,4},g2{j,5},g2{j,6}]=...
        FCS_ZK(0,-1,0,-1,taumin,taumax,tauN);
    save(strcat(subdir{1,j},'.mat'),'tau','g2','dir_FCS');
    g2{j,7}=subdir{1,j};
    cd(root);
    save(strcat(date,'.mat'),'tau','g2','dir_FCS')
end


