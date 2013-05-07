function PiHist(pi)
r = find(pi == 2);
pi(r) = 1;
r = find(pi == 3);
pi(r) = 2;
M = max(pi);
figure
subplot(M,1,1);
for i = 1:M,
    [L,num] = bwlabel(pi==i);
    stats = regionprops(L,'Area');
    areas = zeros(length(stats),1);
    for j = 1:length(stats),
        areas(j) = stats(j).Area;
    end
    subplot(M,1,i);
    hist(areas,30)
end