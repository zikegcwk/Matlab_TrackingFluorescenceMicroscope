function [input_tau,GG3]=ThreeState_DD2(input_tau,input_k12,input_k21,input_k23,input_k32,input_Q1,input_Q2,input_Q3)


%three state stuff:
syms k12 k21 k23 k32 Q1 Q2 Q3 tau
Q3state=[-k12 k21 0;k12 -k21-k23 k32;0 k23 -k32];
trans3=expm(Q3state*tau);
Pk=k21*k32+k12*k32+k12*k23;
%eqilibrium state distribtion.
eq1=k21*k32/Pk; v_eq1=subs(eq1,{k12,k21,k23,k32},{input_k12,input_k21,input_k23,input_k32});
eq2=k12*k32/Pk; v_eq2=subs(eq2,{k12,k21,k23,k32},{input_k12,input_k21,input_k23,input_k32});
eq3=k12*k23/Pk; v_eq3=subs(eq3,{k12,k21,k23,k32},{input_k12,input_k21,input_k23,input_k32});

disp(sprintf('eq1=%g, eq2=%g, eq3=%g',v_eq1,v_eq2,v_eq3));

%average intensity
I_ave3=eq1*Q1+eq2*Q2+eq3*Q3;
%auto correlation function
auto3=eq1*trans3(1,1)*Q1^2+eq1*trans3(1,2)*Q1*Q2+eq1*trans3(1,3)*Q1*Q3+eq2*trans3(2,1)*Q2*Q1+eq2*trans3(2,2)*Q2^2+eq2*trans3(2,3)*Q2*Q3+eq3*trans3(3,1)*Q3*Q1+eq3*trans3(3,2)*Q3*Q2+eq3*trans3(3,3)*Q3^2;

%numerical forms
vs_auto3=subs(auto3,{k12,k21,k23,k32,Q1,Q2,Q3},{input_k12,input_k21,input_k23,input_k32,input_Q1,input_Q2,input_Q3});
v_I_ave3=subs(I_ave3,{k12,k21,k23,k32,Q1,Q2,Q3},{input_k12,input_k21,input_k23,input_k32,input_Q1,input_Q2,input_Q3});

%g2(tau)+1 of three-state model 
%GG3=subs(vs_auto3,tau,input_tau)/v_I_ave3^2;
%subs(vs_auto3,tau,input_tau)
GG3=double(subs(vs_auto3,tau,input_tau))/v_I_ave3^2;


if nargout==0
    figure;
    semilogx(input_tau,GG3-1);
    title(sprintf('k12-%g, k21-%g, k23-%g, k32-%g, Q1-%g, Q2-%g, Q3-%g',input_k12,input_k21,input_k23,input_k32,input_Q1,input_Q2,input_Q3))
    clear GG3 input _tau;
end



%two state stuff:
%syms k12 k21 Q2state pi1 pi2 tau Q3state trans2 trans3 k23 k32 Q1 Q2 W Q3 auto3 k_prdc g3
% Q2state=[-k12 k21;k12 -k21];
% trans2=expm(Q2state*tau);
% %temp=expand(subs(expand(trans2),{k21/(k12+k21),k12/(k12+k21)},{'pi1','pi2'}));
% %subs(temp,1/(k12+k21),'pi2')
% pi1=k21/(k12+k21);
% pi2=k12/(k12+k21);
% auto2=pi1*trans2(1,1)*Q1^2+pi1*trans2(1,2)*Q1*Q2+pi2*trans2(2,1)*Q2*Q1+pi2*trans2(2,2)*Q2^2;
% I_ave=pi1*Q1+pi2*Q2;
% 
% g2=auto2/I_ave^2-1;
%ok=subs(g2,{k21/(k12+k21),k12/(k12+k21),exp(-tau*k12-tau*k21)},{'pii1','pii2','W'})
%simplify(ok)
%subexpr(g2)