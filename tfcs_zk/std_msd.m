%function std_msd calculates the weighted g2 std,given by how long each
%trace is (stored at list)
function stdg2=std_msd(list,g2)

T=list(:,3)-list(:,2);
%% get average g2. 
for j=1:1:length(T)
    w_g2(j,:)=(T(j)/sum(T))*g2(j,:);
end

g2_avg=sum(w_g2,1);

%g2_avg=ave_msd(g2,T);


%% get std
for j=1:1:size(g2,1)
    temp(j,:)=(g2(j,:)-g2_avg).^2;
end


for j=1:1:length(T)
    w_temp(j,:)=(T(j)/sum(T))*temp(j,:);
end
stdg2=sum(w_temp,1).^0.5/length(T)^0.5;

    