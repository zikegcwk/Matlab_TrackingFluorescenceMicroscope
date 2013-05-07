display('Processing rnaMax_OG7');
cd w:\data\2008\090108\rnaMax\rnaMax_OG7
[tau,gss,ncounts]=processDataSet(1:30,{[1,2],[3,4],[1,3]},-8,0,300); 
save('rnaMax_OG7_1to30.mat','tau','gss','ncounts');
display('Processing T20...');
cd w:\data\2008\090108\rnaMax\maxBuffer
[tau,gss,ncounts]=processDataSet(1:27,{[1,2],[3,4],[1,3]},-8,0,300);
save('maxBuffer_1to27.mat','tau','gss','ncounts');
display('Processing rnaMax_OG7');
cd w:\data\2008\090108\rnaMax
[tau,gss,ncounts]=processDataSet(1:27,{[1,2],[3,4],[1,3]},-8,0,300); 
save('rnaMax_50mMNaCl2_1to27.mat','tau','gss','ncounts');




