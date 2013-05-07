#include "mex.h" 
#include "math.h"
void corr_subroutine(double *t, double *u, int Nt, int Nu,
    double tau_mn, double tau_mx , double *naa , double *nbb, double *g_tmpp, double *mm)
{
    double g_tmp , T , tau_avg , dtau;
    int kk , na , nb , ix_low ,  ix_hig;

/*see FCS_core.c for all the notes about this code.*/ 
    g_tmp = 0.0;  
    ix_low = 0;
    ix_hig = 0;
    na = 0;
	nb = 0;
    
    dtau = tau_mx - tau_mn;
    tau_avg = 0.5*(tau_mx+tau_mn);  
    
    T = t[Nt-1];
    
    if(u[Nu-1] > T)
    {
        T = u[Nu-1];
    }

    for(kk=0; kk<Nt; kk++)
    {
          while((ix_low < Nu ? u[ix_low] : t[kk]+tau_mn+1) < (t[kk]+tau_mn)){ix_low++;}
          while((ix_hig < Nu ? u[ix_hig] : t[kk]+tau_mx+1) <= (t[kk]+tau_mx)){ix_hig++;}    
           g_tmp += (ix_hig-ix_low);  /*this is precisely the algorithm*/ 
         	if(t[kk]<=T-tau_avg){na++;}
    }
  
    
    while((nb < Nu ? u[nb] : tau_avg + 1) < tau_avg){nb++;}
    nb = Nu-nb;
   
    
    *naa=na;
    *nbb=nb;
    *g_tmpp=g_tmp;
    *mm=(T-tau_avg)/dtau;
    
}


/*end of subroutine*/








void mexFunction(int nlhs, mxArray *plhs[] , int nrhs , const mxArray *prhs[])
{
    double *t , *u;
    double *naa;
    double *nbb;
    double *g_tmpp;
    double *mm;
    double *tau_mn , *tau_mx;
    int n_t , m_t , n_u , m_u , N_t , N_u;
    int N_tau , n_mn , m_mn , n_mx , m_mx;
    int kk;
    
    /* check number of input arguments*/
    if(nrhs != 4){
        mexErrMsgTxt("Wrong number of input arguments.");}    

    /*get input argument dimensions*/
    m_t = mxGetM(prhs[0]);
    n_t = mxGetN(prhs[0]);
    
    m_u = mxGetM(prhs[1]);
    n_u = mxGetN(prhs[1]);
    
    m_mn = mxGetM(prhs[2]);
    n_mn = mxGetN(prhs[2]);
    
    m_mx = mxGetM(prhs[3]);
    n_mx = mxGetN(prhs[3]);    
    
    /* check that tau_mn and tau_mx are equal dimension etc*/
    if (!(m_mn==m_mx) || !(n_mn==n_mx) || (m_mn*n_mn != m_mn & m_mn*n_mn != n_mn)){
        mexErrMsgTxt("Input arguments tau_mn and tau_mx must vectors of equal size.");}
    
    N_t = n_t*m_t;
	N_u = n_u*m_u;

    t = mxGetPr(prhs[0]);    
    u = mxGetPr(prhs[1]);
    
    N_tau = n_mx*m_mx;
    tau_mn = mxGetPr(prhs[2]);
    tau_mx = mxGetPr(prhs[3]);
    
    /*prepare matrix for outputs*/
    plhs[0] = mxCreateDoubleMatrix(m_mx,n_mx,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(m_mx,n_mx,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(m_mx,n_mx,mxREAL);
    plhs[3] = mxCreateDoubleMatrix(m_mx,n_mx,mxREAL);
    
    naa = mxGetPr(plhs[0]);
    nbb=mxGetPr(plhs[1]);
    g_tmpp=mxGetPr(plhs[2]);
    mm=mxGetPr(plhs[3]);
    
    /*call subroutine*/
    for(kk=0; kk < N_tau; kk++){
        corr_subroutine(t,u,N_t,N_u,tau_mn[kk],tau_mx[kk],&naa[kk],&nbb[kk],&g_tmpp[kk],&mm[kk]);}
}
















