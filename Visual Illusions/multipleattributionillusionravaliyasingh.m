% Reverse Phi Illusion
% By Jay Ravaliya
% Department of Biomedical Engineering
% C/O Professor Thomas V. Papathomas

[window_ptr, screen_dimensions] = Screen(0,'OpenWindow',[0,0,0]);
center = [screen_dimensions(3)/2,screen_dimensions(4)/2];
center_x = center(1);
center_y = center(2);
 
eccentricity = center_x/2;
 
radius_of_target = 10;

%luminance direction = luminance
%color direction = color
%dark colors
red_dark = [40,0,0];%red = 1, dark = 0;
green_dark = [0,30,0];%green = 2;dark = 0;
blue_dark = [0,0,50]; %blue = 0, dark = 0
%moderate colors
red_moderate = [100,0,0];%red = 1, moderate = 1;
green_moderate = [0,75,0];%green = 2, moderate = 1;
blue_moderate = [0,0,125];%blue = 0; moderate = 1;
%light colors
red_light = [200,0,0];%red = 1; light = 2;
green_light = [0,150,0];%green = 2,light = 2;
blue_light = [0,0,255];%blue = 0; light = 2;

booldegree = 0;

tic
bool = 0;
color = [];
for i = 0:11
    count = 1;
    for j = bool:2:23
        color(i+1,count) = testing2(j+i,6)/2;
        count = count+1;
    end
    bool = abs(bool-1);
end

bool = 0;
luminance = [];
count = 1;
upbool = 22;
for i = 0:11
    count = 1;
    for j = upbool:-2:0
        luminance(i+1,count) = testing2(j-i,6)/2;
        count = count + 1;
    end
    bool = abs(bool-1);
    upbool = bool + 22;
end
luminance = fliplr(luminance);

start_val = 0;
count = 0;

z = 1;
while (toc < 35)
    for y = 1:12
        for x = start_val:30:360+start_val
            if(z > 12)
                z = 1;
            end
            center_t_x = center_x + eccentricity * cosd(-x);
            center_t_y = center_y + -1*(eccentricity * sind(-x));
            target_x_min = center_t_x - radius_of_target;
            target_x_max = center_t_x + radius_of_target;
            target_y_min = center_t_y - radius_of_target;
            target_y_max = center_t_y + radius_of_target;
            coords = [target_x_min,target_y_min,target_x_max,target_y_max];
            
            if(color(y,z) == 0 && luminance(y,z) == 0)
                    Screen(window_ptr,'FillOval',blue_dark,coords);
                elseif(color(y,z) == 1 && luminance(y,z) == 0)
                    Screen(window_ptr,'FillOval',red_dark,coords);
                elseif(color(y,z) == 2 && luminance(y,z) == 0)
                    Screen(window_ptr,'FillOval',green_dark,coords);
                elseif(color(y,z) == 0 && luminance(y,z) == 1)
                    Screen(window_ptr,'FillOval',blue_moderate,coords);
                elseif(color(y,z) == 1 && luminance(y,z) == 1)
                    Screen(window_ptr,'FillOval',red_moderate,coords);
                elseif(color(y,z) == 2 && luminance(y,z) == 1)
                    Screen(window_ptr,'FillOval',green_moderate,coords);
                elseif(color(y,z) == 0 && luminance(y,z) == 2)
                    Screen(window_ptr,'FillOval',blue_light,coords);
                elseif(color(y,z) == 1 && luminance(y,z) == 2)
                    Screen(window_ptr,'FillOval',red_light,coords);
                elseif(color(y,z) == 2 && luminance(y,z) == 2)
                    Screen(window_ptr,'FillOval',green_light,coords);
            end
            
            z = z + 1;
            
            if(booldegree == 0)
                start_val = start_val + 15;
            elseif(booldegree == 1)
                start_val = start_val - 15;
            end
            booldegree = abs(booldegree - 1);
        end
        Screen(window_ptr,'Flip');
        WaitSecs(1);
    end
end
clear screen;
