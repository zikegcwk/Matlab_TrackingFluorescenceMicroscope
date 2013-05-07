function [B,C]=Traces_Reprocessing(kinetics_defmlc_file,fps,minimumlifetime)

% This script was created on 051108 By Max Greenfeld It is a modivation of
% an earlier script FractionFoldedIndividualMoleculesAndKinetics.  This
% looks to be a good starting point for more visulation of individual
% molecule data

% This file needs as an input a kinetics_defmlc file and parameters such as
% the minimum trace langth and the number of frames per second

%this script is best run by running the first cell to generate the matrix
%of all the kinetic and residuals.  Then running the second cell to have
%the data plotted in a nice way



%%%Two function to average the data

% trace boxcar averging scheme
function averaged = meanaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = mean(temp);
for j=1:N
    averaged = [averaged averaged(end)+1];
end
end


% function to calculate median average trace. The length of the trace is
% shrunk by N
function averaged = medianaverage(array, N)

n2 = length(array);
temp=zeros(N,n2-(N-1));
for i=1:N,
    temp(i,:) = array(1+(i-1):n2-(N-1)+(i-1));
end
averaged = median(temp);
for j=1:N
    averaged = [averaged averaged(end)+1];
end
end



% Run The first section to generate the array to be ploted
rawdatatoimport = '(kinetics_defmlc)cascade36.37.38.39.40.41.42.43.44.45.46.47.48.49.(1 mM)(4)';
fps = 25;
xtalk = 0.05;
%assignedtransition = 0; % Use Manually Assign Kinetic Transition
assignedtransition = 1; % Use A Systemati Alogrithim

handles.average = 1; % No averaging
%handles.average = 2; % 2 point Median
%handles.average = 3; % 2 point mean
%handles.average = 4; % 3 point Median
%handles.average = 5; % 3 point mean
%handles.average = 6; % 4 point Median
%handles.average = 7; % 4 point mean
%handles.average = 8; % 5 point Median
%handles.average = 9; % 5 point mean

% This was written on 060608 by Max Greenfeld the point is to reaverage
% extracted traces and to recalculate all the importnat files


% Import the raw data and find the positions of the molecules
finalrawdata = importdata(rawdatatoimport);
%finalrawdata = finalrawdata*10^3


moleculstart = find(finalrawdata(:,1)==-9 & finalrawdata(:,2)==-9 & finalrawdata(:,3)==-9);
moleculend = find(finalrawdata(:,1)==9 & finalrawdata(:,2)==9 & finalrawdata(:,3)==9);
moleculeposition = [moleculstart,moleculend];
numberofmolecule = size(moleculeposition,1);

%an averaged data array is being built up in this for loop
averageddata=[];

for i=1:numberofmolecule;

    % alot of things need to be reinitialized since the traces change
    % length 
moleculstart =[];
moleculend =[];
acceptor=[]; 
donor =[];
templength = [];
tempdonor = [];
tempacceptor = [];
tempfret = [];

moleculstart =moleculeposition(i,1);
moleculend =moleculeposition(i,2);

acceptor = finalrawdata((moleculstart+1):(moleculend-1),1);
donor = finalrawdata((moleculstart+1):(moleculend-1),2);
transitionbar = finalrawdata(moleculstart,4);

tracelength = moleculend-moleculstart-1;
xframe = 1:tracelength;



% decide how to average the data
switch handles.average 
  
    case 1
        xdata = xframe';
        ydata1 = donor';
        ydata2 = acceptor';
        averagingname = 'none';
    case 2
        xdata = meanaverage(xframe,2);
        ydata1 = medianaverage(donor,2);
        ydata2 = medianaverage(acceptor,2);
        averagingname = '2ptmedian';
    case 3
        xdata = meanaverage(xframe,2);
        ydata1 = meanaverage(donor,2);
        ydata2 = meanaverage(acceptor,2);
        averagingname = '2ptmean';
    case 4
        xdata = meanaverage(xframe,3);
        ydata1 = medianaverage(donor,3);
        ydata2 = medianaverage(acceptor,3);
        averagingname = '3ptmedian';
    case 5
        xdata = meanaverage(xframe,3);
        ydata1 = meanaverage(donor,3);
        ydata2 = meanaverage(acceptor,3);
         averagingname = '3ptmean';
    case 6
        xdata = meanaverage(xframe,4);
        ydata1 = medianaverage(donor,4);
        ydata2 = medianaverage(acceptor,4);
        averagingname = '4ptmedian';
    case 7 
        xdata = meanaverage(xframe,4);
        ydata1 = meanaverage(donor,4);
        ydata2 = meanaverage(acceptor,4);
         averagingname = '4ptmean';
    case 8
        xdata = meanaverage(xframe,5);
        ydata1 = medianaverage(donor,5);
        ydata2 = medianaverage(acceptor,5);
        averagingname = '5ptmedian';
    case 9
        xdata = meanaverage(xframe,5);
        ydata1 = meanaverage(donor,5);
        ydata2 = meanaverage(acceptor,5);
        averagingname = '5ptmean';


end

% Make the the data all the same size
cutlength = size(ydata1,2);
tempdonor = ydata1;
tempacceptor = ydata2;
templength = xdata(1:cutlength);


tempfret = (tempacceptor-xtalk*tempdonor)./(tempdonor+tempacceptor-xtalk*tempdonor);
tempaverageddata = [ tempacceptor; tempdonor; tempfret; zeros(1,cutlength)];
averageddata = [ averageddata; [-9 -9 -9 transitionbar]];
averageddata = [ averageddata; tempaverageddata'];
averageddata = [ averageddata; [9 9 9 9]];
end

newnamte = strcat(averagingname,rawdatatoimport);
tempfid1=fopen(newnamte,'a');
fprintf(tempfid1,'%d %d %4.3f %d\n',averageddata');
fclose(tempfid1);


%fprintf(tempfid10,'%d %d %4.3f %d\n',[-9;-9;-9;get(handles.slider1,'Value')]);
%fprintf(tempfid10,'%d %d %4.3f %d\n',[acceptor(left:right); tempdonor(left:right); fret(left:right); templevel(left:right)']);
%fprintf(tempfid10,'%d %d %4.3f %d\n',[9;9;9;9]);
%fclose(tempfid10);
% newnamte = strcat(averagingname,'kinetics',rawdatatoimport);
% tempfid=fopen(newnamte,'a');
% fprintf(tempfid,'%d %d %4.3f %d\n',kinetics');



%Assigne Kinetice transition to the data
%Need to refind the position of the molecules

moleculeposition =[];
moleculstart = find(averageddata(:,1)==-9 & averageddata(:,2)==-9 & averageddata(:,3)==-9);
moleculend = find(averageddata(:,1)==9 & averageddata(:,2)==9 & averageddata(:,3)==9);
moleculeposition = [moleculstart,moleculend];
numberofmolecule = size(moleculeposition,1);

kinetics =[];
for i=1:numberofmolecule;
     
moleculstart =[];
moleculend =[];
tempfret = [];

moleculstart =moleculeposition(i,1);
moleculend =moleculeposition(i,2);
tempfret = averageddata((moleculstart+1):(moleculend-1),3);

tracelength = moleculend-moleculstart-1;
    
    fretstep=1;
    
    if assignedtransition ==1
        
        lowtohighstop = averageddata(moleculstart,4);
        hightolowstop = averageddata(moleculstart,4);
    else
        
        lowtohighstop = 0.5;
        hightolowstop = 0.5;
    end

  
kinetics = [ kinetics; [-9 -9 -9 -9]];
tempdwell = [];
while fretstep<tracelength
    
if tempfret(fretstep)<= mean([ lowtohighstop hightolowstop]);
   

while tempfret(fretstep)<=lowtohighstop
if fretstep<tracelength && tempfret(fretstep)<=lowtohighstop && tempfret(fretstep+1)<=lowtohighstop

    tempdwell = [tempdwell;tempfret(fretstep)];
    fretstep = fretstep+1;
    
elseif fretstep<tracelength && tempfret(fretstep+1)>=lowtohighstop
    
    tempdwell = [tempdwell;tempfret(fretstep)];
    kinetics = [ kinetics; [0 size(tempdwell,1)  mean(tempdwell), 3]];
   
    tempdwell = []; 
    fretstep = fretstep+1
    %break
    
else %%fretstep==tracelength
    
    kinetics= [ kinetics; [0 size(tempdwell,1)  mean(tempdwell), 3]];
    kinetics = [ kinetics; [9 9 9 9]];
    hightolowstop =100;
    break
end
end

if fretstep<tracelength && tempfret(fretstep)>=hightolowstop && tempfret(fretstep+1)>=hightolowstop

 tempdwell = [tempdwell;tempfret(fretstep)];
 fretstep = fretstep+1;

elseif fretstep<tracelength && tempfret(fretstep+1)<=hightolowstop

    tempdwell = [tempdwell;tempfret(fretstep)];
    kinetics = [ kinetics; [3 size(tempdwell,1)  mean(tempdwell), -3]];
    
    tempdwell = []; 
    fretstep = fretstep+1
    %break
   
else %%fretstep==tracelength
    
    kinetics= [ kinetics; [3 size(tempdwell,1)  mean(tempdwell), -3]];
    kinetics = [ kinetics; [9 9 9 9]];
    break

end
else
    
while tempfret(fretstep)>=hightolowstop
  
if fretstep<tracelength && tempfret(fretstep)>=hightolowstop && tempfret(fretstep+1)>=hightolowstop

 tempdwell = [tempdwell;tempfret(fretstep)];
 fretstep = fretstep+1;

elseif fretstep<tracelength && tempfret(fretstep+1)<=hightolowstop

    tempdwell = [tempdwell;tempfret(fretstep)];
    kinetics = [ kinetics; [3 size(tempdwell,1)  mean(tempdwell), -3]];
    
    tempdwell = []; 
    fretstep = fretstep+1
    %break
   
else %%fretstep==tracelength
    
    kinetics= [ kinetics; [3 size(tempdwell,1)  mean(tempdwell), -3]];
    kinetics = [ kinetics; [9 9 9 9]];
    lowtohighstop =-100;
    break

end
end

while tempfret(fretstep)<=lowtohighstop
if fretstep<tracelength && tempfret(fretstep)<=lowtohighstop && tempfret(fretstep+1)<=lowtohighstop

    tempdwell = [tempdwell;tempfret(fretstep)];
    fretstep = fretstep+1;
    
elseif fretstep<tracelength && tempfret(fretstep+1)>=lowtohighstop
    
    tempdwell = [tempdwell;tempfret(fretstep)];
    kinetics = [ kinetics; [0 size(tempdwell,1)  mean(tempdwell), 3]];
    
    tempdwell = []; 
    fretstep = fretstep+1
    %break
    
else %%fretstep==tracelength
    
    kinetics= [ kinetics; [0 size(tempdwell,1)  mean(tempdwell), 3]];
    kinetics = [ kinetics; [9 9 9 9]];
   
    break

end

end
end

end
end

newnamte = strcat(averagingname,'kinetics',rawdatatoimport);
tempfid=fopen(newnamte,'a');
fprintf(tempfid,'%d %d %4.3f %d\n',kinetics');


end

%% So the value don't dump




