%function t_tide_search looks into g2 (cell) and try to find a t_tide point
%that can minimize the average point differences in the autocorrelation g2. 
function t_tide_search(tau,data,ref,tau_range)

tauR_index=find(tau>tau_range(1)&tau<tau_range(2));


for j=1:1:length(tauR_index)
    [N(j),val(j)]=scale(data(tauR_index(j):end),ref(tauR_index(j):end));
    val(j)=val(j);
    d(j)=length(data(tauR_index(j):end));
end

tau(tauR_index(find(min(val))))

figure;

semilogx(tau(tauR_index),val./d)
figure
semilogx(tau(tauR_index),d)

% 
% 
% function d=data_ref_diff(ref,data,cc)
% 
% temp_d=(cc*data-ref).^2;
% d=sum(tem_d);
