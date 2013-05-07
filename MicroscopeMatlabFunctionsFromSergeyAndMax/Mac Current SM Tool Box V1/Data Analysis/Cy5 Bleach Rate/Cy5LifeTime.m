function [B]=Cy5LifeTime(numbers,concentration)

% This was modified from two scripts LIFETIMEanalALLcascadeNORMALcopier and
% likftime40fpsRAW to look at Cy5 Photobleaching Rates



kinprefix = '(kinetics2_cy5life)cascade';
FRETprefix = '(4)(FRETDIST)';
RAWprefix =  '(4)(RAWFRET)';
conc = num2str(concentration);
%%KINETICS
numberholder={};
finaldata = [];
i=length(numbers);
suffix = '(4).dat';
openbracket = '(';
closebracket = ' mM)';
for index=1:i,

    number=num2str(numbers(index)); 
   extractfilename = strcat(kinprefix,number,suffix)
if exist(extractfilename)==2  
    s = dir(extractfilename);
    filesize = s.bytes
    if  exist(extractfilename)==2  & filesize>0
    tempdata = importdata(extractfilename);
    
    finaldata = [finaldata;tempdata];
    numbername = strcat(number,'.');
    numberholder = strcat(numberholder,numbername);
    end
end

end
filename = strcat(kinprefix,numberholder,openbracket,conc,closebracket,suffix);
filename = char(filename)
save(filename,'finaldata','-ascii');
K = filename;


B=lifetime40fpsRAW(K,concentration);

%copy the figures to the clipboard
% titlekin = [num2str(concentration) ' mM Metal kinetics'];
% h=findobj('Name', titlekin);
h = gcf;
s = ['print' ' -f' num2str(h) ' -dmeta'];
eval(s);
% 
% C=histfitleastsquares(A,concentration,[]);
% % titledist = [num2str(concentration) ' mM Metal distribution'];
% % h=findobj('Name', titledist);
% h= gcf;
% s = ['print' ' -f' num2str(h) ' -dmeta'];
% eval(s);
% 
% 
% KINCHECK = [B(7)/(B(7)+B(2))]

% close(gcf);
% close(gcf);

% for index2=1:i,
%     
% finaldataname = strcat(prefix,num2str(numbers(index),suffix}

% how i did it before:    
% % Mg07mM = [importdata('(kinetics)rib25.dat');importdata('(kinetics)rib26.dat');importdata('(kinetics)rib27.dat')]
% % save('(kinetics)rib25.26.27.dat','Mg07mM','-ascii')