%function single_fcs calculate FCS curves for file_N files and average them.
%The taumin and taumax are to specify the limite of tau. N is the number of
%points calculated in tau. 
%[tau, g2] =single_fcs_CR(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag,normalize_flag),

function [tau, g2] = single_fcs_CR(s_N,e_N,t_min,t_max,taumin,taumax,N,plot_flag,normalize_flag,linear),


%%%%%%%%%%%%%%%%%%%%%%% 
if nargin==1
    e_N=s_N;
    taumin=-5;
    taumax=-1;
    N=300;
    t_min=0;
    t_max=60;
    plot_flag=1;
    normalize_flag=0;
    linear=0;
end

if nargin==2
    taumin=-5;
    taumax=-1;
    N=300;
    t_min=0;
    t_max=60;
    plot_flag=1;
    normalize_flag=0;
    linear=0;
end


if nargin==4
    taumin=-5;
    taumax=-1;
    N=300;
    plot_flag=1;
    normalize_flag=0;
    linear=0;
    
end

if nargin==9
    linear=0;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     
   if s_N==e_N
        
        %calculate the auto and cross correlation functions. 
       [tau,g2]=lfcs_zk(s_N,taumin,taumax,N,t_min,t_max,linear);
       
       if normalize_flag==1
          for k=1:1:45
            temp_g(k)=g2(1,k);
          end    
           
          mean(temp_g)
          std(temp_g)
          
          amp_g2=mean(temp_g);
          g2=g2/amp_g2;
       end
    
       
   else 
        for j=s_N:1:e_N
           [tau,g2_temp(j,:)]=lfcs_zk(j,taumin,taumax,N,t_min,t_max,linear);
            %give the average correlation values from 10^-5 to 10^-4
        end
            g2=mean(g2_temp,1);
            
       if normalize_flag==1
          for k=1:1:45
            temp_g(k)=g2(1,k);
          end    
           
          temp_g(45)
          
          amp_g2=mean(temp_g);
          g2=g2/amp_g2;
       end
           
   end

if plot_flag==1


    figure('Name',cd)
    if linear
        semilogy(tau,g2,'k');
    else 
        semilogx(tau,g2,'k');
    end
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('Auto-correlation value','FontSize',14);
    title('Auto-Correlation','Color','r','FontSize',14);

else
    %do nothing!
end