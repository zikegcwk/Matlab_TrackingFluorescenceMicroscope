k=0;
clear df_count
for j=1:1:(length(dfdates)-1)
    j
    if dfdates(j+1)~=dfdates(j)
        k=k+1;
        df_count(k)=1;
        df_day(k)=dfdates(j);
        k
    else
        df_count(k)=df_count(k)+1;
    end
end

df_day(1)=1;
df=zeros(1,max(df_day));
allday=1:1:max(df_day);

for j=1:1:length(df_day)
    df_index(j)=find(allday==df_day(j));       
end

for j=1:1:length(df_index)
    df(df_index(j))=df_count(j);
end
    