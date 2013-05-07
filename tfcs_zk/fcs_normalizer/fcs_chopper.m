function [tau_c,g2_chopped1]=fcs_chopper(varargin)
%% get the inputs right.
tau=varargin{1};
g2=varargin{2};

if nargin==2
    t_index=length(tau);
    tau_c=tau;
end

if nargin==3
    if length(varargin{3})==1
        t_tide=varargin{3};
        t_index=min(find(tau>t_tide));
        tau_c=tau(1:t_index);
    else
        t_index=length(tau);
        tau_c=tau;
        thry=varargin{3};
    end    
end

if nargin==4
    t_tide=varargin{3};
    thry=varargin{4};
    t_index=min(find(tau>t_tide));
    tau_c=tau(1:t_index);
end
%%manul inputs of the type. 
type='diffusion';

%% get the underlying carrying dynamics correct. 
% for j=1:1:3
% % %     fit=FCS_diffusion_fit(tau,g2{1,j},0.5,pi*0.5^2/0.532,[0 0],'poly');
% % %     theoryg2(j,:)=FCS_diff_poly(tau,fit{1,2}(1),fit{1,2}(2),fit{1,2}(3),fit{1,2}(4),fit{1,2}(5),fit{1,2}(6));
% % % 
% % %     theoryg2(j,:)=mean(g2{9,4});
%      theoryg2(j,:)=g2{1,3};
% % 
%  end
for j=1:1:3
    %theoryg2(j,:)=thry;
    theoryg2(j,:)=g2{1,3};
end

%% perform the separation procedure
for j=1:1:size(g2,1)
    for k=1:1:6
        if k<4
           if strcmp(type,'diffusion')    
                g2_chopped1{j,k}=g2{j,k}(1:t_index)./theoryg2(k,1:t_index)-1;
           elseif strcmp(type,'tracking')
                g2_chopped1{j,k}=(g2{j,k}(1:t_index)+1)./(theoryg2(k,1:t_index)+1)-1;
           end
        else
            for l=1:1:size(g2{j,k},1)
                if strcmp(type,'diffusion')
                    g2_chopped1{j,k}(l,:)=g2{j,k}(l,1:t_index)./theoryg2(k-3,1:t_index)-1;
                elseif strcmp(type,'tracking')
                    g2_chopped1{j,k}(l,:)=(g2{j,k}(l,1:t_index)+1)./(theoryg2(k-3,1:t_index)+1)-1;
                end
            end
        end
    end
end

%% legends
if size(g2,2)>6
    for j=1:1:size(g2,1)
        g2_chopped1{j,7}=g2{j,7};
    end
end

%% if tracking, get laser power, fluorescence rate right. 
if size(g2,2)>7
    for j=1:1:size(g2,1)
        g2_chopped1{j,8}=g2{j,8};
        g2_chopped1{j,9}=g2{j,9};
        g2_chopped1{j,10}=g2{j,10};
    end
end


