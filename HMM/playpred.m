clear small;
clear ninefive five;
dfyear=[100,130,175,140,75,40,30];
    
for k=1:1:7
    for j=2:1:length(bin)
        small(k,j)=5*(pred(k,j)+pred(k,j-1))*0.5;
    end    
        
    
    sum(small);
    intsmall(k,:)=cumsum(small(k,:));
end

figure;
hold all;

for k=1:1:7
     plot(bin,intsmall(k,:))
 one(k)=bin(min(find(intsmall(k,:)>0.01)));
 five(k)=bin(min(find(intsmall(k,:)>0.05)));
 ninefive(k)=bin(max(find(intsmall(k,:)<0.95)));
 ninenine(k)=bin(max(find(intsmall(k,:)<0.99)));

end
 
    
figure;hold all;
plot(1999:1:2005,one,'--sb')
plot(1999:1:2005,five,'--or');
plot(1999:1:2005,ninefive,'--or');
plot(1999:1:2005,ninenine,'--sb');
plot(1999:1:2005,dfyear,'*-k')
xlabel('Year','FontSize',14);
Box on;
ylabel('Number of Defaults in the Year','FontSize',14);