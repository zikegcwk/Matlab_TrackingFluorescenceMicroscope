function PlotPFits_(x,P,titleNum,pi)
    hold off
    subplot(2,1,1);
    hold off
    plot(x(:,1),'r-');
    if size(x,2) > 1,
        hold on
        plot(x(:,2),'g-');
    end
    axis([1 length(x) min(min(x)) max(max(x))]);
  
    subplot(2,1,2);
    plot((pi-1)./(size(P,1)-1),'r-','LineWidth',2);
    hold on
    plot(P(1,:),'k-','LineWidth',1);    
%     legendStrings = {'state','P(1)'};
    if size(P,1) > 1,
        plot(P(2,:),'g-','LineWidth',1);
%         legendStrings = [legendStrings 'P(2)'];
        if size(P,1) > 2,
            plot(P(3,:),'b-','LineWidth',1);
%             legendStrings = [legendStrings 'P(3)'];
            if size(P,1) > 3,
                plot(P(4,:),'m-','LineWidth',1);
%                 legendStrings = [legendStrings 'P(4)'];
            end
        end        
    end
    
    axis([1 length(x) -0.1 1.1]);
    
    title(num2str(titleNum));
%     legend(legendStrings);
    
%     pause