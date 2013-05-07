%function FCS_ZK_tracking_4

function [tau,A,D,X,Tr]=FCS_ZK_tracking_4(filenum,tmin,tmax,taumin,taumax,N)
load(sprintf('data_%g', filenum));
tau=logspace(taumin,taumax,N);

data = cell(length(tags),1);

for j=1:1:2
    if tmax>tmin
        data{j} = tags{j}(tags{j} >= tmin & tags{j} <= tmax);   
    else
        data{j} = tags{j}(tags{j} >= min(tags{j}) & tags{j} <= max(tags{j}));
    end
end
data{3}=sort([data{1} data{2}]);

disp(strcat(cd,'->',filenum));

fprintf('calculating: tracking contributed correlation...')
%[X1,X1_std]=FCS_compute(data{1},data{2},tau);
Tr=corr_Laurence(data{3}, data{3}, tau);
Tr = Tr(1:end-1)-1;
%T_std=0;

fprintf('acceptor...')
%[X2,X2_std]=FCS_compute(data{3},data{4},tau);
A=corr_Laurence(data{1}, data{1}, tau);
A =A(1:end-1)-1;
A=(A+1)./(Tr+1)-1;
%A_std=0;

fprintf('donor...')
%[X3,X3_std]=FCS_compute(data{1},data{3},tau);
D=corr_Laurence(data{2}, data{2}, tau);
D = D(1:end-1)-1;
D=(D+1)./(Tr+1)-1;
%D_std=0;

fprintf('finally cross, one more...')
%[X3,X3_std]=FCS_compute(data{1},data{3},tau);
X=corr_Laurence(data{1}, data{2}, tau);
X = X(1:end-1)-1;
X=(X+1)./(Tr+1)-1;
%X_std=0;


tau = tau(1:end-1);
