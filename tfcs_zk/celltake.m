function nnewc=celltake(newc,oldc,ele)

if isempty(newc{1,1})
    for j=1:1:7
        nnewc{1,j}=oldc{ele,j};
    end
else
    for j=1:1:7
        temp{1,j}=oldc{ele,j};
    end

    nnewc=cat(1,newc,temp);
end