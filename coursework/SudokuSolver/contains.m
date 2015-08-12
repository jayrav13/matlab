 function out = contains(vect, num)
%jayrav
%eschbach
out = 0;
count = 0;
for x = 1:length(vect)
    if(num == vect(x))
        count = count + 1;
    end
end
if(count > 1)
    out = 1;
end
end