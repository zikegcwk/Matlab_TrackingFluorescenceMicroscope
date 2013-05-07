function A = GetAfrompi(pi)
%infers transition matrix from sequence of hidden states

%modify to handle case of last unique state

method = 4;


stateLabels = unique(pi(1:end-1));
nStates = length(stateLabels);

if length(unique([reshape(stateLabels,[1 nStates]) pi(end)])) > nStates,
    disp('warning: pi(end) introduces new state, so no transition information is gathered on this state');
%     pi = pi(1:end-1);
end

if method == 1,
    stateLabels = unique(pi);
    nStates = length(stateLabels);

    if min(reshape(stateLabels,[1 nStates])==linspace(1,nStates,nStates)) == 0, %if state labels are not 1,2,...,nStates
        [stateLabels,m,n] = unique(pi);
        pi = n;
    end
    
    A = zeros(nStates,nStates);

    for i = 2:length(pi),  
        A(pi(i-1),pi(i)) = A(pi(i-1),pi(i)) + 1;
    end
    A = A./repmat(sum(A,2),[1 nStates]);

elseif method == 2,
    stateLabels = unique(pi);
    nStates = length(stateLabels);
    lastLabel = pi(end);

    A = zeros(nStates,nStates);
    
    pi_labeled = (2.^pi(1:end-1)).*(3.^pi(2:end));

    for i = 1:nStates,
        label1 = stateLabels(i);
        n = length(find(pi == label1)) - (label1==lastLabel);
        for j = 1:nStates,
            if i ~= j,
                A(i,j) = length(find(pi_labeled == ((2^label1)*(3^stateLabels(j)))));
                A(i,j) = A(i,j)/n;            
            end
        end
    end

    %add diagonal
    A = A + diag(1-sum(A,2));
elseif method == 3,
    stateLabels = unique(pi);
    nStates = length(stateLabels);
    lastLabel = pi(end);
    
    A = zeros(nStates,nStates);
    
    pi_labeled = pi(1:end-1).*sqrt(-1) + pi(2:end);
    
    for i = 1:nStates,
        label1 = stateLabels(i);
        n = length(find(pi == label1)) - (label1==lastLabel);
        for j = 1:nStates,
            if i ~= j,
                A(i,j) = length(find(pi_labeled == label1*sqrt(-1) + stateLabels(j)));
                A(i,j) = A(i,j)/n;    
            end
        end
    end
    
    %add diagonal
    A = A + diag(1-sum(A,2));
else
    stateLabels = unique(pi);
    nStates = length(stateLabels);

    if min(reshape(stateLabels,[1 nStates])==linspace(1,nStates,nStates)) == 0, %if state labels are not 1,2,...,nStates
        [stateLabels,m,n] = unique(pi);
        pi = n;
    end
    
    A = zeros(nStates,nStates);
    labeled = pi(1:end-1) + (pi(2:end)-1)*nStates;
    
    for i = 1:nStates^2,
        A(i) = A(i) + sum(labeled == i);
    end
    A = A./repmat(sum(A,2),[1 nStates]);
end