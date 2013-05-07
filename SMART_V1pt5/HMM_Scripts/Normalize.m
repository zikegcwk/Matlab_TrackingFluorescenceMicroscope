function N = Normalize(M,dim)
%normalizes sum of M along dimension dim to be 1
dimVector = ones(1,length(size(M)));
dimVector(dim) = size(M,dim);
N = M./repmat(sum(M,dim),dimVector);