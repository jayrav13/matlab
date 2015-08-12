% Reverse Phi Illusion
% By Jay Ravaliya
% Department of Biomedical Engineering
% C/O Professor Thomas V. Papathomas

clear all;
which_screen = 0;

bool = 1;
tbool = 1;

count_break = 0;

contrast = 0.2; %number has to be below 1, 1 = 100%
contrast_num = 256*contrast;
contrast_num = contrast_num / 2;
dim_color = 128-contrast_num;
bright_color = 128+contrast_num;

[window_ptr, screen_dimensions] = Screen(0,'OpenWindow',[128,128,128]);
center = [screen_dimensions(3)/2,screen_dimensions(4)/2];
center_x = center(1);
center_y = center(2);

eccentricity = center_x/2;

radius_of_target = 10;

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
        plus_key = KbName('+');
        minus_key = KbName('-');


tic

pause=.015;

start_val = 0;

pause_inc=1;
pause_array(pause_inc)=pause;

while(toc < 30)
    bool = abs(tbool - 1);
    tbool = bool;
        for x = start_val:45:360+start_val
            center_t_x = center_x + eccentricity * cosd(-x);
            center_t_y = center_y + -1*(eccentricity * sind(-x));
            target_x_min = center_t_x - radius_of_target;
            target_x_max = center_t_x + radius_of_target;
            target_y_min = center_t_y - radius_of_target;
            target_y_max = center_t_y + radius_of_target;
            coords = [target_x_min,target_y_min,target_x_max,target_y_max];
            if(bool == 1)
               Screen(window_ptr,'FillOval',[dim_color,dim_color,dim_color],coords);
            elseif(bool == 0)
                Screen(window_ptr,'FillOval',[bright_color,bright_color,bright_color],coords);
            end
        
            bool = abs(bool - 1);
            
              
        end
    Screen(window_ptr,'Flip');
    WaitSecs(pause);%selected default: 0.015
    start_val = start_val + 9;
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

clear screen;
