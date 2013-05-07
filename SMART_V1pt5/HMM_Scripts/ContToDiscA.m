function A_disc = ContToDiscA(A_cont,f_sample)
%computes discrete time transition matrix from continuous time transition
%matrix given the sample rate

A_disc = expm(A_cont./f_sample);