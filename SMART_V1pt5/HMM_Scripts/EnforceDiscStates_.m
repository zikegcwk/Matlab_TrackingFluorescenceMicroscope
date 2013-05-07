% function E = EnforceDiscStates_(E,discStates)
% % enforce some discrete states have identically distributed emissions
% 
% nChannels = size(E,2);
% 
% tempState = 1;
% for i = 1:length(discStates),
%     for k = 1:discStates(i),
%         for j = 1:nChannels,
%             E{tempState+k-1,j} = E{tempState,j};
%         end
%     end
%     tempState = tempState + discStates(i);
% end

function E = EnforceDiscStates_(E,discStates,P)
%enforce some discrete states have identically distributed emissions

nChannels = size(E,2);

tempState = 1;
for i = 1:length(discStates),
    for j = 1:nChannels,
        temp = E{tempState,j}.*0;
        for k = 1:discStates(i),
            temp = temp + E{tempState+k-1,j}.*sum(P(tempState+k-1,:));
        end
        for k = 1:discStates(i),
            E{tempState+k-1,j} = temp/sum(sum(P(tempState:tempState+discStates(i)-1,:)));
        end
    end    
    tempState = tempState + discStates(i);
end