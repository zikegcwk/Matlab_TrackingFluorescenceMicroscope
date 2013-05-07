function output = mpostotable(filename)
fid = fopen(filename);
Numberofmolecules = fread(fid,1,'int16')/2;
PositionTable = zeros(Numberofmolecules,5);
for i=1:Numberofmolecules
    PositionTable(i,1) = i;
    PositionTable(i,2) = fread(fid,1,'int16');
    PositionTable(i,4) = fread(fid,1,'int16');%every second x-coordinates is for "acceptor side"
end
for i=1:Numberofmolecules %this is saving the y-coordinate
    PositionTable(i,3) = fread(fid,1,'int16');
    PositionTable(i,5) = fread(fid,1,'int16');
end
m=findstr(filename,'.');
newname=filename(1:m-1);
newfilename = strcat(newname, 'mpos', '.dat');
fid2 = fopen(newfilename, 'wb');
fprintf(fid2,'%d %4.1f %4.1f %4.1f %4.1f\n',PositionTable');
fclose(fid);
output=1;
fclose(fid2);