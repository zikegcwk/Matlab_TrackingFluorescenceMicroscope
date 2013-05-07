%this code is to generate simulated photon arrival times given a continuous
%time two-state Markov Chain model with state life time exponentially distributed, which is used to describe the hairpin dynamics I have in experimnets. 
%Note this is a double stochastic processes - as both the life times and
%the photon arrival times are stochastic. 


function Markov_Hairpin(lifetime_high, lifetime_low, F_high, F_low, T_total, filenum)

% %let's first define some parameters. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %open state fluorescence rate (HIGH fluorescence rate state) in units of
% %photons/second
% F_high=3000;
% 
% %closed state fluorescence rate (LOW fluorescence rate state)
% F_low=1000;
% 
% %average open state life time in unit of second.
% %lifetime_high=200*10^-6;
% lifetime_high=0.0002;
% 
% 
% %average closed state life time
% %lifetime_low=100*10^-6;
% lifetime_low=0.0005;
% 
% 
% %total observation time in units of seconds
% T_total=10;



%now generate continuous-time two-state Markov chain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%we always start with low state
clear T;

T(1,1)=0;
T(1,2)=-1;   %low state is represented by -1 at this location
i=1;

while T(i,1)<T_total
    

if T(i,2)==-1
    T(i+1,1)=T(i,1)+exprnd(lifetime_low);
    
elseif T(i,2)==1
    T(i+1,1)=T(i,1)+exprnd(lifetime_high);
end

T(i+1,2)=T(i,2)*-1;


i=i+1;

end

T(i,1)=T_total;
T(i,2)=0;

%from the states, we use T to generate photon arrival time tags.
%%%%%%%%%%%%%%%%%%%%%%%%%


for j=1:1:length(T)-1
    if T(j,2)==-1
        photon{j}=poisson(F_low,T(j),T(j+1));
    elseif T(j,2)==1;
        photon{j}=poisson(F_high,T(j),T(j+1));
    end
end


%combine all the tags together. Prepare the output file.
photon_tags=[];

for j=1:1:length(T)-1
    if photon{j}>0
        photon_tags=[photon_tags photon{j}];
    else
    end
end

clear tags;
tags{1}=photon_tags;

save('data_3.mat','tags')

save(sprintf('data_%g', u), 'tags', 'lifetime_high', 'lifetime_low', 'F_high', 'F_low', 'T_total', 'filenum');

% operation_time=toc;















