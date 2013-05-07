function y = tripleexponential(x,xdata)
%double exponential equation for use in least squares fitter
% x(3)=1-x(1)
y=1-(x(1).*exp(-x(2).*xdata))-(x(3).*exp(-x(4).*xdata))-((1-x(1)-x(3)).*exp(-x(5).*xdata));
% x(3)=1-x(1);