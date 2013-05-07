function [counts,A,lifetimes,stateLabels] = GetAfrompi_(pi)
[stateLabels,m,n] = unique(pi);
pi = n;
nStates = length(stateLabels);

if sum(pi == pi(end)) == 1,
    disp('warning: pi(end) introduces new state, so no transition information is gathered on this state');
end

A = zeros(nStates,nStates);

for i = 2:length(pi),  
    A(pi(i-1),pi(i)) = A(pi(i-1),pi(i)) + 1;
end
counts = A;
lifetimes = sum(A,2)./sum(A-diag(diag(A)),2);
A = A./repmat(sum(A,2),[1 size(A,1)]);