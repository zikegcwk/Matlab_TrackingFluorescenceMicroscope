%function FCS_ZK_4
function [tau,X1,X2,X3]=FCS_JUMP_ZK_4(filenum,tmin,tmax,taumin,taumax,N)

load(sprintf('data_%g', filenum));

tau=logspace(taumin,taumax,N);

%for j=1:1:2
%    tags{j}=peak_eater(tags{j},1e-2,200,0);
%end

JUMP=(1/177e3)*1e5;

%for j=3:1:4
%    tags{j}=peak_eater(tags{j},1e-2,600,0);
%end


data = cell(4,1);
for j=1:1:4
    data{j} = tags{j}(tags{j} >= tmin & tags{j} <= tmax);
end



if length(tags)==4

    fprintf('calculating Acceptor channel auto-correlation.\n')
    X1=corr_Laurence(data{1},data{1},tau+JUMP);
    X1 = X1(1:end-1)-1;
    fprintf('calculating donor channel auto-correlation.\n')
    X2=corr_Laurence(data{2},data{2},tau+JUMP);
    X2 = X2(1:end-1)-1;
    fprintf('calculating cross-correlation.\n\n')
    X3=corr_Laurence(data{1},data{2},tau+JUMP);
    X3=X3(1:end-1)-1;
elseif length(tags)==2
    fprintf('calculating Acceptor channel auto-correlation.\n')
    X1=corr_Laurence(data{1},data{1},tau);
    X1 = X1(1:end-1)-1;
    fprintf('calculating donor channel auto-correlation.\n')
    X2=corr_Laurence(data{2},data{2},tau);
    X2 = X2(1:end-1)-1;
    fprintf('calculating cross-correlation.\n\n')
    X3=corr_Laurence(data{1},data{2},tau);
    X3=X3(1:end-1)-1;
else
    return;
end
    
    
    
    
tau = tau(1:end-1);
