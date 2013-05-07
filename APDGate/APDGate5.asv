% APDGate(arg1, arg2)
% toggles gate arg1 to state arg2.
function APDGate5(lineCmd, intCmd); 
global LineState;
global IntState

dio = digitalio('nidaq', 'Dev1');
if nargin==1
    intCmd=0; %by default we don't want to integrate
end
    hline = addline(dio, 0:5, 'Out');
    hline = addline(dio, 6, 'Out');
   
    IntState=1;
    if (sum(lineCmd) & intCmd),
    IntState = 0;
    end
    
    
    output = logical([lineCmd IntState]);
    putvalue(dio, output);
    LineState=lineCmd;
    
    hgui=findobj('Tag','gui5');
 if not(isempty(hgui))
     for j=1:6
     set(findobj('Tag',sprintf('apd%s',num2str(j))),'Value',LineState(j));
     end
 end

delete(dio);

return;
