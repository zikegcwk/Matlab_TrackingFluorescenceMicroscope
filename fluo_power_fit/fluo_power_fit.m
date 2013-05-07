%Function fluo_power takes into laser intensity and fluorescence rate and fit
%to a function like: F=A*L/(B+L), where L is laser intenstiy, A & B are
%constants and F is fluorescence rate. 
function [A,B]=fluo_power_fit(L,F)

f2fit=@(parameters,tau) fluo_power(L,parameters(1),parameters(2));

%initial guess of A
parameters_1_guess=35;
%initial guess of B
parameters_2_guess=175;

[parameters_fit,r]=nlinfit(L,F,f2fit,[parameters_1_guess,parameters_2_guess]);


figure;
plot(L,F,'sb','MarkerSize',6,'MarkerFaceColor','r');
hold on;
LL=linspace(0,max(L),500);
plot(LL,fluo_power(LL,parameters_fit(1),parameters_fit(2)));

A=parameters_fit(1);
B=parameters_fit(2);


function FF=fluo_power(L,A,B)

FF=A*L./(B+L);