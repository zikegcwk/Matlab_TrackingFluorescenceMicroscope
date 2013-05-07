function A = EnforceNoHops_(A,noHops,reduceRate)
% enforce some hops forbidden  
% nStates = size(A,1);
% A((noHops(:,2)-1)*nStates + mod(noHops(:,1)-1,nStates)+1) = 0;
for i = 1:size(noHops,1),
    if ~reduceRate,
        A(noHops(i,1),noHops(i,2)) = 0;
    else %if reduceRate, divide forbidden transition rates by 10, else set them to 0
        A(noHops(i,1),noHops(i,2)) = A(noHops(i,1),noHops(i,2))/10;
    end
end

%renormalize rows of A
A = A./repmat(sum(A,2),[1 size(A,1)]);