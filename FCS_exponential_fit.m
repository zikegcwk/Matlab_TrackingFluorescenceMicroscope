function fit=FCS_exponential_fit(x,y)




f2fit=@(para,x) exponential(x,para(1),para(2),para(3));


para_1_guess=y(end);

para_2_guess=-0.5;

para_3_guess=100;


[para_fit,r]=nlinfit(x,y,f2fit,[para_1_guess,para_2_guess,para_3_guess]);

fit.parafit=para_fit;
fit.r=r;
fit.x=x;
fit.thry=exponential(x,para_fit(1),para_fit(2),para_fit(3));

end

function y=exponential(x,a,b,c)

y=a+b.*exp(-c*x);

end