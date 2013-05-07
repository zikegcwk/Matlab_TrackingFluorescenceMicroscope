taumin=-5;
taumax=0;
xi=0;
w=390e-9;
d0=1e-3;
display('Starting calculation');
display(sprintf('Current time is : %s',datestr(now,14)));
description='type=FCS;OD=0;stock=8108a;sample=rna sergei dye;buffer=TE 1%2ME;tag=concentration';
display(sprintf('Starting to process data set with description : \n %s',description)); 
ds=createDataSets(description,1:15,1e-3,16:30,1e-2,31:45,1e-2);
y=autoprocess_dcoeff(ds,taumin,taumax,w,xi,d0);
display(sprintf('Current time is : %s',datestr(now,14)));
filetosave=sprintf('%s.mat',datestr(now,'yymmdd_HHMMSS'));
display(sprintf('Processing of data set completed. Saving results in file %s',filetosave));
save(filetosave,'description','ds','y','taumin','taumax','w','xi','d0');
