function [nu_lower,nu_upper] = GetConfBoundPointsA_(r,c,A,E,fitChannelType,confInt,x)

%finds lower and upper point for A(r,c) within confInt

e = Get_e_(E,fitChannelType,x);

logPxMax = LogPxWith_es_(A,e);

%confindence interval

nu_upper = 1;
nu_lower = 0;

precision = (1-confInt)/100;

done = 0;
dir = -1;
stepSize = (nu_upper - A(r,c))/2;
while done == 0,
    Atry = A;
    Atry(r,:) = Atry(r,:).*(1-(nu_upper))/(1-A(r,c));
    Atry(r,c) = nu_upper;
    logPx = LogPxWith_es_(Atry,e);
    if mod((exp(logPx - logPxMax) > (1-confInt)) + (dir+1)/2,2),
        dir = -1*dir;
    end
    nu_upper = nu_upper + dir*stepSize;
    stepSize = stepSize/2;
    
%     if stepSize < precision*A(r,c),
    if abs(exp(logPx-logPxMax) - (1-confInt)) < precision,
        done = 1;
    end
end
done = 0;
dir = 1;
stepSize = A(r,c)/2;
while done == 0,
    Atry = A;
    Atry(r,:) = Atry(r,:).*(1-(nu_lower))/(1-A(r,c));
    Atry(r,c) = nu_lower;
    logPx = LogPxWith_es_(Atry,e);
    if mod((exp(logPx - logPxMax) > (1-confInt)) + (dir-1)/2,2),
        dir = -1*dir;
    end
    nu_lower = nu_lower + dir*stepSize;
    stepSize = stepSize/2;
    
%     if stepSize < precision*A(r,c),
    if abs(exp(logPx-logPxMax) - (1-confInt)) < precision,
        done = 1;
    end
end