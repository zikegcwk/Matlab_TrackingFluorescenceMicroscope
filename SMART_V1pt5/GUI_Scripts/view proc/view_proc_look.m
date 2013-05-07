function view_proc_look(handles)






if strmatch('blank', handles.view_look, 'exact') == true
    
    
     cla(handles.axes1)
     cla(handles.axes2)
     cla(handles.axes3)
     cla(handles.axes4)
     cla(handles.axes5)
    
    
    set(handles.axes1,'Visible','off');
    set(handles.axes2,'Visible','off');
    set(handles.axes3,'Visible','off');
    set(handles.axes4,'Visible','off');
    set(handles.axes5,'Visible','off');
%    set(handles.axes6,'Visible','off');
    
    set(handles.uitable1,'Visible','off');
    set(handles.uitable2,'Visible','off');      
    set(handles.uitable3,'Visible','off');
    

    set(handles.popupmenu4,'Visible','off');
    set(handles.popupmenu1,'Visible','on');
    set(handles.popupmenu2,'Visible','off', 'Position', [0.7 0.55 0.1 0.04],'String',{'x-axis'})
    set(handles.popupmenu3,'Visible','off', 'Position', [0.82 0.55 0.1 0.04],'String',{'y-axis'})
    set(handles.popupmenu1,'String',{'' 'Sort Data' 'HMM' 'FRET and Threshold' 'Cluster' })
    
    set(handles.pushbutton1,'Visible','off');
    set(handles.checkbox1,'Visible','off');
    set(handles.checkbox3,'Visible','off');
    %set(handles.edit1,'Visible','off')
    set(handles.slider1,'Visible','off');
%     

    

          
    
    
elseif strmatch('sort', handles.view_look, 'exact') == true
    
    
    
    %zoom off
    set(handles.axes1,'Visible','off');
    cla(handles.axes1)
    set(handles.axes2,'Visible','off');
    cla(handles.axes2)
    set(handles.axes3,'Visible','off');
    cla(handles.axes3)
    set(handles.axes4,'Visible','off');
    cla(handles.axes4)
    set(handles.axes5,'Visible','off');
    cla(handles.axes5)
 %   set(handles.axes6,'Visible','off');
 %   cla(handles.axes6)
    
    set(handles.uitable1,'Visible','on');
    set(handles.uitable2,'Visible','on');      
    set(handles.uitable3,'Visible','on');
    
    set(handles.popupmenu1,'Visible','on','Value',2);
    set(handles.popupmenu2,'Visible','off');
    set(handles.popupmenu3,'Visible','off');
    set(handles.popupmenu4,'Visible','off');
    
    set(handles.pushbutton1,'Visible','on','String','Reset');
  %  set(handles.checkbox1,'Visible','off', 'value',0,'String','Manual');
    set(handles.slider1,'Visible','off');
    %set(handles.edit1,'Visible','off');
    
    set(handles.uitable1,'Position',[0.02 0.02 0.6 .9])
    set(handles.uitable2,'Position',[0.63 0.15 0.32 .3])
    set(handles.uitable3,'Position',[0.63 0.52 0.35 .4])
    set(handles.popupmenu1,'Position',[0.8 0.01 0.15 0.05]);
    set(handles.pushbutton1,'Position',[0.65 0.03 0.1 0.05]);
    set(handles.checkbox3,'Position',[0.8 0.06 0.1 0.08],'string','Convert to FPS','Visible','on');
    
    
    
  if isfield(handles,'selected_data')
      
      
      
      
      temp = get(handles.uitable1,'Data');
      
      
      temp_cell = mat2cell(handles.sort_matrix,ones(1,size(handles.sort_matrix,1)),ones(1,size(handles.sort_matrix,2)));
      data_string = cellfun(@(c)num2str(c,'%.1f'),temp_cell,'un',0);
      
      
      temp = cat(2, handles.selected, data_string);
      
      
      temp2 = get(handles.uitable3,'Data');
      temp_names = handles.sort_names;
      temp_names = ['Selected' temp_names];
      
      temp2 = [true , temp2(:,1)'];
      
      
      
      set(handles.uitable1,'Data', temp(:,cell2mat(temp2)),'ColumnName',temp_names(1,cell2mat(temp2)))
      set(handles.uitable1,'ColumnFormat',{'logical'})
      set(handles.uitable1,'ColumnEditable',[true false(1,size(temp(:,cell2mat(temp2)),2)-1)])
   
      set(handles.uitable1,'RowName','Numbered')
      %set(handles.uitable1,'Data',temp)
      %set(handles.uitable1,'ColumnName',cat(2,'Selected' ,sort_str))
      
      
      set(handles.uitable2,'ColumnName',{'Movie Start' 'Movie End' 'Group Start' 'Group End'})
      set(handles.uitable2,'RowName',{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'})
      
      
      
      
  else
        
      
      set(handles.uitable2,'Data',[zeros(10,2) ones(10,2)])
      set(handles.uitable2, 'ColumnEditable', [ true true true true ]);
      set(handles.uitable2,'ColumnName',{'Movie Start' 'Movie End' 'Group Start' 'Group End'})
      set(handles.uitable2,'RowName',{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'})
      
   
      %temp = get_unique_identifiers();
      sort_range =[];
      sort_range = [sort_range; min(handles.sort_matrix)];
      sort_range = [sort_range; max(handles.sort_matrix)];
      sort_range = round(sort_range*handles.round{1})/handles.round{1};
      
      if size(handles.sort_matrix,2) ~= size(sort_range,2)    
       sort_range = [handles.sort_matrix(1,:) ;handles.sort_matrix(1,:)];
      end
      
      
      temp_cell = mat2cell(sort_range,ones(1,size(sort_range,1)),ones(1,size(sort_range,2)));
      data_string = cellfun(@(c)num2str(c,handles.round{2}),temp_cell,'un',0);
      
      data_string = cat(2, mat2cell(logical(ones(size(sort_range,2),1)), ones(size(sort_range,2),1)',1),data_string');
      
      %sort_range = [true(1,size(sort_range,2));sort_range];
      
      sort_str = handles.sort_names;
      
      set(handles.uitable3,'Data',data_string,'RowName',sort_str,'ColumnName',{'sort' 'min','max'},...
          'ColumnEditable',[true true true],'ColumnFormat',{'logical','numeric','numeric'},'ColumnWidth',{ 50 60  60})
      

      
      % Just some tricks to get a nicly formated table
      temp_cell = mat2cell(handles.sort_matrix,ones(1,size(handles.sort_matrix,1)),ones(1,size(handles.sort_matrix,2)));
      data_string = cellfun(@(c)num2str(c,'%.1f'),temp_cell,'un',0);
      handles.selected = mat2cell(false(size(handles.sort_matrix,1),1),ones(1,size(handles.sort_matrix,1)),1);
      temp = cat(2, handles.selected, data_string);
      
      
      %set(handles.uitable1,'ColumnFormat',{'logical','char' ,'char' ,'char' ,'char' ,'char', 'char'})
      %set(handles.uitable1,'ColumnEditable',[true false false false false false false ])
      set(handles.uitable1,'RowName','Numbered')
      set(handles.uitable1,'Data',temp)
      set(handles.uitable1,'ColumnName',cat(2,'Selected' ,sort_str))
      
      
      
  end
    
    
    
elseif strmatch('data', handles.view_look, 'exact')
    
    
    
    val = get(handles.popupmenu1,'Value');
    
    
    
            set(handles.uitable1,'Visible','on','Position',[0.05   0.02   0.5    .6]);
            set(handles.uitable1,'ColumnFormat',{'char','char' ,'char' ,'char' })
            set(handles.uitable1,'ColumnEditable',[false false false false  ])
    
            set(handles.axes1,'Visible','on','Position',[0.65   0.2   .32   .32],'box','on');      
            set(handles.axes2,'Visible','on','Position',[0.05   0.67   .68   .15]);
            set(handles.axes3,'Visible','on','Position',[0.05   0.84   .68   .15]);
          
            set(handles.uitable2,'ColumnName',{});
            set(handles.uitable2,'Visible','off');
            set(handles.uitable3,'Visible','off');
            
            
            set(handles.popupmenu2,'Visible','on','Position',[0.6 0.575 0.17 0.04]);
            set(handles.popupmenu3,'Visible','on','Position',[0.6 0.54 0.17 0.04]);
            
            set(handles.pushbutton1,'Visible','off');
            set(handles.checkbox1,'Visible','on','string','CI','Position',[0.7 0.04 0.1 0.04]);
            %set(handles.edit1,'Visible','on','Position',[0.6 0.03 0.1 0.04],'String','Conf. Int.')
            
            set(handles.slider1,'Visible','on', 'Position', [0.65 0.1  0.3 0.01]);
            
            set(handles.checkbox3,'Position',[0.7 0.015 0.1 0.04],'string','Log-Log axes','Visible','on','Value',0);
    
            switch val
                
                
                case 3
                    
                    
                    set(handles.axes5,'Visible','on','Position',[.78   0.67   .2   0.319],'Color','none');
                    set(handles.axes4,'Visible','off','Position',[.78   0.67   .2   0.319]);
                    
                    tstring = [];
                    for k=1:size(handles.view_data{2},2)
                    tstring = [tstring, {num2str(k)}];
                    end
                    tstring = [tstring, {'All'}];
                    set(handles.popupmenu4,'Visible','on','Position', [0.82 0.6 0.1 0.04],'String',tstring,'Value',1);
                  
                    
                    
                    
                case 4
                    
                    
                    axes(handles.axes4)
                    cla;
                    axes(handles.axes5)
                    cla;
                    set(handles.axes4,'Visible','on','Position',[.78   0.67   .2   0.15],'xlim', [0 1],'ylim', [0 1]);
                    set(handles.axes5,'Visible','on','Position',[.78   0.84   .2   0.15],'Color', 'w','xlim', [0 1],'ylim', [0 1]);
                    
                    
                    
                    
            end
            
            
    
    
elseif strmatch('bic', handles.view_look, 'exact')
    
    
    %cla(handles.axes1,'reset');
    %set(handles.axes1,'Visible','on','Position',[0.1   0.4   .5   .5]);     
    set(handles.axes1,'Visible','on','Position',[0.1   0.5   .4   .4]);      
    
    

    set(handles.popupmenu1,'Visible','off');
    set(handles.popupmenu2,'Visible','on','Position',[0.30 0.25 0.17 0.04]);
    set(handles.popupmenu2,'String', {'BIC','BIC normalize' 'logPx','logPx normalize'})
    
    set(handles.uitable1,'Visible','on','Position',[0.1   0.05   0.8    .2]);
    set(handles.uitable1,'ColumnFormat',{'char'  },'ColumnName','Fit Group','RowName','default') ;
    set(handles.uitable1,'ColumnEditable',[false   ]);
    
    set(handles.uitable1,'Data',handles.proc_name')
    set(handles.uitable1,'ColumnWidth',{500})
    
    
    
elseif strmatch('cluster', handles.view_look, 'exact')
    
    
            
 
            % get cluster types
            cluster_types =  get_cluster_info(handles);
            
            set(handles.popupmenu3,'Visible','on','Position',[0.798 0.3 0.17 0.04],'String',cluster_types,'Value',1);
            
            cs = {'1 Cluster' '2 Cluster' '3 Cluster' '4 Cluster' '5 Cluster' '6 Cluster' '7 Cluster' '8 Cluster' ...
                '9 Cluster' '10 Cluster' '11 Cluster' '12 Cluster' '13 Cluster' '14 Cluster' '15 Cluster'};
            set(handles.popupmenu4,'Visible','on','Position', [0.798 0.25 0.1 0.04],'String',cs,'Value',1);
            %    set(handles.popupmenu4,'Visible','on','Position', [0.82 0.55 0.1 0.04]);
        
            set(handles.axes1,'Visible','on','Position',[0.1  0.4   .45   .45],'box','on','xtick',[],'ytick',[]);
            ylabel(handles.axes1,'')
            xlabel(handles.axes1,'')
            set(handles.pushbutton1,'Visible','on');
            set(handles.pushbutton1,'Position',[0.8 0.2 0.1 0.05],'String','Cluster');
            
            
else
    
end























