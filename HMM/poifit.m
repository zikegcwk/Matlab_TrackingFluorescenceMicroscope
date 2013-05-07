%this is a function that fits the poission pdf, give data x.
%data x is organized as index being the random variable and its probability
%density is given by the value in the x array. 
function [coefEsts,h,p]=poifit(x,plot_flag)


modelFun =  @(p,x) p.^x .* exp(-p)./factorial(x);
startingVals = find(x==max(x))
[coefEsts,r] = nlinfit(1:1:length(x), x, modelFun, startingVals);

if plot_flag
    figure;
    subplot(3,1,1:2)
    y=modelFun(coefEsts,1:1:length(x));
    plot(x,'r');
    hold on;
    plot(y);
    legend('data','fit');
    subplot(3,1,3);
    plot(r,'*')    
end

[h,p]=chi2gof(r)
