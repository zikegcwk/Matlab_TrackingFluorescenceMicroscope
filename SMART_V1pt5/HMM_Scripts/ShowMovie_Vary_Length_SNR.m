load Vary_Length_SNR_data.mat

%% plot confidence regions
rect = [50 50 1400 800];
rect2 = rect;%[50 50 1360 760];
fig = figure('Position',rect);
pause(0.1)

% aviobj = avifile('sample102.avi','Compression','Indeo5');
% aviobj.quality = 100;

f = getframe(fig,rect2);
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,5) = 0;

for i = 1:length(SNRList),
    subplot(3,4,1:4);
    postFit = outputs{i}.postFit;
    stretchFactor = 1;
    mu2_plot = mu2List(i)+stretchFactor*2*sqrt(mu2List(i));
    mu1_plot = mu1 - stretchFactor*2*sqrt(mu1);
    postFit = (postFit(2,:)).*(mu2_plot - mu1_plot) + mu1_plot;
    loglog(1:1:length(postFit),postFit,'k-','LineWidth',3,'Color',[1 1 1].*0.6); hold on
    loglog(1:1:round(TList(i)),xList{i}.x,'b-');
    loglog(1:1:round(TList(i)),xList{i}.xnoiseless_stretched,'r-');
    loglog([1 1].*round(TList(i)),[mu1-3*sqrt(mu1) mu2List(i)+3*sqrt(mu2List(i))],'k-'); hold off
    legend('inferred fit','signal','true state','Location','NorthEast');

    xlabel('time')
    ylabel('intensity')
    axis([10 TList(end) mu1-3*sqrt(mu1) mu2List(i)+3*sqrt(mu2List(i))])
    title(['T = ' num2str(round(TList(i))) ', SNR = ' num2str(SNRList(i))]);
    
    %plot confidence interval
    subplot(3,4,[6 7 10 11]);
    if SNRList(i) >= SNRManual,
        errorBounds = outputs{i}.errorBoundsAuto;
    else
        errorBounds = outputs{i}.errorBoundsManual;
    end
    
    a12List = errorBounds.var1region;
    a21List = errorBounds.var2region;
    P = errorBounds.PMat; P = P./max(max(P));
    
    imagesc(a12List,a21List,P'); colorbar('location','EastOutside'); hold on
    plot(a12,a21,'gx');
    plot(a12,a21,'ko','MarkerFaceColor',[1 1 1]);
    contour(a12List,a21List,P',[(1-confInt) 0.9],'Color',[1 0 0]); hold off
    colormap jet
    set(gca,'Color',[0 0 1].*0.5625);
    title(['data likelihood']);
    axis([0 1 0 1]);
    set(gca,'YDir','normal');
    
    f = getframe(fig,rect2);
    im(:,:,1,i) = rgb2ind(f.cdata,map,'nodither');
    
    pause(0.1)
end
imwrite(im,map,'VaryLengthSNR.gif','DelayTime',0.1,'LoopCount',inf) %g443800