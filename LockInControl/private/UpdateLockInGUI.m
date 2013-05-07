% Human2Vec(HumanStruct) (private)
% Updates the LockInGUI interface (if it exists) to reflect the values
% contained in its human-readable input structure.
function UpdateGUI(HumanStruct)

[axy, az] = Human2Vec(HumanStruct);

oldHiddenHandleState = get(0, 'showHiddenHandles');
set(0, 'showHiddenHandles', 'on');
hObject = findobj(get(0, 'Children'), 'Tag', 'LockInGUI');
set(0, 'showHiddenHandles', oldHiddenHandleState);

if hObject,
    panelHandles = get(hObject, 'Children');

    handles = struct();
    for u = 1:length(panelHandles),
        panelChildren = get(panelHandles(u), 'Children');
        for v = 1:length(panelChildren),
            if ~strcmp(get(panelChildren(v), 'Tag'), ''),
                handles.(get(panelChildren(v), 'Tag')) = panelChildren(v);
            end;
        end;
    end;

    GainStrings = {'20dB', '26dB', '34dB', '40dB', '46dB', '54dB', '60dB', '66dB', '74dB', '80dB',...
        '86dB', '94dB', '100dB', '106dB', '114dB', '120dB', '126dB', '134dB', '140dB', '146dB', ...
        '154dB', '160dB', '166dB', '174dB', '180dB', '186dB', '194dB'};

    SensStrings = {'2nV', '5nV', '10nV', '20nV', '50nV', '100nV', '200nV', '500nV', '1uV', '2uV', ...
        '5uV', '10uV', '20uV', '50uV', '100uV', '200uV', '500uV', '1mV', '2mV', '5mV', '10mV', ...
        '20mV', '50mV', '100mV', '200mV', '500mV', '1V'};
    
    SensStrings = fliplr(SensStrings); % I accidentally input these in the wrong order.
    
    TcStrings = {'10us', '30us', '100us', '300us', '1ms', '3ms', '10ms', '30ms', ...
        '100ms', '300ms', '1s', '3s', '10s', '30s', '100s', '300s', '1ks', '3ks', ...
        '10ks', '30ks'};

    set(handles.FreqXY, 'String', num2str(axy(2)/1000));
    set(handles.PhaseXY_Text, 'String', axy(3));
    set(handles.PhaseXY, 'Value', axy(3));
    set(handles.GainXY, 'Value', axy(4)+1);
    set(handles.GainXY_Text, 'String', GainStrings{axy(4)+1});
    set(handles.SensXY_Text, 'String', SensStrings{axy(4)+1});
    set(handles.TcXY, 'Value', axy(5)+1);
    set(handles.TcXY_Text, 'String', TcStrings{axy(5)+1});
    set(handles.SlopeXY, 'Value', axy(6)+1);
    set(handles.ReserveModeXY, 'Value', axy(7)+1);

    if axy(7) ~= 1,
        set(handles.ReserveXY, 'Visible', 'off');
        set(handles.ReserveXY_Text, 'Visible', 'off');
    else
        set(handles.ReserveXY, 'Visible', 'on');
        set(handles.ReserveXY_Text, 'Visible', 'on');
    end;

    set(handles.OffsetX, 'Value', axy(9));
    set(handles.OffsetX_Text, 'String', strcat(num2str(axy(9)*10), ' mV'));
    set(handles.OffsetY, 'Value', axy(10));
    set(handles.OffsetY_Text, 'String', strcat(num2str(axy(10)*10), ' mV'));

    set(handles.FreqZ, 'String', num2str(az(2)/1000));
    set(handles.PhaseZ_Text, 'String', az(3));
    set(handles.PhaseZ, 'Value', az(3));
    set(handles.GainZ, 'Value', az(4)+1);
    set(handles.GainZ_Text, 'String', GainStrings{az(4)+1});
    set(handles.SensZ_Text, 'String', SensStrings{az(4)+1});
    set(handles.TcZ, 'Value', az(5)+1);
    set(handles.TcZ_Text, 'String', TcStrings{az(5)+1});
    set(handles.SlopeZ, 'Value', az(6)+1);
    set(handles.ReserveModeZ, 'Value', az(7)+1);
    set(handles.OffsetZ, 'Value', az(9));
    set(handles.OffsetZ_Text, 'String', strcat(num2str(az(9)*10), ' mV'));

    guidata(hObject, handles);
end;

return;