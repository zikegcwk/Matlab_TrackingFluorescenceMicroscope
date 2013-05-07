function siglist=DrawPlots3DselectKeyboard(rng)

files=dir('data_*.mat');

filesnamesCell=struct2cell(files);

[a,n]=size(filesnamesCell);

M=zeros(n,1);

    for i=1:n

        cs=filesnamesCell{1,i};

        M(i)=str2num(cs(6:end-4));

    end

M=sort(M);

data2draw=[];    

siglist=[]; ndat = 0;

for i=1:length(rng)

    lastfile=(rng(i)-mod(rng(i),100))+100;

    x=find(M<lastfile & M>=rng);

    data2draw=cat(1,data2draw,M(x));

end

j=1; quitloop=-1; ll=[580   241   903   714];

while ((j<=length(data2draw))&&(quitloop<0)),

    DrawPlots3D(data2draw(j)); thisfig = gcf; set(thisfig,'Position',ll);

    mchoice=0;

    while (mchoice<5),

        %mchoice=menu('Options','Record from Fluor','Record from Stages','Record from Power','Erase last record','Next file','Previous file','Quit');

        isCorrect=0;

        while not(isCorrect);

        s=input('Action : ','s');

        

        if isempty(s)

            mchoice=5;

            isCorrect=1;

        else

            switch s

                case 'p'

                    mchoice=1;

                    isCorrect=1;

                case 'pp'

                    mchoice=2;

                    isCorrect=1;

                case 'ppp'

                    mchoice=3;

                    isCorrect=1;

                case 'b'

                    mchoice=6;

                    isCorrect=1;

                case 'e'

                    mchoice=4;

                    isCorrect=1;

                case 'x'

                    mchoice=7;

                    isCorrect=1;

                otherwise

                    display('Incorrect input');

                    isCorrect=0;

            end

        end

        end

                    

        if (mchoice==1),

            figure(thisfig); subplot(3,1,1);

            gg=get(gca,'Xlim');

            if (gg(1)<0),

                gg(1)=0;

            end;

            if (gg(2)>60),

                gg(2)=60;

            end;

            newsig = [data2draw(j) gg];

            siglist = [siglist; newsig]; ndat = ndat+1;

            set(gca,'XLimMode','auto');

            set(gca,'YLimMode','auto');

        end;

        if (mchoice==2),

            figure(thisfig); subplot(3,1,2);

            gg=get(gca,'Xlim');

            if (gg(1)<0),

                gg(1)=0;

            end;

            if (gg(2)>60),

                gg(2)=60;

            end;

            newsig = [data2draw(j) gg];

            siglist = [siglist; newsig]; ndat = ndat+1;

            set(gca,'XLimMode','auto');

            set(gca,'YLimMode','auto');

        end;

        if (mchoice==3),

            figure(thisfig); subplot(3,1,3);

            gg=get(gca,'Xlim');

            if (gg(1)<0),

                gg(1)=0;

            end;

            if (gg(2)>60),

                gg(2)=60;

            end;

            newsig = [data2draw(j) gg];

            siglist = [siglist; newsig]; ndat = ndat+1;

            set(gca,'XLimMode','auto');

            set(gca,'YLimMode','auto');

        end;        

        if (mchoice==4),

            siglist = siglist(1:ndat-1,:);

        end;        

        siglist,

    end;

    ll = get(thisfig,'Position'); close(thisfig);

    if (mchoice==6),

        j=j-1;

    elseif (mchoice==7),

        quitloop=1;

    else

        j=j+1;

    end;    

end