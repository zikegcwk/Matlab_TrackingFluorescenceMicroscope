function [B,C]=KinfreTanalALLcascadeANYcopierResiduals(numbers,concentration,fps)

% A quick script to merge kinetics and fret distributions extracted from diffrent movies together
% k=kineticsmerger(numberoffiles,prefix,numbers)
% 
% numberoffiles - the number of files to merge
% kinprefix set to (kinetics)cascade
% FRETprefix set to '(4)(FRETDIST)'
% numbers - the file number.
%%
% comment on this section when not runing the script directly

% numbers=[42 43];
% concentration=1;
% fps=25;
% openbracket = '(';
% closebracket = ' mM)';

% end coment ount section

kinprefix = '(kinetics)cascade';
kinmlcprefix = '(kinetics_defmlc)cascade';
kintwoprefix = '(kinetics2)cascade'; % Added Max Greenfled 120207
FRETprefix = '(4)(FRETDIST)';
RAWprefix =  '(4)(RAWFRET)';
conc = num2str(concentration);



%%

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
%%
%%KINETICS_defmlc
numberholder={};
finaldata = [];
i=length(numbers);
suffix = '(4).dat';
openbracket = '(';
closebracket = ' mM)';
for index=1:i,

    number=num2str(numbers(index)); 
   extractfilename = strcat(kinmlcprefix,number,suffix)
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
filename = strcat(kinmlcprefix,numberholder,openbracket,conc,closebracket,suffix);
filename = char(filename)
save(filename,'finaldata','-ascii');
K2 = filename;


%%kinetics2 Added Max Greenfeld 120207 For counting number of molecules
numberholder={};
finaldata = [];
i=length(numbers);
suffix = '(4).dat';
openbracket = '(';
closebracket = ' mM)';
for index=1:i,

    
    
    
    number=num2str(numbers(index)); 
   extractfilename = strcat(kintwoprefix,number,suffix)
if exist(extractfilename)==2  
    s = dir(extractfilename);
    filesize = s.bytes
    if  exist(extractfilename)==2  & filesize>0
    tempdata = importdata(extractfilename)';
    
    finaldata = [finaldata;tempdata];
    numbername = strcat(number,'.');
    numberholder = strcat(numberholder,numbername);
    end
end

end
filename = strcat(kintwoprefix,numberholder,openbracket,conc,closebracket,suffix);
filename = char(filename)
save(filename,'finaldata','-ascii');
K3 = filename;


%%


%%FRET
numberholder={};
finaldata = [];
i=length(numbers)
suffix = '.dat';
preprefix = 'cascade';
for index=1:i,
   number=num2str(numbers(index)); 
   extractfilename = strcat(preprefix,number,FRETprefix,suffix);
   if exist(extractfilename)==2  
    tempdata = importdata(extractfilename);
    finaldata = [finaldata tempdata];
          
    if exist(extractfilename)==2  & index >= 2,
        index
        sum(finaldata(:,2))
        finaldata(:,2) = finaldata(:,2)+tempdata(:,2);
        sum(finaldata(:,2))
    end
      
    
    numbername = strcat(number,'.');
    numberholder = strcat(numberholder,numbername);
   end
end

filename = strcat(FRETprefix,numberholder,openbracket,conc,closebracket,suffix);
filename = char(filename);
save(filename,'finaldata','-ascii');
A = filename;




%%RAW FRET
numberholder={};
finaldata = [];
i=length(numbers)
suffix = '.dat';
preprefix = 'cascade';
for index=1:i,
   number=num2str(numbers(index)); 
   extractfilename = strcat(preprefix,number,RAWprefix,suffix);
   if exist(extractfilename)==2  
    tempdata = importdata(extractfilename);
    finaldata = [finaldata;tempdata];
          
%     if exist(extractfilename)==2  & index >= 2,
%         index
%         sum(finaldata(:,2))
%         finaldata(:,2) = finaldata(:,2)+tempdata(:,2);
%         sum(finaldata(:,2))
%     end
%       
% if exist(extractfilename)==2  
%     s = dir(extractfilename);
%     filesize = s.bytes
%     if  exist(extractfilename)==2  & filesize>0
%     tempdata = importdata(extractfilename);
%     
%     finaldata = [finaldata;tempdata];
%     numbername = strcat(number,'.');
%     numberholder = strcat(numberholder,numbername);
%     end    
    numbername = strcat(number,'.');
    numberholder = strcat(numberholder,numbername);
   end
end

filename = strcat(RAWprefix,numberholder,openbracket,conc,closebracket,suffix);
filename = char(filename);
save(filename,'finaldata','-ascii');

%%

B=kinanyfps2residuals(K,K3,concentration,fps); %Max Greenfeld Added K3 to count the number of molecules

%copy the figures to the clipboard
% titlekin = [num2str(concentration) ' mM Metal kinetics'];
% h=findobj('Name', titlekin);
h = gcf;
s = ['print' ' -f' num2str(h) ' -dmeta'];
eval(s);

C=histfitleastsquaresresiduals(A,concentration,[]);
% titledist = [num2str(concentration) ' mM Metal distribution'];
% h=findobj('Name', titledist);
h= gcf;
s = ['print' ' -f' num2str(h) ' -dmeta'];
eval(s);


KINCHECK = [B(7)/(B(7)+B(2))]

% close(gcf);
% close(gcf);

% for index2=1:i,
%     
% finaldataname = strcat(prefix,num2str(numbers(index),suffix}

% how i did it before:    
% % Mg07mM = [importdata('(kinetics)rib25.dat');importdata('(kinetics)rib26.dat');importdata('(kinetics)rib27.dat')]
% % save('(kinetics)rib25.26.27.dat','Mg07mM','-ascii')