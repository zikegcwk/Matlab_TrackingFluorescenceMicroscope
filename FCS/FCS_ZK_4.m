%function FCS_ZK_4

function [tau,X1,X2,X3,X1_std,X2_std,X3_std]=FCS_ZK_4(filenum,tmin,tmax,taumin,taumax,N)
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
    if tmax>tmin
        data{j} = tags{j}(tags{j} >= tmin & tags{j} <= tmax);   
    else
        data{j} = tags{j}(tags{j} >= min(tags{j}) & tags{j} <= max(tags{j}));
    end
end



if length(tags)==4
%     fprintf('calculating Acceptor channel auto-correlation...')
%     %[X1,X1_std]=FCS_compute(data{1},data{2},tau);
%     X1=corr_Laurence(data{1}, data{2}, tau);
%     X1 = X1(1:end-1)-1;
%     %X1_std = X1_std(1:end-1);
%     X1_std=0;
%     fprintf('donor...')
%     %[X2,X2_std]=FCS_compute(data{3},data{4},tau);
%     X2=corr_Laurence(data{3}, data{4}, tau);
%     X2 = X2(1:end-1)-1;
%     %X2_std = X2_std(1:end-1);
%     X2_std=0;
%     fprintf('finally cross....\n')
%     %[X3,X3_std]=FCS_compute(data{1},data{3},tau);
%     X3=corr_Laurence(sort([data{1} data{2}]), sort([data{3} data{4}]), tau);
%     X3 = X3(1:end-1)-1;
%     %X3_std = X3_std(1:end-1);
%     X3_std=0;
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('calculating diffusion...')
    diffusion=corr_Laurence(sort([data{1} data{2} data{3} data{4}]), sort([data{1} data{2} data{3} data{4}]),tau)-1;
    fprintf('acceptor....') 
    X1=corr_Laurence(data{1}, data{2}, tau)-1;
    fprintf('donor....') 
    X2=corr_Laurence(data{3}, data{4}, tau)-1;
    fprintf('cross....') 
    X3=corr_Laurence(sort([data{1} data{2}]), sort([data{3} data{4}]), tau)-1;
    fprintf('now magic....\n')  
     X1=(X1)./(diffusion);
     X2=(X2)./(diffusion);
     X3=(X3)./(diffusion);
     X1 = X1(1:end-1);
     X2 = X2(1:end-1);
     X3 = X3(1:end-1);
    X1_std = 0;
    X2_std = 0;
    X3_std = 0;
elseif length(tags)==3
    X1=corr_Laurence(data{2}, data{1}, tau);
    X2=corr_Laurence(data{3}, data{3}, tau);
    %X3=corr_Laurence(data{2}, data{1}, tau);
    %X3=X2;%X1=X3;
    X3=corr_Laurence(data{3}, data{2}, tau);
    X1 = X1(1:end-1)-1;
    X2 = X2(1:end-1)-1;
    X3 = X3(1:end-1)-1;    
    X1_std=0;X2_std = 0;X3_std=0;
      
    fprintf('done....\n')
    
    
    
elseif length(tags)==2
    fprintf('Two tags. Calculating...')
 
    
%********************* 
%      Track=corr_Laurence(sort([data{1} data{2}]), sort([data{1} data{2}]),tau);
%      X1=corr_Laurence(data{1}, data{1}, tau);
%      X2=corr_Laurence(data{2}, data{2}, tau);
%      X3=corr_Laurence(data{1}, data{2}, tau);
%      X1=(X1)./(Track);
%      X2=(X2)./(Track);
%      X3=(X3)./(Track);
%      X1 = X1(1:end-1)-1;
%      X2 = X2(1:end-1)-1;
%      X3 = X3(1:end-1)-1;
%     X1_std = 0;
%     X2_std = 0;
%     X3_std = 0;
%__________________________

%------------------------------------
    X1=corr_Laurence(data{1}, data{1}, tau);
    X2=corr_Laurence(data{2}, data{2}, tau);
    %X3=corr_Laurence(data{2}, data{1}, tau);
    %X3=X2;%X1=X3;
    X3=corr_Laurence(data{2}, data{1}, tau);
    X1 = X1(1:end-1)-1;
    X2 = X2(1:end-1)-1;
    X3 = X3(1:end-1)-1;    
    X1_std=0;X2_std = 0;X3_std=0;
      
    fprintf('done....\n')
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

