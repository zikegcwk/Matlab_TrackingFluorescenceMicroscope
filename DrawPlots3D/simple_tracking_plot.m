function simple_tracking_plot(filenum,dt)

load(sprintf('data_%g.mat',filenum));

[I,t]=atime2bin(tags0,1e-2);
figure;
subplot(2,1,1);
plot(t,I*10^-3/dt);
subplot(2,1,2);
hold all;
plot(t0,x0);
plot(t0,y0,'g');
plot(t0,z0,'r');