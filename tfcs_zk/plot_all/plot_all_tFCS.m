%plot_all_tFCS(tau99,C427Cls{8,5},C427Cls{8,9},C427list{8},C427Cls{8,8})
function plot_all_tFCS(tau,A,T,siglist,laser)

if nargin==3
    plot_laser=0;
else
    plot_laser=1;
end

size_A=size(A);

N=size_A(1,1);

figure_number=floor(N/15);

for j=1:1:figure_number
    figure;
    for k=1:1:15
        subplot(3,5,k)
        semilogx(tau,A((j-1)*15+k,:));
        hold on;
        semilogx(tau,ave_msd(A,T),'r');
        axis tight;
        if plot_laser
            title(sprintf('data%6.3g(%6.3g-%6.3g),\nL:%6.3g(%6.3g),T:%6.3g',siglist((j-1)*15+k,1),siglist((j-1)*15+k,2),siglist((j-1)*15+k,3),laser((j-1)*15+k,1),laser((j-1)*15+k,2),T((j-1)*15+k)));
        else
            title(sprintf('%g',(j-1)*15+k));
        end
        set(gca,'XScale','log')
    end
end


figure

    
    for k=1:1:(N-figure_number*15)
        subplot(3,5,k)
        semilogx(tau,A(figure_number*15+k,:));
        hold on;
        semilogx(tau,ave_msd(A,T),'r');
        axis tight;
        if plot_laser
           title(sprintf('data%g(%g-%g),L:%g(%g),T:%g',siglist(figure_number*15+k,1),siglist(figure_number*15+k,2),siglist(figure_number*15+k,3),laser(figure_number*15+k,1),laser(figure_number*15+k,2),T(figure_number*15+k)));
        else
           title(sprintf('%g',figure_number*15+k));
           %title(sprintf('%g',figure_number*15+k));
        end
        set(gca,'XScale','log')
    end

        