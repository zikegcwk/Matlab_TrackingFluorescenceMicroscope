% APDGate(arg1, arg2)
% toggles gate arg1 to state arg2.
function APDGate(arg1, arg2); 
global IntState;




dio = digitalio('nidaq', 'Dev1');
if(nargin == 2),
    APDNum = arg1;
    newState = arg2;
    
    hline = addline(dio, APDNum, 'Out');
    hline = addline(dio, 4, 'Out');

    output = logical([newState IntState]);
    putvalue(dio, output);
    hgui=findobj('Tag','gui3');
if not(isempty(hgui))
    set(findobj('Tag',sprintf('apd%s',num2str(APDnum))),'Value',arg2);
end
    

else
    LineState = arg1;
    hline = addline(dio, 0:3, 'Out');
    hline = addline(dio, 4, 'Out');
    
    output = logical([LineState IntState]);
    putvalue(dio, output);
%     hgui=findobj('Tag','gui3');
% if not(isempty(hgui))
%     for j=1:4
%     set(findobj('Tag',sprintf('apd%s',num2str(j)-1)),'Value',LineState(j));
%     end
% end
end;

delete(dio);

return;
