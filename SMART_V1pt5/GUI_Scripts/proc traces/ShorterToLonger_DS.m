function long = ShorterToLonger_DS(short)
nStates = sum(short);
long = zeros(1,nStates);
ix = 1;
for i = 1:length(short),
    long(ix:ix+short(i)-1) = i;
    ix = ix + short(i);
end