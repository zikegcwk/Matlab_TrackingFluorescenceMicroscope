%function FCS_fmin_s(tau,gdd,gaa,gad) takes three FCS curves openloop and
%fit them to three functions simultaneously, by minimizing the overall
%square differences. 

function paraf=FCS_fmin_s(tau,gdd,gaa)
wxy=1;
wz=pi*wxy^2/0.532;

fminf=@(para) sum((gdd-g2dd(tau,para)).^2)+sum((gaa-g2aa(tau,para)).^2);
paraf=fminsearch(fminf,[])




function sq=g2aa(tau,para)
wxy=1;
wz=pi/0.532;
K=para(1);
rate=para(2);
Difu=para(3);
NN=para(4);

sq=(K.*exp(-rate.*tau)).*FCS_openloop(tau,wxy,wz,NN,Difu);

end
function sq2=g2dd(tau,para)
wxy=1;
wz=pi/0.532;
K=para(1);
rate=para(2);
Difu=para(3);
NN=para(4);
sq2=((1/K).*exp(-rate.*tau)).*FCS_openloop(tau,wxy,wz,NN,Difu);

end 