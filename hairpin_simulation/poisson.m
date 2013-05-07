%function poisson generate photon arrial time tags given average rate and
%start time point and end time point. it's a realization of poisson
%process. 
function T=poisson(lambda,t_start,t_end)


T=-1;%if no output generated, T will be this value. This serves as a marker to prevent no output error.


t(1)=t_start+random('Exponential',1/lambda);

i=1;
while t(i) < t_end,
  t(i+1)=t(i)+random('Exponential',1/lambda);
  i=i+1;
    
end

for j=1:1:length(t)-1
        T(j)=t(j);
end

