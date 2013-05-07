function radsolve(w, s);

r = 0:0.01:2*w;

y = -1/2+w*sqrt(2)/sqrt(s^2+w^2)*exp(-2*r.^2/(s^2+w^2)).*(1-s^2/(s^2+w^2) +4*s^2*r.^2/(s^2+w^2)^2);

plot(r, y);

return;
