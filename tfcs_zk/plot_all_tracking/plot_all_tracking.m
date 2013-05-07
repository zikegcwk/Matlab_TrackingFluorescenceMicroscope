function plot_all_tracking(A,dt)

size_A=size(A);

N=size_A(1,1);

figure_number=floor(N/8);
%% plot fluo
for j=1:1:figure_number
    figure;
    for k=1:1:8
        subplot(2,4,k)
        drawplots3d_list(A((j-1)*8+k,1),dt,A((j-1)*8+k,2),A((j-1)*8+k,3),'fluo');
        axis tight;
        title(sprintf('%g',(j-1)*8+k));
    end
end
figure
for k=1:1:(N-figure_number*8)
        subplot(2,4,k)
        drawplots3d_list(A(figure_number*8+k,1),dt,A(figure_number*8+k,2),A(figure_number*8+k,3),'fluo');
        %semilogx(tau,A(figure_number*15+k,:));
        axis tight;
        title(sprintf('%g',figure_number*8+k));
end

%% plot stages
    for j=1:1:figure_number
    figure;
    for k=1:1:8
        subplot(2,4,k)
        drawplots3d_list(A((j-1)*8+k,1),dt,A((j-1)*8+k,2),A((j-1)*8+k,3),'stage');
        axis tight;
        title(sprintf('%g',(j-1)*8+k));
    end
end
figure
for k=1:1:(N-figure_number*8)
    subplot(2,4,k)
    drawplots3d_list(A(figure_number*8+k,1),dt,A(figure_number*8+k,2),A(figure_number*8+k,3),'stage');
    %semilogx(tau,A(figure_number*15+k,:));
    axis tight;
    title(sprintf('%g',figure_number*8+k));
end

%% daqout
for j=1:1:figure_number
figure;
for k=1:1:8
        subplot(2,4,k)
        drawplots3d_list(A((j-1)*8+k,1),dt,A((j-1)*8+k,2),A((j-1)*8+k,3),'daqout');
        %axis tight;
        title(sprintf('%g',(j-1)*8+k));
    end
end
figure
    for k=1:1:(N-figure_number*8)
        subplot(2,4,k)
        drawplots3d_list(A(figure_number*8+k,1),dt,A(figure_number*8+k,2),A(figure_number*8+k,3),'daqout');
        %semilogx(tau,A(figure_number*15+k,:));
        %axis tight;
        title(sprintf('%g',figure_number*8+k));
    end