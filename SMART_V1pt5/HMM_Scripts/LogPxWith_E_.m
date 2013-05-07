function logPx = LogPxWith_E_(A,E,fitChannelType,x)
%computes forward probability matrix F for HMM
%with transition matrix A, mean vector m,
%variance vector v, initial probabilities mu0
%string x  

%lambdaMat = [lr1 lr2 ; lg1 lg2]
% if strcmp(fitType,'exp'),
%     E = 1./E; %convert to rates from means
% end
%gaussMat = [mr1 mr2 stdr1 stdr2 ; mg1 mg2 stdg1 stdg2]

%compute mu0 from stationary distribution of A  
% [v,D] = eigs(A');
v = ones(length(A),1)./length(A); %comment this unless get_data_SNR_length_prec
mu0 = v(:,1)./sum(v(:,1));

e = Get_e_(E,fitChannelType,x);

F = zeros(size(A,1),length(e));
normF = zeros(1,length(e));
%initialize

% nChannels = size(E,1);
% nStates = size(A,1);

% e provided as argument
F(:,1) = mu0(:).*e(1,:)';

normF(1) = sum(F(:,1));
F(:,1) = F(:,1)./normF(1); %normalize to avoid underflow

for i = 2:length(e),      
    F(:,i) = (A'*F(:,i-1)).*e(i,:)'; % sum(F(:,i-1).*A(:,k),1).*e;
    
    %normalize to avoid underflow
    normF(i) = sum(F(:,i));
    F(:,i) = F(:,i)./normF(i);
end
% cumsumlognormF = cumsum(log(normF));
% logPx = cumsumlognormF(end); %log(P(x|model))
logPx = sum(log(normF));