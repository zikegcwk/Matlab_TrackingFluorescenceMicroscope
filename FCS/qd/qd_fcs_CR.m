%function qd_fcs_CR calculate FCS curves for file_N files and average them with the option to plot.
%The taumin and taumax are to specify the limite of tau. N is the number of
%points calculated in tau.  Modified by C.R. 7/14/09 to calculate
%cross-correlations only in case of two channels 
%and to account for a finite delay d_off present in channel 2 of 2;
%[tau,gR,gG,gX] = qd_fcs_CR(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag,lin,d_off),


function [tau,gX,gR,gG] = qd_fcs_CR(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag,lin,d_off),
 
fprintf('Your value of delay is %g\n',d_off);

if nargin==1
    e_N=s_N;
    taumin=-5;
    taumax=-1;
    N=600;
    t_min=0;
    t_max=60;
    plot_flag=1;
    lin = 0;
    d_off = 0.0;
end

if nargin==2
    taumin=-5;
    taumax=- 1;
    N=600;
    t_min=0;
    t_max=60;
    plot_flag=1;
    lin = 0;
    d_off = 0.0;
end


if nargin==4
    taumin=-5;
    taumax=-1;
    N=600;
    plot_flag=1;
    lin = 0;
    d_off = 0.0;
    
end


        gR=zeros(e_N-s_N+1,N-1);
        gG=zeros(e_N-s_N+1,N-1);
        gX=zeros(e_N-s_N+1,N-1);
         
        clear rr0
        clear gg0
        clear xx0
      
   if s_N==e_N
       
       %If only 2 outputs are provided, then just compute cross-correlation, 
       %otherwise calculate the auto and cross correlation functions. 
       
       if nargout == 2 % only compute cross-correlation if two outputs are specified
           [tau,gX(1,:)]=lfcs_CR(s_N,taumin,taumax,N,t_min,t_max,lin,d_off);
       else
       [tau,gR(1,:),gG(1,:),gX(1,:)]=lfcs_CR(s_N,taumin,taumax,N,t_min,t_max,lin,d_off);
        %give the average correlation values from 10^-5 to 10^-4
       end
       for k=1:1:60
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
        for j=s_N+1:1:e_N+1
            jprime = j-s_N;
            if nargout ==2 % only compute cross-correlation if two outputs are specified
                [tau,gX(jprime,:)]=lfcs_CR(j-1,taumin,taumax,N,t_min,t_max,lin,d_off);
            else
            [tau,gR(jprime,:),gG(jprime,:),gX(jprime,:)]=lfcs_CR(j-1,taumin,taumax,N,t_min,t_max,lin,d_off);
            %give the average correlation values from 10^-5 to 10^-4
            end
            for k=1:1:200
                temp_gR(k)=gR(jprime,k);
                temp_gG(k)=gG(jprime,k);
                temp_gX(k)=gX(jprime,k);
            end    
        
            rr0(j)=mean(temp_gR);
            gg0(j)=mean(temp_gG);
            xx0(j)=mean(temp_gX);
        end

            ave_gR=mean(gR,1);
            ave_gG=mean(gG,1);
            ave_gX=mean(gX,1);

   end
   if plot_flag==1
       scrsz = get(0,'ScreenSize');
       figure('Name',cd,'Position',[100 0.55*scrsz(4) 0.33*scrsz(3) 0.33*scrsz(4)]);
       if lin
           plot(tau,ave_gR,'blue--',tau,ave_gG,'green--',tau,ave_gX,'r-');
       else
           semilogx(tau,ave_gR,'blue--',tau,ave_gG,'green--',tau,ave_gX,'r-');
       end  
       xlabel('delay lag (S)','FontSize',14);
       ylabel('g2','FontSize',14);
       title('Auto and Cross-Correlations','Color','r','FontSize',14);
    else
    end
% if plot_flag==1
%    scrsz = get(0,'ScreenSize');
% 
%     figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100])
%     
%     subplot(1,3,1);
%     semilogx(tau,ave_gR,'b');
%     xlabel('correlation time scale (S)','FontSize',14);
%     ylabel('Auto-correlation value','FontSize',14);
%     title('Atto425 Auto-Correlation','Color','r','FontSize',14);
% 
%     subplot(1,3,2)
%     semilogx(tau,ave_gG,'g');
%     xlabel('correlation time scale (S)','FontSize',14);
%     ylabel('Auto-correlation value','FontSize',14);
%     title('Atto532 Auto-Correlation','Color','r','FontSize',14);
% 
%     
%     subplot(1,3,3)   
%     semilogx(tau,ave_gX,'r');
%     xlabel('correlation time scale (S)','FontSize',14);
%     ylabel('Cross-correlation value','FontSize',14);
%     title('Cross-Correlation','Color','r','FontSize',14);
% else
%     
% end