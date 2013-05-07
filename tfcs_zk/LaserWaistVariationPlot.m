tau=logspace(-6,-1,600);

D=[20 20 20];
bandwidth=[20*2*pi 300*2*pi;20*2*pi 300*2*pi;10*2*pi 300*2*pi];
noise=[0.05;0.05;0.5];
%laserwaist=[0.65;0.65;3];

omega_xy=[0.22;0.4;0.65;1;2];
omega_z=pi*omega_xy.^2/0.444;

figure;
hold on;

for j=1:1:5
    laserwaist=[omega_xy(j);omega_xy(j);omega_z(j)];
    T_GG2(:,j)=Track_GG2(tau,D,bandwidth,noise,laserwaist,'second_order',0,0);
    semilogx(tau,(T_GG2(:,j)-1)./(T_GG2(1,j)-1))
end


