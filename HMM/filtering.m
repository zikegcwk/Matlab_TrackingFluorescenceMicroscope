function f=filtering(filenum,t1,t2)
f.file=filenum;
f.tstart=t1;
f.tend=t2;
t1=t1*10;t1=floor(t1);t1=t1/10;
t2=t2*10;t2=floor(t2);t2=t2/10;
f.t1=t1;
f.t2=t2;
dt=10e-3;
[I,t]=plot_fluo(filenum,dt,t1,t2,0);
% size(I{1})
% size(I{2})
seq=I{1};
seq(end)=round(mean(seq));

f.t=t;
%initial guess of the model.
guessTR(1,1)=0.9898;
guessTR(1,2)=1-guessTR(1,1);
guessTR(2,1)=0.0197;
guessTR(2,2)=1-guessTR(2,1);

[f.estTR f.estE f.logliks f.pS]=trainHMM(seq,guessTR,[min(seq) mean(seq)]);

for j=1:1:length(f.pS)
    if f.pS(2,j)>f.pS(1,j)
        indi2(j)=1;
    else
        indi2(j)=0;
    end
end
f.data=seq;
f.indi=indi2;

 %figure;
 %plot(t{1},indi2)
k=1;u=1;

for j=1:1:length(f.pS)-1
    if indi2(j)==1 && indi2(j+1)==0
       td(k)=j;
       k=k+1;
    end
    
    if indi2(j)==0 && indi2(j+1)==1
        tu(u)=j+1;
        u=u+1;
    end
end

if indi2(1)==1
    s1='begin_high';
else
    s1='begin_low';
end

if indi2(end)==1
    s2='end_high';
else
    s2='end_low';
end

%case one, only t down.
if exist('td') && ~exist('tu')
    td=td*dt+t1;
    f.ts=t1;
    f.te=td(1);
end 

%case two, only t up.
if exist('tu') && ~exist('td')
    tu=tu*dt+t1;
    f.ts=tu(1);
    f.te=t2;
end

%case if both are assigned.
if exist('tu') && exist('td') 
        td=td*dt+t1;
        tu=tu*dt+t1;
    if strcmp(s1,'begin_high') && strcmp(s2,'end_high')
       f.ts(1)=t1;
       f.te(1)=td(1);
       for j=2:1:size(td,2)
           f.ts(j)=tu(j-1);
           f.te(j)=td(j);
       end
       f.ts(j+1)=tu(j);
       f.te(j+1)=t2;
    end
    
    if strcmp(s1,'begin_low') && strcmp(s2,'end_high')
       for j=1:1:size(td,2)
           f.ts(j)=tu(j);
           f.te(j)=td(j);
       end
       f.ts(j+1)=tu(j+1);
       f.te(j+1)=t2;
    end
    
    if strcmp(s1,'begin_high') && strcmp(s2,'end_low') 
         f.ts(1)=t1;
         f.te(1)=td(1);
         for j=2:1:size(tu,2)
             f.ts(j)=tu(j-1);
             f.te(j)=td(j);
         end
    end
    
    if strcmp(s1,'begin_low') && strcmp(s2,'end_low')
        for j=1:1:size(tu,2)
            f.ts(j)=tu(j);
            f.te(j)=td(j);
        end
    end
end

goodindi=find((f.te-f.ts)>2);
for j=1:1:length(goodindi)
    f.tss(j)=f.ts(goodindi(j));
    f.tee(j)=f.te(goodindi(j));
end

  
% d2=diff(indi2);

%case one.with zero initially but encount 1 at d2. This means we start with
%low and eventually hit a high.
%case two, with zero initally but enter -1 at d2. This means we start with
%high and eventually hit a low. 
% 
% f.t1=find(d2==1);
% f.t2=find(d2==-1);
% 
% n=min(size(f.t1,2),size(f.t2,2));
% 
% if f.t1(1)<f.t2(1)%start situation one - low first. 
%     for j=1:1:n-1
%         f.tt1(j)=f.t1(j);
%         f.tt2(j)=f.t2(j);
%     end
%     if size(f.t1,2)>size(f.t2,2)
%         f.tt1(n)=f.t1(n);
%         f.tt2(n)=length(f.pS);
%     else
%         f.tt1(n)=f.t1(n);
%         f.tt2(n)=f.t2(n);
%     end   
% else %starting at high
%     f.tt1(1)=1;
%     f.tt2(1)=f.t2(1);
%     if n>1
%         for j=2:1:n-1
%             f.tt1(j)=f.t1(j-1);
%             f.tt2(j)=f.t2(j);
%         end
%         if size(f.t1,2)==size(f.t2,2)
%             f.tt1(n)=f.t1(n);
%             f.tt2(n)=length(f.pS);
%         else
%             f.tt1(n)=f.t1(n-1);
%             f.tt2(n)=f.t2(n);
%         end 
%     end
% end
% 
% f.tt1=f.tt1*1e-2+t1;
% f.tt2=f.tt2*1e-2+t1;
% % 
% % for j=1:1:length(f.tt1)
% %     if (f.tt2(j)-f.tt1(j)>2)
% %         goodindi(j)=1;
% %     else
% %         goodinid(j)=0;
% %     end
% % end
% 
% goodindi=find((f.tt2-f.tt1)>2);
% 
% for j=1:1:length(goodindi)
%     f.ts(j)=f.tt1(goodindi(j));
%     f.te(j)=f.tt2(goodindi(j));
% end










    


