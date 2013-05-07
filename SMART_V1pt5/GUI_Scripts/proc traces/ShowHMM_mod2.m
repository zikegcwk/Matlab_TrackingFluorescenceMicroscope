function ShowHMM_mod2(A,cimatrix,discStates,cax)
%shows HMM graphically, emission matrix E can be cell array or matrix  
nStates = size(A,1);



secsize = 2*pi/nStates;

circle_stat = [];
for i=1:nStates
circle_stat = [circle_stat; [cos(secsize*i) sin(secsize*i) ]];
end
circle_stat(:,1);

%axes(cax);
offset = 0.01;

for i = 1:nStates,
    for j = 1:nStates,
        if i~=j,
            if A(i,j) ~=0
            
           if mod(i,2)
           %a1 =  arrow([circle_stat(i,1)+offset*j circle_stat(i,2)],[circle_stat(j,1) circle_stat(j,2)+offset*j]);
           a1 =  arrow([circle_stat(i,1)-offset*j circle_stat(i,2)],[circle_stat(j,1)-offset*j circle_stat(j,2)]);
           
           else
           %a1 =  arrow([circle_stat(i,1)-offset*j circle_stat(i,2)],[circle_stat(j,1) circle_stat(j,2)+offset*j]); 
           a1 =  arrow([circle_stat(i,1)+offset*j circle_stat(i,2)],[circle_stat(j,1)+offset*j circle_stat(j,2)]);
           
           end
           
           
           if cimatrix{i,j} == 0
              set(a1,'EdgeColor','None','FaceColor','None')    
           end
           
           
           if cimatrix{i,j} == 2
              set(a1,'EdgeColor','g','FaceColor','g')    
           end
           
           end
            
        end
    end
end
hold(cax,'on')
%s1 = scatter(cax, circle_stat(:,1),circle_stat(:,2),ones(size(circle_stat(:,2)))*100);


state_type = ShorterToLonger_DS(discStates);
unique_states = size(unique(state_type),2);
temp_color = varycolor(unique_states);


if max(state_type) <= unique_states
for i=1:nStates

s1 = scatter(cax, circle_stat(i,1),circle_stat(i,2),state_type(i)'*100);
set(s1,'MarkerEdgeColor',temp_color(state_type(i),:),'MarkerFaceColor',temp_color(state_type(i),:))
%set(x1,'
end
else
    
    disp('max discStates must be less than the numbe of unique states')
end
xlim([-1.1 1.1]);
ylim([-1.1 1.1]);
set(cax,'xtick', [],'ytick',[],'box','on')





% 
% %get state lifetimes
% lifetimes = 1./(1 - diag(A));
% 
% %set plot parameters  
% stateCircR = 0.2;  
% stateCircCent = [0.8 ; 0.5];
% maxStateBoxEdge = 0.1;
% minStateBoxEdge = 0.05;
% stateBoxEdgeLengths = (lifetimes).*maxStateBoxEdge./max((lifetimes));
% maxArrowWidth = 1;
% minArrowWidth = 2;
% allDispVector = [0 ; 0];
% figureColor = [1 1 1].*0.9;
% 
% %get positions of states and arrows on circle
% stateBoxPositions = zeros(nStates,2); %x and y positions of state boxes  
% arrowStatePositions = zeros(nStates,nStates,4);
% stateColors = zeros(nStates,3);
% lineWidths = zeros(nStates,nStates);
% deltaTheta = 2*pi/nStates;
% thetaPhase = pi;
% for i = 1:nStates,
%     stateBoxPositions(i,1) = stateCircCent(1) + 1.5 * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);
%     stateBoxPositions(i,2) = stateCircCent(2) + 1.5 * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
% end
% 
% 
% for i = 1:nStates,
%     for j = 1:nStates,
%         if i~=j,
%             if colored,
%                 arrowScale = 1.5;
%             else            
%                 arrowScale = 1.2;
%             end
%             arrowStatePositions(i,j,1) = stateCircCent(1) + arrowScale * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);% + 0.1 * stateCircR*
%             arrowStatePositions(i,j,2) = stateCircCent(2) + arrowScale * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
%       
%             if i > j,
%                 s = -0.1;
%             else
%                 s = 0.1;
%             end
%             arrowStatePositions(i,j,3) = stateCircCent(1) + arrowScale * stateCircR*cos((j-1)*deltaTheta+thetaPhase) + allDispVector(1);
%             arrowStatePositions(i,j,4) = stateCircCent(2) + arrowScale * stateCircR*sin((j-1)*deltaTheta+thetaPhase) + allDispVector(2);
%         
%             dispVector = s*1*stateCircR.*[cos((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase) sin((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase)];
%             arrowStatePositions(i,j,1) = arrowStatePositions(i,j,1) + dispVector(1) + allDispVector(1);
%             arrowStatePositions(i,j,2) = arrowStatePositions(i,j,2) + dispVector(2) + allDispVector(2);
%             arrowStatePositions(i,j,3) = arrowStatePositions(i,j,3) + dispVector(1) + allDispVector(1);
%             arrowStatePositions(i,j,4) = arrowStatePositions(i,j,4) + dispVector(2) + allDispVector(2);
%             
%             %shorten arrows by 0.9
%             
%         end
%     end
% end
% %figure
% 
% for i = 1:nStates,
%     for j = 1:nStates,
%         if i~=j, %do not show transitions back to state  
%                 
%             
% %           arrow(cax, [arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)])
%           annotation('arrow',[arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)],...
%                    'HeadStyle','plain','HeadWidth',4,'LineWidth',1);
% 
%         end
%     end
% end
% % stateColors
% %position states around circle
% for i = 1:nStates,  
% %     if colored,
% %         bColor = stateColors(i,:);
% %     else
%         bColor = [1 1 1].*0.9;
%  %   end
%     annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
%         'BackgroundColor',bColor.*0.9);
%     annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
%         'BackgroundColor','none','EdgeColor','none','Color',[0 0 0],'String',num2str(i),...
%         'HorizontalAlignment','Center','VerticalAlignment','Middle');
% end

%set(gcf,'Color','w');

%set(gcf,'Position',[1261         694         275         211])

