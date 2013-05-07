#include "mex.h" 
#include "math.h"
void corr_subroutine(double *t, double *u, int Nt, int Nu,
    double tau_mn, double tau_mx , double *g , double *g_std)
{
    double g_tmp , T , tau_avg , dtau;
    int kk , na , nb , ix_low ,  ix_hig;
    double C[Nt];
/*this core is adapted from Andy's C code.*/    
/*Nt and Nu are number of photons in t and u.*/

/*This looks like g2tau initialization.*/
    g_tmp = 0.0;  
    
    ix_low = 0;
    ix_hig = 0;

    for(kk=0;kk<Nt;kk++)
    {
          C[kk]=0.0;
        
    }   
	/* counters for normalization*/
	na = 0;
	nb = 0;


/*dtau is the binning window of tau. This also serves as a binning window of photons. 
   when you think about how to calculate FCS, note the intensity is actually a discrete function of time. You 
 actually need to use the discrete version of autocorrelation to understand the numerical manipulations 
 carried on here.  
  tau_avg is the middel tau average point
 They are here in order to calculate the normalized g2tau.*/
    dtau = tau_mx - tau_mn;
    tau_avg = 0.5*(tau_mx+tau_mn);  
    
/* t is an arrary from 0 to Nt-1. Thus T is the maximum of t and u. */    
    T = t[Nt-1];
    if(u[Nu-1] > T){T = u[Nu-1];}

    for(kk=0; kk<Nt; kk++)
    {
/*  
Here is actually two loops together. for a kk, that is, for a photon in the t data, 
it's finding the number of photons in u whoes values are less than t with tau min.

This looks to me that t is the master stream while u is the slave stream. 

this two loop together still only calculate for one set of taumin and taumax. 
In other words, we need to use subroutine many times (depend on how many taus we have)
in order to calculate the FCS curves across some tau spectrum. 

The following can cause seg faults.  

//        while(ix_low < Nu & (u[ix_low] < (t[kk]+tau_mn))){ix_low++;}
//        while(ix_hig < Nu & (u[ix_hig] <= (t[kk]+tau_mx))){ix_hig++;} */

          while((ix_low < Nu ? u[ix_low] : t[kk]+tau_mn+1) < (t[kk]+tau_mn)){ix_low++;}
          while((ix_hig < Nu ? u[ix_hig] : t[kk]+tau_mx+1) <= (t[kk]+tau_mx)){ix_hig++;}    
        
        
        /*
        look like my job here is to replace this g_tmp's value and store it as an arrary. 
        
        that is, for each photon in the master stream, it has some contribution to the g2(tau)
        that's one data point that takes into two sources of error into account. One is the stochastic
        trajectory taken by the fluorescence particle and the other is the stochastic photon emitting 
        process. 
        
        */
        g_tmp += (ix_hig-ix_low);  /*this is precisely the algorithm*/ 
		
        C[kk]=ix_hig-ix_low; /*C is the number of pairs for each photon in t*/
		
		
		if(t[kk]<=T-tau_avg){na++;}
    }

/*  More potential for seg faults. 
//    while( nb < Nu & u[nb] < tau_avg){nb++;} */
    while((nb < Nu ? u[nb] : tau_avg + 1) < tau_avg){nb++;}
    nb = Nu-nb;
        
    if(na > 0 & nb > 0 & dtau > 0 ){
          /*before the following step, g_tmp is the number of photon pairs that have time separation within tau_mn to tau_mx.*/
    
          /*now normalize g_tmp*/
        *g = g_tmp*(T-tau_avg)/na/nb/dtau;
          
    
    
    }
    else{*g = 0;} /*should be guaranteed??*/
    
    
   /* +g_tmp*g_tmp*dtau*(pow(na,-1.5)+pow(nb,-1.5))/(T-tau_avg)*/
   /*     *g_std=g_tmp*(T-tau_avg)*(na+nb)/na/nb/dtau;          */
   
    
    *g_std=*g*sqrt(1/g_tmp);
    
    
}


/*end of subroutine*/








void mexFunction(int nlhs, mxArray *plhs[] , int nrhs , const mxArray *prhs[])
{
    /* 
	g = eventTimeCorr( t , u , tau_mn , tau_mx)
	
	Routine for calculating cross correlation functions between two vectors 
	of event times. See Laurence et. al. Opt. Lett. 31,829 (2006). Resulting correlation 
	function is averaged over the specified time bin, and the normalization within each bin 
	is approximated using the average time bin. (i.e. for bin times comparable to dynamic 
	timescales in the data, some artifacts may arise from this method.)
     
     I don't think you can ever encounter this...you just need to use 'normal' bin sizes
     
     plus, all the algorithms that calculate FCS have to average over certain bin window. 
     
     THERE IS NO WAY AROUND THIS. 
     
     */
    
    double *t , *u;
    double *g;
    double *g_std;
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
    g = mxGetPr(plhs[0]);
    g_std=mxGetPr(plhs[1]);
    
    /*call subroutine*/
    for(kk=0; kk < N_tau; kk++){
        corr_subroutine(t,u,N_t,N_u,tau_mn[kk],tau_mx[kk],&g[kk],&g_std[kk]);}
}
















