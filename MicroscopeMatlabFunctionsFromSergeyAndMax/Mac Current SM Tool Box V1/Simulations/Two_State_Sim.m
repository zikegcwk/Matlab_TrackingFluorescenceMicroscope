function output = Two_State_Sim(N,T,Tmin,k1,k2,kb)
%Simulation of two-state transition with one bleaching rate.
%Inputs: N (number of molecules); T (total observation time); k1, k2 -
%transition rate constants; kb - bleaching rate constant. All rate
%constants entered in "per s probability" form.
%fid = fopen('results', 'wb');
%To run from here
%N=171;T=60;Tmin=2;k1=10,k2=2;kb=0.05;
%end of parameter input
Dist = zeros(N,5);
countertossed = 0;
for i=1:N
    TimeState1 = 0;
    TimeState2 = 0;
    StateDice = rand;
        if StateDice <= (k1/(k1+k2))%Making sure fraction of molecules starting in each state is prop to its thermodynamic population
            State = 2;
        else State = 1;
        end
    t=1;
    j=0;
    while t <= 1000*T
        if State == 2; 
            BleachDice = rand;
            %barf = isscalar(BleachDice)
            if BleachDice <= kb/1000 %are we going to bleach?
               TimeState2 = TimeState2+(t-j); % If yes, add dwell time to corresp state and get out!
               t=1000*T;
               continue
            else %If we didn't bleach, we check if we make a transition
                TransitionDice = rand;
                if TransitionDice >= k2/1000 % If not, just keep elongating
                    t = t+1;
                else State = 1; %If yes, increase time in State 2 by dwell time, reset dwell counter j, and elongate
                    TimeState2 = TimeState2+(t-j);
                    j=t;
                    t=t+1;
                end
            end      
            continue
        else 
            BleachDice = rand;
            if BleachDice <= kb/1000 %Did we bleach?
               TimeState1 = TimeState1+(t-j); % If yes, add dwell time to corresp state and get out!
               t=1000*T;
               continue
            else %If we didn't bleach, we check if we make a transition
                TransitionDice = rand; 
                if TransitionDice >= k1/1000 % If not, just keep elongating
                    t = t+1;
                else State = 2; %If yes, increase time in State 2 by dwell time, reset dwell counter j, and elongate
                    TimeState1 = TimeState1+(t-j);
                    j=t;
                    t=t+1;
                end
            end
        end
    end
    %Now need to write two numbers TimeState1 and TimeState2 into an
    %array, make new row and go to the next molecule.
    FractionFolded = TimeState2/(TimeState1+TimeState2);
    
    if FractionFolded == 0; %Assign non-folding molecules limit of dG of -5 kcal
        dG = -5;
    elseif FractionFolded == 1; %Assign non-folding molecules limit of dG of -5 kcal
    dG = 5;
    else dG = 0.587*log(FractionFolded/(1-FractionFolded));
    end
      Dist(i,:) = [TimeState1/1000 TimeState2/1000 (TimeState1+TimeState2)/1000 FractionFolded dG];
%       Dist(i,:) = [TimeState1/1000 TimeState2/1000 (TimeState1+TimeState2)/1000 0 0];
%     countertossed = countertossed + 1;
end
  
filename = strcat('kin',num2str(T),'(',num2str(k1),'_',num2str(k2),')',num2str(Tmin),'(',num2str(1/kb),')','.dat');
fid = fopen(filename, 'a');
fprintf(fid, '%d %d %d %d %d\n', Dist');
AcceptedG = 0;
for k = 1:N
    if Dist(k,3)>Tmin
    AcceptedG = [AcceptedG Dist(k,5)];
    else
        continue
    end
end
bins = -4.5:0.5:4.5;%Binning decided here
binned = hist(AcceptedG,bins);
Histogram = zeros(length(bins),3);
%bins = bins';
for l = 1:(length(bins));
    Histogram(l,1) = bins(l);
    Histogram(l,2) = binned(l);
    Histogram(l,3) = Histogram(l,2)/(length(AcceptedG));
end
filename2 = strcat('hist',num2str(T),'(',num2str(k1),'_',num2str(k2),')',num2str(Tmin),'(',num2str(1/kb),')','.dat');
fid2 = fopen(filename2, 'a');
fprintf(fid2, '%d %d %d\n', Histogram');

fclose('all');

output=1
