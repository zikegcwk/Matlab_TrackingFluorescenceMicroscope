function StepXYZ(x, y,z);

if nargin ~= 3,
    error('You must specify a 3-D coordinate.');
end;

if length(x) ~= 1 | length(y) ~= 1 | length(z) ~= 1,
    error('Invalid input coordinate.');
end;

x = x / 10; y = y / 10; z=z/10;

if x > 10 | x < 0 | y > 10 | y < 0 | z>10 | z<0,
    error('Coordinate out of range.');
end;

ao = analogoutput('nidaq', 'Dev1');
addchannel(ao, [0 1 2]);
putdata(ao, [x*ones(34,1), y*ones(34, 1), z*ones(34,1)]);
start(ao);
wait(ao, 1);
delete(ao);

return;