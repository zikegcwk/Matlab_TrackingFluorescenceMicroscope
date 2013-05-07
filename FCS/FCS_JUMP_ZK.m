function [tau,ave_X1,ave_X2,ave_X3,X1,X2,X3]=FCS_JUMP_ZK(s_N,e_N,tmin,tmax,taumin,taumax,N,tide)

 if e_N<s_N
     for j=s_N:1:(s_N+200)
         if exist(sprintf('data_%g.mat',j),'file')==2
             e_N=j;
         end
     end
 end

X1=zeros(e_N-s_N+1,N-1);
X2=zeros(e_N-s_N+1,N-1);
X3=zeros(e_N-s_N+1,N-1);
% X1_negative_flag=zeros(e_N-s_N+1,1);
% X2_negative_flag=zeros(e_N-s_N+1,1);

for j=1:1:(e_N-s_N+1)
           disp(sprintf('begin FCS calculations on file %g. ', j+s_N-1));
           
           
           [tau,X1(j,:),X2(j,:),X3(j,:)]=FCS_JUMP_ZK_4(s_N-1+j,tmin,tmax,taumin,taumax,N);
%            if X1(j,1)<0
%                X1_negative_flag(j)=1;
%            end
%            if X2(j,1)<0
%                X2_negative_flag(j)=1;
%            end
                     
end

% X1_bad_index=find(X1_negative_flag==1);
% X2_bad_index=find(X2_negative_flag==1);
% 
% X1(X1_bad_index,:)=[];
% X2(X2_bad_index,:)=[];


ave_X1=mean(X1,1);
ave_X2=mean(X2,1);
ave_X3=mean(X3,1);       
scrsz = get(0,'ScreenSize');
 figure('Name',strcat(cd),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
 title(cd)
 semilogx(tau,ave_X1,'r');
 hold on;
 semilogx(tau,ave_X2,'b');
 semilogx(tau,ave_X3,'k');

if nargin==6
 scrsz = get(0,'ScreenSize');
 figure('Name',strcat(cd,'Normalized'),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
 title(cd)
 t_tide=min(find(tau>tide));
 scale_X1=scale(ave_X1(t_tide:end),ave_X3(t_tide:end));
 scale_X2=scale(ave_X2(t_tide:end),ave_X3(t_tide:end));
 semilogx(tau,ave_X1*scale_X1,'r');
 hold on;
 semilogx(tau,ave_X2*scale_X2,'b');
 semilogx(tau,ave_X3,'k');
end    
% figure('Name',strcat(cd,'\Donor'),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
% title('Donor Autocorrelation')
