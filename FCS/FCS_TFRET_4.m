%function FCS_ZK_4

function [tau,X1,X2,X3,X1_std,X2_std,X3_std]=FCS_TFRET_4(filenum,tmin,tmax,taumin,taumax,N)



load(sprintf('data_%g', filenum));



tau=logspace(taumin,taumax,N);



%for j=1:1:2

%    tags{j}=peak_eater(tags{j},1e-2,200,0);

%end





%for j=3:1:4

%    tags{j}=peak_eater(tags{j},1e-2,600,0);

%end





data = cell(length(tags),1);

for j=1:1:length(tags)

    data{j} = tags{j}(tags{j} >= tmin & tags{j} <= tmax);

end







if length(tags)==4
    fprintf('calculating Acceptor channel auto-correlation.\n')
    %[X1,X1_std]=FCS_compute(data{1},data{2},tau);
    X1=corr_Laurence(data{1}, data{2}, tau);
    X1 = X1(1:end-1)-1;
    %X1_std = X1_std(1:end-1);
    X1_std=0;
    fprintf('calculating donor channel auto-correlation.\n')
    %[X2,X2_std]=FCS_compute(data{3},data{4},tau);
    X2=corr_Laurence(data{3}, data{4}, tau);
    X2 = X2(1:end-1)-1;
    %X2_std = X2_std(1:end-1);
    X2_std=0;
    fprintf('calculating cross-correlation.\n\n')
    %[X3,X3_std]=FCS_compute(data{1},data{3},tau);
    X3=corr_Laurence(data{1}, data{3}, tau);
    X3 = X3(1:end-1)-1;
    %X3_std = X3_std(1:end-1);
    X3_std=0;
elseif length(tags)==2
    fprintf('calculating Acceptor channel auto-correlation.\n')
    X1=corr_Laurence(data{1}, data{1}, tau);
    X1 = X1(1:end-1)-1;
    X1_std = 0;
    fprintf('calculating Donor channel auto-correlation.\n')
    X2=corr_Laurence(data{2}, data{2}, tau);
    X2 = X2(1:end-1)-1;
    X2_std = 0;
    fprintf('calculating cross-correlation.\n\n')
    X3=corr_Laurence(data{1}, data{2}, tau);
    X3 = X3(1:end-1)-1;
    X3_std = 0;
elseif length(tags)==1
     fprintf('calculating auto-correlation from the only tags.\n')
     X1=corr_Laurence(data{1}, data{1}, tau);
     X1 = X1(1:end-1)-1;
     X1_std=0;
     X2=X1;X2_std=0;
     X3=X1;X3_std=0;
    return;

end


tau = tau(1:end-1);


if nargout==4

    clear X1_std X2_std X3_std;

end

