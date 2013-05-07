% SCANXY  Performs 2-dimensional raster scan, recording fluorescence rate 
% at each point of the scan.
%
%   [M,x,y] = scanXY(xmin,xmax,ymin,ymax,dx) returns the 2-D scan spanning
%   from xmin to xmax along x, and ymin to ymax along y, in increments of
%   dx along both axes.  M is a matrix of fluorescence rates, x and y are
%   vectors of positions.
%
%   [M,x,y] = scanXY(xmin,xmax,ymin,ymax,dx,timeout) allows specification
%   of the timeout time for photon counting.  Defaults to 100ms.
function [M,x,y] = scanXY_ZK(xmin,xmax,ymin,ymax,dx,timeout);

if nargin < 5,
    error('Input must specify scan coordinates.');
end;

if nargin < 6,
    timeout = 0.1;
end;

if nargin > 6,
    error('Too many inputs.');
end;

global LineState;

for j=0:1:3
    if LineState(j+1)
        fprintf('Measuring fluorescence on APD %g',j);
        if (j==0) | (j==1 )
            board=0;
            chan=j;
        elseif (j==2) | (j==3)
            board=1;
            chan=j-2; 
        else
            break;
            return;
        end
   
        
    end
end

gt65x_init(1);

ixBoard = 0;
numDataPoints = 1000000;

x0 = xmin;
y0 = ymin;

dy = dx; %um

addpath(cd);
fileIx = 0;

x = xmin:dx:xmax;
y = ymin:dx:ymax;

Nx = length(x);
Ny = length(y);
M = zeros(Nx,Ny)

fig_num = round(100000*rand);

figure(fig_num);
dt = .01;

for j= 1:Nx;
    for k=1:Ny;
        StepXY(x(j) , y(k));
        pause(.1);
        tags0 = rttags(board, numDataPoints, timeout, chan);
        M(k,j) = length(tags0)/dt;
        figure(fig_num)
        pcolor(x,y,M);
    end;
end;
StepXY(x0,y0);
