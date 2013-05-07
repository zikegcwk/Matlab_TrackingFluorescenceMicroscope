function short = LongerToShorter_DS(long)
short = zeros(1,max(long));
for i = 1:max(long),
    short(i) = sum(long == i);
end