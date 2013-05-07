function [P,F,B,normF,normB,logPx] = Post_(A,E,fitChannelType,x)
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
% A
[v,D] = eigs(A');
mu0 = v(:,1)./sum(v(:,1));

F = zeros(size(A,1),length(x));
normF = zeros(1,length(x));
%initialize

B = zeros(size(A,1),length(x));
normB = zeros(1,length(x));
%initialize


% nChannels = size(E,1);
% nStates = size(A,1);
e = Get_e_(E,fitChannelType,x);

F(:,1) = mu0(:).*e(1,:)';
normF(1) = sum(F(:,1));
F(:,1) = F(:,1)./normF(1); %normalize to avoid underflow

B(:,length(x)) = ones(size(A,1),1);
normB(length(x)) = sum(B(:,length(x)));
B(:,length(x)) = B(:,length(x))./normB(length(x)); %normalize to avoid underflow

for i = 2:length(x),
    bi = length(x)-i+1;
    F(:,i) = (A'*F(:,i-1)).*e(i,:)'; % sum(F(:,i-1).*A(:,k),1).*e;
    B(:,bi) = A*(B(:,bi+1).*e(bi+1,:)');
    %normalize to avoid underflow
    normF(i) = sum(F(:,i));
    F(:,i) = F(:,i)./normF(i);
    normB(bi) = sum(B(:,bi));
    B(:,bi) = B(:,bi)./normB(bi);    
end
P = F.*B;   P = P./repmat(sum(P,1),[size(A,1) 1]);
% cumsumlognormF = cumsum(log(normF));
% logPx = cumsumlognormF(end); %log(P(x|model))
logPx = sum(log(normF));