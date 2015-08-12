% ==================================
% trialinstruct.m
% A program created to display trial conditions to the
% administrator during each main trial.
% by Jay H. Ravaliya
% ==================================
% motion: reach vs grab
%   1 == reach
%   2 == grab
% stimuli: properspective vs reverspective -- illusionary vs
%              reverspective -- veridical
%   1 == properspective
%   2 == reverspective -- illusionary
%   3 == reverslective -- veridical
% speed: fast vs slow
%   1 == slow
%   2 == fast
function parameters = trialsinstruct(vec)
parameter1 = vec(1);
parameter2 = vec(2);
parameter3 = vec(3);

if(parameter1 == 1)
    if(parameter2 == 1)
        if(parameter3 == 1)
            parameters = 'Reach; Properspective; Slow';
        elseif(parameter3 == 2)
            parameters = 'Reach; Properspective; Fast';
        end
    elseif(parameter2 == 2)
        if(parameter3 == 1)
            parameters = 'Reach; Reverspective -- Illusionary; Slow';
        elseif(parameter3 == 2)
            parameters = 'Reach; Reverspective -- Illusionary; Fast';
        end
    elseif(parameter2 == 3)
        if(parameter3 == 1)
            parameters = 'Reach; Reverspective -- Veridical; Slow';
        elseif(parameter3 == 2)
            parameters = 'Reach; Reverspective - Veridical; Fast';
        end
    end
elseif(parameter1 == 2)
    if(parameter2 == 1)
        if(parameter3 == 1)
            parameters = 'Grab; Properspective; Slow';
        elseif(parameter3 == 2)
            parameters = 'Grab; Properspective; Fast';
        end
    elseif(parameter2 == 2)
        if(parameter3 == 1)
            parameters = 'Grab; Reverspective -- Illusionary; Slow';
        elseif(parameter3 == 2)
            parameters = 'Grab; Reverspective -- Illusionary; Fast';
        end
    elseif(parameter2 == 3)
        if(parameter3 == 1)
            parameters = 'Grab; Reverspective -- Veridical; Slow';
        elseif(parameter3 == 2)
            parameters = 'Grab; Reverspective -- Veridical; Fast';
        end
    end
end