try
    clear all;
    
    % open window
    Screen('Preference', 'SkipSyncTests', 1);
    [window_ptr, screen_dimensions] = Screen(0,'OpenWindow',[0,0,0]);
    
    % define keys
    KbName('UnifyKeyNames');
    esc_key = KbName('Escape');
    EXIT = 0;
        %up/down control eccentricity by increments of 5 pixels radius
        up_key = KbName('UpArrow');
        down_key = KbName('DownArrow');
        %left/right control target size by increments of 2 pixels radius;
        left_key = KbName('LeftArrow');
        right_key = KbName('RightArrow');
        %+/- controls speed by increments of .001 seconds
        plus_key = KbName('q');
        minus_key = KbName('a');

    
    % get center of screen
    center = [screen_dimensions(3)/2,screen_dimensions(4)/2];
    center_x = center(1);
    center_y = center(2);

    % define color, circle radius and more
    eccentricity = center_x/2;
    radius_of_target = 10;
    [color_tmp luminance_tmp] = tablemaker();
    color = color_tmp(1,:);
    luminance = luminance_tmp(1,:);
    
    % loop until esc key is pressed
    tic;
    start_val = 0;
    turns = 0;
    
    %initialize wait time so that it can be variated
    pause = 0.015;
    pause_inc = 1;
    pause_array(pause_inc) = pause;
    
    while ~EXIT && toc<30

        % turn wheel by 15 degrees each time we redraw it. 
        start_val = start_val + 15;
        x = start_val;
        turns = turns + 1;

        % display each color
        for col = 1:12
            % generate object rectabgle
            center_t_x = center_x + eccentricity * cosd(-x);
            center_t_y = center_y + -1*(eccentricity * sind(-x));
            target_x_min = center_t_x - radius_of_target;
            target_x_max = center_t_x + radius_of_target;
            target_y_min = center_t_y - radius_of_target;
            target_y_max = center_t_y + radius_of_target;
            coords = [target_x_min,target_y_min,target_x_max,target_y_max];

            % draw circles
            if mod(turns+col,12) == 0
                col2 = 12;
            else
                col2 = mod(turns+col,12);
            end
            Screen(window_ptr,'FillOval', ...
                colorreturn(color(col),luminance(col2)),coords);

            % increment angle
            x = x + 30;
        end

        % display flip    
        Screen(window_ptr,'Flip');
        WaitSecs(pause);

        % get keyboard
        [keyIsDown, secs, keyCode] = KbCheck;
        if (keyCode(esc_key))
            EXIT = 1;
            break;
        end
        if(keyCode(up_key))
            eccentricity = eccentricity + 5;
        end
        if(keyCode(down_key)&&eccentricity>20)
            eccentricity = eccentricity - 5;
        end
        if(keyCode(left_key)&&radius_of_target>5)
            radius_of_target = radius_of_target - 2;
        end
        if(keyCode(right_key))
            radius_of_target = radius_of_target + 2;
        end
        if(keyCode(plus_key) && pause >.01)
            pause = pause-.001;
        end
        if(keyCode(minus_key) && pause < 1)
            pause = pause + .001;
        end
        pause_inc = pause_inc + 1;
        pause_array(pause_inc) = pause;
        %pause=pause+.01;

        
            
    end
    
    clear Screen;
catch
    clear Screen
    disp(lasterr);
end