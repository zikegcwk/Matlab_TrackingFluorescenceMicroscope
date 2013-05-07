%[tau2,g2]=FCS_cut(tau1,g1,t_tide)
%function FCS_cut cuts g1 into g2 with the minimum tau as t_tide.
function [tau2 g2]=FCS_cut(tau1,g1,t_tide)


t_index=min(find(tau1>=t_tide));
tau2=tau1(t_index:end);

%% get the normalinzation constant.
for j=1:1:size(g1,1)
    for k=1:1:3
        for kk=1:1:size(g1{j,k+3},1)
            g2{j,k+3}(kk,:)=g1{j,k+3}(kk,t_index:end);
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