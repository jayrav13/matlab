function bool = matrixloc(in, loc)
%jayrav
%eschbach
r = loc(1);
c = loc(2);
A = zeros(9,9);
bool = false;
vect = zeros(1,81);
if(r <=3)
    if(c <=3)
        for x = 1:3
            for y = 1:3
                A(x,y) = in(x,y);
            end
        end
    end
    if (c > 3 && c <=6)
        for x = 1:3
            for y = 4:6
                A(x,y) = in(x,y);
            end
        end
    end
    if(c > 6 && c <=9)
        for x = 1:3
            for y = 7:9
                A(x,y) = in(x,y);
            end
        end
    end
end

if(r > 3 && r <=6)
    if(c <=3)
        for x = 4:6
            for y = 1:3
                A(x,y) = in(x,y);
            end
        end
    end
    if (c > 3 && c <=6)
        for x = 4:6
            for y = 4:6
                A(x,y) = in(x,y);
            end
        end
    end
    if (c > 6 && c <=9)
        for x = 4:6
            for y = 7:9
                A(x,y) = in(x,y);
            end
        end
    end
end

if(r > 6 && r <=9)
    if(c <=3)
        for x = 7:9
            for y = 1:3
                A(x,y) = in(x,y);
            end
        end
    end
    if (c > 3 && c <=6)
        for x = 7:9
            for y = 4:6
                A(x,y) = in(x,y);
            end
        end
    end
    if (c > 6 && c <=9)
        for x = 7:9
            for y = 7:9
                A(x,y) = in(x,y);
            end
        end
    end
end

vect = A(:);
%bool = A;

if(contains(vect,in(r,c)) == true)
    bool = true;
end