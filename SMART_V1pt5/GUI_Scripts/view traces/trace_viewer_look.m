function trace_viewer_look(handles,viewlook)

% sets the look of the trace viewer depending on the value of viewlook
% viewlook = 1 verything of off
% viewlook = 2 things look correct

switch viewlook
    case 1
        
        
        set(handles.pushbutton2,'visible','off')
        set(handles.pushbutton1,'visible','off')
        set(handles.axes1,'visible','off')
        set(handles.axes2,'visible','off')
        set(handles.axes3,'visible','off')
        set(handles.axes4,'visible','off')
        set(handles.axes5,'visible','off')
        %set(handles.axes6,'visible','off')
        set(handles.axes7,'visible','off')
        
        set(handles.checkbox1,'visible','off')
        set(handles.checkbox2,'visible','off')
        set(handles.slider1,'visible','off')
        set(handles.listbox1,'visible','off')
        set(handles.pushbutton1,'visible','off')
        set(handles.pushbutton2,'visible','off') 
        set(handles.pushbutton3,'visible','off')
        
        set(handles.popupmenu2,'visible','off')
        set(handles.popupmenu3,'visible','off')
        
        
        
    case 2
        
        
        set(handles.pushbutton2,'visible','on')
        set(handles.pushbutton1,'visible','on')
        set(handles.axes1,'visible','on')
        set(handles.axes2,'visible','on')
        
        cla(handles.axes3,'reset')
        cla(handles.axes4,'reset')
        
        set(handles.axes3,'visible','on','Position',[0.6800    0.6455    0.15    0.3237])
        set(handles.axes4,'visible','on','Position',[0.6800    0.3121    0.15    0.3237])
        
        
        
        
        set(handles.axes5,'visible','on')
        %set(handles.axes6,'visible','off')
        set(handles.axes7,'visible','off')
        set(handles.checkbox2,'visible','on','Position',[0.6739    0.21    0.0643    0.0520],'String','Show All','Value',1)
        set(handles.checkbox1,'visible','on')
        set(handles.checkbox2,'visible','on','Position',[0.6739    0.2    0.0643    0.0443])
        set(handles.slider1,'visible','on')
        set(handles.listbox1,'visible','on')
        set(handles.pushbutton1,'visible','on')
        set(handles.pushbutton2,'visible','on') 
        set(handles.pushbutton3,'visible','on')
        
        set(handles.popupmenu2,'visible','on','Position',[0.75    0.20    0.09    0.0520])
        set(handles.popupmenu3,'visible','on','Position',[0.75    0.13    0.09    0.0520])
        
        
        
        
        
        
end