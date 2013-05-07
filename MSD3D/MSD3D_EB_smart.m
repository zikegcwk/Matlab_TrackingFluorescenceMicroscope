%   MSD3D   Compute the mean-squared deviation from a tracking trajectory
%   as a function of time interval
%
%   [dT, dX, dY, dZ] = MSD3D(filenum, t_start, t_stop) returns the MSD
%   curve for all three axes corresponding to the data in file
%   data_filenum, starting at time t_start and ending at t_stop.
%
%   See also msdfit, msdfit2, drawplots3d
function [dT, DX, DY, DZ,EB] = MSD3D_EB_smart(t0,x0,y0,z0);

tstart = 0;
tstop = log10(1000); %log(T/1ms)

dt = t0(2)-t0(1);
DeltaT = ceil(logspace(tstart,tstop,250));
DiffX = diff(x0);
DiffY = diff(y0);
DiffZ = diff(z0);

DX = 0*DeltaT;
DY = DX;
DZ = DX;
EB=0*DeltaT;
        
for tt = 1:length(DeltaT),
    Dt = DeltaT(tt);
    X_Dt = sum(reshape(DiffX(1:Dt*floor(numel(DiffX)/Dt)), Dt, floor(numel(DiffX)/Dt)), 1);
    Y_Dt = sum(reshape(DiffY(1:Dt*floor(numel(DiffY)/Dt)), Dt, floor(numel(DiffY)/Dt)), 1);
    Z_Dt = sum(reshape(DiffZ(1:Dt*floor(numel(DiffZ)/Dt)), Dt, floor(numel(DiffZ)/Dt)), 1);
    DX(tt) = var(X_Dt)/(2*Dt*dt); %(mean(X_Dt.^2) - mean(X_Dt)^2)/(2*Dt*dt);
    DY(tt) = var(Y_Dt)/(2*Dt*dt); %(mean(Y_Dt.^2) - mean(Y_Dt)^2)/(2*Dt*dt);
    DZ(tt) = var(Z_Dt)/(2*Dt*dt); %(mean(Z_Dt.^2) - mean(Z_Dt)^2)/(2*Dt*dt);
    EB(tt)=sqrt(length(X_Dt));
end;

dT = DeltaT*dt;

return;