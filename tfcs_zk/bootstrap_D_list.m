%function boostrap_D_list takes a list and compute diffusion coefficient
%based on bootstrap method. 
function [D,stdD]=bootstrap_D_list(list,dt)

D=zeros(1,length(list));
stdD=zeros(1,length(list));

for j=1:1:length(list)
    [D(j),stdD(j)]=bootstrap_D(list(j,1),list(j,2),list(j,3),dt);
end