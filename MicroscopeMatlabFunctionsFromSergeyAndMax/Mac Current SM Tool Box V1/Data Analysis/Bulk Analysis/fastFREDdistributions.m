function  output = fastFREDdistributions(datasource, concentration, tweakguesses)

%By Max Greenfeld 011607
%this script is to concatenate FRET Histograms and to plot the data
%indipendent of the kinetics


%%
% comment on this section when not runing the script directly

numbers=[61:65];
concentration=1;
fps=25;
openbracket = '(';
closebracket = ' mM)';

% end coment ount section

kinprefix = '(kinetics)cascade';
kinmlcprefix = '(kinetics_defmlc)cascade';
kintwoprefix = '(kinetics2)cascade'; % Added Max Greenfled 120207
FRETprefix = '(4)(FRETDIST)';
RAWprefix =  '(4)(RAWFRET)';
conc = num2str(concentration);



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


C=histfitleastsquaresresiduals(A,concentration,[]);
% titledist = [num2str(concentration) ' mM Metal distribution'];
% h=findobj('Name', titledist);
h= gcf;
s = ['print' ' -f' num2str(h) ' -dmeta'];
eval(s);