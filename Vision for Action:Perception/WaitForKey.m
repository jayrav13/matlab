function WaitForKey()
    % wait for input
    while(1)
        [keyIsDown,timeSecs,keyCode] = KbCheck;
        if keyIsDown
            % wait for key release
            while(1)
                [keyIsDown,timeSecs,keyCode] = KbCheck;
                if ~keyIsDown
                    break;
                end
            end
            break;
        end
    end
end