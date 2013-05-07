function data2draw=DrawPlots3Dall(rng)
files=dir('data_*.mat');
filesnamesCell=struct2cell(files);
[a,n]=size(filesnamesCell);
M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end
data2draw=[];    
for i=1:length(rng)
    lastfile=(rng(i)-mod(rng(i),100))+100;
    x=find(M<lastfile & M>=rng);
    data2draw=cat(1,data2draw,M(x));
end
data2draw=sort(data2draw);
for j=1:length(data2draw)
    DrawPlots3D(data2draw(j));
end
 