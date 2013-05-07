function mass_filtering(list)


clear f; 

for j=1:1:size(list,1)
    list(j,1)
    f{j}=filtering(list(j,1),list(j,2),list(j,3));
end

clear newlist;
w=1;

    for j=1:1:size(list,1)
        list(j,:)
        if isfield(f{j},'tss')
         for k=1:1:size(f{j}.tss,2)
             if (f{j}.tee(k)-f{j}.tss(k))>1
                 newlist(w,1)=list(j,1);
                 newlist(w,2)=f{j}.tss(k);
                 newlist(w,3)=f{j}.tee(k);
                 w=w+1;
             end
         end
        end
    end

save('filted_list5mS.mat','f','list','newlist');