function corefilename = generate_file_name(movienumbers,sequential_movies,file_type)

corefilename = {};


for i=1:size(movienumbers,2)
  
    
    
%if sequential_movies == 0
 
%  tempname =  strcat( 'cascade', num2str(movienumbers(i)),'(4).dat');
%else
    j=sequential_movies(1);
    
   while j <= sequential_movies(2)
   
   switch file_type
       case '(raw)cascade'
           
           tempname = strcat( '(raw)cascade', num2str(movienumbers(i)),'(', num2str(j),').dat');
           
       case '.mtrace'
           tempname = strcat( 'cascade', num2str(movienumbers(i)),'(', num2str(j),').mtrace');
           
       case '.tracesp'
           tempname = strcat( 'cascade', num2str(movienumbers(i)),'(', num2str(j),').tracesp');
           
       case '.traces'
           tempname = strcat( 'movie', num2str(movienumbers(i)),'(', num2str(j),').traces');
           
   end
   
   corefilename = cat(1, corefilename, [{tempname} {movienumbers(i)} {j}]);
   
   j = j+1;
   
   end
   
end
    
end



