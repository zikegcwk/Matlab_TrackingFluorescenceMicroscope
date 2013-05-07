function IntControl(IntState);

dio = digitalio('nidaq', 'Dev1');
hline = addline(dio, 4, 'Out');
output = logical(IntState);
putvalue(dio, output);
delete(dio);

return;
