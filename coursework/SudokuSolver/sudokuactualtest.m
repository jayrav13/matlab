 clear;clc;
f = @sudokuproject;  % the name of the function.  submit it with the name sudokuproject!!!
dotimer = input('type 1 and hit enter to time your code.  just hit enter if you only want to check answers\n');
%%% initialize variables
load sudokuactualtest.mat;
success = zeros(1,22);
theirtimes = inf*ones(1,22);
%%% check their answers
for j = 1:22
    for k = 1:4
        fprintf('*******************************\n')
    end
    try   % try running their program
        a = f(puz(:,:,j));
        fprintf('puzzle %.0f\n',j)
        if(a==blaseans(:,:,j))  % compare their answer to mine
            fprintf('!!!!!!!!!!!you got it right!!!!!!!!!!!!\n');
            success(j) = 1;
        else
            thepuzzle = puz(:,:,j)
            fprintf('!!!!!!!!!!!you got it wrong.  you got:!!!!!!!!!!!\n');
            a
            fprintf('the correct answer for puzzle %.0f was\n',j)
            correctanswer = blaseans(:,:,j)
        end
    catch exception   % their program crashed
        fprintf('!!!!!!!!!!!your attempt at this question crashed!!!!!!!!!!!\n');
    end
end
for k = 1:4
    fprintf('*******************************\n')
end
%%% do the timer stuff
if(~isempty(dotimer) && dotimer)
    for j = find(success)
        f(puz(:,:,j));   % run it once before starting timer
        tic;
        for k = 1:13
            f(puz(:,:,j));   % run it once before starting timer
        end
        theirtimes(j) = toc;
    end
    for ay = 1:22
        fprintf('Your average time for %.0f was %.6f\n', ay,theirtimes(ay)/13)
    end
    fprintf('Your average total time was %.6f\n', sum(theirtimes)/13)
end
fprintf('\nyour final score is %.0f\n\n',5*sum(success))    