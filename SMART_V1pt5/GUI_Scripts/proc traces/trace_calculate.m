function output  = trace_calculate(raw_data,proc_spec)


%(data,xtalk, recalculate_dlt_G, new_trace_length,dltG_method,threshold_point,...
 %   recalculate_signal_to_noise,noise_cutoff,intensit_threshold)


%the following section will recalculate the dltaG for each molecule by
%fitting the trace two a two state gausian and it will not use more data
%than specified by the new_trace_length parameter.  For traces that are
%longer than the desired length, the two raw data files will be trimed down
%in a linear fashion






%extract a temp trace
temps_spce = raw_data{1};
temptrace  =  raw_data{2};


%smooth the using the specified averaging method

if strmatch('no', proc_spec.general_spec.smooth, 'exact')
    
    % Do not average the trace

    
else
    
    temp = num2str(proc_spec.general_spec.smooth);
    temptrace(:,1) = smooth(temptrace(:,1),temp);
    temptrace(:,2) = smooth(temptrace(:,2),temp);

end







% calculate fret
x_talk = ave_param.table{1,2};
tempfret =  (temptrace(:,2)-x_talk*temptrace(:,1))./(temptrace(:,2)+temptrace(:,1)-x_talk*temptrace(:,1));


anomolous = find(tempfret < -0.3);
tempfret(anomolous) = -0.3;
anomolous = find(tempfret > 1.3);
tempfret(anomolous) = 1.3;


temptrace(:,3) = tempfret;








% Impute Values
tempfret = ave_trace(:,3);
threshold_point = mean([ave_param.table{13,2} ave_param.table{14,2}]);




highposition = find(tempfret > threshold_point);
highfret = tempfret(highposition);
tempfret(highposition) = [];
lowfret  = tempfret;
equilibrium(1) = size(highfret,1)/size(lowfret,1);



if  ave_param.table{5,2} == 2;
    
    lowerbound = [0 0 0 0 0.3 0 ];
    upperbound = [10000 .5 .6 10000 1 .6 ];
    tweak = [100 0.15 0.1 100 0.8 0.15];
    options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
    
    
    [tempy tempx] = hist(tempfret,50);
    histfit=lsqcurvefit(@gauss2,tweak,tempx,tempy,lowerbound,upperbound,options);
    
    equilibrium(2) = histfit(4)/histfit(1);
    
end


temp = ave_param.table{3,2};
temp_dltg = zeros(1,2);
for i=1:size(equilibrium,2)
    
    if equilibrium(i) == 0;
       equilibrium(i) = 0.0000001;
    end
    
    if equilibrium(i) == Inf;
       equilibrium(i) = 10^7;
    end
    
    temp_dltg(i)=-1.987*temp*log(equilibrium(i))/1000;
    
end


dltg.thresh=temp_dltg(1);
dltg.fit=temp_dltg(2);
therm_sum = dltg;
therm_sum.temp = temp;

    
total_I = (ave_trace(:,1)'+ave_trace(:,2)'-ave_param.table{1,2}*ave_trace(:,1)'); 
therm_sum.mean_total_i = mean(total_I);



total_I_signal = [];
total_I_av = total_I;
ind_max = find(total_I,1,'last');%SergeyDec2007 made averaging before finding Imax, should avoide spikes better
for ind=20:(ind_max-10)
    if total_I(ind)>ave_param.table{6,2} %SERGEY - threshold for "real" signal, still better use human judgement here
        total_I_signal = [total_I_signal total_I(ind)];
    end
  total_I_av(1,ind) = sum(total_I(1,ind:ind+9))/10;%Sergey replaced with forward running average over 10 points
%(total_I(ind-2)+total_I(ind-1)+total_I(ind)+total_I(ind+1)+total_I(ind+2))/5;
end

%SERGEY try calculating SNR here
[total_I_hist,total_I_out] = hist(total_I_signal,30);

for p=2:30
    total_I_hist(p) = total_I_hist(p-1)+total_I_hist(p);
end
total_I_hist = total_I_hist/total_I_hist(30);
total_I_middle = total_I_out(find(total_I_hist>=0.5,1,'first'));
total_I_sigma = (total_I_out(find(total_I_hist>=0.83,1,'first')) - total_I_out(find(total_I_hist>=0.17,1,'first')))/2;

SNR = round(total_I_middle/total_I_sigma*10)/10;

therm_sum.ser_snr = SNR;
therm_sum.nois_cutoff = ave_param.table{6,2};
     %recalculated{i,29} = [recalculated{i,24} SNR signal_to_noise];
%     recalculated{i,24} = [recalculated{i,24} SNR signal_to_noise];
    
    




output1 = {dltg SNR};
output2 = therm_sum;
    
    
    
    
% end   
%     end
%     
%     
%     
%        if recalculate_signal_to_noise(2) == 2
%            
%        %to_calc_sn = data(:,10);
%        
%        
%        for i=1:size(data,1)
%            
%            temp_trace = data{i,10}
%            
%            
%            close all
%           
%            figure('WindowStyle', 'docked')
%            plot(temp_trace(:,1),'r')
%            hold
%            plot(temp_trace(:,2),'g')
%            
%            figure('WindowStyle', 'docked')
%            hist(temp_trace(:,1),50)
%            figure('WindowStyle', 'docked')
%            
%            
%            
%            
% pdf_normmixture = @(x,p,mu1,mu2,sigma1,sigma2) ...
%                          p*normpdf(x,mu1,sigma1) + (1-p)*normpdf(x,mu2,sigma2);
%            
%                      
% x = hist(temp_trace(:,2),-100:100:1500)
%                      
% pStart = .5;
% muStart = quantile(x,[.25 .75])
% sigmaStart = sqrt(var(x) - .25*diff(muStart).^2)
% start = [pStart muStart sigmaStart sigmaStart];
% 
% 
% lb = [0 -Inf -Inf 0 0];
% ub = [1 Inf Inf Inf Inf];
% 
% options = optimset('MaxIter',300, 'MaxFunEvals',600);  
% 
% paramEsts = mle(x, 'pdf',pdf_normmixture, 'start',start, 'lower',lb, 'upper',ub)
%  
% 
% bins = -2.5:.5:7.5;
% h = bar(bins,histc(x,bins)/(length(x)*.5),'histc');
% set(h,'FaceColor',[.9 .9 .9]);
% xgrid = linspace(1.1*min(x),1.1*max(x),200);
% pdfgrid = pdf_normmixture(xgrid,paramEsts(1),paramEsts(2),paramEsts(3),paramEsts(4),paramEsts(5));
% hold on; plot(xgrid,pdfgrid,'-'); hold off
% xlabel('x'); ylabel('Probability Density');
% 
% 
% tweak = [100 0.15 0.1 100 0.8 0.15];
% options = optimset('Display','iter','TolFun',1e-12);  
% options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
% histfit=lsqcurvefit(@gauss2,tweak,A(:,1),A(:,2),lbound,ubound,options);
% output = histfit;
% bounded = [output(3) output(6)]
% 
% 
%            
%            
%            
%            
%            
%        end
%     
    
    
    
    
       
 


