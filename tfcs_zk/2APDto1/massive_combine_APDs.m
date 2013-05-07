function massive_combine_APDs()

    files=dir('data_*.mat');
    filesnamesCell=struct2cell(files);
    [a,n]=size(filesnamesCell);
    M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end
    M=sort(M);
 
 
 
 
 for j=1:1:length(M)
     if M(j)<10000
     Combine_APDs(M(j));
     end
 end
