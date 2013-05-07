
fprintf('Select region to include in inset\n');
[x, y] = ginput(2);
x = sort(x); y = sort(y);

line([x(1);x(1)], [y(1);y(2)], 'Color', 'k');
line([x(1);x(2)], [y(1);y(1)], 'Color', 'k');
line([x(1);x(2)], [y(2);y(2)], 'Color', 'k');
line([x(2);x(2)], [y(2);y(1)], 'Color', 'k');



fprintf('Select location of inset\n');
[X, Y] = ginput(2);
X = sort(X); Y = sort(Y);
if diff(X)>diff(Y),
    x2 = X; y2 = [Y(1); Y(1)+abs(diff(X)/diff(x)*diff(y))];
else y2 = Y; x2 = [X(1); X(1)+abs(diff(Y)/diff(y)*diff(x))]; end;  % conserve aspect ratio

line([x2(1);x2(1)], [y2(1);y2(2)], 'Color', 'k');
line([x2(1);x2(2)], [y2(1);y2(1)], 'Color', 'k');
line([x2(1);x2(2)], [y2(2);y2(2)], 'Color', 'k');
line([x2(2);x2(2)], [y2(2);y2(1)], 'Color', 'k');

if x2(1) < x(1) & y2(1) < y(1),
  line([x(1);x2(1)],[y(2);y2(2)], 'Color', 'k');
  line([x(1);x2(2)],[y(1);y2(2)], 'Color', 'k');
  line([x(2);x2(2)],[y(1);y2(1)], 'Color', 'k');
end; 
if x2(1) < x(1) & y2(1) > y(1),
  line([x(1);x2(2)],[y(2);y2(1)], 'Color', 'k');
  line([x(1);x2(1)],[y(1);y2(1)], 'Color', 'k');
  line([x(2);x2(2)],[y(2);y2(2)], 'Color', 'k');
end;
if x2(1) > x(1) & y2(1) < y(1),
  line([x(2);x2(1)],[y(1);y2(2)], 'Color', 'k');
  line([x(1);x2(1)],[y(1);y2(1)], 'Color', 'k');
  line([x(2);x2(2)],[y(2);y2(2)], 'Color', 'k');
end;
if x2(1) > x(1) & y2(1) > y(1),
  line([x(2);x2(1)],[y(2);y2(1)], 'Color', 'k');
  line([x(1);x2(1)],[y(2);y2(2)], 'Color', 'k');
  line([x(2);x2(2)],[y(1);y2(1)], 'Color', 'k');
end;
x2 = X; y2 = Y;
XTick = get(gca, 'XTick');
YTick = get(gca, 'YTick');

xax = [min(XTick); max(XTick)];
yax = [min(YTick); max(YTick)];
axispos = [(x2(1)-xax(1))/diff(xax); (y2(1)-yax(1))/diff(yax)];
axissize = [diff(x2)/diff(xax);diff(y2)/diff(yax)];

%a = axes('position', [axispos(1) axispos(2) axissize(1) axissize(2)]);

%modpolar(T(1, :), T(2, :), T(1, pindex), T(2, pindex));