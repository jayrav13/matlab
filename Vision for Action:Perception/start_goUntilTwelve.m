% =========================================================================
% ---
% by Hristiyan Kourtev, RuCCS, Rutgers University
% 6/12/2010
% =========================================================================
%
% Modified by Jay Ravaliya
%
% =========================================================================

%clear all data
clear all;
close all;
%blank variable used for enter key
blank = ' ';
%arduino connected vs. debugging
debug = 1;
if(debug == 0)
    a = arduino('COM3');
    a.pinMode(13,'output');
    a.digitalWrite(13,1);
end
%try
% ====================== general experiment parameters ====================

% ----------------- get subject info -----------------
% get config file
[configFileName, pathName] = uigetfile('*.xls*', 'Select a config file for this experiment.');
[num, txt, raw] = xlsread(fullfile(pathName, configFileName));
%set configuration file name equal to data file name
subj_id = dername(configFileName);
% -------- parse trial variables -------- %
trial_nums = 1:1:50;
trial_nums = trial_nums(:);
subj_age = num(1);
subj_dominant_eye = char(raw(2,2));
subj_dominant_hand = char(raw(3,2));
subj_stereopsis = char(raw(4,2));
subj_acuity = char(raw(5,2));
record_eyes = num(6);
relay_delays = ones(50,1)*num(7);
light_on_delays = ones(50,1)*num(8);
light_on_durs = ones(50,1)*num(9);
num_trials = length(trial_nums);
further_spot = [];
further_temp = '';
num_questions = '';
bunked = [];
temp_time = [];

% open file 
filename = ['data/', num2str(subj_id), '.txt'];
fid = fopen(filename, 'w');

% store general trial info
fprintf(fid, 'Subject ID = ''%s''\n', subj_id);
fprintf(fid, 'Subject Age = ''%d''\n', subj_age);
fprintf(fid, 'Subject''s Dominant Eye = ''%s''\n', subj_dominant_eye);
fprintf(fid, 'Subject''s Dominant Hand = ''%s''\n', subj_dominant_hand);
fprintf(fid, 'Subject''s Stereopsis Test Results = ''%s''\n', subj_stereopsis);
fprintf(fid, 'Subject''s Acuity = ''%s''\n', subj_acuity);
fprintf(fid, 'Subject''s Eye Tracker Status = ''%d''\n', record_eyes);
fprintf(fid, 'Stimuli Retraction Delay = ''%s'' second(s)\n', num2str(num(7)));
fprintf(fid, 'Light Delay = ''%s'' second(s)\n', num2str(num(8)));
fprintf(fid, 'Lights Off Delay = ''%s'' second(s)\n', num2str(num(9)));
fprintf(fid, '\n');
fprintf(fid, 'Additional Questions? ');

% intro
fprintf('Welcome to the Motor Visual experiment\n\n');

num_questions = ' ';
done = 0;
% additional questions
while(done == 0)
    num_questions = input('Please enter the number of additional questions you wish to ask the subject: ', 's');
    num_questions = strtrim(num_questions);
    if(numcheck(num_questions) == 1)
        done = 1;
    else
        done = 0;
    end
end
num_questions = str2num(num_questions);
fprintf(fid, 'Num Questions: %d\n',num_questions);
for x = 1:num_questions
    question = input('Enter question: ','s');
    question = strtrim(question);
    fprintf(fid, 'Question %d: %s\n',x,question);
    answer = input('Enter response: ','s');
    answer = strtrim(answer);
    fprintf(fid, 'Answer %d: %s\n',x,answer);
end

% ready to begin experiment
fprintf('Ready to begin session. This session has a total of %.0f trials.\n', num_trials);
blank = input('Press any key to start.');
fprintf(fid,'\n');
fprintf(fid, 'TIME STAMPS\n');
fprintf(fid,'pre-training trials\n');
fprintf(fid, 'ov_trial_#\tpr_trial_#\ttime\n');
disp('===================');
disp('PRE-TRAINING TRIALS');
disp('===================');
disp('There are two (2) Pre-Training Trials');
success = zeros(1,2);
while(sum(success) ~= 2)
    for m = 1:2
        if(success(m) == 0)
            further_spot(m) = 0;
            fprintf('Trial %d: ',m);
            blank = input('Ask subject to reach towards the center pole. Press enter to begin trial.','s');
            temp_time = fix(clock);
            if(debug == 0)
                temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
            end
            fprintf(fid, '%d\t\t%d\t\t%d/%d/%d, %d:%d:%d''\n',m,m, temp_time(2),temp_time(3),temp_time(1),temp_time(4),temp_time(5),temp_time(6));
            done = 0;
            while(done == 0)
                further_temp = input('Trial success or failure? 1 or 2 for success, 3 for failure: ','s');
                further_temp = strtrim(further_temp);
                [r c] = size(further_temp);
                if(r+c == 0)
                    further_temp = ' ';
                end
                if(validate(further_temp))
                    if(further_temp ~= '3')
                        success(m) = 1;
                        done = 1;
                    else
                        success(m) = 0;
                        done = 1;
                    end
                else
                    success(m) = 0;
                    done = 0;
                end
            end
        end
    end
    if(m~=2)
        blank = input('End of trial, reset and press enter.','s');
    end
end

blank = input('END OF PRE-TRAINING. ENTER TO CONTINUE');
disp('===============');
disp('TRAINING TRIALS');
disp('===============');
disp('There are eight (8) Training Trials.');
fprintf(fid, '\n');
fprintf(fid, 'training trials\n');
fprintf(fid, 'key:\n');
fprintf(fid, 'motion: 1 - reach, 2 - grab\n');
fprintf(fid, 'stimuli: 1 - midline away, 2 - midline towards\n');
fprintf(fid, 'ov_trial_#\ttr_trial_#\ttime\t\t\t\tmotion\tstimuli\tresult\tfurther\n');
fprintf(fid, '==========\t==========\t====\t\t\t\t=======\t======\t======\t=======\n');
blank = input('Enter to continue.');
fprintf('\n');
training_matrix = scramblertraining();
success = zeros(1,8);  
count = 1;
while(sum(success) ~= 8)
    for m=3:10
        current_m = m-2;
        if(success(current_m) == 0)
            current_scramble = training_matrix(current_m,:);
            instruct = traininginstruct(current_scramble(1),current_scramble(2));
            fprintf('Training Trial %.0f Parameters: %s\n', current_m, instruct);
            blank = input('Press enter to begin trial\n','s');
            temp_time = fix(clock);
            if(debug == 0)
                temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
            end
            done = 0;
            while(done == 0)
                further_temp = input('Which is further? 1 or 2? (enter: 1 or 2; 3 for fail): ','s');
                further_temp = strtrim(further_temp);
                [r c] = size(further_temp);
                if(r+c == 0)
                    further_temp = ' ';
                end
                if(validate(further_temp))
                    if(further_temp ~= '3')
                        success(current_m) = 1;
                        status = 'succ';
                        done = 1;
                        further_spot(m) = str2num(further_temp);
                    else
                        success(current_m) = 0;
                        status = 'fail';
                        done = 1;
                        further_spot(m) = 0;
                    end
                else
                    success(current_m) = 0;
                    status = 'fail';
                    done = 0;
                    further_spot(m) = 0;
                end

            end
            fprintf(fid, '%d\t\t%d\t\t%d/%d/%d, %d:%d:%d\t%d\t\t%d\t\t%s\t\t%d''\n',m,current_m,temp_time(2),temp_time(3),temp_time(1),temp_time(4),temp_time(5),temp_time(6),current_scramble(1),current_scramble(2),status,further_spot(m));
            
        end
    end
    if(count == 1)
        fprintf(fid, 'training trials -- failed redo\n');
        fprintf(fid, 'ov_trial_#\ttr_trial_#\ttime\t\t\t\tmotion\tstimuli\tresult\tfurther\n');
        count = count + 1;
    end
        fprintf(fid, '----------\t----------\t----\t\t\t\t-------\t------\t------\t-------\n');
end
blank = input('END OF TRAINING. ENTER TO CONTINUE');
disp('===============');
disp('MAIN TRIALS');
disp('===============');
disp('There are fourty (40) Main Trials.');
fprintf(fid, '\n');
fprintf(fid, 'main trials\n');
fprintf(fid, 'key:\n');
fprintf(fid, 'target (with respect to yellow/mid line: 1 - in front of, 2 - behind\n');
fprintf(fid, 'motion: reach vs grab\n');
fprintf(fid, '  1 == reach\n');
fprintf(fid, '  2 == grab\n');
fprintf(fid, 'stimuli: properspective vs reverspective -- illusionary vs reverspective -- veridical\n');
fprintf(fid, '  1 == properspective\n');
fprintf(fid, '  2 == reverspective -- illusionary\n');
fprintf(fid, '  3 == reverslective -- veridical\n');
fprintf(fid, 'speed: fast vs slow\n');
fprintf(fid, '  1 == slow\n');
fprintf(fid, '  2 == fast\n');
fprintf(fid, 'ov_trial_#\tma_trial_#\ttime\t\t\t\tmotion\tstimuli\tspeed\t\tresult\tfurther\n');
fprintf(fid, '==========\t==========\t====\t\t\t\t======\t=======\t=====\t\t======\t=======\n');
blank = input('Enter to continue.');
fprintf('\n');

%success = zeros(1,36);  
main_matrix = scramblertrials();
current_scramble = main_matrix(1,:);
count = 1;
trials = 36;
ill_trials = 12;
ver_trials = 12;
count = 0;
m = 11;
current_m=1;
done = 1;
total_result = zeros(2,1);
store_answer = [];
while(trials > 0 || (ill_trials > 0 || ver_trials > 0))

    len = length(main_matrix);
    decided = 0;
    while(decided == 0)
        if(count == len)
            main_matrix = scramblertrials();
            count = 0;
            decided = 1;
        end
        if(done == 1)
            count = count + 1;
            current_scramble = main_matrix(count,:);
            locs = find(main_matrix(:,2) ~= 1);
            done = 0;
            decided = 1;
            if(trials < 0)
                if(current_scramble(2) == 1)
                    decided = 0;
                    done = 1;
                end
            end
        end

    end

    
    instruct = trialsinstructpilot(current_scramble(1),current_scramble(2), current_scramble(3));
    fprintf('Main Trial %.0f Parameters: %s\n', current_m, instruct);
    if(ver_trials < 0)
        fprintf('TRY TO FORCE SUBJECT TO SEE STIMULI IN ILLUSION\n');
    end
    if(ill_trials < 0)
        fprintf('TRY TO FORCE SUBJECT TO SEE STIMULI VERIDICALLY\n');
    end
    blank = input('Press enter to begin trial\n','s');
    temp_time = fix(clock);
    if(debug == 0)
        temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
    end
    while(done == 0)
        further_temp = input('Is the target in front of or behind the yellow/mid line?(enter: 1 for in front of or 2 for behind; 3 for fail): ','s');
        further_temp = strtrim(further_temp);
        [r c] = size(further_temp);
        if(r+c == 0)
            further_temp = ' ';
        end
        if(validate(further_temp))
            if(further_temp ~= '3')
                trials = trials - 1;
                %success(current_m) = 1;
                status = 'succ';
                done = 1;
                further_spot(m) = str2num(further_temp);
                if(current_scramble(2) == 2 || current_scramble(2) == 3)
                    if(further_spot(m) == 1)
                        store_answer = 1;
                        ver_trials = ver_trials - 1;
                        total_result(1,1) = total_result(1,1)+1;
                        %trials = trials - 1;
                    elseif(further_spot(m) == 2)
                        store_answer = -1;
                        ill_trials = ill_trials - 1;
                        total_result(2,1) = total_result(2,1)+1;

                        %trials = trials - 1;
                    end
                end
            else
                %success(current_m) = 0;

                status = 'fail';
                done = 1;
                further_spot(m) = 0;
                        main_matrix(length(main_matrix)+1,:) = current_scramble;
                current_scramble = main_matrix(count,:);
                trials = trials + 1;

                
            end
        else
            %Ssuccess(current_m) = 0;
            status = 'fail';
            done = 0;
            further_spot(m) = 0;
        end
            %m = m + 1;
            %current_m = current_m + 1;
    end

                    fprintf(fid, '%d\t\t%d\t\t%d/%d/%d, %d:%d:%d\t\t%d\t\t%d\t\t%d\t\t%s\t\t%d''\n',m,current_m,temp_time(2),temp_time(3),temp_time(1),temp_time(4),temp_time(5),temp_time(6),current_scramble(1),current_scramble(2),current_scramble(3),status,store_answer);
                                m = m + 1;
            current_m = current_m + 1;

end



blank = input('END OF TRIALS. ENTER TO CONTINUE');
% store all trial data and results

% end of experiment
blank = input('Congratulations. You have completed this experiment. Press any key to exit');
fprintf(fid, 'Breakdown of Reverspective Trials\n');
fprintf(fid, 'Illusionary: %.0f\n',total_result(1));
fprintf(fid, 'Veridical: %.0f\n',total_result(2));

% x = find(store_answer==1);
% y = find(store_answer==-1);
% disp(x);
% disp(y);
% disp(x/(x+y));
% disp(y/(x+y));

% ----------------- end program ----------------------
%close data file
fclose(fid);
%clear all;
% ----------------- /end program ----------------------

% catch err
%     % print errors
%     disp(err);
%     
%     % close data file
%     fclose(fid);
%     %clear all;
% end