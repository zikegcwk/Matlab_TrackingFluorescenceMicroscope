function etry = GetConfRegionSizeE_(n,c,p,A,E,fitChannelType,confInt,x,boundsMeshSize,auto_MeshSpacing)
e = Get_e_(E,fitChannelType,x);

logPxMax = LogPxWith_es_(A,e);

%confindence intermal


deltaupper = abs(E{n,c}(p)/100);
deltalower = abs(E{n,c}(p)/100);

Etry = E;

Etry{n,c}(p) = E{n,c}(p)+deltaupper;
if (exp(LogPxWith_E_(A,Etry,fitChannelType,x) - logPxMax) > (1-confInt)),
    pow = +1;
else
    pow = -1;
end

maxSteps = 100;

steps = 0;

done = 0;
while done == 0,
    Etry{n,c}(p) = E{n,c}(p) + deltaupper;
    logPx = LogPxWith_E_(A,Etry,fitChannelType,x);
    if exp(logPx - logPxMax)^pow > (1-confInt)^pow,
        deltaupper = deltaupper * 2^pow;
    else
        deltaupper = deltaupper * 2^(pow == -1); %double it if approched from above
        done = 1;
    end
    
    steps = steps + 1;
    if steps > 100,
        disp(['warning: could not find upper error bound on e(' num2str(n) ',' num2str(c) ',' num2str(p) ') in ' num2str(maxSteps) ' iterations']);
        deltaupper = abs(E{n,c}(p)/100);
        done = 1;
    end
end

Etry = E;
Etry{n,c}(p) = E{n,c}(p)-deltalower;
if (exp(LogPxWith_E_(A,Etry,fitChannelType,x) - logPxMax) > (1-confInt)),
    pow = +1;
else
    pow = -1;
end
steps = 0;
done = 0;
while done == 0,
    Etry{n,c}(p) = E{n,c}(p) - deltalower;
    logPx = LogPxWith_E_(A,Etry,fitChannelType,x);
    if exp(logPx - logPxMax)^pow > (1-confInt)^pow,
        deltalower = deltalower * 2^pow;
    else
        deltalower = deltalower * 2^(pow == -1); %double it if approched from above
        done = 1;
    end
    
    steps = steps + 1;
    if steps > 100,
        disp(['warning: could not find lower error bound on e(' num2str(n) ',' num2str(c) ',' num2str(p) ') in ' num2str(maxSteps) ' iterations']);
        deltalower = abs(E{n,c}(p)/100);
        done = 1;
    end
end 

if strcmp(auto_MeshSpacing,'square'),
    etry = linspace(E{n,c}(p)-deltalower,E{n,c}(p)+deltaupper,boundsMeshSize)';
end
if strcmp(auto_MeshSpacing,'auto'),
    etry = linspace(E{n,c}(p)-deltalower,E{n,c}(p),round(boundsMeshSize/2))';
    etry(end) = [];
    etry = [etry ; linspace(E{n,c}(p),E{n,c}(p)+deltaupper,round(boundsMeshSize/2))'];
end