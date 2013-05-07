%function c=scale(data,ref) takes two input (have to be the same size) and
%multiply data with c to match ref. It outputs the scale.

%works by fminsearch

function [c,val]=scale(data,ref)

[c,val]=fminsearch(@(x)sum((x*data-ref).^2),1);
%val=val/length(data);

if nargout==1
    clear val;
end

% 
% 
% function d=data_ref_diff(ref,data,cc)
% 
% temp_d=(cc*data-ref).^2;
% d=sum(tem_d);
