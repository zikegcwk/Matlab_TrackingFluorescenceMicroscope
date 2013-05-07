function e=FRET_e_by_tags(filenum)

load(sprintf('data_%g.mat',filenum));

if length(tags)==2
    I_D=length(tags{2});
    I_A=length(tags{1});
elseif length(tags)==4
    I_D=length(tags{3});
    I_A=length(tags{1});
%I_A=length(tags{1})-9.9158*10^4;
else
    error('check your number of tags?')
end



e=I_A/(I_D+I_A);