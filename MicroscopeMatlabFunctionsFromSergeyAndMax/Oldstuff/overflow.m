 %Text file printing of highest value
    if get(handles.checkbox5,'Value')==1
      file=strrep(handles.filename,'.pma','.txt');
    end
    
    if get(handles.checkbox6,'Value')==1
        file=strrep(handles.filename,'.pmb','.txt');
    end
    
    
    j=0;
       
    outputfile=fopen(file,'w');
    
    for i=1:m_number,             
        if overlap(i)==0
            j=j+1;
            x(2*j-1)=tempx(i);         
            y(2*j-1)=tempy(i);
            
            %apply offset and find local maximum
            x(2*j)=tempx(i)+result(2)/2+handles.xoffset;                    
            y(2*j)=tempy(i)+handles.yoffset;
            temp=handles.movie_all(y(2*j)-1:y(2*j)+1,x(2*j)-1:x(2*j)+1,(start_locate_don));
            %[maxy, maxx]=find(temp==max(max(max(max(temp)))))   %error happens if there are 2 values when temp==max(temp)?
            maxy=2;  % inserted here because line above gives trouble need to fix later
            maxx=2; % inserted here because line above gives trouble need to fix later
            
            x(2*j)=x(2*j)+maxx-2;
            y(2*j)=y(2*j)+maxy-2;
            donor_points(j,:)=[x(2*j-1) y(2*j-1)];
            acceptor_points(j,:)=[x(2*j) y(2*j)];
            value=0;
                       
            %This block adds 5x5 around located spot and then prints to a
            %file the values for histograms.
            for min_x=tempx(i)-2:tempx(i)+2
              for min_y=tempy(i)-2:tempy(i)+2
                handles.movie_all(min_y,min_x,(start_locate_don));
                value=value+handles.movie_all(min_y,min_x,(start_locate_don));
              end
            end
            
     
            fprintf(outputfile,'%f\n',value);
            
        end
    end
    fclose(outputfile);
    