% syms k12 k21 Q k A
% 
% 
% k21=solve('(((k-k21)/k21)*(1-Q)^2)/(1+(k-k21)*Q/k21)^2-A',k21);
% k12=k-k21;
% 
    clear AA DA FRET kt p1 p2 rate12 rate21 std_rate12 std_rate21 stdkt

for j=1:1:4
    syms k12 k21 A1 A2 D1 D2 pi1 pi2 DD
    jj=j+4;
    AA=Aamp(jj);
    DA=Damp(jj);
    FRET=co129.FRET(jj)
    kt(j)=(Arate(jj)+Drate(jj))/2;
    stdkt(j)=(0.25*stdArate(jj)^2+0.25*stdDrate(jj)^2)^0.5;

%     pi1=k21/kt;
%     pi2=(kt-k21)/kt;
% 
%     s(j)=solve(sprintf('%f-((1-pi1)/pi1)*(1-(3-A1)/A1)^2/(1+(1-pi1)*(3-A1)/pi1/A1)^2',AA), ...
%     sprintf('%f-(pi1/pi2)*(1-(3-A1)/A1)^2/(1+pi1*(3-A1)/pi2/A1)^2',DA), ...
%     sprintf('%f-(pi1*A1+pi2*(3-A1))/(3)',FRET), ...
%     'pi1','pi2','A1')
    s(j)=solve(sprintf('%f-((1-pi1)/pi1)*(1-(3-A1)/A1)^2/(1+(1-pi1)*(3-A1)/pi1/A1)^2',AA), ...
    sprintf('%f-(pi1*A1+(1-pi1)*(3-A1))/(3)',FRET), ...
    'pi1','A1')

    Aopen(j)=s(j).A1(2);
    p1(j)=s(j).pi1(2);
    p2(j)=1-s(j).pi1(2);
    
    rate12(j)=kt(j)*p2(j);
    std_rate12(j)=stdkt(j)*p2(j);
    rate21(j)=kt(j)*p1(j);
    std_rate21(j)=stdkt(j)*p1(j);
end
figure;
errorbar(1:1:4,rate12,std_rate12,'--ob');
hold on;
errorbar(1:1:4,rate21,std_rate21,'--or');
xlabel('sample index','FontSize',14);
ylabel('Rate(Hz)','FontSize',14)