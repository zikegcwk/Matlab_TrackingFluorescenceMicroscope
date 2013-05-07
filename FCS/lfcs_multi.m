function [tau, g] = lfcs_multi(file_vec, taumin, taumax, N, tmin, tmax);

g = zeros(1, N-1);

for q = 1:length(file_vec),
    if nargin == 6,
        [tau, gtmp] = lfcs(file_vec(q), taumin, taumax, N, tmin, tmax);
    else
        [tau, gtmp] = lfcs(file_vec(q), taumin, taumax, N);
    end;
    
    g = g + gtmp/length(file_vec);
end;

return;