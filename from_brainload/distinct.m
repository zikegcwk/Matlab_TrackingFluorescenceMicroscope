% Dset = distinct(S)
% Returns the distinct elements of a vector S; note that the elements are put
% into ascending order.
function Dset = distinct(S)


S = sort(S);
Dset(1) = S(1);
dindex = 1;
for k = 2:length(S);
    if S(k) ~= Dset(dindex),
        dindex = dindex + 1;
        Dset(dindex) = S(k);
    end;
end;
return;