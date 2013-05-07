
%2nd orderbinding rate from experiments, this is only an estimated value. 
kon=2.14*10^5; %M^-1*s^-1

%off rate
koff=1; %s^-1

%concentration of tracking molecule.
%we certainly could go higher than this value if needed.
R=25*10^-9; %M


%concentration of QD585
%G=0:10^-9:100*10^-9; %from 0 to 100*10^-9M.
G=25*10^-9;

k=kon*G


t=logspace(0,3,200);
x=(k*R./(k+koff))*(1-exp(-(k+koff)*t));

plot(t,x/R)
