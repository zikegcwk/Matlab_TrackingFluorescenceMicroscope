#include "mex.h"
#include "matrix.h"
#include <math.h>
#include <stdlib.h>

/* usage: signal_out = fast_lee_filter(signal, m, sigma_0); Uses the Lee filter with 
	coefficient sigma_0 and window m to smooth the input signal.
*/

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
    int ii, jj, m, *signal_dim, num_bins, window_min, window_max, window_size;
    double *signal, sigma_0, *signal_out, running_var, *running_means;
	       
    signal_dim = (int *) mxGetDimensions(prhs[0]);
    num_bins = signal_dim[0] * signal_dim[1];
    
    signal = (double *) mxGetPr(prhs[0]);
    m = (int) mxGetPr(prhs[1])[0];
	sigma_0 = mxGetPr(prhs[2])[0];

	window_size = 2 * m + 1;

    plhs[0] = mxCreateDoubleMatrix(signal_dim[0], signal_dim[1], mxREAL);
    signal_out = mxGetPr(plhs[0]);
	
	running_means = (double *) malloc(num_bins * sizeof(double));
    
	for(ii = 0; ii < num_bins; ii++) {
		window_min = (ii > m) ? ii - m : 0;
		window_max = (num_bins > ii + m) ? ii + m : num_bins;
		
		running_means[ii] = 0.0;
		for(jj = window_min; jj <= window_max; jj++)
			running_means[ii] += signal[jj];
		
		running_means[ii] /= window_size;
	}

	for(ii = 0; ii < num_bins; ii++) {
		window_min = (ii > m) ? ii - m : 0;
		window_max = (num_bins > ii + m) ? ii + m : num_bins;
		
		running_var = 0.0;
		for(jj = window_min; jj <= window_max; jj++)
			running_var += (signal[jj] - running_means[jj])*(signal[jj] - running_means[jj]);
		running_var /= window_size;

		signal_out[ii] = running_means[ii] + (signal[ii] - running_means[ii]) * running_var / (running_var + sigma_0*sigma_0);
	}

	free(running_means);

	return;
}
