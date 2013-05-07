function [nutry] = GetConfRegionSizeA_(r,c,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing)
e = Get_e_(E,fitChannelType,x);

logPxMax = LogPxWith_es_(A,e);

%confindence interval


deltaupper = 1-A(r,c);% min(A(1,2)*64,1-A(1,2));  
deltalower = A(r,c); 

maxSteps = 100;

steps = 0;

done = 0;   
movedatleastonce = 0;
while done == 0,
    Atry = A;
    Atry(r,:) = Atry(r,:).*(1-(A(r,c)+deltaupper))/(1-A(r,c));
    Atry(r,c) = A(r,c) + deltaupper;
    logPx = LogPxWith_es_(Atry,e);
    if exp(logPx - logPxMax) > (1-confInt),
        if movedatleastonce == 1,
            deltaupper = deltaupper * 2;
        end
        done = 1;
    else
        deltaupper = deltaupper / 2 ; 
        movedatleastonce = 1;
    end
    
    steps = steps + 1;
    if steps > 100,
        disp(['warning: could not find upper error bound on a(' num2str(r) ',' num2str(c) ') in ' num2str(maxSteps) ' iterations']);
        disp('using default value 1');
        deltaupper = 1-A(r,c);
        done = 1;
    end
    
end

steps = 0;
done = 0;
movedatleastonce = 0;
while done == 0,
    Atry = A;
    Atry(r,:) = Atry(r,:).*(1-(A(r,c)-deltalower))/(1-A(r,c));
    Atry(r,c) = A(r,c) - deltalower;
    logPx = LogPxWith_es_(Atry,e);
    if exp(logPx - logPxMax) > (1-confInt),
        if movedatleastonce == 1,
            deltalower = deltalower * 2;
        end
        done = 1;
    else
        deltalower = deltalower / 2;
        movedatleastonce = 1;
    end
    
    steps = steps + 1;
    if steps > 100,
        disp(['warning: could not find lower error bound on a(' num2str(r) ',' num2str(c) ') in ' num2str(maxSteps) ' iterations']);
        disp('using default value 0');
        deltalower = A(r,c);
        done = 1;
    end
end

if strcmp(auto_MeshSpacing,'square'),
    nutry = linspace(A(r,c)-deltalower,A(r,c)+deltaupper,boundsMeshSize)';
end
if strcmp(auto_MeshSpacing,'auto'),
    nutry = linspace(A(r,c)-deltalower,A(r,c),round(boundsMeshSize/2))';
    nutry(end) = [];
    nutry = [nutry ; linspace(A(r,c),A(r,c)+deltaupper,round(boundsMeshSize/2))'];
end