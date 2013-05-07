%fp(g2)  - plot g2(:,6) - 6 is pc;
%fp(tau,g2) - plot g2;
%fp(tau,g2,N) - plot sub N g2.
%fp(tau,g2,t_tide) - plot everything and cut to t_tide;
%fp(tau,g2,N,t_tide) - plot sub N and cut to t_tide;

function fp(varargin)

pc=6;

lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;


if nargin==1
    g1=varargin{1};
    tau1=logspace(-(size(g1{1,1},2)+1)/10,0,(size(g1{1,1},2)+1));
    tau1=tau1(1:end-1);
    N=1:1:size(g1,1);
    if (min(tau1)<10^-6)
        t_tide=1e-6;
    else
        t_tide=1e-6;
    end
end

if nargin==2
    tau1=varargin{1};
    g1=varargin{2};
    N=1:1:size(g1,1);
    t_tide=1e-6;
end

if nargin==3
    tau1=varargin{1};
    g1=varargin{2};
    if min(varargin{3})>=1
        N=varargin{3};
        t_tide=1e-6;
    else 
        N=1:1:size(g1,1);
        t_tide=varargin{3};
    end
end

if nargin==4
    N=varargin{3};
    t_tide=varargin{4};
end

[t,g2]=FCS_cut(tau1,g1,t_tide);



figure;
hold all;
for j=1:1:length(N)
    if j<8
        shadedErrorBar_zk(t,g2{N(j),pc},{'Color',darkcolor(j,:),'LineWidth',1});
    elseif j<15
        shadedErrorBar_zk(t,g2{N(j),pc},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',1});
    else
        shadedErrorBar_zk(t,g2{N(j),pc},{'Color',darkcolor(j-14,:),'LineStyle','-.','LineWidth',1});
    end

    xlabel('Log(tau) [S]', 'FontSize', 14);
    ylabel('Correlation [A.U.]', 'FontSize', 14);
    if size(g2,2)>6
        my_L{j}=g2{N(j),7};
    end
end
    
if size(g2,2)>6
   legend(my_L);
end
    box on;
    


