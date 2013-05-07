#include <mex.h>
#include <matrix.h>
#include <stdlib.h>
#include <math.h>

/* required arguments (in order):
	sigmaxy
	sigmaz
	gamxy
	gamz 
	wxy
	wz
	L
	b
	Delta
	tau1
	a
	Rg
	tau
*/

#define MAX_P 200
#define __DEBUG

double varphi(const int, const int, const int, const double *, const double *, const double **, const double);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, a;
	double sigmaxy_sq, sigmaz_sq, wxy_sq, wz_sq;
	double *Rg, *Rg_sq, *tau;
	double *static_xy, *static_z, dynamic_xy, dynamic_z, dynamic_sys_xy, dynamic_sys_z;
	double *g, gnorm, tovertau, c, **cosmatrix, *pa, *pinv_sq, x;
	int numDyes, numTau, l, m, u;
    int p;
    
	if(nrhs != 13) 
		mexErrMsgTxt("This function requires 13 arguments. For argument list, see .c file.");
	
	sigmaxy = *(double *) mxGetPr(prhs[0]);
	sigmaz = *(double *) mxGetPr(prhs[1]);
	gamxy = *(double *) mxGetPr(prhs[2]);
	gamz = *(double *) mxGetPr(prhs[3]);
	wxy = *(double *) mxGetPr(prhs[4]);
	wz = *(double *) mxGetPr(prhs[5]);
	L = *(double *) mxGetPr(prhs[6]);
	b = *(double *) mxGetPr(prhs[7]);
	Delta = *(double *) mxGetPr(prhs[8]);
	tau1 = *(double *) mxGetPr(prhs[9]);
	a = *(double *) mxGetPr(prhs[10]);
	
	numDyes = mxGetN(prhs[11]);
	Rg = (double *) mxGetPr(prhs[11]);

	numTau = mxGetN(prhs[12]);
	tau = (double *) mxGetPr(prhs[12]);
    
    if(nlhs > 1)
        mexErrMsgTxt("This function only returns a single vector.");

	plhs[0] = mxCreateDoubleMatrix(1, numTau, mxREAL);
	g = mxGetPr(plhs[0]);

    static_xy = (double *) malloc(numDyes*sizeof(double));
    static_z = (double *) malloc(numDyes*sizeof(double));
    Rg_sq = (double *) malloc(numDyes*sizeof(double));

    sigmaxy_sq = sigmaxy*sigmaxy;
	sigmaz_sq = sigmaz*sigmaz;
	wxy_sq = wxy*wxy/4;
	wz_sq = wz*wz/4;
    
    for(l=0;l<numDyes;l++) {
        Rg_sq[l] = Rg[l]*Rg[l];
        static_xy[l] = sigmaxy_sq + Rg_sq[l] + wxy_sq;
        static_z[l] = sigmaz_sq + Rg_sq[l] + wz_sq;
    }
    
    pinv_sq = (double *) malloc(MAX_P*sizeof(double));
    pa = (double *) malloc(MAX_P*sizeof(double));
    cosmatrix = (double **) malloc(MAX_P*sizeof(double *));
	for(p = 1; p <= MAX_P; p++) {
        pinv_sq[p-1] = 1.0/p/p;
        pa[p-1] = pow((double) p, a);
        cosmatrix[p-1] = (double *) malloc(numDyes*numDyes*sizeof(double));
        for(l = 0; l < numDyes; l++)
            for(m = 0; m < numDyes; m++)
                cosmatrix[p-1][l + m*numDyes] = cos(M_PI*p*l*Delta/L)*cos(M_PI*p*m*Delta/L);
    }
    c = 2*L*b/3/M_PI/M_PI; /* Just a constant that appears often in the loop */

    for(u=0; u < numTau; u++) {
        /* store the systematic contributions to the dynamic terms because they do not depend on l,m */
        dynamic_sys_xy = sigmaxy_sq*exp(-gamxy*tau[u]); 
        dynamic_sys_z = sigmaz_sq*exp(-gamz*tau[u]);
        
        tovertau = tau[u]/tau1;
		g[u] = 0;
		gnorm = 0;
		for(l=0; l < numDyes; l++) {
            x = c*varphi(l,l,numDyes,pinv_sq, pa, cosmatrix, tovertau);
            dynamic_xy = dynamic_sys_xy + x;
        	dynamic_z = dynamic_sys_z + x;
                
            g[u] += 1/((static_xy[l]*static_xy[l] - dynamic_xy*dynamic_xy)*sqrt(static_z[l]*static_z[l]-dynamic_z*dynamic_z));
			gnorm += 1/(static_xy[l]*static_xy[l]*sqrt(static_z[l]*static_z[l]));
	   		for(m=0; m < l; m++) {
                x = c*varphi(l,m,numDyes,pinv_sq, pa, cosmatrix, tovertau);
    			dynamic_xy = dynamic_sys_xy + x;
        		dynamic_z = dynamic_sys_z + x;

                g[u] += 2/((static_xy[l]*static_xy[m] - dynamic_xy*dynamic_xy)*sqrt(static_z[l]*static_z[m]-dynamic_z*dynamic_z));
				gnorm += 2/(static_xy[l]*static_xy[m]*sqrt(static_z[l]*static_z[m]));
			}
		}
		g[u] /= gnorm;
		g[u] -= 1;
	}
    free(static_xy);
    free(static_z);
    free(Rg_sq);
    free(pinv_sq);
    free(pa);
    for(p = 0; p < MAX_P; p++)
        free(cosmatrix[p]);
    free(cosmatrix);
	return;
}

double varphi(const int l, const int m, const int numDyes, const double *pinv_sq, const double *pa, const double **cosmatrix, const double tovertau) {
    int p;
    double ret = 0;
    for(p=1;p<=MAX_P;p++)
        ret += pinv_sq[p-1]*exp(-tovertau*pa[p-1])*cosmatrix[p-1][l + m*numDyes];
    return ret;
}
