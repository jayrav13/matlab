% =========================================================================
% ---
% by Jay Ravaliya, Department of Biomedical Engineering, Rutgers University
% 6/12/2010
% =========================================================================
%
% with assistance from Hristiyan Kourtev
%
% =========================================================================

%clear all data
clear all;
close all;
%arduino connected vs. debugging
debug = 1;
if(debug == 0)
    a = arduino('COM3');
    a.pinMode(13,'output');
    a.digitalWrite(13,1);
end

try
% ====================== general experiment parameters ====================

% ----------------- get subject info -----------------
% get config file
[configFileName, pathName] = uigetfile('*.xls*', 'Select a config file for this experiment.');
[num, txt, raw] = xlsread(fullfile(pathName, configFileName));
%set configuration file name equal to data file name
subj_id = dername(configFileName);
% -------- parse trial variables -------- %
trial_nums = 1:1:55;
num_trials = length(trial_nums);
trial_nums = trial_nums(:);
subj_age = num(1);
subj_dominant_eye = char(raw(2,2));
subj_dominant_hand = char(raw(3,2));
subj_stereopsis = char(raw(4,2));
subj_acuity = char(raw(5,2));
record_eyes = num(6);
relay_delays = ones(num_trials,1)*num(7);
light_on_delays = ones(num_trials,1)*num(8);
light_on_durs = ones(num_trials,1)*num(9);
action = num(10);

%store values
further_temp = ''; %temporary variable for where the target was
further_spot = []; %stores which spot is further
num_questions = ''; %how many questions to ask subject
blank = ' '; %blank space for enter key
bunked = []; %failed trials
temp_time = []; %stores time of trial
store_answer = zeros(1,36); %

% open file 
filename = ['data/', num2str(subj_id), '.txt'];
filename2 = ['data2/', num2str(subj_id), '.txt'];
fid = fopen(filename, 'w');
fid2 = fopen(filename2,'w');

% store general trial info
cl = fix(clock);
fprintf(fid, 'Date: %d/%d/%d\n', cl(2),cl(3),cl(1));
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

% variable to store if the input for #questions is done
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
%asks subject all necessary questions
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
fprintf('Ready to begin session. This session has a total of 47 trials.\n', num_trials);
blank = input('Press enter to start.');
fprintf(fid,'\n');
fprintf(fid, 'TIME STAMPS\n');
fprintf(fid,'pre-training trials\n');
fprintf(fid, 'ov_trial_#\tpr_trial_#\ttime\n');
disp('===================');
disp('PRE-TRAINING TRIALS');
disp('===================');
disp('There are three (3) Pre-Training Trials');
success = zeros(1,3);
while(sum(success) ~= 3)
    for m = 1:3
        if(success(m) == 0)
            further_spot(m) = 0;
            fprintf('Trial %d: ',m);
            blank = input('Ask subject to reach towards the center pole. Press enter to begin trial.','s');
            temp_time = fix(clock);
            if(debug == 0)
                temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
            end
            fprintf(fid, '%d\t\t%d\t\t%d:%d:%d''\n',m,m,temp_time(4),temp_time(5),temp_time(6));
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
    if(m~=3)
        blank = input('End of trial, reset and press enter.','s');
    end
end

blank = input('END OF PRE-TRAINING. ENTER TO CONTINUE');
disp('===============');
disp('TRAINING TRIALS');
disp('===============');
disp('There are twenty eight (8) Training Trials.');
fprintf(fid, '\n');
fprintf(fid, 'training trials\n');
fprintf(fid, 'key:\n');
fprintf(fid, 'speed: 1 - fast, 2 - slow, 3 - comfort\n');
fprintf(fid, 'motion: 1 - reach, 2 - grab\n');
fprintf(fid, 'stimuli: 1 - midline away, 2 - midline towards\n');
fprintf(fid, 'further: 1 - in front of midline, 2 - behind midline\n');
fprintf(fid, 'ov_trial_#\ttr_trial_#\ttime\t\tspeed\t\tmotion\tstimuli\tresult\tfurther\n');
fprintf(fid, '==========\t==========\t====\t\t=====\t\t=======\t======\t======\t=======\n');
blank = input('Enter to continue.');
fprintf('\n');
training_matrix = scramblertraining();
success = zeros(1,8);  
count = 1;
while(sum(success) ~= 8)
    for m=4:11
        current_m = m-3;
        if(success(current_m) == 0)
            current_scramble = training_matrix(current_m,:);
            if(action == 1)
                instruct = traininginstructPOINT(current_scramble);
            elseif(action == 2)
                instruct = traininginstructGRAB(current_scramble);
            end
            fprintf('Training Trial %.0f Parameters: %s\n', current_m, instruct);
            blank = input('Press enter to begin trial.','s');
            temp_time = fix(clock);
            if(debug == 0)
                temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
            end
            done = 0;
            while(done == 0)
                further_temp = input('Is the target in front of or behind the midline?(enter: 1 for in front of or 2 for behind; 3 for fail): ','s');
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
                fprintf(fid, '%d\t\t%d\t\t %d:%d:%d\t%d\t\t%d\t\t%d\t\t%s\t\t%d''\n',m,current_m,temp_time(4),temp_time(5),temp_time(6),current_scramble(1),current_scramble(2),current_scramble(3),status,further_spot(m));
            
        end
    end
    if(count == 1)
        fprintf(fid, 'training trials -- failed redo\n');
        fprintf(fid, 'ov_trial_#\ttr_trial_#\ttime\t\tspeed\t\tmotion\tstimuli\tresult\tfurther\n');
        count = count + 1;
    end
        fprintf(fid, '----------\t----------\t----\t\t\t\t-------\t------\t------\t-------\n');
end
blank = input('END OF TRAINING. ENTER TO CONTINUE');
disp('===============');
disp('MAIN TRIALS');
disp('===============');
disp('There are fourty (36) Main Trials.');
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
fprintf(fid, 'furthe\r: in front of, or behind, midline\n');
fprintf(fid, '  1 = in front of midline\n');
fprintf(fid, '  2 = behind midline\n');

fprintf(fid, 'ov_trial_#\tma_trial_#\ttime\t\tmotion\tstimuli\tspeed\t\tresult\tfurther\n');
fprintf(fid, '==========\t==========\t====\t\t======\t=======\t=====\t\t======\t=======\n');
fprintf(fid2, 'Properspective = 1\nReversepective = 2 or 3\n');
fprintf(fid2, 'Trial\t\tStimulus\t\tPercept\n');
fprintf(fid2, '======\t========\t\t=======\n');

blank = input('Enter to continue.');
fprintf('\n');

done_one=0;
success = zeros(1,36);  
main_matrix = scramblertrials();
count = 1;

while(sum(success) ~= 36)
    for m=12:47
        current_m = m-11;
        if(success(current_m) == 0)
            current_scramble = main_matrix(current_m,:);
            if(action == 1)
                instruct = trialsinstructpilotPOINT_SB(current_scramble);
            elseif(action == 2)
                instruct = trialsinstructpilotGRAB_SB(current_scramble);
            end
            fprintf('Main Trial %.0f Parameters: %s\n', current_m, instruct);
            blank = input('Press enter to begin trial.','s');
            temp_time = fix(clock);
            if(debug == 0)
                temp_time = switchcode(light_on_delays(m), relay_delays(m), light_on_durs(m), a);
            end
            done = 0;
            
            while(done == 0)
                further_temp = input('0 for Proper, 1 for Reverse Illusory percept, 2 for Reverse Veridical percept, 3 for failed trial: ','s');
                further_temp = strtrim(further_temp);
                [r c] = size(further_temp);
                if(r+c == 0)
                    further_temp = ' ';
                end
                if(validate_SB(further_temp))
                    if(further_temp ~= '3')
                        success(current_m) = 1;
                        status = 'succ';
                        done = 1;
                        further_spot(m) = str2num(further_temp);
                        if(current_scramble(2) == 2 || current_scramble(2) == 3)
                            if(further_spot(m) == 1)
                                store_answer(current_m) = 1;
                            elseif(further_spot(m) == 2)
                                store_answer(current_m) = -1;
                            end
                        end
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
            fprintf(fid, '%d\t\t%d\t\t %d:%d:%d\t%d\t\t%d\t\t%d\t\t%s\t\t%d''\n',m,current_m,temp_time(4),temp_time(5),temp_time(6),current_scramble(1),current_scramble(2),current_scramble(3),status,further_spot(m));
            fprintf(fid2, '%d\t\t\t%d\t\t\t%d\n',current_m,current_scramble(2),further_spot(m));
        end
    end
    done_one = 1;
    if(count == 1)
        fprintf(fid, 'main trials -- failed redo\n');
        fprintf(fid, 'ov_trial_#\tma_trial_#\ttime\t\tmotion\tstimuli\tspeed\t\tresult\tfurther\n');
        count = count + 1;
    end
    fprintf(fid, '----------\t----------\t----\t\t\t\t-------\t------\t-----\t\t------\t-------\n');
end
blank = input('END OF TRIALS. ENTER TO CONTINUE');
% store all trial data and results

% end of experiment
blank = input('Congratulations. You have completed this experiment. Press any key to exit');
% fprintf(fid, 'Percentage Breakdown of Reverspective Trials\n');
% [r c1] = size(find(store_answer==-1));
% [r c2] = size(find(store_answer==1));
% fprintf(fid, 'Illusionary: %.0f\n',c1);
% fprintf(fid, 'Veridical: %.0f\n',c2);

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

catch err
    % print errors
    disp(err);
    
    % close data file
    fclose(fid);
    %clear all;
end