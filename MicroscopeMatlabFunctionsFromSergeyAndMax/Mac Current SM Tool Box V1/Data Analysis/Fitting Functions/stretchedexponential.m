function y = stretchedexponential(x,xdata)
%single exponential equation for use in least squares fitter
% y=1-exp(-x(1)*xdata);
y=1-exp(-(x(1)*xdata).^x(2));