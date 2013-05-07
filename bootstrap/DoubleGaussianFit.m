function para_fit=DoubleGaussianFit(x,y)

f2fit=@(para,tau) DoubleGaussian(tau,para(1),para(2),para(3),para(4),para(5),para(6));


para_1_guess=2.5;
para_2_guess=15;
para_3_guess=0.5;
para_4_guess=2.5;
para_5_guess=15;
para_6_guess=0.5;

[para_fit,r]=nlinfit(x,y,f2fit,[para_1_guess,para_2_guess,para_3_guess,para_4_guess,para_5_guess,para_6_guess]);

figure;
plot_x=linspace(min(x),max(x));
plot_y=DoubleGaussian(plot_x,para_fit(1),para_fit(2),para_fit(3),para_fit(4),para_fit(5),para_fit(6));
plot(plot_x,plot_y,'r','LineWidth',2);
hold on;
bar(x,y);
hold off;


function f=DoubleGaussian(InputData_X,x0_1,A_1,sx_1,x0_2,A_2,sx_2)

% x0_1 = InputParams(1);
% A_1  = InputParams(2);
% sx_1 = InputParams(3);
% x0_2 = InputParams(4);
% A_2  = InputParams(5);
% sx_2 = InputParams(6);

f = A_1*exp(-0.5*(InputData_X-x0_1).^2/sx_1.^2) + A_2*exp(-0.5*(InputData_X-x0_2).^2./sx_2.^2);
%Error = sum(abs(f.^2));