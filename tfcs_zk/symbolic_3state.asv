clc
syms k12 k21 Q2state pi1 pi2 tau Q3state trans2 trans3 k23 k32 Q1 Q2 W Q3 auto3 k_prdc g3
Q2state=[-k12 k21;k12 -k21];
trans2=expm(Q2state*tau);
%temp=expand(subs(expand(trans2),{k21/(k12+k21),k12/(k12+k21)},{'pi1','pi2'}));
%subs(temp,1/(k12+k21),'pi2')
pi1=k21/(k12+k21);
pi2=k12/(k12+k21);
auto2=pi1*trans2(1,1)*Q1^2+pi1*trans2(1,2)*Q1*Q2+pi2*trans2(2,1)*Q2*Q1+pi2*trans2(2,2)*Q2^2;
I_ave=pi1*Q1+pi2*Q2;

g2=auto2/I_ave^2-1;

vs_auto2=subs(auto2,{k11,k12,k21,k22},{1e})

% ok=subs(g2,{k21/(k12+k21),k12/(k12+k21),exp(tau*k12+tau*k21)},{'pii1','pii2','W'});
% simplify(ok)
% subexpr(g2)
% 
% 
Q3state=[-k12 k21 0;k12 -k21-k23 k32;0 k23 -k32];
trans3=expm(Q3state*tau);
k_prdc=k21*k32+k12*k32+k12*k23;
eq2=k12*k32/k_prdc;
eq1=(k21*k12)*eq2;
eq3=(k23*k32)*eq2;
I_ave3=eq1*Q1+eq2*Q2+eq3*Q3;
auto3=eq1*trans3(1,1)*Q1^2+eq1*trans3(1,2)*Q1*Q2+eq1*trans3(1,3)*Q1*Q3...
    +eq2*trans3(2,1)*Q2*Q1+eq2*trans3(2,2)*Q2^2+eq2*trans3(2,3)*Q2*Q3...
    +eq3*trans3(3,1)*Q3*Q1+eq3*trans3(3,2)*Q3*Q2+eq3*trans3(3,3)*Q3^2;

g3=auto3/I_ave3^2-1;
vs_auto3=subs(auto3,{k12,k21,k23,k32,Q1,Q2,Q3},{1e5,1e4,1e2,1e2,1,0.5,0});
v_I_ave3=subs(I_ave3,{k12,k21,k23,k32,Q1,Q2,Q3},{1e5,1e4,1e2,1e2,1,0.5,0});

s_tau=logspace(-7,0,70);
v_g3=double(subs(vs_auto3,tau,s_tau))/v_I_ave3^2;

figure;
semilogx(s_tau,v_g3)













