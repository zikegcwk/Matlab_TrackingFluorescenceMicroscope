%   MSD3D   Compute the mean-squared deviation from a tracking trajectory
%   as a function of time interval
%
%   [dT, dX, dY, dZ] = MSD3D(filenum, t_start, t_stop) returns the MSD
%   curve for all three axes corresponding to the data in file
%   data_filenum, starting at time t_start and ending at t_stop.
%
%   See also msdfit, msdfit2, drawplots3d
function [dT, DX, DY, DZ] = MSD3D_ZK(varargin);
draw_plot = 0;

tstart = 0;
tstop = log10(1000); %log(T/1ms)

if nargin == 1,
    load(sprintf('data_%g', varargin{1}));
    ix = 1:length(t0);
else
    if nargin == 3,
        load(sprintf('data_%g', varargin{1}));
        SampRate = floor(1/(t0(2)-t0(1)));
        ix = find(t0 >= varargin{2} & t0 <= varargin{3});
        %ix = (SampRate*varargin{2}):(SampRate*varargin{3});
    else
        if nargin == 4,
            ix = 1:length(x0);
            t0 = varargin{1};
            x0 = varargin{2};
            y0 = varargin{3};
            z0 = varargin{4};
        else
            if nargin == 5,
                load(sprintf('data_%g', varargin{1}));
                SampRate = floor(1/(t0(2)-t0(1)));
                %ix = (SampRate*varargin{2}):(SampRate*varargin{3});
                ix = find(t0 >= varargin{2} & t0 <= varargin{3});
                tstart = varargin{4};
                tstop = varargin{5};
            else
                if nargin == 6,
                    t0 = varargin{1};
                    x0 = varargin{2};
                    y0 = varargin{3};
                    z0 = varargin{4};
                    SampRate = floor(1/(t0(2)-t0(1)));
                    %ix = (SampRate*varargin{2}):(SampRate*varargin{3});
                    ix = find(t0 >= varargin{2} & t0 <= varargin{3});
                else
                    error('Invalid arguments.');
                end;
            end;
        end;
    end;
end;

if ix(1) == 0,
    ix(1) = 1;
end;

x0 = x0(ix);
y0 = y0(ix);
z0 = z0(ix);

dt = t0(2)-t0(1);
DeltaT = ceil(logspace(tstart,tstop,300));
DiffX = diff(x0);
DiffY = diff(y0);
DiffZ = diff(z0);

DX = 0*DeltaT;
DY = DX;
DZ = DX;

for tt = 1:length(DeltaT),
    Dt = DeltaT(tt);
    X_Dt = sum(reshape(DiffX(1:Dt*floor(numel(DiffX)/Dt)), Dt, floor(numel(DiffX)/Dt)), 1);
    Y_Dt = sum(reshape(DiffY(1:Dt*floor(numel(DiffY)/Dt)), Dt, floor(numel(DiffY)/Dt)), 1);
    Z_Dt = sum(reshape(DiffZ(1:Dt*floor(numel(DiffZ)/Dt)), Dt, floor(numel(DiffZ)/Dt)), 1);
    DX(tt) = var(X_Dt)/(2*Dt*dt); %(mean(X_Dt.^2) - mean(X_Dt)^2)/(2*Dt*dt);
    DY(tt) = var(Y_Dt)/(2*Dt*dt); %(mean(Y_Dt.^2) - mean(Y_Dt)^2)/(2*Dt*dt);
    DZ(tt) = var(Z_Dt)/(2*Dt*dt); %(mean(Z_Dt.^2) - mean(Z_Dt)^2)/(2*Dt*dt);
end;

if(draw_plot),
    %figure(2010);
    figure;
    semilogx(DeltaT*dt, [DX;DY;DZ], 'LineWidth', 2);
    xlabel('\Delta t [s]', 'FontSize', 16);
    ylabel('MSD(\Delta t) [\mum^2/s]', 'FontSize', 16);
    set(gca, 'FontSize', 16);
%     if nargin==3
%         [gxy,gz]=displayGains(varargin{1});
%     title(sprintf('data\\_%g from %g to %g  GainXY=%gdb, GainZ=%gdb',varargin{1},varargin{2},varargin{3},gxy,gz));
%     end
end;
dT = DeltaT*dt;

if nargout == 0,
    clear('dT', 'DX', 'DY', 'DZ');
end;

return;