function y = doubleexponential(x,xdata)
%double exponential equation for use in least squares fitter
% x(3)=1-x(1)
% x(2)<x(3);
y=1-x(1).*exp(-x(2).*xdata)-((1-x(1)).*exp(-x(3).*xdata));


% x(3)=1-x(1);