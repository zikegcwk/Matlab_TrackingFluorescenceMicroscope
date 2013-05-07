function e = Get_e_(E,fitChannelType,x)
nStates = size(E,1);
nChannels = size(E,2);
if prod(double(strcmp(fitChannelType(:),'exp'))) == 1, %all channels are 'exp'
    M = zeros(length(x),nChannels,nStates);
    xr = zeros(size(x,1),nChannels,nStates);
    for i = 1:nStates,
        M(:,:,i) = ones(length(x),1)*cell2mat(E(i,:));
        xr(:,:,i) = x;
    end

    e = squeeze(prod(pdf('exp',xr,M),2));
elseif prod(double(strcmp(fitChannelType(:),'gauss'))) == 1, %all channels are 'gauss'
    M = zeros(length(x),nChannels,nStates);
    S = zeros(length(x),nChannels,nStates);
    xr = zeros(size(x,1),nChannels,nStates);
    E = cell2mat(E);
    for i = 1:nStates,
        M(:,:,i) = ones(length(x),1)*E(2*i-1,:);
        S(:,:,i) = ones(length(x),1)*E(2*i,:);
        xr(:,:,i) = x;
    end
    
    e = squeeze(prod(pdf('norm',xr,M,S),2));
elseif prod(double(strcmp(fitChannelType(:),'poisson'))) == 1,


    M = zeros(length(x),nChannels,nStates);
    xr = zeros(size(x,1),nChannels,nStates);
    for i = 1:nStates,
        M(:,:,i) = ones(length(x),1)*cell2mat(E(i,:));
        xr(:,:,i) = x;
    end
    
    e = squeeze(prod(pdf('poisson',xr,M),2));
    
%     e = zeros(length(x),nChannels,nStates);
%    
%     M = max(max(x));
%     for i = 1:nChannels,
%         for j = 1:nStates,
%             F = @(y)(1./E{j,i}(1)).*exp(-y./E{j,i}(1));
%             precompute = zeros(M+1,1);
%             precompute(1) = quad(F,0,0.5);
%             for m = 2:M+1,
%                 precompute(m) = quad(F,m-0.5,m+0.5);
%             end
%             e(:,i,j) = precompute((x(:,i)+1));
%         end
%     end
%     e = squeeze(prod(e,2));

else %both 'gauss' and 'exp' channels  
    e = zeros(length(x),nChannels,nStates);
    for i = 1:nStates,
        for j = 1:nChannels,
            if strcmp(fitChannelType(j),'exp'),
                M = ones(length(x),1)*[E{i,j}(1)];
                e(:,j,i) = pdf('exp',x(:,j),M);
            elseif strcmp(fitChannelType(j),'gauss'),
                M = ones(length(x),1)*[E{i,j}(1)];
                S = ones(length(x),1)*[E{i,j}(2)];
                e(:,j,i) = pdf('norm',x(:,j),M,S); 
            end
        end
    end
    e = squeeze(prod(e,2));
end


%% check to see if numerical underflow occurred
if max(max(isnan(e))) == 1,
    error('numerical underflow occurred when computing emission probabilities');
end

if min(sum(abs(e),2)) == 0,
    error('numerical underflow occurred when computing emission probabilities');
end