

tau=logspace(-6,-1,600);

for j=1:1:6
k12=0.5*10^j;
k21=1*10^j;
DyeGG2(:,j)=TwoState_DD2(tau,k12,k21,3);
end

