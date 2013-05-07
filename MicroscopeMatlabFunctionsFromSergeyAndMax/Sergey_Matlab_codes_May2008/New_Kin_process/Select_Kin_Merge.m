function output = Select_Kin_Merge(prefix,suffix,start,stop,minlength,Keqmin,Keqmax)%(filename,minlength, Keqmin)
%width let's say 3-fold around average
%HURRRAAAAAY! It works!
%Added separate save of kinetics for those molecules that did not meet the
%Keq requirement
%minlength in FRAMES!!!
MergedKin = [];
for i=start:stop
    getdatafrom = strcat(prefix,suffix,'cascade', num2str(i), '(4).dat');
    try
        tempdata = importdata(getdatafrom);
        MergedKin = [MergedKin;tempdata];
    catch
        %barf = strcat('err_',getdatafrom)
    end
end
%  length(MergedKin)
%  return
Unfolded = [];
Folded = [];
% UnfoldedU = [];%for Unstable molecules with Keq<Keqmin
% FoldedU = [];
UnfoldedTemp = [];
FoldedTemp = [];
TimeLow = 0;
TimeHigh = 0;
%count=0;
      for j=2:length(MergedKin)
                        
            if MergedKin(j,1)==0
%                 
                TimeLow = TimeLow + MergedKin(j,2);
                UnfoldedTemp = [UnfoldedTemp;MergedKin(j,:)];
%                 isfinite(Kin(j,2))
%                 isfinite(Kin(j,3))
%                 return
            elseif MergedKin(j,1)==3
                TimeHigh = TimeHigh + MergedKin(j,2);
                FoldedTemp = [FoldedTemp;MergedKin(j,:)];
            elseif MergedKin(j,1)==9&&MergedKin(j,2)==9
                
                Keq = TimeHigh/TimeLow;
                %Timetotal = TimeLow+TimeHigh
                if (TimeLow+TimeHigh)>minlength
                    if (Keq>=Keqmin)&&(Keq<=Keqmax)
                        %count=count+1;
                        Unfolded = [Unfolded;UnfoldedTemp];
                        Folded = [Folded;FoldedTemp];
                        UnfoldedTemp = [];
                        FoldedTemp = [];
                        TimeLow = 0;
                        TimeHigh = 0;
                        Keq = 0;
%                     elseif (Keq<Keqmin)
%                         UnfoldedU = [UnfoldedU;UnfoldedTemp];
%                         FoldedU = [FoldedU;FoldedTemp];
%                         UnfoldedTemp = [];
%                         FoldedTemp = [];
%                         TimeLow = 0;
%                         TimeHigh = 0;
                    else
                    end
                else
                    UnfoldedTemp = [];
                    FoldedTemp = [];
                    TimeLow = 0;
                    TimeHigh = 0;
                    Keq = 0;
                end
%                 
            else
            end
        
            
      end
      %count
 %return
parameters = strcat('(',num2str(log10(Keqmin),2),'_',num2str(log10(Keqmax),2),')');
newfilename1 = strcat('Fkin',parameters,'cascade', num2str(start),'_',num2str(stop),'.dat');%folding kinetcis
newfilename2 = strcat('Ukin',parameters,'cascade', num2str(start),'_',num2str(stop),'.dat');
% newfilename3 = strcat('FkinU',parameters,'.dat');
% newfilename4 = strcat('UkinU',parameters,'.dat');
dlmwrite(newfilename1, Unfolded,',');%Unfolded dwells-folding kinetics
dlmwrite(newfilename2, Folded,',');%Folded dwells - unfolding kinetics
% dlmwrite(newfilename3, UnfoldedU,',');
% dlmwrite(newfilename4, FoldedU,',');

%%%%%%%Multi-file code
% newfilename1 = strcat(prefix,suffix,'(',num2str(start),'to',num2str(stop),')Fkin',parameters,'.dat');%folding kinetcis
% newfilename2 = strcat(prefix,suffix,'(',num2str(start),'to',num2str(stop),')Ukin',parameters,'.dat');
% newfilename3 = strcat(prefix,suffix,'(',num2str(start),'to',num2str(stop),')FkinU',parameters,'.dat');
% newfilename4 = strcat(prefix,suffix,'(',num2str(start),'to',num2str(stop),')UkinU',parameters,'.dat');
% dlmwrite(newfilename1, Unfolded,',');%Unfolded dwells-folding kinetics
% dlmwrite(newfilename2, Folded,',');%Folded dwells - unfolding kinetics
% dlmwrite(newfilename3, UnfoldedU,',');
% dlmwrite(newfilename4, FoldedU,',');
