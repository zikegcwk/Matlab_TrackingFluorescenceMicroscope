% LFCS  Compute fluorescence autocorrelation using Laurence method on
%   log-spaced data
%
%   [tau, g] = LFCS(filenum,taumin,taumax,N) computes the autocorrelation 
%   curve of the data object 'tags0' inside the file 'data_filenum' in the 
%   current working directory.  tmin and tmax specify lower and upper times
%   (in log10-seconds).  Default is taumin = -6, taumax = -1 (resulting in 
%   the autocorrelation for tau from 1 us to 100 ms.
%
%   N (optional) specifies the number of data points.  Default is 200.
%
%   [tau,g] = LFCS(filenum,taumin,taumax,N,tmin,tmax) allows the
%   specification of starting and stopping times within the data file, so
%   that only points between tmin and tmax will be included in the
%   correlation.
%
%   If there are two data streams inside the file, 'tags0' and 'tags1',
%   then [tau, g] = LFCS(...) will return the cross-correlation of those
%   two streams.
%
%   [tau, g0, g1] = LFCS(...) returns the individual autocorrelations of
%   streams tags0 and tags1.
%
%   [tau, g0, g1, gx] = LFCS(...) also returns the cross-correlation.
%
%   [...] = LFCS(..., linear) will use linearly spaced time lags if
%   linear == true.
%
%   Note that 'tags0' and 'tags1' must be lists of times generated by point 
%   processes.


function [tau,g1,g2,g3] = LFCS_zk(filenum,taumin,taumax,N,tmin,tmax, linear),

crosscorr_on_single = 1; % Compute cross correlation when there are two 
                         % data streams and only one output? Otherwise
                         % the autocorrelation of the first stream is calculated. 

DEF_TAUMIN = -6;
DEF_TAUMAX = -1;
DEF_N = 200;




load(sprintf('data_%g', filenum));

numstream = 0;
if ~exist('tags'),
    error('There are no fluorescence streams in that file!');
end;

if nargin == 5,
    tmax = tags{1}(end);
end;

if linear,
    tau = linspace(taumin, taumax, N);
    fprintf('Using linearly spaced data.\n');
else
    tau = logspace(taumin,taumax,N);
end;

if nargout > 2 & numstream == 1,
    error('You request too many outputs. That file contains only one data stream.');
end;


if length(tags) == 2,
    data = cell(2,1);
    data{1} = tags{1}(tags{1} >= tmin & tags{1} <= tmax);
    data{2} = tags{1}(tags{1} >= tmin & tags{1} <= tmax);
    
   
    if nargout > 2,
        fprintf('Two data streams: computing both autocorrelations.\n');
        
        g1 = corr_Laurence(data{1}, data{1}, tau);
        g1 = g1(1:end-1)-1;
        g2 = corr_Laurence(data{2}, data{2}, tau);
        g2 = g2(1:end-1)-1;
        if nargout == 4,
            fprintf('Computing cross-correlation.\n');
            g3 = corr_Laurence(data{1}, data{2}, tau);
            g3 = g3(1:end-1)-1;
        end;
    end;
else         
    data = {tags{1}(tags{1} >= tmin & tags{1} <= tmax)};
    g1 = corr_Laurence(data{1}, data{1}, tau);
    g1 = g1(1:end-1)-1;
end;

tau = tau(1:end-1);
g2=tau;
g3=tau;

return;
