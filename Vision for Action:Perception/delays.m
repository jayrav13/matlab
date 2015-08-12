% ==================================
% delays.m
% A program created to sort the delays to properly ensure
% the execution of various ARDUINO related events during a trial
% by Jay H. Ravaliya
% ==================================
function  arranged = delays(LSDelay, RSDelay, LDelay)
RDelay = 0.5;%constant time of actuator being ON

matr = [LSDelay,RSDelay,(LDelay+LSDelay),(RDelay + RSDelay);13,12,13,12];

times = matr(1,:);
arranged = zeros(2,4);

for x = 1:4
    [value location] = min(times);
    arranged(:,x) = matr(:,location);
    times(location) = Inf;
end

end