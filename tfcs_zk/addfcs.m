%function addfcs will add g1 and g2 together to give g3. 
function g3=addfcs(varargin)
if nargin==2
    %here I will just form g3 from all rows in g1 and g2.
    g1=varargin{1};
    g2=varargin{2};
    g3=cat(1,g1,g2);   
end

if nargin==4
    %now I will take N1 from g1 and N2 from g2 to form g3
    g1=varargin{1};
    g2=varargin{2};
    N1=varargin{3};
    N2=varargin{4};
    
    g3=cell(length(N1)+length(N2),size(g1,2));
    
    for j=1:1:length(N1)
        for k=1:1:size(g1,2)
            g3{j,k}=g1{N1(j),k};
        end
    end
    
    for j=1:1:length(N2)
        for k=1:1:size(g1,2)
            g3{length(N1)+j,k}=g2{N2(j),k};
        end
    end
    
    
end


