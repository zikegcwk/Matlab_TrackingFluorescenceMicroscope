function output = generate_fret_threshold_table(handles)












table = cell(22,5);

% temp_data = struct2cell(handles.view_data{5});
% temp_names = fieldnames(handles.view_data{5});
% temp = cat(2, temp_names, temp_data);

temp_string = {'name' 'trace_num' 'spots_in_movie' 'position_x' 'position_y' 'fps','len','nchannels'};

for i=1:10
    
    
    try
        
    table{i,1} = temp_string{i};
    table{i,2} = getfield(handles.view_data{5},temp_string{i});
        
    catch
        
    end
end





temp_string = {'dltg' 'mean_total_i' 'snr' };

for i=1:10
    
    
    try
        
    table{i,3} = temp_string{i};
    table{i,4} = getfield(handles.view_data{4},temp_string{i});
        
    catch
        
    end
end



temp_string = {'dltg' 'mean_total_i' 'snr' };

for i=1:10
    
    
    try
        
    table{i,3} = temp_string{i};
    table{i,4} = getfield(handles.view_data{4},temp_string{i});
        
    catch
        
    end
end







if ~isempty(fieldnames(handles.view_data{6}))



thresh_summary = handles.view_data{6};
    

axes(handles.axes2)
cla;
kin_plot = thresh2kinetics(thresh_summary.thresholded);
plot(kin_plot(:,1)/handles.view_data{5}.fps,kin_plot(:,5),'Color','k');
xlabel('Times [sec]')
ylabel('Thresholded')


axes(handles.axes4)
cla;
plot(thresh_summary.k1to2_xval,thresh_summary.k1to2_single_residuals,'k',...
    thresh_summary.k1to2_xval,thresh_summary.k1to2_dobule_residuals,'r','Marker','+');
ylabel('Fold Residual')
xlabel('Time [sec]')
%xlim([0 max([thresh_summary.k2to1_xval;  thresh_summary.k1to2_xval])])
ylim([-0.15 0.15])

axes(handles.axes5)
cla;
plot(thresh_summary.k2to1_xval,thresh_summary.k2to1_single_residuals,'k',...
    thresh_summary.k2to1_xval,thresh_summary.k2to1_dobule_residuals,'r','Marker','+');
ylabel('Unfold Residual')
%xlim([0 max([thresh_summary.k2to1_xval;  thresh_summary.k1to2_xval])])
ylim([-0.15 0.15])
xlabel('')


table{11,1} = 'k1to2_single';
table{11,3} = num2str(thresh_summary.k1to2_single);
table{12,1} = 'k1to2_dobule';
table{12,2} = num2str(thresh_summary.k1to2_dobule(1));
table{12,3} = num2str(thresh_summary.k1to2_dobule(2));
table{12,4} = num2str(thresh_summary.k1to2_dobule(3));


table{14,1} = 'k2to1_single';
table{14,3} = num2str(thresh_summary.k2to1_single);
table{15,1} = 'k2to1_dobule';
table{15,2} = num2str(thresh_summary.k2to1_dobule(1));
table{15,3} = num2str(thresh_summary.k2to1_dobule(2));
table{15,4} = num2str(thresh_summary.k2to1_dobule(3));



end

output = table;

