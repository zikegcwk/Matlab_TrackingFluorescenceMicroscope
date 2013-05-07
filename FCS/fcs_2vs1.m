
% function fcs_2vs1 calculate and plot auto correlation and cross
% correlation for a situation where there are two detectors at one
% wavelength and another detector at another wavelength. 

%see also fcs_1vs1 for the case where you have 1 detector for each
%wavelength.


function fcs_2vs1(s_N,e_N,t_min,t_max,taumin,taumax,N)


 
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

tau=logspace(taumin,taumax,N);
      
        
   if s_N==e_N
       
      load(sprintf('data_%g', s_N));
       
      g1=corr_Laurence(tags{2},tags{3},tau);
      g1 = g1(1:end-1)-1;
      fprintf('Autocorrelation from the cross correlation of two detectors calculated.\n')
      
      g2=corr_Laurence(tags{1},tags{1},tau);
      g2 = g2(1:end-1)-1;
      fprintf('Autocorrelation from a single detector calcualted.\n')
       
      ave_gR=mean(g1,1);
      ave_gG=mean(g2,1);
     
      
        
   else 
        for j=s_N:1:e_N
            load(sprintf('data_%g', j));
       
            g1=corr_Laurence(tags{1},tags{2},tau);
            gR(j,:) = g1(1:end-1)-1;
            fprintf('Autocorrelation from the cross correlation of two detectors calculated.\n')
      
            g2=corr_Laurence(tags{3},tags{3},tau);
            gG(j,:) = g2(1:end-1)-1;
            fprintf('Autocorrelation from a single detector calcualted.\n')

          

            ave_gR=mean(gR,1);
            ave_gG=mean(gG,1);

        end

   end


    figure('Name',cd)
    xlabel('correlation time scale (S)','FontSize',14);
    ylabel('correlation value','FontSize',14);
  
    clf; hold all;
    
    semilogx(tau(1:end-1),ave_gR,'r');
    semilogx(tau(1:end-1),ave_gG,'g');
    
    
    hold off;
    