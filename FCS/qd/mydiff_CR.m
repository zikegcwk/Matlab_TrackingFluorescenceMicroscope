function s = mydiff_CR(X,n)
% function mydiff_CR(X,n) returns a vector whose length is length(X)-n consisting of
% elements [X(n)-X(1) X(n+1)-X(2) ... X(length(X))-X(length(X)-n+1)] (C.R.
% 7/20/09)
a = [X(n+1:length(X)) zeros(1,n)]-X;
s = a(1:length(X)-n);
return;
