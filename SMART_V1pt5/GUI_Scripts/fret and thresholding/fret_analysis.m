function [output1 output2]  = fret_analysis(temptrace,fret_spec)


%(data,xtalk, recalculate_dlt_G, new_trace_length,dltG_method,threshold_point,...
 %   recalculate_signal_to_noise,noise_cutoff,intensit_threshold)


%the following section will recalculate the dltaG for each molecule by
%fitting the trace two a two state gausian and it will not use more data
%than specified by the new_trace_length parameter.  For traces that are
%longer than the desired length, the two raw data files will be trimed down
%in a linear fashion






%extract a temp trace
%temps_spce = raw_data{1};
%temptrace  =  raw_data{2};



%smooth the using the specified averaging method

if strmatch('no', fret_spec.smooth, 'exact') == true
    
    % Do not average the trace

    
else
    
    temp = num2str(proc_spec.general_spec.smooth);
    temptrace(:,1) = smooth(temptrace(:,1),temp);
    temptrace(:,2) = smooth(temptrace(:,2),temp);

end



% calculate fret
x_talk = fret_spec.x_talk;
tempfret =  (temptrace(:,2)-x_talk*temptrace(:,1))./(temptrace(:,2)+temptrace(:,1)-x_talk*temptrace(:,1));


anomolous = find(tempfret < fret_spec.fret_cutoff(1));
tempfret(anomolous) = fret_spec.fret_cutoff(1);
anomolous = find(tempfret > fret_spec.fret_cutoff(2));
tempfret(anomolous) = fret_spec.fret_cutoff(2);


temptrace(:,3) = tempfret;







% tempy = x(:,[2:2:size(x,2)]);
% tempy = sum(tempy,2);
% 
% tempx = x(:,1)
% bar(tempx,tempy)






threshold_point = fret_spec.threshold;


%if strmatch('threshold', fret_spec.dltg_method, 'exact')


highposition = find(tempfret > threshold_point);
highfret = tempfret(highposition);
tempfret(highposition) = [];
lowfret  = tempfret;
equilibrium = size(highfret,1)/size(lowfret,1);



%end


% if strmatch('fit', fret_spec.dltg_method, 'exact')
%     
%     lowerbound = [0 0 0 0 0.3 0 ];
%     upperbound = [10000 .5 .6 10000 1 .6 ];
%     tweak = [100 0.15 0.1 100 0.8 0.15];
%     options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
%     
%     
%     [tempy tempx] = hist(tempfret,50);
%     histfit=lsqcurvefit(@gauss2,tweak,tempx,tempy,lowerbound,upperbound,options);
%     
%     equilibrium = histfit(4)/histfit(1);
%     
% end


    
if equilibrium == 0;
    equilibrium = 0.0000001;
end

if equilibrium == Inf;
    equilibrium = 10^7;
end

temp_dltg=-1.987*fret_spec.temp*log(equilibrium)/1000;


fret_summary.dltg = temp_dltg;


total_I = (temptrace(:,1)'+temptrace(:,2)'-fret_spec.x_talk*temptrace(:,1)'); 

fret_summary.mean_total_i = round(mean(total_I));


fret_summary.snr = NaN;
    
    
 output1 = temptrace;
 output2 = fret_summary;
    
       
 


