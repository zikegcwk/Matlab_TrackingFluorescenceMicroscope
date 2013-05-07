function xi_out = coarsen( xi_in, dt_in, dt_out );
% COARSEN  Increase the bin time of a sequence of photon counts
%    xi_out = coarsen( xi_in, dt_in, dt_out ) computes the coarsening of
%    the fluorescence data xi_in, which has a bin time of dt_in, into
%    data xi_out with bin time dt_out.

if dt_out < dt_in,
    error( 'Can not generate a finer signal than the input!' );
end;

if round( dt_out / dt_in ) ~= dt_out / dt_in,
    error( 'Output bintime must be a multiple of input bintime!' );
end;

if numel( xi_in ) ~= length( xi_in ),
    error( 'Input data must be a vector!' );
end;

xi_size = size( xi_in );
if xi_size(1) ~= 1,
    xi_in = reshape( xi_in, 1, length( xi_in ) );
end;

group_size = dt_out / dt_in;

while round( length( xi_in ) / group_size ) ~= length( xi_in ) / group_size,
    xi_in = [xi_in, 0];
end;

xi_out = sum( reshape( xi_in, group_size, length( xi_in ) / group_size ), 1 );

return;