%function bimolelular_reaction_fit takes time series of reaction extent
%subject to some initial concentration of Ro and Go and fit the data to
%simple model given by Notes:???: 


function [k,to]=bimolecular_reaction_fit(t,extent,Ro,color)

f2fit=@(parameters,t) bimolecular_reaction(parameters(1),parameters(2),t);

[parameters_fit,r]=nlinfit(t,extent,f2fit,[10^-3 50])

k=parameters_fit(1)/Ro;
to=parameters_fit(2);


figure('Name',cd)
plot(t,extent,'*','LineWidth',1,'MarkeredgeColor',color,'MarkerFaceColor',color,'MarkerSize',5);
hold on;
time=linspace(-to,max(t),20000);
plot(time,bimolecular_reaction(parameters_fit(1),parameters_fit(2),time),color,'LineWidth',2);
text(max(time)*0.6,0.2,strcat('On rate is --',num2str(k),'M^-1*S^-1'),'Color',[0,0,1]);
text(max(time)*0.6,0.4,strcat('Starting time is --',num2str(to),'S'),'Color',[0,0,1]);


figure('Name',cd)
plot(t,r,'*k')



function f=bimolecular_reaction(kR,to,t)


    f=kR*(t+to)./(1+kR*(t+to));
    
    