%i got some msd fit parameters stored as xyz and want to covert it to a
%series of structures that use its elements to represent 1 2 and 3. 
function fit123=fitconver(fitxyz)

fit123(1).D=fitxyz.Dx;
fit123(2).D=fitxyz.Dy;
fit123(3).D=fitxyz.Dz;

fit123(1).gammaC=fitxyz.gammaCx;
fit123(2).gammaC=fitxyz.gammaCy;
fit123(3).gammaC=fitxyz.gammaCz;

fit123(1).gammaP=fitxyz.gammaPx;
fit123(2).gammaP=fitxyz.gammaPy;
fit123(3).gammaP=fitxyz.gammaPz;

fit123(1).n=fitxyz.nx;
fit123(2).n=fitxyz.ny;
fit123(3).n=fitxyz.nz;



