function out=FIDA(filenum,plot_flag)
dt=5*10^-6;
load(sprintf('data_%g.mat',filenum));
%acceptor channel.
tag=sort([tags{1} tags{2}]);
%donor channel.
%tag=sort([tags{3} tags{4}]);
[I,t]=atime2bin(tag,dt);

out.bin=0:1:12;
h=hist(I,out.bin);
out.prob=h./length(I);
if plot_flag
    %figure;
    semilogy(out.bin,out.prob);

end