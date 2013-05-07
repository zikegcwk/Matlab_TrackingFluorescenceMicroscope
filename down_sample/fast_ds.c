#include "mex.h"
#include "matrix.h"
#include <math.h>

/* usage: t_ds = fast_ds(t, dt); Downsamples arrival-time data into photon counts in 
    time bins of width dt.
*/

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
	char stop = 0;
    int ii, curr_bin, num_phot, *t_dim, num_bins;
    double *t, dt, *t_ds;
        
    t_dim = (int *) mxGetDimensions(prhs[0]);
    num_phot = t_dim[0] * t_dim[1];
    
    t = (double *) mxGetPr(prhs[0]);
    dt = *((double *) mxGetPr(prhs[1]));

    num_bins = ceil(t[num_phot - 1] / dt);
    plhs[0] = mxCreateDoubleMatrix(1, num_bins, mxREAL);
    t_ds = mxGetPr(plhs[0]);
    
    curr_bin = 0;
    ii = 0;
    while(curr_bin < num_bins) {
        t_ds[curr_bin] = 0.0;
        while(t[ii] < (curr_bin + 1) * dt && !stop) {
            t_ds[curr_bin] += 1.0;
            if(ii < num_phot - 1)
				ii++;
			else
				stop = 1;
        }
        curr_bin ++;
    }
    return;
}
