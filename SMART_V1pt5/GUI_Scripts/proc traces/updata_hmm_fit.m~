function updata_hmm_fit(handles)






%get(handles.uitable1,'Data')
handles.table_spec.user_table2{1,2} = 1;
proc_spec = process_spec(handles);
nStates = proc_spec.params.nStates;

%A = ones(nStates,nStates)
A = ones(nStates, nStates);
%gca()

%A(1,2)=2
%A(1,3)=2


% cimatrix = mat2cell(zeros(nStates,nStates), ones(nStates,1)', ones(nStates,1)');
% cimatrix(1:4,1:4) = handles.table_spec.user_table1(22:25,2:5);
% cimatrix{1,1} = 0; 
% cimatrix{2,2} = 0;
% cimatrix{3,3} = 0;
% cimatrix{4,4} = 0;
% 
% cimatrix = cell2mat(cimatrix)*2;


cimatrix =  handles.table_spec.user_table1(15:24,2:11);



%proc_spec.params.discStates



ShowHMM_mod2(A,cimatrix,proc_spec.params.discStates,handles.axes1)




