%function plot_all_fcs takes tau and a matrix g2 and plot all the fcs
%curves in g2 as a function of tau. Ok. so g2 is size of (number of curves, number of points in each curve)

function plot_all_fcs(tau,g2)

A=g2;


size_A=size(A);

N=size_A(1,1);

figure_number=floor(N/15);

for j=1:1:figure_number
    figure;
    for k=1:1:15
        subplot(3,5,k)
        semilogx(tau,A((j-1)*15+k,:));
        axis tight;
        title(sprintf('%g',(j-1)*15+k));
    end
end


figure

    
    for k=1:1:(N-figure_number*15)
        subplot(3,5,k)
        semilogx(tau,A(figure_number*15+k,:));
        axis tight;
        title(sprintf('%g',figure_number*15+k));
    end

        