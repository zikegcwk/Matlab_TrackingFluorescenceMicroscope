function figs2tex(figs,filename,keepfigs)
totalWidth=170;

[nr,nc]=size(figs);
cdir=pwd;
if nargin==2 
    keepfigs=1;
end

if ispc, % Make sure the right directory is chosen if using Windows vs. Linux
    figsDir='.\figures';
else 
    figsDir='./figures';
end

if exist(figsDir,'dir')
    cd(figsDir)
else
    display(sprintf('Creating directory %s',figsDir));
    mkdir(figsDir)
    cd(figsDir)
end

%find where to start numerotation of files
files=dir('fig_*.pdf');
file_start=0;
if not(isempty(files))
    filesnamesCell=struct2cell(files);
    [a,n]=size(filesnamesCell);
    M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(5:end-4));
    end
    file_start=max(M);
end

filename2=filename;
if ~strcmp(filename(end-3:end),'.tex')
filename2=strcat(filename,'.tex');
end
fid = fopen(filename2,'w');
fprintf(fid,'\\documentclass[11pt, oneside]{paper}\n');
fprintf(fid,'\\usepackage{graphicx}\n');
fprintf(fid,'\\usepackage{amsmath}\n');
fprintf(fid,'\\usepackage[T1]{fontenc}\n');
fprintf(fid,'\\usepackage[latin1]{inputenc}\n');
fprintf(fid,'\\usepackage[top=2cm, bottom=2cm, left=1cm, right=1cm]{geometry}\n');
fprintf(fid,'\\usepackage{longtable}');
fprintf(fid,'\\pagestyle{empty}');
fprintf(fid,'\\begin{document}\n');

s1='l';
s2='';
for i=1:nc
    s2=strcat(s2,s1);
end

cfignum=file_start;
fprintf(fid,'\\begin{longtable}{%s}\n',s2);
figWidth=floor(totalWidth/nc);
for i=1:nr
    for j=1:nc-1
        cfignum=cfignum+1;
        cfilename=sprintf('fig_%g.eps',cfignum);
        saveas(figs(i,j),cfilename,'psc2');
        cfilename2=sprintf('fig_%g.pdf',cfignum);
        fprintf(fid,'\\includegraphics[width=%gmm]{%s}&\n',figWidth,cfilename2);
    end
        cfignum=cfignum+1;
        cfilename=sprintf('fig_%g.eps',cfignum);
        saveas(figs(i,nc),cfilename,'psc2');
        cfilename2=sprintf('fig_%g.pdf',cfignum);
        fprintf(fid,'\\includegraphics[width=%gmm]{%s}\\\\\n',figWidth,cfilename2);
        if keepfigs
        cfilename3=sprintf('fig_%g.fig',cfignum);
        saveas(figs(i,nc),cfilename3);
        end
end
fprintf(fid,'\\end{longtable}\n');
fprintf(fid,'\\end{document}\n');
fclose(fid);
for i=file_start+1:cfignum
    cfilename=sprintf('fig_%g.eps',i);
    display(sprintf('Converting figure %s to pdf...',cfilename));
    Str=sprintf('epstopdf fig_%g.eps',i);
    dos(Str);
end
% display('Compiling latex file and creating pdf document...');
% Str=sprintf('pdflatex %s',filename2);
% dos(Str);


display('Erasing temporary files...')
if ~keepfigs
Str=sprintf('del %s.log %s.aux %s.tex',filename2(1:end-4),filename2(1:end-4),filename2(1:end-4));
dos(Str);
end

for i=file_start+1:cfignum
    cfilename=sprintf('fig_%g.eps',i);
    Str=sprintf('del %s',cfilename);
    dos(Str);
    if ~keepfigs
    cfilename2=sprintf('fig_%g.pdf',i);
    Str=sprintf('del %s',cfilename2);
    dos(Str);
    end
end
% display(sprintf('PDF document generated in %s.pdf',filename2(1:end-4))); 
cd(cdir);




