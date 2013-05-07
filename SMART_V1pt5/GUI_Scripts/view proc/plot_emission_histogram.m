function plot_emission_histogram(handles)




hmm_output = handles.view_data{7};
raw_data = handles.view_data{2};

nStates = size(hmm_output.A,1);
        
stateColors = varycolor(nStates);    
        
        means = zeros(nStates,size(raw_data,2));
        stdevs = zeros(nStates,size(raw_data,2));

        k = get(handles.popupmenu4,'Value'); % plot a selected chanel
        
        if k <=size(hmm_output.fitChannelType,2)
 
            for i = 1:nStates,
                if strcmp(hmm_output.fitChannelType(k),'gauss'),
                    means(i,k) = hmm_output.E{i,k}(1);
                    stdevs(i,k) = hmm_output.E{i,k}(2);
                elseif strcmp(hmm_output.fitChannelType(k),'poisson'),
                     means(i,k) = hmm_output.E{i,k}(1);
                     stdevs(i,k) = means(i,k);
                elseif strcmp(hmm_output.fitChannelType(k),'exp'),
                    means(i,k) = hmm_output.E{i,k}(1);
                    
                end
            end
        
        xmin = min(min(means-3.*stdevs));
        xmax = max(max(means+3.*stdevs));
        ymax = 1.2 * 1/(min(min(stdevs))*sqrt(2*pi));

        if strcmp(hmm_output.fitChannelType(k),'poisson')
           if xmin <0
               xmin = 0;
           end
            
        end
        
        legendString = [];
%        lifetimes
        
      
        %axes(handles.axes4)
        %cla;    
   
        
        binSpacing = round(100*(xmax-xmin)/200)/100;
        %binSpacing = (xmax-xmin)/200;
        
        binPositions = xmin:binSpacing:xmax;
        
        hist(handles.axes5,raw_data(:,k),binPositions)

        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','k','EdgeColor','k');
        % generate pdf weighted by state lifetimes
        pdfSpacing = binSpacing; %doesn't have to be the same as bin positions
        pointsAtWhichToPlotpdf = xmin:pdfSpacing:xmax;

        
        
        
         %[sig_i x] = hist( raw_data(:,k), xmin:binSpacing:xmax);
         %sig_i = sig_i / sum(sig_i);
         %bar(handles.axes5,x,sig_i)
         xlim(handles.axes5,[0 xmax])
         ylim('auto')
         temp_xlim = get(handles.axes5,'XLim');
         temp_ylim = get(handles.axes5,'YLim');
         
          
        %x = xmin:(xmax-xmin)/200:xmax;
       
        
        %lifetimes = 1./(1-diag(handles.view_data{7}.A));
        [v,D] = eigs((handles.view_data{7}.A)');
        r = find(abs(diag(D)-1) == min(abs(diag(D)-1)),1,'first');
        v = v(:,r); v = v./sum(v); %gets stationary distribution
        lifetimes = v;
        
        
        if nStates == 1
        
        lifetimes = 1; % temp for debug
        
        end
        
        ipdf = [];
            for i = 1:nStates,  
                
                if strcmp(hmm_output.fitChannelType(k),'gauss'),
                    y = lifetimes(i).*pdf('norm',pointsAtWhichToPlotpdf,means(i,k),stdevs(i,k));
                    %y = y./(sum(lifetimes));
                    %y = y*size(raw_data(:,k),1).*binSpacing;
                    
                    ipdf = [ipdf ; y];
                elseif strcmp(hmm_output.fitChannelType(k),'poisson'),
                    y = lifetimes(i).*pdf('poisson',round(pointsAtWhichToPlotpdf),means(i,k));
                    ipdf = [ipdf ; y];
                elseif strcmp(hmm_output.fitChannelType(k),'exp'),
                    y = lifetimes(i).*pdf('exp',x,means(i,k));
                    ipdf = [ipdf ; y];
 
                end
            end
                
              
            
            
            if strcmp(hmm_output.fitChannelType(k),'gauss'),
                
                ipdf = ipdf./(sum(lifetimes));
                ipdf = ipdf.*size(raw_data(:,k),1).*round(binSpacing);
                %ipdf = ipdf.*size(raw_data(:,k),1);
                
            elseif strcmp(hmm_output.fitChannelType(k),'poisson'),
                
                ipdf = ipdf./(sum(lifetimes));
                ipdf = ipdf.*size(raw_data(:,k),1).*round(binSpacing);
                %ipdf = ipdf.*size(raw_data(:,k),1);
                
            elseif strcmp(hmm_output.fitChannelType(k),'exp'),
            end
            
            
            
            
            
            
            
            

            
                hold(handles.axes5, 'on')
                p1 =plot(handles.axes5,pointsAtWhichToPlotpdf,ipdf,'-','LineWidth',3);
                ylim(handles.axes5,temp_ylim)
                xlim(handles.axes5,[0 xmax])
              
                for i=1:nStates
                
                set(p1(i),'Color', stateColors(i,:))
                end
                
                % hold on
               
              hold(handles.axes5, 'on')
               plot(handles.axes5,pointsAtWhichToPlotpdf, sum(ipdf),'--','Color','r','LineWidth',3);
               
               % hold on;
                
                legendString{i} = num2str(i);
                set(gca,'Color','w')
                xlabel('Intensity')
                ylabel('')
        else
           disp('Does not plot emission histograms simultaneously') 
        end