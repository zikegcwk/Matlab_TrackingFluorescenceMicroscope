function f = Dest(beta,dt);
f = DestNoise([beta(1) 0 beta(2:end)],dt);