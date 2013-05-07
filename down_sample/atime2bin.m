function [out, edges] = atime2bin( t, dt, tmin, tmax )

% ATIME2BIN   Down-samples arrival-time data into binned data
%     I = ATIME2BIN( t, dt ) returns the number of photons in the arrival-time
%     stream t arriving within time bins of width dt.
%
%     I = ATIME2BIN(t, dt, tmin) allows the minimum time to be specified
%     (the maximum time will be the last arrival time.
%
%     I = ATIME2BIN(t, dt, tmin, tmax) also allows the maximum time to be
%     specified.
%
%     [I, t] = ATIME2BIN(...) also returns the time bins used.

if nargin < 2,
    error( 'Two input parameters required.' );
end;

if nargin == 2, 
    tmin = min(t);
    tmax = max(t);
end;

if nargin == 3,
    tmax = max(t);
end;



if nargout > 2,

    error( 'At most two output parameters.' );

end;



if numel( dt ) ~= 1,

    error( 'dt must be a scalar' );

end;



if length(t) < 1,

    warning('t is empty.');

    out = 0; 

    edges = 0;

    return;

end;



if prod( size( t ) ) ~= length( t ),

    error( 't must be a vector' );

end;



edges = tmin:dt:tmax;

out = histc(t, edges);



%out = fast_ds( t, dt );



return;