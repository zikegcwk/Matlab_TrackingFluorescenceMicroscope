function r=ts_rates_with_error(rate_obj,Qh_obj,Qavg_obj)
%% prepare parameters
amp=rate_obj.amp;
c1=rate_obj.amp;
stdc1=rate_obj.stdamp;
k=rate_obj.rate;
stdk=rate_obj.stdrate;

Qh=Qh_obj.bness;
c2=Qh_obj.bness;
stdc2=Qh_obj.bstd;

avgQ=Qavg_obj.bness;
c3=Qavg_obj.bness;
stdc3=Qavg_obj.bstd;

    
%% perform calculation
%as=solve('ph+pl-1','(ph/pl)*(1-Qh*pl/(c3-ph*Qh))^2-c1*(1+ph*Qh/(c3-ph*Qh))^2');
%ph=as.ph;
%pl=as.pl;

ph=(c1*c3^2)/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2);
pl=(c2 ^2 - 2*c2*c3 + c3^2)/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2);

diff_phc1=c3^2/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2) - (c1*c3^4)/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2)^2;
diff_phc2=-(c1*c3^2*(2*c2 - 2*c3))/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2)^2;
diff_phc3=(2*c1*c3)/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2) - (c1*c3^2*(2*c3 - 2*c2 + 2*c1*c3))/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2)^2;

diff_plc1=-(c3^2*(c2^2 - 2*c2*c3 + c3^2))/(c1*c3^2 - 2*c2*c3 + Qh^2 + c3^2)^2;
diff_plc2=(2*c2 - 2*c3)/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2) - ((2*c2 - 2*c3)*(c2^2 - 2*c2*c3 + c3^2))/(c1*c3^2 - 2*c2*c3 + c2^2 + c3^2)^2;
diff_plc3=-(2*c2 - 2*c3)/(c1*c3^2 - 2*c2*c3 + Qh^2 + c3^2) - ((2*c3 - 2*c2 + 2*c1*c3)*(c2^2 - 2*c2*c3 + c3^2))/(c1*c3^2 - 2*c2*c3 + Qh^2 + c3^2)^2;

std_ph=(diff_phc1^2*stdc1^2+diff_phc2^2*stdc2^2+diff_phc3^2*stdc3^2)^0.5;
std_pl=(diff_plc1^2*stdc1^2+diff_plc2^2*stdc2^2+diff_plc3^2*stdc3^2)^0.5;

Ql=(c3-ph*c2)/pl;
diff_Qlc3=1/pl;
diff_Qlph=-c2/pl;
diff_Qlpl=-(c3 - c2*ph)/pl^2;
std_Ql=(diff_Qlc3^2*stdc3^2+diff_Qlph^2*std_ph^2+diff_Qlpl^2*std_pl^2)^0.5;

K=ph/pl;
stdK=(std_ph^2/pl^2+std_pl^2*ph^2/pl^4)^0.5;

klh=K*k/(K+1);
diff_klh_k=K/(K + 1);
diff_klh_K=k/(K + 1) - (K*k)/(K + 1)^2;
std_klh=(diff_klh_k^2*stdk^2+diff_klh_K^2*stdK^2)^0.5;

khl=k/(K+1);
std_khl=std_klh;

%% prepare output. 
r.K=K;
r.Q=Qh/Ql;
r.klh=klh;r.std_klh=std_klh;
r.khl=khl;r.std_khl=std_khl;
r.ph=ph;r.std_ph=std_ph;
r.pl=pl;r.std_pl=std_pl;


r.amp=rate_obj.amp;
r.std_amp=rate_obj.stdamp;
r.k=rate_obj.rate;
r.std_k=rate_obj.stdrate;

r.avgQ=avgQ;
r.std_avgQ=Qavg_obj.bstd;

r.Ql=Ql;
r.std_Ql=std_Ql;
r.Qh=Qh;
r.std_Qh=Qh_obj.bstd;







