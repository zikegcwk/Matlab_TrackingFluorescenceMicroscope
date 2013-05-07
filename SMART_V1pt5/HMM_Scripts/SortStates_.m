function [A,E] = SortStates_(A,E)
%reorders transition matrix A and emissions matrix E to sort states by
%increasing channel 1 mean (param 1)
nStates = size(E,1);
nChannels = size(E,2);
means = zeros(nStates,1);
for i = 1:nStates,  
    means(i) = E{i,1}(1);
%     means(i) = E(i);
end
[means,ix] = sort(means,'ascend');

if min(ix == (1:nStates)') == 0, %means currently not ascending
%     disp('sort')
%     disp(E{1,1})
%     disp(E{2,1})
%     disp(E{3,1})
%     pause
    %generate permutation matrix from ix  
    p = eye(nStates);
    p = p(ix,:);

    %permute transition matrix
    A = p*A*p';

    %permute emissions matrix  
    Ep = E;
    for i = 1:nStates,
        for j = 1:nChannels,
            Ep{i,j} = E{ix(i),j};
%             Ep(i) = E(ix(i));
        end
    end
    E = Ep;
end