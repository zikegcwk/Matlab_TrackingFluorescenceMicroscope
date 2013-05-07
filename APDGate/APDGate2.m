% APDGate(arg1, arg2)
% toggles gate arg1 to state arg2.
function APDGate2(lineCmd, intCmd); 
global LineState;
global IntState

dio = digitalio('nidaq', 'Dev1');
if nargin==1
    intCmd=0; %by default we don't want to integrate
end
    hline = addline(dio, 0:3, 'Out');
    hline = addline(dio, 4, 'Out');
   
    IntState=1;
    if (sum(lineCmd) & intCmd),
    IntState = 0;
    end
    
    
    output = logical([lineCmd IntState]);
    putvalue(dio, output);
    LineState=lineCmd;
    
    hgui=findobj('Tag','gui3');
 if not(isempty(hgui))
     for j=1:4
     set(findobj('Tag',sprintf('apd%s',num2str(j-1))),'Value',LineState(j));
     end
 end

delete(dio);

return;
