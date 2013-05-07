function [Hmean,Hmeanfrac] = GetHmean(P,b)
%gets mean entropy of estimator P and mean entropy as fraction of maximum log(size(P,1))
%assumes P(i,j) = P(X_j = i|Y^T) posterior probability

if nargin == 1,
    b = exp(1); %if no base specified, use e
end
if size(P,1) > size(P,2),
    P = P';
end

Htotal = 0;
Hlist = zeros(1,size(P,2));
for i = 1:length(P),
    Htotal = Htotal + GetH(P(:,i),b);
    Hlist(i) = GetH(P(:,i),b);
end
Hmean = Htotal./size(P,2);
Hmeanfrac = Hmean./(log(size(P,1))/log(b));

% figure,hist(Hlist./(log(size(P,1))/log(b)));