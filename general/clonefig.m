% CLONEFIG clones a figure
%   clonefig(fig1, fig2) creates a clone of figure fig1 in figure fig2.

function clonefig(fig1, fig2);

figure(fig2);

axesorig = get(get(fig1, 'CurrentAxes'), 'Children');

copyobj(get(fig1, 'Children'), fig2);
return;
