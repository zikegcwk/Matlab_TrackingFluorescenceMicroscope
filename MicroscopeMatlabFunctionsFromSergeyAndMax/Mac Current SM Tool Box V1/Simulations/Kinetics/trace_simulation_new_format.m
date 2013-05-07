function output = trace_simulation_new_format( au1, ku1, au2, ku2, af1, kf1, af2, kf2,...
    number_of_simulations,photo_bleack_rate,equlibrium,fps,endtime)

%written Max Greenfeld - 12/04/07 
%This is to calcualte the fraction of dwell time expected given input
%kinetic parameters for single and double exponential fits of culumulatieve
%fret histograms.

% k is the rate constant for a single exponentila fit
% a1 is the fast amplitude for a double expoential fit
% k1 is the fast rate for a double exponential fit
% a2 is the slow amplitude for a double exponential fit
% k2 is the slow amplitude for a doulbe exponetial fit

% time is the the longest time a calculate will be carreid out in practice
% you might want to use mean trace length

% Calling variable within the function

% this is not quite perfect some variable appear to be flipped the stem
% plot does not work need to add double exponentila for completness but It
% does recapitulate the input variables so that is good add in random
% starts and ends whay about photobleaching rate





% This is old code the frst section generates traces the second then with
% the variables defined I just run the other sorting algorithims.




numberofmolecules=number_of_simulations;
%minimumlifetime=50;
photobleachrate=photo_bleack_rate;
%fps = 1;

time = exprnd(photobleachrate, [numberofmolecules,2]);

toolong = find(time(:,1)>endtime);
time(toolong)=endtime;
% equlibrim distribution of the molecule used to choose the starting FRET
% state
%equlibrium=0.49;


tku1=1/ku1;
tku2=1/ku2;

tkf1=1/kf1;
tkf2=1/kf2;

meanlowfret = 0.3;
meanhighfret = 0.5;

allmlecules=[];
rawdata=[];
for index=1:numberofmolecules;
    
    
startstate=rand;

B=[];

if startstate <=equlibrium;
    
    if rand < af1;
      foldeddewll=exprnd(tkf1);
      B = [0,foldeddewll,meanhighfret,3];
  
    else
      foldeddewll=exprnd(tkf2);
      B = [0,foldeddewll,meanhighfret,3];
    
    end
    
else
    
    if rand < au1;
      foldeddewll=exprnd(tku1);
      B = [3,foldeddewll,meanhighfret,-3];
       
    else
      foldeddewll=exprnd(tku2);
      B = [3,foldeddewll,meanhighfret,-3];
    
    end
end

temp=B;

while sum(B(:,2))<= time(index);
    
    
    if temp(1)==3
      temp=[];
      if rand < af1
      foldeddewll=exprnd(tkf1);
      temp = [0,foldeddewll,meanhighfret,3];
      B=[B;temp];
      else
      temp=[];
      foldeddewll=exprnd(tkf2);
      temp = [0,foldeddewll,meanhighfret,3];
      B=[B;temp];
      end    
        
    else
        
      temp=[];
      if rand < au1
      foldeddewll=exprnd(tku1);
      temp = [3,foldeddewll,meanhighfret,-3];
      B=[B;temp];  
      else
      foldeddewll=exprnd(tku2);
      temp = [3,foldeddewll,meanhighfret,-3];
      B=[B;temp];
      end

    end
end
top=[[-9,-9,0,0];zeros(9,4)];
B(:,2)=round(B(:,2)*fps);

B=[top;B; [9,9,9,9]]
allmlecules=[allmlecules; B];
tempraw = [top;zeros( sum(B(:,2)),4);[9,9,9,9]]
rawdata = [rawdata;tempraw]
B=[];

end


simulated = cat(2,{allmlecules},{rawdata});
output =simulated;








