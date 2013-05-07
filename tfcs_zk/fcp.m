%fcp(g2) - plot g2 and cut to 1uS, with tau 10 points per decade. 
%fcp(tau,g2) - plot g2 and cut to 1uS. 
%fcp(tau,g2,t_tide) - plot everything and cut to t_tide;
%fcp(tau,g2,N) - plot subset defined by N and cut to 1uS;
%fcp(tau,g2,N,t_tide) - plot subset and cut to t_tide;

function fcp(varargin)


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
        t_tide=min(tau1);
    else 
        N=1:1:size(g1,1);
        t_tide=varargin{3};
    end
end

if nargin==4
    N=varargin{3};
    t_tide=varargin{4};
end


if (min(tau1)<10^-6)
    [t,g2]=FCS_cut(tau1,g1,t_tide);
    min(t)
else
    t=tau1;
    g2=g1;
end




scrsz = get(0,'ScreenSize');
figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100]); clf;
for kk=1:1:3
    subplot(1,3,kk);hold all;
    for j=1:1:length(N)
        if j<8
            shadedErrorBar_zk(t,g2{N(j),kk+3},{'Color',darkcolor(j,:),'LineWidth',1});
        elseif j<15
            shadedErrorBar_zk(t,g2{N(j),kk+3},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',1});
        else
            shadedErrorBar_zk(t,g2{N(j),kk+3},{'Color',darkcolor(j-14,:),'LineStyle','-.','LineWidth',1});
        end

        xlabel('Tau [S]', 'FontSize', 14);
        ylabel('Correlation [A.U.]', 'FontSize', 14);
        if size(g2,2)>6
            my_L{j}=g2{N(j),7};
        end
    end
    if size(g2,2)>6
       legend(my_L);
    end
        box on;axis tight;
end    


