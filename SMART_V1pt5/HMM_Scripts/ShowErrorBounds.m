function ShowErrorBounds(output,autoormanual)
if strcmp(autoormanual,'auto'),
    eB = output.errorBoundsAuto;
elseif strcmp(autoormanual,'manual'),
    eB = output.errorBoundsManual;
end
numSubplots1D = 0;
for i = 1:length(eB),  
    if eB(i).dimension == 2,
        %% get plotbounds
        var1region = eB(i).var1region;
        var2region = eB(i).var2region;
        if strcmp(eB(i).var1name(1),'a'),
            var1plot = [0 ; (var1region+[diff(var1region)./2 ; 0])];
            var1plot(1) = max(2*var1region(1)-var1plot(2),0);
            var1plot(end) = min(2*var1region(end)-var1plot(end-1),1);
        elseif strcmp(eB(i).var1name(1),'e'),
            var1plot = [0 ; (var1region+[diff(var1region)./2 ; 0])];
            var1plot(1) = 2*var1region(1)-var1plot(2);
            var1plot(end) = 2*var1region(end)-var1plot(end-1);
        end
        if strcmp(eB(i).var2name(1),'a'),
            var2plot = [0 ; (var2region+[diff(var2region)./2 ; 0])];
            var2plot(1) = max(2*var2region(1)-var2plot(2),0);
            var2plot(end) = min(2*var2region(end)-var2plot(end-1),1);
        elseif strcmp(eB(i).var2name(1),'e'),
            var2plot = [0 ; (var2region+[diff(var2region)./2 ; 0])];
            var2plot(1) = 2*var2region(1)-var2plot(2);
            var2plot(end) = 2*var2region(end)-var2plot(end-1);
        end
        
        %% colored blocks plot
        figure
%         subplot(2,1,1);
        PtoPlot = zeros(size(eB(i).PMat)+1); PtoPlot(1:end-1,1:end-1) = eB(i).PMat;
        
        pcolor(var2plot,var1plot,PtoPlot); colorbar
        
        if strcmp(eB(i).var1name(1),'a'),
            [r,c] = GetNumsFromString_(eB(i).var1name);
            val_y = output.A(r,c);
        elseif strcmp(eB(i).var1name(1),'e'),
            [n,c,p] = GetNumsFromString_(eB(i).var1name);
            val_y = output.E{n,c}(p);
        end
        ylabel({eB(i).var1name,['estimated ' eB(i).var1name ' = ' num2str(val_y)]});
        if strcmp(eB(i).var2name(1),'a'),
            [r,c] = GetNumsFromString_(eB(i).var2name);
            val_x = output.A(r,c);
        elseif strcmp(eB(i).var2name(1),'e'),
            [n,c,p] = GetNumsFromString_(eB(i).var2name);
            val_x = output.E{n,c}(p);
        end
        xlabel({eB(i).var2name,['estimated ' eB(i).var2name ' = ' num2str(val_x)]});

        title(['data likelihood dependence on ' eB(i).var1name ' and ' eB(i).var2name ', normalized to max 1']);
        shading flat
%         daspect([1 1 1]);
        hold on
        %calculate contour bound
        threshTemp = sort(reshape(eB(i).PMat,[prod(size(eB(i).PMat)) 1]),'descend');
        r = find(cumsum(threshTemp) > (output.auto_confInt*sum(threshTemp)),1,'first');
        confIntTemp = 1-threshTemp(r);
        confIntTemp = output.auto_confInt;
        
        [C,h] = contour(var2region,var1region,eB(i).PMat,(1-confIntTemp),'Color',[1 0 1]);
        text_handle = clabel(C,h);
        set(text_handle,'Color',[1 1 1]);
        axis([var2region(1) var2region(end) ...
            var1region(1) var1region(end)]);
        text(val_x,val_y,'+','Color',[1 1 1],'VerticalAlignment','Middle','HorizontalAlignment','Center');

        %% contour plot
        figure
%         subplot(2,1,2)
        contourf(var2region,var1region,eB(i).PMat,[0 linspace((1-confIntTemp),1,6)]); colorbar;
        hold on;
        
        [C,h] = contour(var2region,var1region,eB(i).PMat,(1-confIntTemp));
        text_handle = clabel(C,h);
        set(text_handle,'Color',[1 1 1]);
        % set(text_handle,'BackgroundColor',[1 1 1],'Edgecolor',[1 1 1]);
        ylabel({eB(i).var1name,['estimated ' eB(i).var1name ' = ' num2str(val_y)]});
        xlabel({eB(i).var2name,['estimated ' eB(i).var2name ' = ' num2str(val_x)]});
        text(val_x,val_y,'+','Color',[1 1 1],'VerticalAlignment','Middle','HorizontalAlignment','Center');
        title(['data likelihood dependence on ' eB(i).var1name ' and ' eB(i).var2name ', normalized to max 1']);
%         daspect([1 1 1])
    elseif eB(i).dimension == 1,
        numSubplots1D = numSubplots1D + 1;
    end
end
if numSubplots1D > 0,
    figure
    title('data likelihood dependence on some parameters, normalized to max 1');
    j = 1;
    for i = 1:length(eB),
        if eB(i).dimension == 1,  
            subplot(numSubplots1D,1,j);
            plot(eB(i).var1region,eB(i).PMat,'b.-'); hold on        
            if strcmp(eB(i).var1name(1),'a'),
                [r,c] = GetNumsFromString_(eB(i).var1name);
                val_x = output.A(r,c);
            elseif strcmp(eB(i).var1name(1),'e'),
                [n,c,p] = GetNumsFromString_(eB(i).var1name);
                val_x = output.E{n,c}(p);
            end
            xlabel({eB(i).var1name,['estimated ' eB(i).var1name ' = ' num2str(val_x)]});
    %         plot([val_x ; val_x],[0 ; 1],'k-');
            
            title(['data likelihood dependence on ' eB(i).var1name ', normalized to max 1']);
            axis([eB(i).var1region(1) eB(i).var1region(end) 0 max(eB(i).PMat)]);
            
            
            threshTemp = sort(eB(i).PMat,'descend');
            r = find(cumsum(threshTemp) > (output.auto_confInt*sum(threshTemp)),1,'first');
            confIntTemp = 1-threshTemp(r);
            line([eB(i).var1region(1) eB(i).var1region(end)],[(1 - confIntTemp) (1 - confIntTemp)],'Color',[0.5 0.5 0.5]);
            
            j = j + 1;            
        end
    end 
end