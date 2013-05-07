#include "mex.h" 
void corr_subroutine(double *t, double *u, int Nt, int Nu,
    double tau_mn, double tau_mx , double *g)
{
    double g_tmp , T , tau_avg , dtau;
    int kk , na , nb , ix_low ,  ix_hig;

    g_tmp = 0.0;
    
    ix_low = 0;
    ix_hig = 0;

	// counters for normalization
	na = 0;
	nb = 0;

    dtau = tau_mx - tau_mn;
    tau_avg = 0.5*(tau_mx+tau_mn);
    
    T = t[Nt-1];
    if(u[Nu-1] > T){T = u[Nu-1];}

    for(kk=0; kk<Nt; kk++){
        while(ix_low < Nu & (u[ix_low] < (t[kk]+tau_mn))){ix_low++;}
        while(ix_hig < Nu & (u[ix_hig] <= (t[kk]+tau_mx))){ix_hig++;}
            
        g_tmp += (ix_hig-ix_low);
		
		if(t[kk]<=T-tau_avg){na++;}
    }

    while( nb < Nu & u[nb] < tau_avg){nb++;}
    nb = Nu-nb;
        
    if(na > 0 & nb > 0 & dtau > 0 ){
          g_tmp = g_tmp*(T-tau_avg)/dtau/na/nb;
    }
    else{g_tmp = 0;} //should be guaranteed??
    
    *g = g_tmp;
}

void mexFunction(int nlhs, mxArray *plhs[] , int nrhs , const mxArray *prhs[])
{
    /* subroutine for calculating correlation function from time stamp 
    data according to Laurence et al.*/
    
    double *t , *u;
    double *g;
    double tau_mn , tau_mx;
    int nt , mt , nu , mu , Nt, Nu;
    
    mt = mxGetM(prhs[0]);
    nt = mxGetN(prhs[0]);
    
    mu = mxGetM(prhs[1]);
    nu = mxGetN(prhs[1]);

	Nt = nt*mt;
	Nu = nu*mu;

    // check number of input arguments
    if(nrhs != 4){
        mexErrMsgTxt("Requires 4 input arguments.");}    
    
	if(!((Nt==nt) || (Nt==mt)) || !((Nu==nu) || (Nu==mu))){
		mexErrMsgTxt("Inputs t and u must be vectors.");}

	t = mxGetPr(prhs[0]);    
    u = mxGetPr(prhs[1]);
    
    tau_mn = mxGetScalar(prhs[2]);
    tau_mx = mxGetScalar(prhs[3]);
    
    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    g = mxGetPr(plhs[0]);
    
    //call some subroutine
    corr_subroutine(t,u,Nt,Nu,tau_mn,tau_mx,g);
}
