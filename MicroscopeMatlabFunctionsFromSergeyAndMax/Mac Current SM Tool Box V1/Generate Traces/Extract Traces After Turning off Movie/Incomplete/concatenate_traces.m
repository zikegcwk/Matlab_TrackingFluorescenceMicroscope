function output = concatenate_traces(filenames)



%mpostotable_concatenate({'cascade23(4).traces' 'Copy of cascade23(4)'},2)

% temp variables

%filenames = {'cascade23(4).traces' 'Copy of cascade23(4).traces'};



n = size(filenames,2);

i=1;
mposnames = {};
for i=1:n
     
tempfilename= char(filenames(1,i));
m=findstr(tempfilename,'.');

tempfilename = strcat(tempfilename(1:m-1), '.mpos');
mposnames = {char(mposnames), tempfilename};


end 


 % this does not quite work correct since I don't understand somehting about
% changing variable ie cell, strin or number in matlab so will procede

positiontable = {'cascade23(4).mpos' 'Copy of cascade23(4).mpos'};

 
positiontable = mpostotable_concatenate(positiontable,n)


TraceAndPositionMatch(filename,positiontable)

clear all

% newfilename = strcat(newname, 'mpos', '.dat');
% fid2 = fopen(newfilename, 'wb');
% fprintf(fid2,'%d %4.1f %4.1f %4.1f %4.1f\n',PositionTable');
% fclose(fid);
% output=1;
% fclose(fid2);
% 

% 
% 
% 
% 
% 
% 
% 
% 
% 
% for i=1:n
% 
% 
% 
% %   fid=fopen(handles.datafile,'r');
%         
%         fid=fopen('cascade23(4).traces','r');
%         len=fread(fid,1,'int32');
%         Ntraces=fread(fid,1,'int16');
%         Data=fread(fid,[Ntraces+1 len],'int16');
%         fclose(fid);
%        
%         
%         
%      
%         
%         FinalPositionTable = [];
% 
%         
% for i=1:n
% 
%     
% fid = fopen(char(filename(1,i)));
% Numberofmolecules = fread(fid,1,'int16')/2;
% PositionTable = zeros(Numberofmolecules,5);
% for i=1:Numberofmolecules
%     PositionTable(i,1) = i;
%     PositionTable(i,2) = fread(fid,1,'int16');
%     PositionTable(i,4) = fread(fid,1,'int16');%every second x-coordinates is for "acceptor side"
% end
% for i=1:Numberofmolecules %this is saving the y-coordinate
%     PositionTable(i,3) = fread(fid,1,'int16');
%     PositionTable(i,5) = fread(fid,1,'int16');
% end
% 
% FinalPositionTable = [FinalPositionTable;PositionTable];
% 
% end
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         handles.fps=40;
%         nmapped=Ntraces/2;
%         ndonor=Ntraces/2;



%for ind=filenumber1:filenumberlast
%     filename = 'testanimal.traces';%strcat('cascade', num2str(ind),'(4)','.traces');
%     try
%         fid=fopen(filename);
%         length = fread(fid,1,'int32');
%         
%         NumberTraces = fread(fid,1,'int16');
%         Data = fread(fid,[NumberTraces+1 length],'int16');
%         fclose(fid);
%        
%         
%         size(Data);
% %         Data(3,100:120);
%         Data_dF = zeros(length, window);
%         Data_dB = zeros(length, window);
%         Data_aF = zeros(length, window);
%         Data_aB = zeros(length, window);
%         
%         f = ones(length,window);
%         b = ones(length,window);
   






% 
% 
% % this function is designed to importat a bunch of mpos files from
% % sucessive movies taken without moving the stage and toe find the position
% % of invariant spots across all of the movies that plan is to then use this
% % possitions to find the traces that are the same in all the movies and
% % then concatenate the traces...That might take a day or two to implement.
% 
% 
% FinalPositionTable = [];
% for i=1:n
%     
%     
%     
%     
%     
% fid = fopen(char(filename(1,i)));
% Numberofmolecules = fread(fid,1,'int16')/2;
% PositionTable = zeros(Numberofmolecules,5);
% for i=1:Numberofmolecules
%     PositionTable(i,1) = i;
%     PositionTable(i,2) = fread(fid,1,'int16');
%     PositionTable(i,4) = fread(fid,1,'int16');%every second x-coordinates is for "acceptor side"
% end
% for i=1:Numberofmolecules %this is saving the y-coordinate
%     PositionTable(i,3) = fread(fid,1,'int16');
%     PositionTable(i,5) = fread(fid,1,'int16');
% end
% 
% FinalPositionTable = [FinalPositionTable;PositionTable];
% 
% end
% 
% SotredFinalPositionTable = sortrows(FinalPositionTable,[2,3]);
% SizePositionTablesize = size(FinalPositionTable,1);
% 
% 
% % the following code concilidates all the tables into a final list
% 
% FinalConsolidated = [];
% 
% i = 1;
% 
% while i <=SizePositionTablesize
%     
%     consolidated = SotredFinalPositionTable(i,:);
%     
%     PositionSensitivity = 1; % this is the sensitiviy for picking point locations
% 
%     
%     if abs(SotredFinalPositionTable(i,[2 3])-SotredFinalPositionTable(i+1,[2 3]))<=PositionSensitivity;
%       
%     consolidated = [consolidated ; SotredFinalPositionTable(i+1,:)];
%     i=i+1;
%     
%     else i==SizePositionTablesize;
%     end
%     
%     
%     
%     
%         
%         if size(consolidated,1)> 1
%         tempconsolidated = mean(consolidated);
%         consolidated = [];
%         i=i+1;
%         else
%         tempconsolidated = consolidated;
%         consolidated = [];
%         i=i+1;
%         end    
%         
%         FinalConsolidated = [FinalConsolidated ; tempconsolidated];
% 
% end
%    
% i=1;
% newname=[];
% for i=1:n
%      
% tempfilename= char(filename(1,i));
% m=findstr(tempfilename,'.');
% newname=[newname tempfilename(1:m-1)];
% 
% end 
%  
% 
% newfilename = strcat(newname, 'mpos', '.dat');
% fid2 = fopen(newfilename, 'wb');
% fprintf(fid2,'%d %4.1f %4.1f %4.1f %4.1f\n',PositionTable');
% fclose(fid);
% output=1;
% fclose(fid2);