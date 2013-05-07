function n = corr_CR(data1,data2,x,ndiffs)
% corr_CR(data1,data2,x,ndiffs) returns a histogram of pairs of arrival
% times using simple time tag differences t(i+k)-t(i) up to k = ndiffs.  It is useful for
% calculating g2(tau) for short timescales tau << 1/detection rate.  x is
% an array of delay lags tau.  To plot simply use plot(x,n).  Chandra Raman
% 7/20/09
npts = length(x);       % number of time lags to compute
n = zeros(1,npts);
for i=1:ndiffs
n = n+histc(mydiff_CR(sort([data1 data2]),i),x)-histc(mydiff_CR(data1,i),x)-histc(mydiff_CR(data2,i),x);
end
return;


