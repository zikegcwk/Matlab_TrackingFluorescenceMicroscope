%N=fcs_N(g2,t_tide)
%function fcs_N takes cell g2 and output normalization constants for
%acceptor, donor and cross. The reference data is always the first row of
%g2.
function g2_N=fcsN(varargin)

if nargin==2
    g2=varargin{1};
    t_tide=varargin{2};
    tau=logspace(-(size(g2{1,1},2)+1)/10,0,(size(g2{1,1},2)+1));
    tau=tau(1:end-1);
elseif nargin==3
    tau=varargin{1};
    g2=varargin{2};
    t_tide=varargin{3};
end

t_index=min(find(tau>t_tide));

for j=1:1:size(g2,1)
    for k=1:1:3
        N(j,k)=scale(g2{j,k}(t_index:end),g2{1,k}(t_index:end));
    end
end

for j=1:1:size(g2,1)
    for k=1:1:3
        g2_N{j,k}=g2{j,k}*N(j,k);
        g2_N{j,k+3}=g2{j,k+3}*N(j,k);
    end
end

if size(g2,2)>6
    for j=1:1:size(g2,1)
        g2_N{j,7}=g2{j,7};
    end
end