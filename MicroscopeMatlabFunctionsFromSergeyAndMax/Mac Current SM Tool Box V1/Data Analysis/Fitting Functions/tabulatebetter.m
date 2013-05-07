function table = tabulatebetter(x)
%TABULATE Frequency table.
%   TABLE = TABULATE(X) takes a vector X and returns a matrix, TABLE.
%   The first column of TABLE contains the unique values of X.  The
%   second is the number of instances of each value.  The last column
%   contains the percentage of each value.
%
%   TABLE = TABULATE(X), where X is a character array or a cell array
%   of strings, returns TABLE as a cell array.  The first column
%   contains the unique string values in X, and the other two columns
%   are as above.
%
%   TABULATE with no output arguments returns a formatted table
%   in the command window.
%
%   See also PARETO.
   
%   Copyright 1993-2004 The MathWorks, Inc. 
%   $Revision: 2.12.4.2 $  $Date: 2003/11/24 23:24:45 $

isnum = isnumeric(x);
if isnum
   if min(size(x)) > 1,
      error('stats:tabulate:InvalidData','Requires a vector input.');
   end

   y = x(~isnan(x));
else
   y = x;
end

if ~isnum || any(y ~= round(y)) || any(y < 1);
   docell = true;
   [y,yn] = grp2idxgrp2idx(y);
   maxlevels = length(yn);
   
   %%fix yn
%    yn = {1:1:maxlevels}
   %%end fix
else
   docell = false;
   maxlevels = max(y);
   %yn = cellstr(num2str((1:maxlevels)'));
end
docell;
%add in values for zero.
% % y = [0.1:0.1:maxlevels];
%hope that worked

 [counts values] = hist(y,(1:maxlevels));
% [counts values] = hist(y,maxlevels);
counts = [0 counts];
values = [0 values];

total = sum(counts);
percents = 100*counts./total;
totalcounts = counts;            

for j=1:maxlevels
            totalcounts(j) = sum(counts(1:j))/total;
end                 
% totalcounts


if nargout == 0
   if docell
      width = max(cellfun('length',yn));
      width = max(5, min(50, width));
   else
      width = 5;
   end
   
   % Create format strings similar to:   '  %5s    %5d    %6.2f%%\n'
   fmt1 = sprintf('  %%%ds    %%5d    %%6.2f%%%% %%5d\n',width);
   fmt2 = sprintf('  %%%ds    %%5s   %%6s    %%5s\n',width);
   fprintf(1,fmt2,'Value','Count','Percent','Sum');
   if docell
      for j=1:maxlevels
         fprintf(1,fmt1,yn{j},counts(j),percents(j),totalcounts(j));
      end
   else
      fprintf(1,'  %5d    %5d    %6.2f%%\n',[values' counts' percents' totalcounts']');
   end
else
   if ~docell
      table = [values' counts' percents' totalcounts'];
   elseif isnum
yyn=str2num(char(yn{:}));
% yyn = cell2mat(yn)
       yyn = [0 yyn'];
       table = [yyn' counts' percents' totalcounts'];

%             table = [str2num(char(yn{:})) counts' percents' totalcounts'];

   else
       yn = [0 yn];
      table = [yn num2cell([counts' percents' totalcounts'])];
   end
end
