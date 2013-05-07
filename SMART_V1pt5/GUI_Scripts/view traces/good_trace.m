


function roi = good_trace(data, settings )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here





% look for regions of not physically reasonable FRET
%high_fret_constriant= 1.3;
%low_fret_constriant= -1.3;
%starting_sensitivity=[low_fret_constriant,high_fret_constriant];

select_attempt = 3; %  just switch this to try different methods

switch select_attempt


    case 1
        
start_end=[];
start_p =[];



fret_constraint = [-0.3 1.3];
fretv = data(:,3)';
position = 1:size(data,1)-20;


%position = find(handles.fretv(1:end-20)>starting_sensitivity(1) | handles.fretv(1:end-20)<starting_sensitivity(2));


while isempty(start_p)==true

%position = find(handles.fretv(1:end-20)>1.5);

    
for i=1:size(position,2);
    
   how_many_no_physica =  find(fretv(position(i):position(i)+20)>=fret_constraint(1)...
       | fretv(position(i):position(i)+20)<=fret_constraint(2));
   if size(how_many_no_physica,2)<=2  
       start_p = [start_p, i];   
       break
   end 
   
end

%starting_sensitivity=starting_sensitivity+[-0.1 0.1];

if isempty(start_p)==true;
    start_p=1;
    break
end

end

start_end(1) = position(start_p);
%position = find(handles.fretv(20:end)>1.5);


%position = 1:size(data,1)-20;
position = find(fretv(20:end)>fret_constraint(1) | fretv(20:end)<fret_constraint(2));

end_p =[];

while isempty(end_p)==true
for i=size(position,2):-1:21;
    
   how_many_no_physica =  find(fretv(position(i)-20:position(i))>=fret_constraint(2) |...
       fretv(position(i)-20:position(i))<=fret_constraint(1));

   
   if size(how_many_no_physica,2)<=2 
       end_p = [end_p, i];  
       break
   end 
end
   if isempty(end_p)==true;
       end_p=1;
    break
   end

   
   
end

start_end(2) = position(end_p);

if isempty(start_end(1):start_end(2))==true
    error('can not fin fit');

end


%laseron = find(acceptor >550 & fret >0.19, 1, 'last');
%laseron = find(acceptor >acceptor_constraint & fret >fret_constraint, 1, 'last');
%acceptor_constraint= str2double(get(handles.edit13,'String'));

total_intensity= settings{8,2};



total_I = (data(:,1)'+data(:,2)'- settings{1,2}*data(:,1)'); 

%end_position = start_position;
start_position = start_end(1);
while start_position < size(total_I,2)

if      total_I(start_position) > total_intensity &&...
        total_I(start_position+1) > total_intensity &&...
        total_I(start_position+2) > total_intensity
        
    break
else
    start_position = start_position +1;
end
end

start_end(1)=start_position;



end_position = start_end(2);
while end_position > 3

if      total_I(end_position) > total_intensity &&...
        total_I(end_position-1) > total_intensity &&...
        total_I(end_position-2) > total_intensity
        
    break
else
    end_position = end_position -1;
end
end
start_end(2)=end_position;


red_constraint= settings{9,2};


acceptorv = data(:,2)';


end_position = start_end(2);
while end_position > 3

if      acceptorv(end_position) > red_constraint &&...
        acceptorv(end_position-1) > red_constraint &&...
        acceptorv(end_position-2) > red_constraint
        
    break
else
    end_position = end_position -1;
end
end
start_end(2)=end_position;





%temp_position = find(handles.donorv(start_end(1):start_end(2)) > green_constraint);




start_position = start_end(1);
while start_position < size(total_I,2)-5

if      total_I(start_position) < total_intensity &&...
        total_I(start_position+1) < total_intensity &&...
        total_I(start_position+2) < total_intensity &&...
        total_I(start_position+3) < total_intensity &&...
        total_I(start_position+4) < total_intensity &&...
        total_I(start_position+5) < total_intensity
        
    break
else
    start_position = start_position +1;
end
end

if start_position < start_end(2)
start_end(2)=start_position;
end




minimum_length= settings{7,2};

if start_end(2)-start_end(1)<minimum_length
   
    %error('alignment error frame in raw trace different than kinetics')
    start_end =[1,2];
    

end


xlimits(1) = start_end(1);
xlimits(2) = start_end(2);

if xlimits(1) == 1 && xlimits(2)==2

   xlimits(2) = size(data,2);
    
end


case 2
    
    
  


                  figure
                  
                  color_order = {'b' 'g' 'r'};
               
                  fit_data = data;
                  fit_data = [fit_data(:,1)+fit_data(:,2) fit_data ];
                  
                   i_range = [-200 1500];
 i_space = 10;
                  
                  est_fits = {};
                     
                     for i=1:3
                     
                     
                     
                     x = fit_data(:,i);
                     

                     if i == 1
                         
                        
                         pdf_normmixture = @(x,mu1,sigma1) normpdf(x,mu1,sigma1);
                         
                         muStart = mean(x);
                         sigmaStart = std(x);
                         
                         lb = [-Inf 0 ];
                         ub = [ Inf Inf];
                         
                         start = [ muStart sigmaStart];
                         
                         xgrid = linspace(i_range(1),i_range(2),round(diff(i_range)/i_space));
                         bins = i_range(1):i_space:i_range(2);
                         
                         
                     else
                     
                         pdf_normmixture = @(x,p,mu1,mu2,sigma1,sigma2) ...
                         p*normpdf(x,mu1,sigma1) + (1-p)*normpdf(x,mu2,sigma2);
                         
                         muStart = quantile(x,[.25 .75]);
                         sigmaStart = sqrt(abs(var(x) - .25*diff(muStart).^2));
                         pStart = .5;
                         start = [pStart muStart sigmaStart sigmaStart];
                         
                         
                         lb = [0 -Inf -Inf 0 0];
                         ub = [1 Inf Inf Inf Inf];
                         
                         
                         
                     end
                         paramEsts = mle(x, 'pdf',pdf_normmixture, 'start',start, 'lower',lb, 'upper',ub);
                         
                         %statset('mlecustom')
                         
                         
                         options = statset('MaxIter',500, 'MaxFunEvals',600);
                         paramEsts = mle(x, 'pdf',pdf_normmixture, 'start',start, ...
                             'lower',lb, 'upper',ub, 'options',options);
                         
                         est_fits = cat(1, est_fits,paramEsts);
                         
                         subplot(3,1,i)
                         
                         
                         

                         h = bar(bins,histc(x,bins)/(length(x)*i_space),'histc');
                         set(h,'FaceColor',color_order{i},'EdgeColor',color_order{i});
                         
                         if i == 1
                           
                             pdfgrid = pdf_normmixture(xgrid,paramEsts(1),paramEsts(2));
                             
                         else
                             
                             pdfgrid = pdf_normmixture(xgrid,paramEsts(1),paramEsts(2),paramEsts(3),paramEsts(4),paramEsts(5));
                             
                         end
                         
                         
                         
                         hold on; p1 = plot(xgrid,pdfgrid,'k-','LineWidth',2); hold off
                         xlabel('x'); ylabel('Probability Density');
    
    
                     
                     end
    
                     select_spec.total_intensity = [200 1000]
                     
                     ext_int = find( fit_data(:,1)<  est_fits{1}(1)- est_fits{1}(2));
                     
                     ser_mat = zeros(size(ext_int));
                     for k=1:(size(ext_int)-1)
                         
                         l = 1;
                         
                         while (ext_int(k) ==ext_int(k+l) - l) && ((k+l)<(size(ext_int,1)-1) )
 
                                ext_int(k+l) = NaN; 
                                l=l+1;
                         end

                         ser_mat(k) = l;

                     end
                     
                     gap_lengths = unique(ser_mat);
                     end_gap = find(ser_mat >=10);
                     
                     if ~isempty(end_gap)
                     end_gap = ext_int(end_gap(1)); % align to the ext_int mat
                     
                     xlimits = [1 end_gap];
                     else
                         
                     xlimits = [1 size(fit_data(:,i),1)];   
                     end
                     
                     
                     
                     
    case 3 
        
       
        ispec_total.range =3;
        ispec_total.gap_size =20;
        ispec_total.fit = 0;
        ispec_total.thresh = 0;
        ispec_total.thresh_range = [100 1500];
        
        ispec_green.range =2;
        ispec_green.gap_size =10;
        ispec_green.fit = 0;
        ispec_green.thresh = 0;
        ispec_green.thresh_range = [-200 800];
        
        ispec_red.range =2;
        ispec_red.gap_size =10;
        ispec_red.fit = 0;
        ispec_red.thresh = 0;
        ispec_red.thresh_range = [-200 700];
        
        ispec_hmm.fit = 1;
        ispec_hmm.std_thresh = 200;
        ispec_hmm.num_bad_std = 2;
        ispec_hmm.snr_min = 3;
        
        ispec_other.windowSize = 1;
        ispec_other.large_bins = 100;
        ispec_other.large_bins_max = 3;
        ispec_other.large_bins_min = 1/4;
        ispec_other.tl_min = 100; % minimum trace length
        
        ispec_other.low_thresh_value = 0;
        ispec_other.fract_time_low_r = 0.2;
        ispec_other.fract_time_low_g = 0.5;
        ispec_other.max_mean_intensity = 1000;
        ispec_other.min_mean_intensity = 300;
        
        
        ispec = {ispec_total; ispec_green; ispec_red};
        
        windowSize = ispec_other.windowSize;
        data(:,1) = filter(ones(1,windowSize)/windowSize,1,data(:,1));
        data(:,2) = filter(ones(1,windowSize)/windowSize,1,data(:,2));
        
        fit_data = data;
        fit_data = [fit_data(:,1)+fit_data(:,2) fit_data ];
        
        
        
        color_order = {'b' 'g' 'r'};
        
        %fit_data = data;
        i_range = [-300 1000];
        i_space = 10;
        
        est_fits = {};
        stop_points_fit ={};
        stop_points_thresh ={};
        stop_points_hmm ={};
        
        for i=1:3
            
            temp_stops = struct;
            %temp_stops_thresh = struct;
            paramEsts = NaN(1,5);
            
            if ispec{i}.fit == true

            x = fit_data(:,i);
            
            pdf_normmixture = @(x,p,mu1,mu2,sigma1,sigma2) ...
                p*normpdf(x,mu1,sigma1) + (1-p)*normpdf(x,mu2,sigma2);
            
            muStart = quantile(x,[.25 .75]);
            sigmaStart = sqrt(abs(var(x) - .25*diff(muStart).^2));
            pStart = .5;
            start = [pStart muStart sigmaStart sigmaStart];
            
            
            lb = [0 -Inf -Inf 0 0];
            ub = [1 Inf Inf Inf Inf];
            
            
            paramEsts = mle(x, 'pdf',pdf_normmixture, 'start',start, 'lower',lb, 'upper',ub);
            
            %statset('mlecustom')
            
            
            options = statset('MaxIter',500, 'MaxFunEvals',600);
            paramEsts = mle(x, 'pdf',pdf_normmixture, 'start',start, ...
                'lower',lb, 'upper',ub, 'options',options);
            
            
            figure
            subplot(3,1,i)
            
            xgrid = linspace(i_range(1),i_range(2),round(diff(i_range)/i_space));
            bins = i_range(1):i_space:i_range(2);
            h = bar(bins,histc(x,bins)/(length(x)*i_space),'histc');
            set(h,'FaceColor',color_order{i},'EdgeColor',color_order{i});
            
            
            pdfgrid = pdf_normmixture(xgrid,paramEsts(1),paramEsts(2),paramEsts(3),paramEsts(4),paramEsts(5));
            
            hold on; p1 = plot(xgrid,pdfgrid,'k-','LineWidth',2); hold off
            xlabel('x'); ylabel('Probability Density');
            
    
            
            est_fits = cat(1, est_fits,paramEsts);
            
            
            
            ext_int = find( fit_data(:,i)< (paramEsts(2)- paramEsts(4)));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
            end_gap = ext_int(end_gap(1));
            end
            temp_stops.low_intens = end_gap;

            
            ext_int = find( fit_data(:,i)> (paramEsts(3)+ paramEsts(5)));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
            end_gap = ext_int(end_gap(1));
            end
            temp_stops.high_intens = end_gap;
                     
                
                
            end  
            stop_points_fit = cat(1,stop_points_fit,temp_stops);
            
            temp_stops = struct;
            if ispec{i}.thresh == true
                
                
                %ispec_total.thresh_range = [100 900];
                

                ext_int = find( fit_data(:,i)< ispec{i}.thresh_range(1));
                
                ser_mat = find_series(ext_int);
                gap_lengths = unique(ser_mat);
                end_gap = find(ser_mat >=ispec{i}.gap_size);
                if ~isempty(end_gap)
                    end_gap = ext_int(end_gap(1));
                end
                temp_stops.low_intens = end_gap;
                
                
                ext_int = find( fit_data(:,i)> ispec{i}.thresh_range(2));
                
                ser_mat = find_series(ext_int);
                gap_lengths = unique(ser_mat);
                end_gap = find(ser_mat >=ispec{i}.gap_size);
                if ~isempty(end_gap)
                    end_gap = ext_int(end_gap(1));
                end
                temp_stops.high_intens = end_gap;
                 
                
                
            end
             stop_points_thresh = cat(1,stop_points_thresh,temp_stops);   
                
                

        end
        disp('');
        disp('');
        
        large_bins = cell(2,2);
        bs=ispec_other.large_bins;
        disc_trace = [];
         temp = [];
        for i=1:bs:size(fit_data,1)-bs 
        disc_trace = [disc_trace ;mean(fit_data(i:i+bs,:))];
        end
        
        temp_g = find(disc_trace(:,2)>disc_trace(end,2)*ispec_other.large_bins_max);
        temp_r = find(disc_trace(:,3)>disc_trace(end,3)*ispec_other.large_bins_max);
        large_bins{1,1} =temp_g*bs;
        large_bins{1,2} =temp_r*bs;
        
        if ~isempty(temp_g)
        temp =[temp temp_g(end)*bs];
        end
        

        if ~isempty(temp_r)
        temp =[temp temp_r(end)*bs];
        end
        disp(['Cut of for low ending intensity ' mat2str(temp)])


        
        
        temp_g = find(disc_trace(:,2)<disc_trace(2,2)*ispec_other.large_bins_min);
        temp_r = find(disc_trace(:,3)<disc_trace(2,3)*ispec_other.large_bins_min);
        large_bins{2,1} =temp_g*bs;
        large_bins{2,2} =temp_r*bs;

        if ~isempty(temp_g)
        temp =[temp temp_g(1)*bs];
        end
        

        if ~isempty(temp_r)
        temp =[temp temp_r(1)*bs];
        end
        disp(['Cut of for low intensity in middle ' mat2str(temp)])
        
        
        
        
        
        
        if ~isempty(temp)
  
        fit_data = fit_data(1:min(temp),:);
        end
        
        
        

        % Threshold the entire trace if too nuch of it is lower than
        temp_g = find(fit_data(:,2)<ispec_other.low_thresh_value );
        temp_g = size(temp_g,1)/size(fit_data(:,2),1);
        
        
        if temp_g>ispec_other.fract_time_low_g
        
         fit_data =  fit_data(1,:);
         disp('Too much low green intensity')
         
        end
        
        temp_r = find(fit_data(:,3)<ispec_other.low_thresh_value );
        temp_r = size(temp_r,1)/size(fit_data(:,3),1);
   
        if temp_r>ispec_other.fract_time_low_r
            fit_data =  fit_data(1,:);
            disp('Too much low red intensity')
        end
        
        
        if mean(fit_data(:,1)) > ispec_other.max_mean_intensity
             fit_data =  fit_data(1,:);
             disp('Overall intensity too high')
        end
        
        
        
        if mean(fit_data(:,1)) < ispec_other.min_mean_intensity
             fit_data =  fit_data(1,:);
             disp('Overall intensity too low')
        end
        
        
        
        
        if (ispec_hmm.fit == true) && (size(fit_data,1)>1)
        


params.nChannels = 2; %number of channels, red is 1, green is 2
params.nStates = 2;%number of states in model 
params.discStates = [];
params.noHops = [];
params.tryPerms = true;

% set Ainitial = 'auto', Einitial 'auto' or set them to a particular value
params.Ainitial = 'auto'; %could have A = [0.98 0.02 ; 0.01 0.99]
params.Einitial = 'auto'; %could have E = cell([2 2]); E{2,1} = [5 ; 3] means state 2, channel 1 (red) has mean 5, stdev 3, etc

% specify fit type for each channel, red then green
params.fitChannelType = cell({'gauss','gauss'}); %each channel must be 'exp' or 'gauss'

% specify data
params.data = fit_data(:,2:3); %x is T by num_channels, column 1 is acceptor (red), column 2 is donor (green)
                 %x can have any number of channels, one per column
params.pi = 0; %true hidden state, leave this at 0 when working with real data

% paramters related to training

params.trainA = true; %set to false if want to never change initial guess for A
params.trainE = true; %set to false if want to never change initial guess for E

params.maxIterEM = 200;      %maximum number of iterations for EM to converge
params.threshEMToConverge = 10^(-4);   %likelihood threshold for EM to converge, don't make lower than this to avoid strange behavior

params.SNRwarnthresh = 1; %warns if 2 states have SNR less than this
params.returnFit = true;



params.paramsErrorToBoundAuto = '';
params.paramsErrorToBoundManual = '';
params.auto_boundsMeshSize = 20;                              
params.auto_MeshSpacing = 'square';                                    
params.auto_confInt = 0.99;       
params.ManualBoundRegions = [];
params.ManualBoundRegions{1} = linspace(50,200,100);
params.plotPFits = false;
params.showProgressBar = false;  
params.pause = false;

output = TrainPostDec_(params);

%close  all
%figure;plot(output.postFit(1,:))


std_compare = [output.E{1,1}(2) output.E{2,1}(2) output.E{1,2}(2) output.E{2,2}(2)];
disp(['STD of Fits' mat2str(round(std_compare))]);

bad_std = find(std_compare > ispec_hmm.std_thresh);


temp_stops = struct;
if ~isempty(bad_std)
    
    if size(bad_std,2) >=ispec_hmm.num_bad_std
  temp_stops.bad_std = 2;
    end
  
end
stop_points_hmm = cat(1,stop_points_hmm,temp_stops); 

E = cell(2,2);
E(1,1) = output.E(1,1);
E(2,1) = output.E(2,1);
E(1,2) = output.E(2,2);
E(2,2) = output.E(1,2);
output.E = E;

    
     
     
     
     
     
         
         
         
     
            i=1;
            %Look at average intensity
            temp_stops = struct;
            ext_int = find( fit_data(:,i)< (mean(fit_data(:,i))- std(fit_data(:,i))*ispec{i}.range));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
                end_gap = ext_int(end_gap(1));
            end
            temp_stops.low_intens = end_gap;
            
            
            
            ext_int = find( fit_data(:,i)> (mean(fit_data(:,i))+ std(fit_data(:,i))*ispec{i}.range));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
                end_gap = ext_int(end_gap(1));
            end
            temp_stops.high_intens = end_gap;
            
            stop_points_hmm = cat(1,stop_points_hmm,temp_stops); 
            disp(['Gaps in total intentist: too low',num2str(temp_stops.low_intens)])
            disp(['Gaps in total intentist: too high',num2str(temp_stops.high_intens)])
                
            
            
            for k=1:2
            i=k+1;
            temp_stops = struct;
            ext_int = find( fit_data(:,i)< (output.E{1,k}(1)- output.E{1,k}(2)*ispec{i}.range));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
            end_gap = ext_int(end_gap(1));
            end
            temp_stops.low_intens = end_gap;
            %disp(['Gaps in', color_order(i), 'intentist: too low',])
            disp(strcat('Gaps in--',color_order(i), ' intensity--too low',num2str(temp_stops.low_intens)))
            %i=3;
            ext_int = find( fit_data(:,i)> (output.E{2,k}(1)+ output.E{2,k}(2)*ispec{i}.range));
            
            ser_mat = find_series(ext_int);
            gap_lengths = unique(ser_mat);
            end_gap = find(ser_mat >=ispec{i}.gap_size);
            if ~isempty(end_gap)
            end_gap = ext_int(end_gap(1));
            end
            temp_stops.high_intens = end_gap;
            
            stop_points_hmm = cat(1,stop_points_hmm,temp_stops); 
            %disp(['Gaps in',{''} ,color_order(i), 'intentist: too low',num2str(temp_stops.high_intens)])
             disp(strcat('Gaps in--',color_order(i), ' intensity--too low',num2str(temp_stops.high_intens)))
            
            
            end
           
            
           
            
            
            disp(strcat('SNR Max Max--',num2str(max(max(output.SNRMat)))))
        if max(max(output.SNRMat)) < ispec_hmm.snr_min
             fit_data =  fit_data(1,:);
             disp('SNR is too low')
        end
        
            
            
            
            
     
  
     
            
        
     
     


        end
end
        
        
        
        
        

     
        %est_fits{:}
        %stop_points_fit{:}
        %stop_points_thresh{1}
        %stop_points_thresh{2}
        %stop_points_thresh{3}
        
        %std_compare
        final_stop_points = stop_points_hmm;
        
        final_stop_points = cat(1,final_stop_points,stop_points_thresh{1});
        
        
        
        %large_bins{:,:}
        
%         for i=1:4
%             
%             try
%                 
%         final_stop_points{i}
% 
%         %output.SNRMat
%             catch
%             end
%         end
        
        stop_options = [];
        for i=1:size(final_stop_points,1)
           
            temp = cell2mat(struct2cell(final_stop_points{i}));
            
            if ~isempty(temp)
            stop_options = [stop_options  temp'];
            end
        end
        stop_options = sort(stop_options);
        
        
        
        if isempty(stop_options) 
           
          stop_options = size(fit_data,1) ; 
            
        end
        

        if stop_options(1)<ispec_other.tl_min
            stop_options = 5 ;
        end
        
        
        
        
       xlimits = [1 stop_options(1)];               




roi = xlimits;