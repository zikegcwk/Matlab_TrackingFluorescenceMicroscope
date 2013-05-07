% things that I want Hairpin_Openloop do: 
% take a general g2, with its 7 cell (2A, 2D, 2X and one string
% description) and spill out the rates, with plots such as overlayed
% normalized FCS plots 




function [fitting,rr,pp]=Hairpin_Openloop(tau,g2,t_tide)

%1. Normalize the total set of g2 by the first g2 curve. The first curve is
%normalize to 1 and tide at t_tide.
%2. plot these g2 curves with error bars.


%plot the raw data
fcs_plot(tau,g2);
%normalize the raw data
[N,g2_N]=fcs_N(tau,g2,t_tide);
%plot the normalized data
fcs_plot(tau,g2_N);
% %get the reaction data by division
[tau_c,g2_Nc]=fcs_chopper(tau,g2_N,t_tide);
% % %plot the reaction data.
  fcs_plot(tau_c,g2_Nc)
% %  
%   for j=1:1:6%size(g2_Nc,1)
%       for k=1:1:1
%           [fitting{j,k},residue{j,k},rr(j,k),pp(j,k)]=FCS_twostate_fit(tau_c,g2_Nc{j,k+3},1);
%           title(g2_Nc{j,7})
%       end
%   end