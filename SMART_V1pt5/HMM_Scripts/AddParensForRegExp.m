function string_with_parens = AddParensForRegExp(string)
%adds parentheses to denote groups of elements in a(r,c), e(n,c,p) string
curParens = 0; %open parens
string = ['{' string '}'];
if string(2) == '(',
    string(2) = [];
end
for i = length(string):-1:1,
    %count left and right parentheses
    if string(i) == ')',
        curParens = curParens + 1;
        if (curParens == 2),
            if (string(i+2) == '}'),
                string(i+1) = [];
            end
        end
    elseif string(i) == '(',
        curParens = curParens - 1;
    end

    
    if (string(i) == ',') && (curParens == 0),
        if string(i+1) == '(',
            string(i+1) = [];
        end
        string = [string(1:i-1) '},{' string(i+1:end)]; 
        
    end
end
string_with_parens = string;