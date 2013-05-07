load Vary_Length_data.mat

%plot confidence bound for each t value
rect = [50 50 1400 800];
rect2 = rect;%[50 50 1360 760];
fig = figure('Position',rect);
pause(0.1)

f = getframe(fig,rect2);
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,5) = 0;

[Ptrace,F,B,normF,normB,logPx] = Post_(A,E,fitChannelType,x);
tListMin_ix = 1;
for t = 1:length(aLimsList),
    tListMax_ix = find(tRecompList <= aLimsList{t}.tMax,1,'last');
    
    lognormF_Mat = aLimsList{t}.lognormF_Mat;
    PMat = sum(lognormF_Mat(:,:,1:tRecompList(tListMin_ix)),3);
    
    a12List = aLimsList{t}.a12List;
    a21List = aLimsList{t}.a21List;
    for i = tListMin_ix:tListMax_ix-1,
        %plot trace
        subplot(3,4,1:4);
        semilogx(1:1:length(x),x); hold on %plot trace weighted by log time
        semilogx(1:1:tRecompList(i),(Ptrace(2,1:tRecompList(i))).*(E{2}(1)-E{1}(1)) + E{1}(1),'r-');
        semilogx([1 1].*tRecompList(i),[min(x) max(x)],'k-'); hold off
        xlabel('time')
        ylabel('intensity')
        axis([tmin max(tRecompList) min(x) max(x)])
        
        %plot confidence interval
        subplot(3,4,[6 7 10 11]);
        P = exp(PMat-max(max(PMat)));
        imagesc(a12List,a21List,P'); colorbar('location','EastOutside'); hold on
        plot(a12,a21,'gx');
        plot(a12,a21,'ko','MarkerFaceColor',[1 1 1]);
        contour(a12List,a21List,P',[(1-confInt) 0.9],'Color',[1 0 0]); hold off
        colormap jet
        set(gca,'Color',[0 0 1].*0.5625);
        title(['data likelihood up to t = ' num2str(tRecompList(i))]);
        axis([0 a12*4 0 a21*4]);
        set(gca,'YDir','normal');
        PMat = PMat + sum(lognormF_Mat(:,:,tRecompList(i)+1:tRecompList(i+1)),3);
        
        f = getframe(fig,rect2);
        im(:,:,1,i) = rgb2ind(f.cdata,map,'nodither');
        pause(0.1);
    end
    tListMin_ix = tListMax_ix;
end
imwrite(im,map,'VaryLength.gif','DelayTime',0.1,'LoopCount',inf) %g443800