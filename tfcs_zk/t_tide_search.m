function t_tide_search(t,g1,g2)

tauvec=min(find(t>10^-5)):1:max(find(t<10^-1));
tauc=t(tauvec);


for j=1:1:size(tauvec,2)
    clear tc;
    tc=tauvec(1,j:end);
    [c,val(j)]=scale(g1(tc),g2(tc));
    val(j)=100*(val(j)/size(tc,2))^0.5/mean([g1(1) g2(1)]);
end

figure;
plot(log10(tauc),val);