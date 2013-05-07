function [tau,ave_X1,ave_X2,ave_X3,X1,X2,X3]=FCS_ZK(s_N,e_N,tmin,tmax,taumin,taumax,N,tide)

 if e_N<s_N
   files=dir('data_*.mat');
    filesnamesCell=struct2cell(files);
    [a,n]=size(filesnamesCell);
    M=zeros(n,1);

    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end

    M=sort(M);

 end


X1=zeros(e_N-s_N+1,N-1);
X2=zeros(e_N-s_N+1,N-1);
X3=zeros(e_N-s_N+1,N-1);
% X1_negative_flag=zeros(e_N-s_N+1,1);
% X2_negative_flag=zeros(e_N-s_N+1,1);

if e_N<s_N
    for j=1:1:length(M)
        disp(cd);
        disp(sprintf('begin FCS calculations on file %g. ', M(j)));
        [tau,X1(j,:),X2(j,:),X3(j,:)]=FCS_ZK_4(M(j),tmin,tmax,taumin,taumax,N);
    end    
else    
    for j=1:1:(e_N-s_N+1)
               disp(cd);
               disp(sprintf('begin FCS calculations on file %g. ', j+s_N-1))
               [tau,X1(j,:),X2(j,:),X3(j,:)]=FCS_ZK_4(s_N-1+j,tmin,tmax,taumin,taumax,N);
    end
end


ave_X1=mean(X1,1);
ave_X2=mean(X2,1);
ave_X3=mean(X3,1);       

scrsz = get(0,'ScreenSize');

%figure('Name',strcat(cd),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
%tau=tau(1:end-1);
figure;clf;
title(cd)
semilogx(tau,ave_X1,'r');
hold on;
semilogx(tau,ave_X2,'b');
semilogx(tau,ave_X3,'k');
grid on;    


if nargin==8
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

