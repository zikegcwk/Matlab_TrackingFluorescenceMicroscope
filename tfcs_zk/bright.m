%function birght take tau and g2 and then read data files to calculate the
%sample brightness. 

function bright(varargin)

if nargin==2
    tau=varargin{1};
    g2=varargin{2};
    f1=0;
    f2=0;
elseif nargin==3
    tau=varargin{1};
    g2=varargin{2};
    f1=varargin{3};
    f2=varargin{3};
elseif nargin==4
    tau=varargin{1};
    g2=varargin{2};
    f1=varargin{3};
    f2=varargin{4};
else
    error('fucking read the fucking code before you fucking use it')
end


w=2;
fit = FCS_diffusion_fit(tau1,g1,w,pi*w^2/0.633,[0 0],'general');

for j=1:1:f2-f1+1
    load(sprintf('data_%g.mat',f1+j-1));
    ti(j)=mean(atime2bin(tags{1},1e-2)+atime2bin(tags{2},1e-2));
end

b=mean(ti)/fit.N;
    