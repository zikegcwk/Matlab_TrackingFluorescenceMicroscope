
% function fcs_1vs1 calculate and plot auto correlation and cross
% correlation for a situation where there is one detector at one
% wavelength. It output the amplitude of the fcs by averaging the fast time
% scale values. Note this is not a very good method as this require that
% there is no dynamics at this fast time scale. 

%see also fcs_2vs1 for the case where you have 2 detectors for one
%wavelength and 1 detector for another wavelength. 


function [rr0,gg0,xx0] = fcs_1vs1(s_N,e_N,t_min,t_max,taumin,taumax,N),


 
if nargin==1
    e_N=s_N;
    taumin=-5;
    taumax=-1;
    N=300;
    t_min=0;
    t_max=60;
end

if nargin==2
    taumin=-5;
    taumax=-1;
    N=300;
    t_min=0;
    t_max=60;
end


if nargin==4
    taumin=-5;
    taumax=-1;
    N=300;
    
end



        gR=zeros(e_N-s_N+1,N-1);
        gG=zeros(e_N-s_N+1,N-1);
        gX=zeros(e_N-s_N+1,N-1);
         
        clear rr0
        clear gg0
        clear xx0
      
        
   if s_N==e_N
        
        [tau,gR(1,:),gG(1,:),gX(1,:)]=lfcs(s_N,taumin,taumax,N,t_min,t_max);
        %give the average correlation values from 10^-5 to 10^-4
        for k=1:1:45
            temp_gR(k)=gR(1,k);
            temp_gG(k)=gG(1,k);
            temp_gX(k)=gX(1,k);
        end    
        
            rr0(1,1)=mean(temp_gR);
            gg0(1,1)=mean(temp_gG);
            xx0(1,1)=mean(temp_gX);
        
        ave_gR=mean(gR,1);
        ave_gG=mean(gG,1);
        ave_gX=mean(gX,1);
       
   else 
        for j=s_N:1:e_N
           [tau,gR(j,:),gG(j,:),gX(j,:)]=lfcs(j,taumin,taumax,N,t_min,t_max);
            %give the average correlation values from 10^-5 to 10^-4
            for k=1:1:45
                temp_gR(k)=gR(j,k);
                temp_gG(k)=gG(j,k);
                temp_gX(k)=gX(j,k);
            end    
        
            rr0(j)=mean(temp_gR);
            gg0(j)=mean(temp_gG);
            xx0(j)=mean(temp_gX);
        end

            ave_gR=mean(gR,1);
            ave_gG=mean(gG,1);
            ave_gX=mean(gX,1);

   end


   scrsz = get(0,'ScreenSize');

    figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100])
    
    subplot(1,3,1);
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('correlation value','FontSize',14);
    title(cd);
    semilogx(tau,ave_gR,'r');

    subplot(1,3,2)
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('correlation value','FontSize',14);
    title(cd);
    semilogx(tau,ave_gG,'g');
    
    subplot(1,3,3)   
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('correlation value','FontSize',14);
    title(cd);
    semilogx(tau,ave_gX,'b');
