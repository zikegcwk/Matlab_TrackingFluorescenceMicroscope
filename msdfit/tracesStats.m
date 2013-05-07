function Y=tracesStats(D_fit,L_fit)
[n,p]=size(D_fit);
Y=[];
thres=0.3;
for i=1:n
    idxs=find(isreal(L_fit(i,:)) & L_fit(i,:)<thres);
    if not(isempty(idxs))
        D=mean(D_fit(i,idxs));
        Y=cat(1,Y,[i,D]);
    end
end

