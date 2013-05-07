figure
hold all

P=100*2;
initial_out=30;
clear tempX temp_x temp_fluo

for j=1:1:4
   for k=1:1:P*0.5
        tempX(j,k)= y0((j-1)*P+k+initial_out);
        temp_fluo(j,k)=daq_out((j-1)*P+k+initial_out);
   end
    
    temp_x(j,:)=tempX(j,:)-tempX(1);
    plot(temp_x(j,:),temp_fluo(j,:));   

end
 figure; hold all;
 for j=1:1:size(temp_x,1)
     plot(temp_x(j,:));
 end
 
x=mean(temp_x,1);
fluo=mean(temp_fluo,1);
std_fluo=std(temp_fluo,1);
figure
errorbar(x,fluo,std_fluo);
gaussian_fit(x,fluo)
