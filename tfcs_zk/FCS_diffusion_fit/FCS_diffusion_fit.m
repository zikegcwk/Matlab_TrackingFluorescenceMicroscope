%function FCS_diffusion_fit takes tau, g2 and laser dimensions wxy and wz
%and fit to various theoretical models. plot_flag = 1 will only plot the
%fitting functions and the data. plot_flag=[1 1] will plot both the
%fittings and the residues. 

%fit type can be 'general', which is the traditional fcs model. 'xyz',
%which gives the model freedom in three axes of the diffusion
%coefficients. 'poly', which fits the data to a 3rd order polynomial. 
function fit=FCS_diffusion_fit(tau,g2,wxy,wz,plot_flag,fit_type)
global lightcolor darkcolor
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;

%% cut tau and g2 to 1e-6
t_tide=10^-6;
t_index=min(find(tau>=t_tide));
tau1=tau(t_index:end);
clear tau;
tau=tau1;
for kk=1:1:size(g2,1)
    g1(kk,:)=g2(kk,t_index:end);
end
clear g2;
g2=g1;

%% beginning fitting
if nargin==2 && nargout ==0
    plot_flag=[1 1];
    fit_type='general';
end    

% if nargout~=0
%     plot_flag=[0 0];
%     fit_type='general';
% end

if nargin==4
    plot_flag=1;
    fit_type='general';
end

if length(plot_flag)==1
    plot_flag(1,1)=1;
    plot_flag(1,2)=0;
end
     %initial estimates for number of molecules inside laser focus
     parameters_1_guess=10;
     %initial estimates for diffusion coefficient.
     parameters_2_guess=100;
     parameters_3_guess=10;
     parameters_4_guess=10;
     parameters_5_guess=10;
     parameters_6_guess=10;
     

     
     
%case when a series of measurement is given as input. 
if size(g2,1)~=1
    %get the average value and weights
    [tau,ave_g2,std_g2]=draw_fcs(tau,g2,1,0);
     %set weights as 1/sigma^2.
     w=1./std_g2.^2;
     %weight the data. 
     wg2=w.^0.5.*ave_g2;
     %weight the model function
     if strcmp(fit_type,'general')%if fit by a general fcs diffusion function is requested.
            %fitting
            f2fit=@(parameters,tau) w.^0.5.*FCS_openloop(tau,wxy,wz,parameters(1),parameters(2));
            [parameters_fit,r,J,sigma]=nlinfit(tau,wg2,f2fit,[parameters_1_guess,parameters_2_guess]);
            ci=nlparci(parameters_fit,r,'jacobian',J);
            %output results
            fit.N=parameters_fit(1);
            fit.D=parameters_fit(2);
            fit.stdN=ci(1,2)-parameters_fit(1);
            fit.stdD=ci(2,2)-parameters_fit(2);
            fit.r=r;
            fit.tau=tau;
            fit.thry=FCS_openloop(tau,wxy,wz,parameters_fit(1),parameters_fit(2));

     elseif strcmp(fit_type,'xyz')%if fit by a more free diffusion function is requested
            %fitting
            f2fit=@(parameters,tau) w.^0.5.*FCS_diff_xyz(tau,wxy,wz,parameters(1),parameters(2),parameters(3),parameters(4));
            [parameters_fit,r,J,sigma]=nlinfit(tau,wg2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);
%           ci=nlparci(parameters_fit,r,'jacobian',J);
            fit.N=parameters_fit(1);
            fit.Dx=parameters_fit(2);fit.Dy=parameters_fit(3);fit.Dz=parameters_fit(4);
            %output results
            fit.r=r;fit.thry=FCS_diff_xyz(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4));
            fit.tau=tau;
     elseif strcmp(fit_type,'poly') %if fit by polynomial is requested
            f2fit=@(parameters,tau) w.^0.5.*FCS_diff_poly(tau,parameters(1),parameters(2),parameters(3),parameters(4),parameters(5),parameters(6));
            [parameters_fit,r]=nlinfit(tau,wg2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess,parameters_5_guess,parameters_6_guess]);
            %output results
            fit.thry=FCS_diff_poly(tau,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4),parameters_fit(5),parameters_fit(6));

     end
     
else %case when only averaged value is given as input.
    if strcmp(fit_type,'general')%if fit by a general fcs diffusion function is requested.
            %fitting
            f2fit=@(parameters,tau) FCS_openloop(tau,wxy,wz,parameters(1),parameters(2));
            [parameters_fit,r,J,sigma]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess]);
            fit.D=parameters_fit(2);
            fit.N=parameters_fit(1);
            fit.r=r;
            ci=nlparci(parameters_fit,r,'jacobian',J);
             fit.stdN=ci(1,2)-parameters_fit(1);
            fit.stdD=ci(2,2)-parameters_fit(2);
            
     elseif strcmp(fit_type,'xyz')%if fit by a more free diffusion function is requested
            f2fit=@(parameters,tau) FCS_diff_xyz(tau,wxy,wz,parameters(1),parameters(2),parameters(3),parameters(4));
            [parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);
            fit.N=parameters_fit(1);
            fit.Dx=parameters_fit(2);fit.Dy=parameters_fit(3);fit.Dz=parameters_fit(4);
            fit.tau=tau;
            fit.thry=FCS_diff_xyz(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4));
            
    elseif strcmp(fit_type,'poly')      
            f2fit=@(parameters,tau) FCS_diff_poly(tau,parameters(1),parameters(2),parameters(3),parameters(4),parameters(5),parameters(6));
            [parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess,parameters_5_guess,parameters_6_guess]);
            fitting_results{1,1}='polynomail fitting results';fitting_results{1,2}=[parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4),parameters_fit(5),parameters_fit(6)];
            residues{1}=r;
            
     end

end    
     
     
  
if 0%plot_flag(1,1)==1
    if size(g2,1)~=1
        %plot fcs curve with std and return the figure handle. 
        %
        %figure;clf;
        hold all;
        if strcmp(fit_type,'general')%if fit by a general fcs diffusion function is requested.
           subplot(3,1,1:2);
           shadedErrorBar_zk(tau,g2,{'Color',darkcolor(1,:),'LineWidth',2});hold on;
           plot(log10(tau),FCS_openloop(tau,wxy,wz,parameters_fit(1),parameters_fit(2)),'r','LineWidth',2);
           fit.thry=FCS_openloop(tau,wxy,wz,parameters_fit(1),parameters_fit(2));
           xlabel('log10(\tau) (S)')
           ylabel('Autocorrelation')
           Box on;
           if 1%plot_flag(1,2) 
                %figure;
                subplot(3,1,3)
                plot(log10(tau),real(r),'-or');
                xlabel('log10(\tau) (S)')
                ylabel('Weighted Residue')
           end
           [hh,pp]=chi2gof(real(r));
           if ~hh
               disp('Accept Model!')
           else
               disp('Reject Model!')
           end
        elseif strcmp(fit_type,'xyz')%if fit by a more free diffusion function is requested    
            figure;clf;
            subplot(3,1,1:2);    
            shadedErrorBar_zk(tau,g2,{'Color',darkcolor(1,:),'LineWidth',2});hold on;
            plot(log10(tau),FCS_diff_xyz(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'LineWidth',2);
            fit.thry=FCS_diff_xyz(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4));
            title(cd);
            subplot(3,1,3);
            plot(log10(tau),real(r),'-or');
            xlabel('\tau (S)')
            ylabel('Weighted Residue')
           
        elseif strcmp(fit_type,'poly')   
               semilogx(tau,FCS_diff_poly(tau,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4),parameters_fit(5),parameters_fit(6)),'LineWidth',3);
               title(cd);
            if plot_flag(1,2) 
                figure;
                semilogx(tau,abs(r),'-or');
                xlabel('\tau (S)')
                ylabel('Weighted Residue')
            end
            
        end    
            
    else
        %figure;
        if strcmp(fit_type,'general')%if fit by a general fcs diffusion function is requested.
            semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
            hold on;
            semilogx(tau,FCS_openloop(tau,wxy,wz,parameters_fit(1),parameters_fit(2)),'LineWidth',3);
            title(cd);
           if plot_flag(1,2) 
                figure;
                semilogx(tau,real(r),'-or');
                xlabel('\tau (S)')
                ylabel('Residue')
           end
          
         elseif strcmp(fit_type,'xyz')%if fit by a more free diffusion function is requested    
            semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
            hold on;
            semilogx(tau,FCS_diff_xyz(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'LineWidth',3);
            title(cd);
            if plot_flag(1,2) 
                figure;
                semilogx(tau,real(r),'-or');
                xlabel('\tau (S)')
                ylabel('Residue')
            end
            
          elseif strcmp(fit_type,'poly')   
               semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
               hold on;  
               semilogx(tau,FCS_diff_poly(tau,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4),parameters_fit(5),parameters_fit(6)),'LineWidth',3);
               title(cd);
            if plot_flag(1,2) 
                figure;
                semilogx(tau,real(r),'-or');
                xlabel('\tau (S)')
                ylabel('Residue')            
            end
            
        end      
            
    end


end

if nargout==0
    clear('N','D');
end



end

function g2tau=FCS_openloop(t,wwxy,wwz,NN,DD)

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

g2tau=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);
end



function g2tau=FCS_diff_xyz(t,wwxy,wwz,NN,Dx,Dy,Dz)

tau_x=wwxy^2/(4*Dx);
tau_y=wwxy^2/(4*Dy);
tau_z=wwz^2/(4*Dz);

g2tau=(1/NN)*(1./(1+t/tau_x).^0.5).*(1./(1+t/tau_y).^0.5).*(1./(1+t/tau_z).^0.5);
end


function g2tau=FCS_diff_poly(t,A,B,C,D,E,F)

%g2tau=1./(D.*t.^3+C.*t.^2+B.*t+A).^0.5;
%g2tau=1./(F.*t.^5+E.*t.^4+D.*t.^3+C.*t.^2+B.*t+A).^0.5;

g2tau=A.*t.^5+B*t.^4+C.*t.^3+D.*t.^2+E.*t+F;
end











