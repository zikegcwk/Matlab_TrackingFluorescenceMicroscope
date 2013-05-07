function g2tau=FCS_tracking(t,para),
gama1=para(1);
c1=para(2);
gama2=para(3);
c2=para(4);

%red laser waist size in xyz.
wxy=1;
wz=pi*wxy^2/0.532;

sigma_xy=c1*exp(-gama1.*t);
sigma_z=c2*exp(-gama2.*t);


g2tau=((0.25*wxy^2+c1)^2./((0.25*wxy^2+c1)^2-sigma_xy.^2)).*((0.25*wz^2+c2)./((0.25*wz^2+c2)^2-sigma_z.^2).^0.5)-1;