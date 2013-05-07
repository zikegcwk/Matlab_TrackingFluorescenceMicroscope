% sigsq = gausspoly_variance(L, wxy, wz, sigxy, sigz, gamxy, gamz, y)

function gof0 = gausspoly_variance(L, b, y_over_L, wxy, wz, sigxy, sigz)

[ylmesh, ymmesh] = meshgrid(y_over_L, y_over_L);

Varphilm = L*b/9 - L*b/6*(abs(ylmesh + ymmesh) + abs(ylmesh-ymmesh))...
    + L*b/6*(ylmesh.^2 + ymmesh.^2);

al_sq = diag(Varphilm);

[almesh, ammesh] = meshgrid(al_sq, al_sq);

staticMxy = (almesh + wxy^2/4 + sigxy^2).*(ammesh + wxy^2/4 + sigxy^2);
staticMz  = (almesh + wz^2/4 + sigz^2).*(ammesh + wz^2/4 + sigz^2);

dynamicMxy = (sigxy^2 + Varphilm).^2;
dynamicMz = (sigz^2 + Varphilm).^2;

f2 = sum(sum(1./(staticMxy - dynamicMxy).*1./sqrt(staticMz - dynamicMz)));
fnorm = sum(sum(1./staticMxy.*1./sqrt(staticMz)));

gof0 = f2 / fnorm-1;
return;