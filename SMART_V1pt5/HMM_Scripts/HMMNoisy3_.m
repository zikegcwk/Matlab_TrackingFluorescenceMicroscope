function [pi,x] = HMMNoisy3_(A,E,channelTypes,N)
%generate noisy hmm string with transition matrix A, mean vector m,
%variance vector v, initial state probability mu0, string length N
%lambdaMat = [lr1 lr2 ; lg1 lg2]
%gaussMat = [mr1 mr2 stdr1 stdr2 ; mg1 mg2 stdg1 stdg2]

nStates = size(E,1);
nChannels = size(E,2);

%initialize x and pi
x = zeros(N,nChannels); %red channel column 1, green channel column 2
pi = zeros(N,1); %high or low fret state

%compute mu0 from stationary distribution of A  
[v,D] = eigs(A');
mu0 = v(:,1)./sum(v(:,1));

%pick initial state  
pi(1) = find(rand <= cumsum(mu0),1,'first');

%set first emission

if strcmp(channelTypes,'exp'), %exponential signal
    mMat = zeros(nChannels,nStates);
    for i = 1:nChannels, 
        for j = 1:nStates, 
            mMat(i,j) = E{j,i}(1);
        end
    end    
    x(1,:) = random('exp',mMat(:,pi(1)),[nChannels 1])';
elseif strcmp(channelTypes,'gauss') %size(E,2) == 4, gaussian signal
    mMat = zeros(nChannels,nStates);
    sMat = zeros(nChannels,nStates);
    for i = 1:nChannels, 
        for j = 1:nStates, 
            mMat(i,j) = E{j,i}(1);
            sMat(i,j) = E{j,i}(2);
        end
    end    
    x(1,:) = random('norm',mMat(:,pi(1)),sMat(:,pi(1)),[nChannels 1])';
elseif strcmp(channelTypes,'poisson') %poisson signal
    mMat = zeros(nChannels,nStates);
    for i = 1:nChannels, 
        for j = 1:nStates, 
            mMat(i,j) = E{j,i}(1);
        end
    end    
    x(1,:) = random('poisson',mMat(:,pi(1)),[nChannels 1])';
end

%make full set of emissions 
for i = 2:N,
    %pick next state
    pi(i) = find(rand <= cumsum(A(pi(i-1),:),2),1,'first');
end
for i = 1:nStates,  
    r = find(pi == i);
    for j = 1:nChannels,
        if strcmp(channelTypes,'exp'), %exponential signal
            x(r,j) = random('exp',mMat(j,i),[length(r) 1])';
        elseif strcmp(channelTypes,'gauss'), %size(E,2) == 4, gaussian signal
            x(r,j) = random('norm',mMat(j,i),sMat(j,i),[length(r) 1])';
        elseif strcmp(channelTypes,'poisson'),
            x(r,j) = random('poisson',mMat(j,i),[length(r) 1])';
        end
    end
end



% x = round(x);

% figure
% subplot(2,1,1);
% plot(x(:,1),'r-');
% hold on
% plot(x(:,2),'g-');
% subplot(2,1,2);
% plot(x(:,1)./(x(:,1)+x(:,2)),'b-');
% hold on
% plot(pi-1,'r-','LineWidth',1);
% % axis([1 length(x) (E{1,1}(1)/(E{1,2}(1)+E{2,2}(1))) (E{2,1}(1)/(E{2,1}(1)+E{2,2}(1)))]);
% 
% nu12obs = sum(diff(pi) == 1)/sum(pi == 1);
% nu21obs = sum(diff(pi) == -1)/sum(pi == 2);
% 
% title(['nu12obs = ' num2str(nu12obs) ', nu21obs = ' num2str(nu21obs)]);