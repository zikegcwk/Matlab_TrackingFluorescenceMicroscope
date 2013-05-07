%function qd_fcs calculate FCS curves for file_N files and average them.
%The taumin and taumax are to specify the limite of tau. N is the number of
%points calculated in tau.
%[tau,gR,gG,gX] = qd_fcs(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag),


function [tau,ave_gX,gX] = qd_fcs(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag),


 
if nargin==1
    e_N=s_N;
    taumin=-7;
    taumax=-1;
    N=500;
    t_min=0;
    t_max=60;
    plot_flag=1;
end

if nargin==2
    taumin=-5;
    taumax=0;
    N=200;
    t_min=0;
    t_max=10;
    plot_flag=1;
end


if nargin==4
    taumin=-6; 
    taumax=-1;
    N=600;
    plot_flag=1;
    
end



        gR=zeros(e_N-s_N+1,N-1);
        gG=zeros(e_N-s_N+1,N-1);
        gX=zeros(e_N-s_N+1,N-1);
         
%         clear rr0
%         clear gg0
%         clear xx0
      
        
   if s_N==e_N
        
        %calculate the auto and cross correlation functions. 
       [tau,gR(1,:),gG(1,:),gX(1,:)]=lfcs_zk(s_N,taumin,taumax,N,t_min,t_max,0);
        %give the average correlation values from 10^-5 to 10^-4
%         for k=1:1:45
%             temp_gR(k)=gR(1,k);
%             temp_gG(k)=gG(1,k);
%             temp_gX(k)=gX(1,k);
%         end    
%         
%             rr0(1,1)=mean(temp_gR);
%             gg0(1,1)=mean(temp_gG);
%             xx0(1,1)=mean(temp_gX);
        
         ave_gR=mean(gR,1);
         ave_gG=mean(gG,1);
        ave_gX=mean(gX,1);
       
   else 
        for j=s_N:1:e_N
            cd
            disp(sprintf('Cross correlation on data_%g.mat. \n',j));
           [tau,gR(j,:),gG(j,:),gX(j,:)]=lfcs_zk(j,taumin,taumax,N,t_min,t_max,0);
            %give the average correlation values from 10^-5 to 10^-4
%             for k=1:1:45
%                 temp_gR(k)=gR(j,k);
%                 temp_gG(k)=gG(j,k);
%                 temp_gX(k)=gX(j,k);
%             end    
%         
%             rr0(j)=mean(temp_gR);
%             gg0(j)=mean(temp_gG);
%             xx0(j)=mean(temp_gX);
        end

            ave_gR=mean(gR,1);
            ave_gG=mean(gG,1);
            ave_gX=mean(gX,1);

   end

if plot_flag==1
   scrsz = get(0,'ScreenSize');

    figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100])
    
    subplot(1,3,1);
    semilogx(tau,ave_gR,'b');
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('Auto-correlation value','FontSize',14);
    title('Atto425 Auto-Correlation','Color','r','FontSize',14);

    subplot(1,3,2)
    semilogx(tau,ave_gG,'g');
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('Auto-correlation value','FontSize',14);
    title('Atto532 Auto-Correlation','Color','r','FontSize',14);

    
    subplot(1,3,3)   
    semilogx(tau,ave_gX,'r');
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('Cross-correlation value','FontSize',14);
    title('Cross-Correlation','Color','r','FontSize',14);
else
    
end