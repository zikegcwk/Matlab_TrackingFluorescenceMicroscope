%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize parameters for which to gather data  

   
% signal parameters
% transition matrix, state 1 is red low (FRET low), state 2 is red high
a12 = 0.1;
a21 = 0.15;
A = [(1-a12) a12 ; a21 (1-a21)];

NMax = 10000;

%means and standard deviations of red or green channel in state 1 or 2
mr1   = 100;
mr2   = 150;
%         mr3   = 110;      mg3 = 125;
%         stdr3 = 5;      stdg3 = 5;
% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([2 1]);
E{1,1} = mr1;
E{2,1} = mr2;
%         E{3,1} = [mr3; stdr3]; E{3,2} = [mg3 ; stdg3];
fitChannelType = cell({'poisson'});
[pi,x] = HMMNoisy3_(A,E,'poisson',NMax);

confInt = 0.9;

%get times at which to recompute logs, log spaced
%get first time at which both transitions happened
tmin = find(cumsum(abs(diff(pi))) == 4,1,'first')+1;
tRecompList = unique(round(logspace(1,log10(NMax),200)'));
tRecompList(end+1) = tRecompList(end); %append this to make sure plot last interval
r = find(tRecompList >= tmin,1,'first');
tRecompList = tRecompList(r:end);

%get A values to try
NMesh = 10;
LengthRescale = 100; 
rescaleFactor = 2;
nTimesRescale = ceil(log(length(x)/LengthRescale)/log(rescaleFactor))+1; %number of times rescale mesh
aLimsList = cell([nTimesRescale 1]);
tRecompaLimits = tmin;
for i = 1:nTimesRescale,
    aLimsList{i}.tMax = min(LengthRescale*rescaleFactor^(i-1),tRecompList(end));
    if i > 1,
        [a12_lower,a12_upper] = GetConfBoundPointsA_(1,2,A,E,fitChannelType,confInt,x(1:tRecompaLimits));
        [a21_lower,a21_upper] = GetConfBoundPointsA_(2,1,A,E,fitChannelType,confInt,x(1:tRecompaLimits));
        a12_lower = a12_lower*0.8; a12_upper = a12_upper*1.2;
        a21_lower = a21_lower*0.8; a21_upper = a21_upper*1.2;
    else
        a12_lower = 0; a12_upper = a12*4;
        a21_lower = 0; a21_upper = a21*4;
    end
    aLimsList{i}.a12List = linspace(a12_lower,a12_upper,NMesh)';    
    aLimsList{i}.a21List = linspace(a21_lower,a21_upper,NMesh)';    
    tRecompaLimits = aLimsList{i}.tMax;
end
for t = 1:length(aLimsList),
    t
    r = find(tRecompList <= aLimsList{t}.tMax);
    lognormF_Mat = zeros(NMesh,NMesh,aLimsList{t}.tMax);
    for i = 1:NMesh,
        for j = 1:NMesh,
            a12try = aLimsList{t}.a12List(i);
            a21try = aLimsList{t}.a21List(j);
            Atry = [(1-a12try) a12try ; a21try (1-a21try)];
            [P,F,B,normF,normB,logPx] = Post_(Atry,E,fitChannelType,x(1:aLimsList{t}.tMax));
            lognormF_Mat(i,j,:) = log(normF);
        end
    end
    aLimsList{t}.lognormF_Mat = lognormF_Mat;
end

save Vary_Length_data.mat

% %plot confidence bound for each t value
% fig = figure('Position',[50 50 1400 800]);
% rect = get(fig,'Position');
% rect(1:2) = [0 0];
% pause(0.1)
% 
% clear Frames
% frames_ix = 1;
% 
% [Ptrace,F,B,normF,normB,logPx] = Post_(A,E,fitChannelType,x);
% tListMin_ix = 1;
% for t = 1:length(aLimsList),
%     t
%     tListMax_ix = find(tRecompList <= aLimsList{t}.tMax,1,'last')
%     
%     lognormF_Mat = aLimsList{t}.lognormF_Mat;
%     PMat = sum(lognormF_Mat(:,:,1:tRecompList(tListMin_ix)),3);
%     
%     a12List = aLimsList{t}.a12List;
%     a21List = aLimsList{t}.a21List;
%     for i = tListMin_ix:tListMax_ix-1,
%         %plot trace
%         subplot(3,4,1:4);
%         semilogx(1:1:length(x),x); hold on %plot trace weighted by log time
%         semilogx(1:1:tRecompList(i),(Ptrace(2,1:tRecompList(i))).*(E{2}(1)-E{1}(1)) + E{1}(1),'r-');
%         semilogx([1 1].*tRecompList(i),[min(x) max(x)],'k-'); hold on
%         xlabel('time')
%         ylabel('intensity')
%         axis([tmin max(tRecompList) min(x) max(x)])
%         
%         %plot confidence interval
%         subplot(3,4,[6 7 10 11]);
%         P = exp(PMat-max(max(PMat)));
%         imagesc(a12List,a21List,P'); colorbar('location','EastOutside'); hold on
%         plot(a12,a21,'gx');
%         plot(a12,a21,'ko','MarkerFaceColor',[1 1 1]);
%         contour(a12List,a21List,P',[(1-confInt) 0.9],'Color',[1 0 0]); hold off
%         colormap jet
%         title(['data likelihood up to t = ' num2str(tRecompList(i))]);
%         axis([0 a12*4 0 a21*4]);
%         set(gca,'YDir','normal');
%         PMat = PMat + sum(lognormF_Mat(:,:,tRecompList(i)+1:tRecompList(i+1)),3);
%         
%         Frames(frames_ix) = getframe(fig,rect);
%         frames_ix = frames_ix + 1;
%         
%         pause
%     end
%     tListMin_ix = tListMax_ix;
% end