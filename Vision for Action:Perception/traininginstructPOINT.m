% ==================================
% traininginstruct.m
% A program created to display trial conditions to the
% administrator during each training trial.
% by Jay H. Ravaliya
% ==================================

function parameters = traininginstructPOINT(vec)
parameter1 = vec(1);
parameter2 = vec(2);
parameter3 = vec(3);

if(parameter1 == 1)
    if(parameter2 == 1)
        if(parameter3 == 1)
            parameters = 'Fast, Point, Midline Away - 2';
        elseif(parameter3 == 2)
            parameters = 'Fast, Point, Midline Towards - 1';
        end
    elseif(parameter2 == 2)
        if(parameter3 == 1)
            parameters = 'Fast, Point, Midline Away - 2';
        elseif(parameter3 == 2)
            parameters = 'Fast, Point, Midline Towards - 1';
        end
    end
elseif(parameter1 == 2)
    if(parameter2 == 1)
        if(parameter3 == 1)
            parameters = 'Slow, Point, Midline Away - 2';
        elseif(parameter3 == 2)
            parameters = 'Slow, Point, Midline Towards - 1';
        end
    elseif(parameter2 == 2)
        if(parameter3 == 1)
            parameters = 'Slow, Point, Midline Away - 2';
        elseif(parameter3 == 2)
            parameters = 'Slow, Point, Midline Towards - 1';
        end
    end
end
    
        
