%GENERAL INFORAMTION
%%%%%%%%%%%%%%%%%%%%
%function g2tau=TrackedQdot_g2(tau,D,bandwidth,noise,laserwaist,model_system,strobing_f,normalize_flag)
%function TrackedQdot_g2 calculate the autocorrelation functions for a tiny
%object such as a qdot tracked with the 3d tracking system. 

%PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tau is the delay times
%D is diffusion coefficient of tracked object, along three axes. 
%bandwidth is a 3 by 1 matrix if model_system is 'first_order', and 3 by 2
%matrix if model system is 'second_order'
%noise is the spectral density of the noise process. 3 by 1 matrix.
%laserwaist is the waist of the blue stationary beam. Notice this beam is
%not spatially modulated. laserwaist is a 3 by 1 matrix, specifying the laser waists in xyz directions. 
%model_system can only be 'first_order' or 'second_order', in which second
%order take in to account of roll off the plant. (if you don't know what I am talking about, you perhaps should read a bit more about tracking literautre before jumping into this code.)
%strobing_f is the frequency of strobing laser system. When strobing_f is
%0, this code assumes no strobing laser. 
%normalize_flag. if normalize_flag is 0, no normalization. if not,
%normalization.

function g2tau=TrackedQdot_g2(tau,D,bandwidth,noise,laserwaist,model_system,strobing_f,normalize_flag)


%calculate the tracking error. 
if strcmp(model_system,'first_order')
   for j=1:1:3
       sigma_tau(j,:)=tracking_error_1(tau,D(j),bandwidth(j),noise(j));
       sigma_zero(j)=tracking_error_1(0,D(j),bandwidth(j),noise(j));
   end
elseif strcmp(model_system,'second_order')
   for j=1:1:3
       sigma_tau(j,:)=tracking_error_2(tau,D(j),bandwidth(j,:),noise(j));
       sigma_zero(j)=tracking_error_2(0,D(j),bandwidth(j,:),noise(j));
   end
else
    error('model_system can only be first_order or second_order!')
end


%use tracking error and laser waists to calculate the tFCS curves.
%no internal dynamics and no strobing here. 
   g2_x=(0.25*laserwaist(1)^2+sigma_zero(1))./((0.25*laserwaist(1)^2+sigma_zero(1))^2-sigma_tau(1,:).^2).^0.5;
   g2_x_0=(0.25*laserwaist(1)^2+sigma_zero(1))./((0.25*laserwaist(1)^2+sigma_zero(1))^2-sigma_zero(1)^2).^0.5;
   
   g2_y=(0.25*laserwaist(2)^2+sigma_zero(2))./((0.25*laserwaist(2)^2+sigma_zero(2))^2-sigma_tau(2,:).^2).^0.5;
   g2_y_0=(0.25*laserwaist(2)^2+sigma_zero(2))./((0.25*laserwaist(2)^2+sigma_zero(2))^2-sigma_zero(2)^2).^0.5;
    
   g2_z=(0.25*laserwaist(3)^2+sigma_zero(3))./((0.25*laserwaist(3)^2+sigma_zero(3))^2-sigma_tau(3,:).^2).^0.5;
   g2_z_0=(0.25*laserwaist(3)^2+sigma_zero(3))./((0.25*laserwaist(3)^2+sigma_zero(3))^2-sigma_zero(3)^2).^0.5; 

   
%add strobing and normalization   
if strobing_f~=0 %if strobing
    if normalize_flag
       normalize_constant=g2_x_0*g2_x_0*g2_x_0-1;
       %g2_x(1)*g2_y(1)*g2_z(1)-1
       g2tau=(g2_x.*g2_y.*g2_z.*StrobingLaser_g2(tau,strobing_f)-1)./normalize_constant; 
    else
       g2tau=g2_x.*g2_y.*g2_z.*StrobingLaser_g2(tau,strobing_f)-1; 
    end
else %if no strobing
    if normalize_flag
       normalize_constant=g2_x_0*g2_x_0*g2_x_0-1;
       %g2_x(1)*g2_y(1)*g2_z(1)-1
       g2tau=(g2_x.*g2_y.*g2_z-1)./normalize_constant; 
    else 
       g2tau=g2_x.*g2_y.*g2_z-1;
    end
end




































    
