function [Dx,Dy,zfiltx,zfilty,tz] = estD(txy,x,y,binFilt);

txy = reshape(txy,1,length(txy));
x = reshape(x,1,length(x));
y = reshape(y,1,length(y));

ix_temp = 1:binFilt:length(txy);

xfilt = x(ix_temp).';
yfilt = y(ix_temp).';
tfilt = txy(ix_temp).';

dt = mean(diff(tfilt));

if nargout <3;
    % fast calculate only final estimate
    Dx = var(diff(xfilt))/2/dt;
    Dy = var(diff(yfilt))/2/dt;
else
    % slow loop, calculate running estimate over input times
	zfiltx = 0*tfilt;
	zfilty = 0*tfilt;
	for jj=1:length(tfilt);
        zfiltx(jj) = var(diff(xfilt(1:jj)))/2/dt;
        zfilty(jj) = var(diff(yfilt(1:jj)))/2/dt;
	end;
    
    Dx = zfiltx(end);
    Dy = zfilty(end);
	
	%hold on;
	tz = (1:length(zfiltx))*mean(diff(tfilt))+min(txy);
end;