% MERGEFIG  Merge two figures
%   mergefig(fig1, fig2, fig3) merges fig1 and fig2, and stores the result
%   in fig3.

function mergefig(fig1, fig2, fig3);

ch1 = get(fig1, 'Children');
ch2 = get(fig2, 'Children');

if length(ch1) ~= length(ch2),
    error('Incompatible figures.');
end;

figure(fig3);

for u = 1:length(ch1),
    axu = [get(ch1(u), 'Children'); get(ch2(u), 'Children')];
    copyobj(axu, fig3);
end;
