function [discStatesList,noHopsList,sameHopsList] = PermuteConstraints_(discStates,noHops,sameHops)
%returns list of distinct discStates permutations and corresponding noHops and sameHops permutations  

nStates = sum(discStates);

[discStatesList,maps] = ListPerms(discStates);
noHopsList = cell(size(maps,1),1);
sameHopsList = cell(size(maps,1),1);


stateIndices = [1 (cumsum(discStates)+1)];
stateIndices(end) = [];    

%permute noHops list
for i = 1:size(maps,1),
    if isempty(noHops),
        noHopsList{i} = [];
    else
        noHopsMap = (1:nStates).*0; 
        tempState = 1;
        for j = 1:length(discStates),
            noHopsMap(tempState:tempState+discStatesList(i,j)-1) = stateIndices(maps(i,j)):stateIndices(maps(i,j))+discStatesList(i,j)-1;
            tempState = tempState + discStatesList(i,j);
        end

        p = eye(nStates);
        p = p(noHopsMap,:);

        hops = zeros(nStates,nStates);
        hops((noHops(:,2)-1)*nStates + mod(noHops(:,1)-1,nStates)+1) = 1;
        hops = p*hops*p';
        [r,c] = find(hops);

        noHopsList{i} = [r c];
    end
end
%permute sameHops list
for i = 1:size(maps,1),
    if isempty(sameHops),
        sameHopsList{i} = [];
    else
        sameHopsMap = (1:nStates).*0; 
        tempState = 1;
        for j = 1:length(discStates),
            sameHopsMap(tempState:tempState+discStatesList(i,j)-1) = stateIndices(maps(i,j)):stateIndices(maps(i,j))+discStatesList(i,j)-1;
            tempState = tempState + discStatesList(i,j);
        end

        p = eye(nStates);
        p = p(sameHopsMap,:);
                
        for k = 1:size(sameHops,1),
            hopsMat = [sameHops(k,1:2) ; sameHops(k,3:4)];
            hops = zeros(nStates,nStates);
            hops((hopsMat(:,2)-1)*nStates + mod(hopsMat(:,1)-1,nStates)+1) = 1;
            hops = p*hops*p';
            [r,c] = find(hops);
            
            sameHopsList{i} = [sameHopsList{i} ; [r(1) c(1) r(2) c(2)]];
        end
    end
end