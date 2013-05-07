function [ave_dt,ave_dx,ave_dy,ave_dz]=plot_all_msd(dt,dx,dy,dz,T)
temp=size(dt);
N=temp(1,1);



figure_number=floor(N/15);

for j=1:1:figure_number
    figure;
    for k=1:1:15
        subplot(3,5,k)
        semilogx(dt((j-1)*15+k,:),dx((j-1)*15+k,:),'b');
        hold on;
        semilogx(dt((j-1)*15+k,:),dy((j-1)*15+k,:),'g');
        semilogx(dt((j-1)*15+k,:),dz((j-1)*15+k,:),'r');
        axis tight;
        title(sprintf('%g',(j-1)*15+k));
        set(gca,'Xscale','log');
    end
end


figure


for k=1:1:(N-figure_number*15)

    subplot(3,5,k)
    semilogx(dt(figure_number*15+k,:),dx(figure_number*15+k,:),'b');
    hold on;
    semilogx(dt(figure_number*15+k,:),dy(figure_number*15+k,:),'g');
    semilogx(dt(figure_number*15+k,:),dz(figure_number*15+k,:),'r');
    axis tight;
    title(sprintf('%g',figure_number*15+k));
    set(gca,'Xscale','log');
end

figure;
ave_dt=mean(dt,1);
ave_dx=ave_msd(dx,T);
ave_dy=ave_msd(dy,T);
ave_dz=ave_msd(dz,T);
semilogx(ave_dt,ave_dx,'b','LineWidth',2);
hold on;
semilogx(ave_dt,ave_dy,'g','LineWidth',2);
semilogx(ave_dt,ave_dz,'r','LineWidth',2);