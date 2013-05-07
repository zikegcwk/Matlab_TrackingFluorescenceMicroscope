%thislist variable should be pre-loaded for this script
j=1; quitloop=-1; ll=[440   378   560   420];
datalist=[];
while ((j<=size(thislist,1))&&(quitloop<0)),
    fnum=floor(thislist(j,1));
    load(strcat('data_',num2str(fnum),'.mat'));
    startP=daq_out(find(t0>thislist(2,2),1));
    stopP=daq_out(find(t0>thislist(2,3),1));
    mchoice=0;
    MSD3D(fnum,thislist(j,2),thislist(j,3)); thisfig = gcf; set(thisfig,'Position',ll);
    mchoice=menu('Options','Input values (and go to next event)','Remove last entry (and go back)','Quit (without recording this event)');
    if (mchoice==1),
        prompt={'Apparent MSD(0.1s):','Uncertainty:'};
        name='Diffusion-coefficient-by-eye';
        numlines=1;
        defaultanswer={'0','0'};
        answerc=inputdlg(prompt,name,numlines,defaultanswer);
        diffco=str2num(answerc{1});
        diffunc=str2num(answerc{2});
        datalist=[datalist; thislist(j,:) startP stopP diffco diffunc];
        j=j+1;
    elseif (mchoice==2),
        datalist=datalist(size(datalist,1)-1,:);
        j=j-1;
    else
        quitloop=1;
    end;
    datalist,
    ll = get(thisfig,'Position'); close(thisfig);
end