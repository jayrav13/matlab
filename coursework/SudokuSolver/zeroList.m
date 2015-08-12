 function out = zeroList(in)
%jayrav
%eschbach
out = [];
count = 0;
[r c] = size(in);
for x = 1:r
    for y = 1:c
        if(in(x,y) == 0)
            count = count + 1;
            out(count, 1) = x;
            out(count, 2) = y;
        end
    end
end

%toc