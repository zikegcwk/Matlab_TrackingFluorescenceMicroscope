function f = DestNoise(beta,dt);
beta=abs(beta);
D = beta(1);
n = beta(2);
gc = beta(3);

if length(beta)<4;
    f = D-1./gc./dt.*(D-n^2*gc^2/2).*(1-exp(-gc*dt));
else
    gp = beta(4);
    A = [[-gp -gc*gp]; [1 0]];
    C = [0 gp*gc];
    Bu = [sqrt(2*D) 0].';
    Bn = [n 0].';
    
    Su = lyap(A,Bu*Bu.');
    Sn = lyap(A,Bn*Bn.');

    f = 0*dt;
    for jj=1:length(dt);
        M = expm(A*dt(jj));

        f(jj)= -2*C*A^-1*Su*C.'*dt(jj)...
            -2*C*A^-2*(eye(2)-M)*Su*C.'...
            +2*C*(eye(2)-M)*Sn*C.';
    end;
    f = f./2./dt;
end;