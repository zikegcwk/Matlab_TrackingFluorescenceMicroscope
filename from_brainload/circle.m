function circle(center, radius)

xrange = center(1)-radius:0.01:center(1)+radius;
y = sqrt(radius^2 - (xrange-center(1)).^2);
line([xrange';flipud(xrange')],[center(2)+y';center(2)-y']);
return;