function output = FlowFolding(start,stop,tflow,tdead)
%width let's say 3-fold around average
%HURRRAAAAAY! It works!
MergedKin = [];
for i=start:stop
    getdatafrom = strcat('(kinetics)(box3)cascade', num2str(i), '(4).dat');
    try
        tempdata = importdata(getdatafrom);
        MergedKin = [MergedKin;tempdata];
    catch
        %barf = strcat('err')
    end
end
size(MergedKin);
% return
PreflowKin = [];
MergedTemp = [];
TimeTotal = 0;
      for j=1:length(MergedKin)
          if (MergedKin(j,1)==9)&&(MergedKin(j,2)~=9)
              MergedTemp = [MergedTemp;MergedKin(j,:)];
              k=j+1;
               while TimeTotal<tflow  
                
                MergedTemp = [MergedTemp;MergedKin(k,:)];
                TimeTotal = sum(MergedTemp(:,2));%TimeTotal+MergedKin(k,2);
                k=k+1;
               end
               size(MergedTemp);
               TimeTotal = 0; 
               PreflowKin = [PreflowKin;MergedTemp;[9 9 9]];
              
               MergedTemp = [];
          else
          end
      end
size(PreflowKin );

parameters = strcat(num2str(tflow),'frame');
newfilename1 = strcat('(Preflow',parameters,')','(kinetics)(box3)cascade',num2str(i),'.dat');%kinetcis of pre-flow state
%newfilename2 = strcat('(merged',num2str(start),'to',num2str(stop),')Ukin(',parameters,').dat');
dlmwrite(newfilename1, PreflowKin,',');%Unfolded dwells-folding kinetics
%dlmwrite(newfilename2, Folded,',');%Folded dwells - unfolding kinetics

%%%%%%%%%%%%%%%%%%%Now lets save kinetics after buffer exchange%%%%%
MergedKin = [MergedKin zeros(length(MergedKin),1)];
PostflowKin = MergedKin(1,:);
MergedTemp = [];
TimeTotal = 0;
j=2;
k=2;%First a loop that adds the forth column with "real time" for each molecule: marking start of each dwell
      while j<=length(MergedKin)
          
          if MergedKin(j,1)~=9
              Dwellstart = sum(MergedKin(k:j,2));
              MergedKin(j,4) = Dwellstart;
              
          else
              MergedKin(j,4) = 0;
              k=j+1;
          end
          j=j+1;
      end
%MergedKin(1:35,:)
for j=2:length(MergedKin)
          if MergedKin(j,4)>tdead
              MergedTemp = [MergedTemp;MergedKin(j,:)];
          elseif (MergedKin(j,1)==9)&&(MergedKin(j,2)==9)
              MergedTemp = [MergedTemp;MergedKin(j,:)];
          elseif (MergedKin(j,1)==9)&&(MergedKin(j,2)~=9)
              MergedTemp = [MergedTemp;MergedKin(j,:)];
              PostflowKin = [PostflowKin;MergedTemp];
              MergedTemp = [];
          end
end
parameters = strcat(num2str(tflow),'frame');
newfilename1 = strcat('(Postflow',parameters,')','(kinetics)(box3)cascade',num2str(i),'.dat');%kinetcis of pre-flow state
%newfilename2 = strcat('(merged',num2str(start),'to',num2str(stop),')Ukin(',parameters,').dat');
dlmwrite(newfilename1, PostflowKin,',');%Unfolded dwells-folding kinetics
%dlmwrite(newfilename2, Folded,',');%Folded dwells - unfolding kinetics