function  output_args  = threshold_std( temptrace,th_param )
%UNTITLED Summary of this function goes here
%   This is max's attept at creating a better thresholding function



fret = temptrace(:,3);
left  = 1;
right = size(fret,1);

thresh = mean([th_param(1) th_param(2)]);

xdata = 1:size(fret,1);

% Taken from Update_Kinetics.m in the standard gui_trace_viewer
% xlim=get(handles.axes2,'XLim');
% xdata=get(handles.fret,'XData');
% ydata=get(handles.fret,'YData');
% 
% left=min(find(xdata >= xlim(1)));
% right=max(find(xdata <= xlim(2)));
% fret = ydata(left:right);


%       ORIGiNAL
%             handles.high_index = find( ydata(left:right)>= handles.high_th) + left - 1;
%             handles.medium_index = find(ydata(left:right) >= handles.low_th & fret < handles.high_th) + left - 1;
%             handles.low_index = find(ydata(left:right) < handles.low_th) + left - 1;

high_index = find( fret(left:right)>= thresh) + left - 1;
%        handles.medium_index = find(ydata(left:right) >= handles.low_th & fret < handles.high_th) + left - 1;
low_index = find(fret(left:right) < thresh) + left - 1;

%       ORIGNIAL
%             handles.high_value = mean(ydata(handles.high_index));
%             handles.medium_value = mean(ydata(handles.medium_index));
%             handles.low_value = mean(ydata(handles.low_index));
test = fret(high_index);
test = sum(test);
if test<0.0001
    high_value = 0.8;
else
    high_value = mean(fret(high_index));
end
%             handles.medium_value = mean(ydata(handles.medium_index));
% keep getting a divide by zero error message if this index is empty.
% so to fix:
test = fret(low_index);
test = sum(test);
if test<0.0001
    low_value = 0.1;
else
    
low_value = mean(fret(low_index));
end

temp = zeros(length(xdata),1);
temp(low_index) = low_value;
%   bernie, commented out
%       temp(handles.medium_index) = handles.medium_value;

temp(high_index) = high_value;


tempy = temp;



templevel = tempy;
temp_a = find(templevel>0.5);
templevel(temp_a )=3;
temp_a  = find(templevel<0.5);
templevel(temp_a)=0;


%set(handles.kinetics,'YData',temp);
% if exist('text9')==1
    %set(handles.text9,'String',num2str(handles.high_value));
% end




A=zeros(1,5);
% bernie took out high_th
%B=[handles.m handles.average left right handles.low_th handles.high_th];
%B=[handles.m handles.average left right handles.low_th];
j=0;

%Added by max to dump deliniated FRET histograms and deleniated traces      
        
%choose to keep first and last dwell?
        

%drop first and last dewll 
%firstdwell =2;
%lastdwell =1;

k=left;

 %use these linesd to keep the last dwell
firstdwell = 1;
lastdwell = 0;

%for i=left:right-lastdwell,
       
tcheck=0;
for i=left:right-1,
     tempy(i);
        tempy(i+1);
    tcheck = tcheck+1;
    if tempy(i)~=tempy(i+1)
        
       
        j=j+1 ;
        lifetime=i+1-k;
        meanfret=mean(fret(k:i));
        A(j,:) = [templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i),i];
%        fprintf(tempfid,'%d %d %4.3f %d\n',templevel(i),lifetime,meanfret,templevel(i+1)-templevel(i));  
        k=i+1;
        tcheck=0;
    end
end


% To Make the format the same for all the traces
A(:,5)=[];
 A(:,3)=NaN; 

output_args = A;


