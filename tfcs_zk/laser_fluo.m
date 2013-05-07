function laser_fluo(g2)
r=1.65/0.35 ;
qA=0.3;
w=1;
for j=1:1:size(g2,1)
    %10th col is the fluorescence rate in unit of number of photons per
    %10mS
    for k=1:1:size(g2{j,10},2)
        a(k)=mean(g2{j,10}{k}{1});
        std_a(k)=std(g2{j,10}{k}{1});
        d(k)=mean(g2{j,10}{k}{2});
        std_d(k)=std(g2{j,10}{k}{2});
    end
    %8th col is the laser power, with mean and std
    for kk=1:1:size(g2{j,8},1)
        lsr(kk)=g2{j,8}(kk,1);
        std_lsr(kk)=g2{j,8}(kk,2);
        all_lsr(w)=lsr(kk);
        w=w+1;
    end    
    
    
    figure(110);
    subplot(1,3,1);hold on;
    scatter(lsr,a,'r');
    title('acceptor channel')
    subplot(1,3,2);hold on;
    scatter(lsr,d);
    title('donor channel')
    subplot(1,3,3);hold on;
    scatter(lsr,a+d)
    title('sum channel');
    
 
    
    figure(111);hold on;
    title('FRET E')
    subplot(1,2,1);hold on;
    errorbar(j,mean(a./(a+d)),std(a./(a+d)))
    subplot(1,2,2);hold on;
    errorbar(j,mean(a.*(1+r)./(r*qA*d+a*r)),std(a.*(1+r)./(r*qA*d+a*r)));
%     figure(112);
%     subplot(2,4,j);
%     hist(a./(a+d));
%     title(g2{j,7});
%     figure(113);hold on;title('laser power')
%     errorbar(j,mean(lsr),std(lsr))
%     
end
% 
% 
% 
%     figure(114);
%     hold on;
%     hist(all_lsr,0:0.05:1)





