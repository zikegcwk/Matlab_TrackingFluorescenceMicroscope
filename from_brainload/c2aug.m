% C2AUG Convert augmented vector/matrix to complex
%   aug_out = c2aug(c_in) returns an augmented vector/matrix, the size of
%   which is twice the size of aug_in in both dimensions. 
function aug_out = c2aug(c_in);

if length(size(c_in)) ~= 2,
    error('I do not understand.');
end;

if size(c_in, 2) == 1,
    aug_out = [real(c_in); imag(c_in)];
    return;
end;

if size(c_in, 1) == 1,
    aug_out = [real(c_in), imag(c_in)];
    return;
end;

aug_out = [real(c_in) -imag(c_in); imag(c_in) real(c_in)];

return;