function fcs_comp(g1,g2)

if size(g1,1)~=size(g2,1)
    error('both g2 should have the same dimension');
end

tau=logspace(-(size(g1{1,1},2)+1)/10,0,(size(g1{1,1},2)+1));
tau=tau(1:end-1);
for k=1:1:size(g1,1)
    for j=1:1:7
        gt{1,j}=g1{k,j};
        gt{2,j}=g2{k,j};
    end
    gt=fcs_N(tau,gt,1e-2);
    fcp(gt);
end