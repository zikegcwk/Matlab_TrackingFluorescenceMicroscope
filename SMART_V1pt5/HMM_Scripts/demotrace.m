%transition matrix
A = [0.9 0.1 0 ;...
     0.1 0.88 0.02 ; ...
     0    0.01 0.99];
%  A = [0.99 0.01 ; 0.01 0.99];
%length of trace
N = 2000;

%means and standard deviations of red or green channel in state 1 or 2
mrL   = 100;      mgH = 130;
stdrL = 10;      stdgH = 10;
mrH   = 120;     mgL  = 110;
stdrH = 10;      stdgL = 10;

nStates = size(A,1);
nChannels = 2; %red and green

% parameter array has format E{n,c}(p) = value of parameter #p in hidden
% state n, channel c (c = 1,2 means red,green);
E = cell([nStates nChannels]);
E{1,1} = [mrL; stdrL]; E{1,2} = [mgH ; stdgH];
E{2,1} = [mrH; stdrH]; E{2,2} = [mgL ; stdgL];
E{3,1} = [mrL; stdrL]; E{3,2} = [mgH ; stdgH];

[pi,x] = HMMNoisy3_(A,E,'gauss',N);
%x is N by nChannels, so x(t,1) is the red value of the red channel at time t
%pi is T by 1, where pi(t) tells you the hidden state at time t

figure
subplot(2,1,1)
plot(x)
title('emissions')
subplot(2,1,2)
plot(pi,'r-');
axis([0 length(pi) 0 (nStates+1)]);
title('hidden state')