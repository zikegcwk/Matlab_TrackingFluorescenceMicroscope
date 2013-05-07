

tau=logspace(-6,-1,600);
D=[20 20 20];
bandwidth=[20*2*pi 300*2*pi;20*2*pi 300*2*pi;10*2*pi 300*2*pi];
noise=[0.05;0.05;0.5];
laserwaist=[0.65;0.65;3];
T_GG2=Track_GG2(tau,D,bandwidth,noise,laserwaist,'second_order',0,0);



for j=1:1:6
k12=1*10^j;
k21=1*10^j;
DyeGG2(:,j)=TwoState_DD2(tau,k12,k21,3);


end

