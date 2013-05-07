%function fcs_section(tau,g2,taumin) will sect g2 from taumin to max(tau)
function [tau_c,g2_section]=fcs_section(tau,g2,taumin)

t_index=min(find(tau>10^taumin));
tau_c=tau(t_index:end);



for j=1:1:size(g2,1)
    for k=1:1:6
        if k<4   
             g2_section{j,k}=g2{j,k}(t_index:end);
        else
            for l=1:1:size(g2{j,k},1)
                g2_section{j,k}(l,:)=g2{j,k}(l,t_index:end);
            end
        end
    end
end

if size(g2,2)>6
    for j=1:1:size(g2,1)
        g2_section{j,7}=g2{j,7};
    end
end