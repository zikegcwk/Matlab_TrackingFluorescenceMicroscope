function [tr11 tr12 tr21 tr22]=pullTR_0623(f)

len=size(f,2);

for j=1:1:len
    if iscell(f)
       tr11(j)=f{j}.estTR(1,1);
    tr12(j)=f{j}.estTR(1,2);
    tr21(j)=f{j}.estTR(2,1);
    tr22(j)=f{j}.estTR(2,2);  
        
    else    
    tr11(j)=f(j).estTR(1,1);
    tr12(j)=f(j).estTR(1,2);
    tr21(j)=f(j).estTR(2,1);
    tr22(j)=f(j).estTR(2,2);
    end
end
    
    