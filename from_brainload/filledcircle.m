function filledcircle(center, radius, c)
if nargin == 2,
   c = 'b';
end;
xrange = center(1)-radius:0.001:center(1)+radius;
y = sqrt(radius^2 - (xrange-center(1)).^2)+center(2);
fill([xrange';flipud(xrange')],[y';-y'],c);
return;