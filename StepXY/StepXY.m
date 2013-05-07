function StepXY(x, y);

if nargin ~= 2,
    error('You must specify a 2-D coordinate.');
end;

if length(x) ~= 1 | length(y) ~= 1,
    error('Invalid input coordinate.');
end;

x = x / 10; y = y / 10;

if x > 10 | x < 0 | y > 10 | y < 0,
    error('Coordinate out of range.');
end;

ao = analogoutput('nidaq', 'Dev1');
addchannel(ao, [0 1]);
putdata(ao, [x*ones(34,1), y*ones(34, 1)]);
start(ao);
wait(ao, 1);
delete(ao);

return;