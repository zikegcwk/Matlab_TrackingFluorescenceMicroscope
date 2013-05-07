%   MSD3D   Compute the mean-squared deviation from a tracking trajectory
%   as a function of time interval
%
%   [dT, dX, dY, dZ] = MSD3D(filenum, t_start, t_stop) returns the MSD
%   curve for all three axes corresponding to the data in file
%   data_filenum, starting at time t_start and ending at t_stop.
%
%   See also msdfit, msdfit2, drawplots3d
function [dT, DX, DY, DZ,EB] = MSD3D_EB_smart2(t0,x0,y0,z0);

tstart = 0;
tstop = log10(1000); %log(T/1ms)

dt = t0(2)-t0(1);
DeltaT = ceil(logspace(tstart,tstop,250));

DX = 0*DeltaT;
DY = DX;
DZ = DX;
EB=0*DeltaT;
        
for tt = 1:length(DeltaT),
    Dt = DeltaT(tt);
    X_Dt = diff2(x0,Dt);
    Y_Dt = diff2(y0,Dt);
    Z_Dt = diff2(z0,Dt);
    DX(tt) = var(X_Dt)/(2*Dt*dt); %(mean(X_Dt.^2) - mean(X_Dt)^2)/(2*Dt*dt);
    DY(tt) = var(Y_Dt)/(2*Dt*dt); %(mean(Y_Dt.^2) - mean(Y_Dt)^2)/(2*Dt*dt);
    DZ(tt) = var(Z_Dt)/(2*Dt*dt); %(mean(Z_Dt.^2) - mean(Z_Dt)^2)/(2*Dt*dt);
    EB(tt)=sqrt(length(X_Dt));
end;

dT = DeltaT*dt;

return;