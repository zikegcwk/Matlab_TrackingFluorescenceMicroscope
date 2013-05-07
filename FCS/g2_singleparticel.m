function y=g2_singleparticel(t,N,D,omeg,xi)
A=1/N;
td=omeg^2/(4*D);
y=A*((1+t/td).^(-1)).*((1+(xi^2)*t/td).^(-1/2));
end