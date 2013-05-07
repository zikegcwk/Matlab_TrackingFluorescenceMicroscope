function [Donor_pk,std_Donor_pk,Acceptor_pk,std_Acceptor_pk,Number_D_pk,std_D_pk,Number_A_pk,std_A_pk,efficiency,std_efficiency]=folder_fret(directory,level)

cd(directory)

% for j=1:1:100
%     Combine_APDs(j,j+100);
% end

fret_e=zeros(98,1);
std_fret_e=zeros(98,1);
D_pk=zeros(98,1);
std_D_pk=zeros(98,1);
A_pk=zeros(98,1);
std_A_pk=zeros(98,1);
ND=zeros(98,1);
std_ND=zeros(98,1);

NA=zeros(98,1);
std_NA=zeros(98,1);

D=cell(98,1);
A=cell(98,1);
E=cell(98,1);


for j=1:1:98
    
    %get the donor/acceptor peak count, and fret efficiency from each
    %individual data file.
    disp(directory);
    [D{j},A{j},E{j}]=FRET_calculator_boss(j+100,2.5e-4,level);
    
    %calculate the fret e in one data file
    fret_e(j)=mean(E{j});
    std_fret_e(j)=std(E{j});
    
    D_pk(j)=mean(D{j});
    std_D_pk(j)=std(D{j});
    
    A_pk(j)=mean(A{j});
    std_A_pk(j)=std(A{j});
    
    %calculate the number of peaks 
    ND(j)=length(D{j});
    std_ND(j)=std(D{j});
    
    NA(j)=length(A{j});
    std_NA(j)=std(A{j});
    
    
end

efficiency=mean(fret_e);
std_efficiency=(sum(std_fret_e.^2)/length(std_fret_e)^2)^0.5;

Acceptor_pk=mean(A_pk);
std_Acceptor_pk=(sum(std_A_pk.^2)/length(std_A_pk)^2)^0.5;

Donor_pk=mean(D_pk);
std_Donor_pk=(sum(std_D_pk.^2)/length(std_D_pk)^2)^0.5;

Number_D_pk=mean(ND);
std_D_pk=(sum(std_ND.^2)/length(std_ND)^2)^0.5;


Number_A_pk=mean(NA);
std_A_pk=(sum(std_NA.^2)/length(std_NA)^2)^0.5;