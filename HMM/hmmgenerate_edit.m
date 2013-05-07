function [seq,  states]= hmmgenerate_edit(L,tr,e, ini_state)
%% get some numbers from inputs
seq = zeros(1,L);
states = zeros(1,L);
numStates = size(tr,1);
numEmissions = size(e,2);

%% prepare for the main loop
% create two random sequences, one for state changes, one for emission
statechange = rand(1,L);
randvals = rand(1,L);

% calculate cumulative probabilities
trc = cumsum(tr,2);
ec = cumsum(e,2);

% normalize these just in case they don't sum to 1.
trc = trc./repmat(trc(:,end),1,numStates);
ec = ec./repmat(ec(:,end),1,numEmissions);

% Assume that we start in state given as input.
currentstate = ini_state;


%%  main loop 
for count = 1:L
    % calculate state transition
    stateVal = statechange(count);
    state = 1;
    for innerState = numStates-1:-1:1
        if stateVal > trc(currentstate,innerState)
            state = innerState + 1;
            break;
        end
    end
    % calculate emission
    val = randvals(count);
    emit = 1;
    for inner = numEmissions-1:-1:1
        if val  > ec(state,inner)
            emit = inner + 1;
            break
        end
    end
    % add values and states to output
    seq(count) = emit;
    states(count) = state;
    currentstate = state;
end