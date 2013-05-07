function plot_gui_ci(handles)


       ci_value = 1-handles.view_data{5}.params.auto_confInt;
        
        
        try
        val = get(handles.popupmenu4,'value');
        avalible_error_bounds = {handles.view_data{7}.errorBoundsAuto.var1name};
        
        switch val
            
            case 1
              
            error_to_plot = [];
            actual_error_bounds = {'e(1,1,1)'   'e(2,1,1)' };
            for i=1:2     
            temp = cellfun(@(x) ~isempty(strfind(x,actual_error_bounds{i})),avalible_error_bounds);
            temp = handles.view_data{7}.errorBoundsAuto(temp);  
            temp = [temp.var1region,temp.PMat];
            to_keep = find(temp(:,2)>ci_value);
            temp = temp(to_keep,:);
            error_to_plot = [error_to_plot; temp([1 end],1)'];
            end

            plot(handles.axes5,error_to_plot(1,:),[0 0],'b', error_to_plot(2,:),[0 0], 'b', 'LineWidth',10)   
                
                
                
            case 2
            
            error_to_plot = [];
            actual_error_bounds = {'e(1,2,1)'   'e(2,2,1)' };
            for i=1:2     
            temp = cellfun(@(x) ~isempty(strfind(x,actual_error_bounds{i})),avalible_error_bounds);
            temp = handles.view_data{7}.errorBoundsAuto(temp);  
            temp = [temp.var1region,temp.PMat];
            to_keep = find(temp(:,2)>ci_value);
            temp = temp(to_keep,:);
            error_to_plot = [error_to_plot; temp([1 end],1)'];
            end

            plot(handles.axes5,error_to_plot(1,:),[0 0],'b', error_to_plot(2,:),[0 0], 'b', 'LineWidth',10)
            
            
            case 3
                
            case 4
        end
        
        
        catch
        
            disp('Confidence intervals do not exist for selected channel')
        
            
        end
