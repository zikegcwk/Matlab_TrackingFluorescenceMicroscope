%function draw_fcs takes tau and g2 and plot the fcs data. 
%note that g2 can be k by N, in which k is the number of FCS traces and N
%is the number of data points in each fcs curve.

function [tau,ave_g2,std_g2,h]=draw_fcs(tau,g2,color,plot_flag)



if nargin==2
    color=1;
    plot_flag=1;
end

if nargin==3
    plot_flag=1;
end

if color == 1;
    paint=[235/255,255/255,235/255];
elseif color ==2;
    paint=[201/255,201/255,201/255];
elseif color ==3;
    paint=[255/255,240/255,245/255];
elseif color ==4;
    paint=[255/255,222/255,173/255];
elseif color ==5;
    paint=[230/255,230/255,250/255];
elseif color ==6;
    paint=[255/255,250/255,205/255];
    
    
end



ave_g2=mean(g2);
k=size(g2);
std_g2=std(g2/k(1,1)^0.5,0,1);
if plot_flag
h=figure('Name',cd);

% h1=area(tau,ave_g2+std_g2,'FaceColor',[1,0,0],'EdgeColor',[1,0,0]);
% set(gca,'Xscale','log')
% hold on;
% %figure
% h2=fill(tau,ave_g2-std_g2,'FaceColor',[0,1,0],'EdgeColor',[1,1,0]);
% min(ave_g2-std_g2)
% set(h1,'BaseValue',min(ave_g2-std_g2))
% set(h2,'BaseValue',min(ave_g2-std_g2))
% set(gca,'Layer','top')
% plot(tau,ave_g2,'Color',[1,1,1])
% set(gca,'Xscale','log')

top_fill=[ave_g2+std_g2 ave_g2(length(tau))+std_g2(length(tau)) min(ave_g2-std_g2) min(ave_g2-std_g2) ];
bottom_fill=[ave_g2-std_g2 ave_g2(length(tau))-std_g2(length(tau)) min(ave_g2-std_g2) min(ave_g2-std_g2) ];

tau_fill=[tau max(tau) max(tau) min(tau) ];



fill(tau_fill,top_fill,paint,'EdgeColor','k')

hold on;
fill(tau_fill,bottom_fill,'w','EdgeColor','k')
axis([min(tau) max(tau) min(ave_g2-std_g2) max(ave_g2+std_g2)]);
set(gca,'Xscale','log')
plot(tau,ave_g2,'Color','r','LineWidth',1)
box on;
else
    h=0;
end

if nargout == 0,
    clear('tau','ave_g2','std_g2','h');
end;

if nargout==3,
    clear('h');
end


