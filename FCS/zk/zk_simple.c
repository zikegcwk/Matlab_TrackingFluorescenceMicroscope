#include <math.h>
#include "mex.h"

static void square(double yp[],double y[])
{
   
    yp[0] = y[0]*y[0];
    return;
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
    double *yp; 
    double *y; 
        
    /* Create a matrix for the return argument */ 
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL); 
    
    /* Assign pointers to the various parameters */ 
    
    /*here plhs is a pointer and mxGetPr assign this pionter to yp.
      this is just a way to tell 
     */
    
    yp = mxGetPr(plhs[0]);
    y = mxGetPr(prhs[0]);
        
    /* Do the actual computations in a subroutine */
    square(yp,y); 
    return;
    
}


