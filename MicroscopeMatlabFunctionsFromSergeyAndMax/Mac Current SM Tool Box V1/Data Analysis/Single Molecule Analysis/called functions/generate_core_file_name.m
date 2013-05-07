function corefilename = generate_core_file_name(movienumbers,sequential_movies)

corefilename = {};

for i=1:size(movienumbers,2)
  
    
    
if sequential_movies == 0
   tempname =  strcat( 'cascade', num2str(movienumbers(i)),'(4).dat')
   corefilename = [corefilename;tempname];
else
    j=1;
    
   while j <= sequential_movies
   

   tempname = strcat( 'cascade', num2str(movienumbers(i)),'(', num2str(j),').dat');
   corefilename = [corefilename;tempname];
    
   j = j+1;
   
   end
   
end
    
end



