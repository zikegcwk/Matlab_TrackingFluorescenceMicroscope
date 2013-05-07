Nsamp = 30;
powerdat = zeros(Nsamp, 1);
t = powerdat;
tprev = 0;

for u = 1:Nsamp,
    tic;
    fprintf('Reading sample %d/%d\n', u, Nsamp);
    ar = SetupAnalogRead(4, 1000, 0.5);
    TriggerAnalogRead(ar);
    data = GetAnalogData(ar);
    
    powerdat(u) = mean(data);
    t(u) = tprev + toc;
    tprev = t(u);
end;

save('LTPower', 't', 'powerdat');
