% ==================================
% dername.m
% A program created to extract the configuration file name
% to be used for the creation of the data file.
% Ex. config.xls --> 'config' --> config.txt
% by Jay H. Ravaliya
% ==================================
%dername
function adj_name = dername(orig_name)
loc = 1;
tr = 0;
adj_name='';
for x = 1:length(orig_name)
    if(orig_name(x) == '.')
        loc = x - 1;
        tr = 1;
        break;
    end
end
for y = 1:loc
    adj_name(y) = orig_name(y);
end
if(tr == 0)
    adj_name = orig_name;
end