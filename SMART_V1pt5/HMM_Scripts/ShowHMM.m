function ShowHMM(A,E,fitChannelType,colored)
%shows HMM graphically, emission matrix E can be cell array or matrix  
nStates = size(A,1);

%get state lifetimes
lifetimes = 1./(1 - diag(A));

%set plot parameters  
stateCircR = 0.2;  
stateCircCent = [0.5 ; 0.5];
maxStateBoxEdge = 0.1;
minStateBoxEdge = 0.05;
stateBoxEdgeLengths = (lifetimes).*maxStateBoxEdge./max((lifetimes));
maxArrowWidth = 15;
minArrowWidth = 1;
allDispVector = [0 ; 0];
figureColor = [1 1 1].*0.9;

%get positions of states and arrows on circle
stateBoxPositions = zeros(nStates,2); %x and y positions of state boxes  
arrowStatePositions = zeros(nStates,nStates,4);
stateColors = zeros(nStates,3);
lineWidths = zeros(nStates,nStates);
deltaTheta = 2*pi/nStates;
thetaPhase = pi;
for i = 1:nStates,
    stateBoxPositions(i,1) = stateCircCent(1) + 1.5 * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);
    stateBoxPositions(i,2) = stateCircCent(2) + 1.5 * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
end
A = A.^1;
% Amin = min(min(A-diag(diag(A))));
% Amin = min(min(A));
Amin = min(min(A+eye(size(A)).*100))
Amax = max(max(A-diag(diag(A))))
% Amax = 1;
for i = 1:nStates,
    for j = 1:nStates,
        if i~=j,  
            lineWidths(i,j) = ((((A(i,j)-Amin)/(Amax-Amin)))) *(maxArrowWidth-minArrowWidth) + minArrowWidth;
%             lineWidths(i,j) = (A(i,j)/Amin)*minArrowWidth;
        end
    end
end
lineWidths
%set state colors
for i = 1:nStates,
    if i == 1,
        stateColors(i,:) = [0 1 0];
    elseif i == 2,
        stateColors(i,:) = [1 0 0];
    elseif i == 3,
        stateColors(i,:) = [0 0 1];
    elseif i > 3,
        stateColors(i,:) = random('unif',0.5,0.9,[1 3]);
    end
end

for i = 1:nStates,
    for j = 1:nStates,
        if i~=j,
            if colored,
                arrowScale = 1.5;
            else            
                arrowScale = 1.2;
            end
            arrowStatePositions(i,j,1) = stateCircCent(1) + arrowScale * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);% + 0.1 * stateCircR*
            arrowStatePositions(i,j,2) = stateCircCent(2) + arrowScale * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
      
            if i > j,
                s = -0.1;
            else
                s = 0.1;
            end
            arrowStatePositions(i,j,3) = stateCircCent(1) + arrowScale * stateCircR*cos((j-1)*deltaTheta+thetaPhase) + allDispVector(1);
            arrowStatePositions(i,j,4) = stateCircCent(2) + arrowScale * stateCircR*sin((j-1)*deltaTheta+thetaPhase) + allDispVector(2);
        
            dispVector = s*1*stateCircR.*[cos((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase) sin((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase)];
            arrowStatePositions(i,j,1) = arrowStatePositions(i,j,1) + dispVector(1) + allDispVector(1);
            arrowStatePositions(i,j,2) = arrowStatePositions(i,j,2) + dispVector(2) + allDispVector(2);
            arrowStatePositions(i,j,3) = arrowStatePositions(i,j,3) + dispVector(1) + allDispVector(1);
            arrowStatePositions(i,j,4) = arrowStatePositions(i,j,4) + dispVector(2) + allDispVector(2);
            
            %shorten arrows by 0.9
            
        end
    end
end
figure
% annotation('ellipse',[stateCircCent(1)-stateCircR stateCircCent(2)-stateCircR stateCircR*2 stateCircR*2],'Color',[0 0 0.5]);

%position transition arrows   
for i = 1:nStates,
    for j = 1:nStates,
        if i~=j, %do not show transitions back to state  
            if colored
                annotation('line',[arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)],...
                    'Color',stateColors(i,:),'LineWidth',lineWidths(i,j));
            else
                annotation('arrow',[arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)],...
                    'HeadStyle','plain','HeadWidth',lineWidths(i,j)*2,'LineWidth',lineWidths(i,j));
            end
        end
    end
end
% stateColors
%position states around circle
for i = 1:nStates,  
    if colored,
        bColor = stateColors(i,:);
    else
        bColor = [1 1 1].*0.9;
    end
    annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
        'BackgroundColor',bColor.*0.9);
    annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
        'BackgroundColor','none','EdgeColor','none','Color',[0 0 0],'String',num2str(i),...
        'HorizontalAlignment','Center','VerticalAlignment','Middle');
end

set(gcf,'Color',figureColor);

%plot emission distributions
%if E{n,c}(p) has p max 1, then treats as poisson distribution  
    if ~isempty(E), 
        figure
        
        set(gca,'Color',figureColor);

        means = zeros(nStates,2);
        stdevs = zeros(nStates,2);

        for k = 1:2, %k from 1 to numChannels
            for i = 1:nStates,
                if strcmp(fitChannelType(k),'gauss'),
                    means(i,k) = E{i,k}(1);
                    stdevs(i,k) = E{i,k}(2);
                elseif strcmp(fitChannelType(k),'exp'),
                    means(i,k) = E{i,k}(1);
                    stdevs(i,k) = means(i,k);
                end
            end
        end
        xmin = min(min(means-3.*stdevs));
        xmax = max(max(means+3.*stdevs));
        ymax = 1.2 * 1/(min(min(stdevs))*sqrt(2*pi))

        legendString = [];
        lifetimes
        for k = 1:2,
            subplot(3,1,k);
            for i = 1:nStates,  
                x = linspace(xmin,xmax,200)';
                if strcmp(fitChannelType(k),'gauss'),
                    y = pdf('norm',x,means(i,k),stdevs(i,k));
                elseif strcmp(fitChannelType(k),'exp'),
                    y = pdf('exp',x,means(i,k));
                end
                plot(x,y,'-','Color',stateColors(i,:),'LineWidth',1); hold on;
                legendString{i} = num2str(i);
            end
%                 axis([xmin xmax 0 ymax]);
            if k == 1,
                title('donor signal pdfs');
                legend(legendString);
%                 xlabel('donor signal');
            elseif k == 2,
                title('acceptor signal pdfs');
%                 xlabel('acceptor signal');
            end
        end
        
        %plot FRET histogram (valid only for both channels of 'gauss' type)
        subplot(3,1,3);
        
        tic
        npoints = 100000;
        ahist = zeros(npoints,nStates);
        dhist = zeros(npoints,nStates);
        frethist = zeros(npoints,nStates);
        for i = 1:nStates,
            dhist(:,i) = random('norm',means(i,1),stdevs(i,1),[npoints 1]);
            ahist(:,i) = random('norm',means(i,2),stdevs(i,2),[npoints 1]);
            frethist(:,i) = ahist(:,i)./(dhist(:,i)+ahist(:,i));
        end
        [min(mean(frethist)-sqrt(var(frethist)).*3) max(mean(frethist)+sqrt(var(frethist)).*3)]
        fretbins = linspace(min(mean(frethist)-sqrt(var(frethist)).*3),max(mean(frethist)+sqrt(var(frethist)).*3),50)';
%         fretbins = linspace(min(min(frethist)),max(max(frethist)),100)';
        fretcounts = zeros(size(fretbins));
        for i = 1:nStates,
            n = hist(frethist(:,i),fretbins)';
            fretcounts = fretcounts + n * lifetimes(i);
        end
        plot(fretbins,fretcounts,'b.-','LineWidth',1);
% 
% 
%         ahist = random('norm',means(1,1),stdevs(1,1),[100000 1]);
%         dhist = random('norm',means(1,2),stdevs(1,2),[100000 1]);
        toc
%         hist(ahist./(ahist+dhist),100);

%         plot(x,y,'b-','LineWidth',3);
        title('FRET histogram');
        
    end
    
    function p = GaussianRatiopdf(mu1,mu2,s1,s2,z)
        a = sqrt(z.^2 ./ s1^2 + 1 / s2^2);
        b = (mu1/s1^2).*z + mu2/s2^2;
        c = exp((1/2).*(b.^2 ./ a.^2) - (1/2)*(mu1^2 / s1^2 + mu2^2 / s2^2));
        Phitoint = @(u) (1/sqrt(2*pi)).*exp(-(1/2).*u.^2);
        Phi = zeros(size(z));
        for i = 1:length(z),
            Phi(i) = quad(Phitoint,-100,b(i)/a(i));
        end
        p = (b.*c./(a.^3)).*(1./(sqrt(2*pi)*s1*s2)).*(2.*Phi - 1) + (1./(a.^2 .*pi.*s1.*s2)).*exp(-0.5*(mu1^2/s1^2 + mu2^2 / s2^2));