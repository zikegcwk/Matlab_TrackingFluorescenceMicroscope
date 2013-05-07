#include "mex.h" 
void corr_subroutine(double *t, double *u, int N,
    double tau_mn, double tau_mx , double *g)
{
    double g_tmp , T , tau_avg , dtau;
    int kk , na , nb , ix_low ,  ix_hig;

    g_tmp = 0.0;
    
    ix_low = 0;
    ix_hig = 0;

    for(kk=0; kk<N; kk++){
        while(ix_low < N & (u[ix_low] < (t[kk]+tau_mn))){ix_low++;}
        while(ix_hig < N & (u[ix_hig] <= (t[kk]+tau_mx))){ix_hig++;}
            
        g_tmp += (ix_hig-ix_low);
    }

    dtau = tau_mx - tau_mn;
    tau_avg = 0.5*(tau_mx+tau_mn);
    
    T = t[N-1];
    if(u[N-1] > T){T = u[N-1];}
    
    na = 0;
    while( na < N & t[na] <= T-tau_avg){na++;}
    
    nb = 0;
    while( nb < N & u[nb] < tau_avg){nb++;}
    nb = N-nb;
        
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
    int nt , mt , nu , mu , N;
    
    mt = mxGetM(prhs[0]);
    nt = mxGetN(prhs[0]);
    
    mu = mxGetM(prhs[1]);
    nu = mxGetN(prhs[1]);
    
    // check number of input arguments
    if(nrhs != 4){
        mexErrMsgTxt("Wrong number of input arguments.");}    

    // check that t and u are equal dimension, then check that t is not a matrix (which also checks u)
    if (!(mt==mu) || !(nt==nu) || (mt*nt != mt & mt*nt != nt)){
        mexErrMsgTxt("Input arguments t and u must vectors of equal size.");}
    //check tau's are real scalars too
    
    N = nt*mt;
    t = mxGetPr(prhs[0]);    
    u = mxGetPr(prhs[1]);
    
    tau_mn = mxGetScalar(prhs[2]);
    tau_mx = mxGetScalar(prhs[3]);
    
    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    g = mxGetPr(plhs[0]);
    
    //call some subroutine
    corr_subroutine(t,u,N,tau_mn,tau_mx,g);
}
