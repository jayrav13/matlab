% ==================================
% validate.m
% A program created to ensure that 1) user entry is a number and that
% 2) if it is a number, that the number corresponds to an entry choice:
% 1 - Target 1 was closer.
% 2 - Target 2 was closer.
% 3 - Trial was a failure; save for future completion.
% by Jay H. Ravaliya
% ==================================
function tf = validate(entry)
entry = str2num(entry);
if(entry > 0)
    if(entry < 4)
        tf = 1;
    else
        tf = 0;
    end
else
    tf = 0;
end
