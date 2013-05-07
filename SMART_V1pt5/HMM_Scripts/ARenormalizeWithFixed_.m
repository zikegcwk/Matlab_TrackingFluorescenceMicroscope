function A = ARenormalizeWithFixed_(rclist,A)
%makes sure Aout is transition rate matrix by normalizing each row of A and
%holding all pairs [r,c] in rclist fixed
%example, row [0.4 0.7 0.2], holding middle element fixed goes to [0.2 0.7 0.1]
%rclist format is [r1 c1 ; r2 c2 ;... ; rn cn]

Ap = A;
for i = 1:size(rclist,1),
    Ap(rclist(i,1),rclist(i,2)) = 0;
end
s1 = sum(Ap,2);
Ap = A.*0;
for i = 1:size(rclist,1),
    Ap(rclist(i,1),rclist(i,2)) = A(rclist(i,1),rclist(i,2));
end
s2 = 1-sum(Ap,2);

Ap = A;
% uniquerows = unique(rclist(:,1));
for i = 1:size(A,1),
    Ap(i,:) = A(i,:).*s2(i)/s1(i);
end
for i = 1:size(rclist,1),
    Ap(rclist(i,1),rclist(i,2)) = A(rclist(i,1),rclist(i,2));
end
A = Ap;