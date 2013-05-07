F_high=3000;

F_low=1000;







%generate some simulation data first. 





%data 1 to 10 

lifetime_high=10*10^-3;

lifetime_low=10^-3;

for j=1:1:1

    disp(sprintf('file_%g',j));

    [tags,T]=Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,10,j);

end


% 
% 
% 
% %data 100 to 110 
% 
% lifetime_high=0.2;
% 
% lifetime_low=0.1;
% 
% for j=100:1:110
% 
%     disp(sprintf('file_%g',j));
% 
%     Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,60,j);
% 
% end
% 
% 
% 
% %data 200 to 210 
% 
% lifetime_high=0.02;
% 
% lifetime_low=0.01;
% 
% for j=200:1:210
% 
%     disp(sprintf('file_%g',j));
% 
%     Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,60,j);
% 
% end
% 
% 
% 
% %data 300 to 310 
% 
% lifetime_high=0.002;
% 
% lifetime_low=0.001;
% 
% for j=300:1:310
% 
%     disp(sprintf('file_%g',j));
% 
%     Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,60,j);
% 
% end
% 
% 
% 
% 
% 
% %data 400 to 410 
% 
% lifetime_high=0.0002;
% 
% lifetime_low=0.0001;
% 
% for j=400:1:410
% 
%     disp(sprintf('file_%g',j));
% 
%     Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,60,j);
% 
% end
% 
% 
% 
% 
% 
% %data 500 to 510 
% 
% lifetime_high=0.00002;
% 
% lifetime_low=0.00001;
% 
% for j=500:1:510
% 
%     disp(sprintf('file_%g',j));
% 
%     Markov_Hairpin(lifetime_high,lifetime_low,F_high,F_low,60,j);
% 
% end
% 
% 
% 
% 
% 
