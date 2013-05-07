%function align3 use fminsearch to align all the curves in cell g1 to its
%first element and store the result into g2. 
function g2=FCS_align(tau,g1,t_tide)


t_index=min(find(tau>t_tide));

%% get the normalinzation constant.
for j=1:1:size(g1,1)
    for k=1:1:3
        for kk=1:1:size(g1{j,k+3},1)
            N(j,k,kk)=scale(g1{j,k+3}(kk,t_index:end),g1{j,k+3}(1,t_index:end));
            g2{j,k+3}(kk,:)=g1{j,k+3}(kk,:)*N(j,k,kk);
        end
    end
end

for j=1:1:size(g1,1)
    for k=1:1:3
        g2{j,k}=mean(g2{j,k+3});
    end
end


%% take care of the lengend.
if size(g1,2)>6
    for j=1:1:size(g1,1)
        g2{j,7}=g1{j,7};
    end
end