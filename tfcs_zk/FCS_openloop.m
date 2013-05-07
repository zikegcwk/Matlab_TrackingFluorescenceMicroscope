%g2tau=FCS_openloop(t,wwxy,wwz,NN,DD)
function g2tau=FCS_openloop(t,wwxy,wwz,NN,DD)

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

g2tau=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);
end
