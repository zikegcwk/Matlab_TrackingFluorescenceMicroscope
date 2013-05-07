
function g2tau=FCS_diff_xyz(t,wwxy,wwz,NN,Dx,Dy,Dz)

tau_x=wwxy^2/(4*Dx);
tau_y=wwxy^2/(4*Dy);
tau_z=wwz^2/(4*Dz);

g2tau=(1/NN)*(1./(1+t/tau_x).^0.5).*(1./(1+t/tau_y).^0.5).*(1./(1+t/tau_z).^0.5);
%g2tau=A.*t.^5+B*t.^4+C.*t.^3+D.*t.^2+E.*t+F;

end
