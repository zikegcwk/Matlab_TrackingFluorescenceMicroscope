function A = GetAutoAinitial_(nStates,N,noHops)
% diagValue = 0.999;
% if nStates > 1,
%     A = (ones(nStates)-eye(nStates)).*(1-diagValue)./(nStates-1)...
%         +eye(nStates).*diagValue;
% else
%     A = 1;
% end
% 
% % A = random('unif',0,1,[nStates nStates]);
% 
% %normalize again, sometimes matlab makes numerical error here
% A = A./(sum(A,2)*ones(1,nStates));



% space rates order of magnitude apart
% min rate set by length of data
rmin = 10/N;
rmax = 0.1;
rates = logspace(log10(rmin),log10(rmax),nStates)';

A = repmat(rates,[1 nStates])./(nStates-1);
%A = A - diag(diag(A)) + (eye(nStates)-diag(rates));
A = A - diag(diag(A)) + (diag(1-rates));

if nStates == 1,
    A = 1;
end


%% enforce some hops forbidden  
if ~isempty(noHops),
    A = EnforceNoHops_(A,noHops,true);    
end