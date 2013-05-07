function autosavefig()
w=dir('*.fig');
for i=1:1:length(w)
    h=openfig(w(i).name);
    dotloc=findstr(w(i).name,'.');
    saveas(h,w(i).name(1:dotloc-1),'png')
end
end