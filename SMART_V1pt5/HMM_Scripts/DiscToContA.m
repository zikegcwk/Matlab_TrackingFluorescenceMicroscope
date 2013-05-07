function A_cont = DiscToContA(A_disc,f_sample)
%computes continuous time transition matrix from discrete time transition
%matrix given the sample rate

%sometimes the output is undefined if the matrix logarithm of A is not real

A_cont = f_sample.*logm(A_disc);