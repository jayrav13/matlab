% ==================================
% switchcode.m
% A program created to control the ARDUINO microprocessor responsible for 
% the manipulation of the visual stimuli along with the room lighting.
% by Jay H. Ravaliya
% ==================================
function time = switchcode(LSD, RSD, LOD, a)
switchPin = 8; %constant
ledPin = 13; %constant
retract = 12; %constant
current = 0; %variable (current state of switch)
last = 0; %variable (past state of switch)
temp = 0; %hold current state of switch to be transcribed to
          %last state after one iteration of while loop

delay = delays(LSD,RSD,LOD); 
dTimes = delay(1,:); %delay times
dPins = delay(2,:);  %pins in order of delay time

dTimesAdj = zeros(1,4);

dTimesAdj(1) = dTimes(1);
dTimesAdj(2) = dTimes(2)-dTimes(1);
dTimesAdj(3) = dTimes(3)-dTimes(2);
dTimesAdj(4) = dTimes(4)-dTimes(3);

%declare/initialize pins
a.pinMode(switchPin,'input');
a.pinMode(ledPin,'output');
a.pinMode(retract,'output');
a.digitalWrite(ledPin,1);
time = '';
x=0;
while(x==0)
    current = a.digitalRead(switchPin);
    last = temp;
    if(current == 0)
        if(last == 1)
            time = fix(clock);
            WaitSecs(dTimesAdj(1));
            current1 = a.digitalRead(dPins(1));
            a.digitalWrite(dPins(1),abs(current1 - 1));
            WaitSecs(dTimesAdj(2));
            current1 = a.digitalRead(dPins(2));
            a.digitalWrite(dPins(2),abs(current1 - 1));
            WaitSecs(dTimesAdj(3));
            current1 = a.digitalRead(dPins(3));
            a.digitalWrite(dPins(3),abs(current1 - 1));
            WaitSecs(dTimesAdj(4));
            current1 = a.digitalRead(dPins(4));
            a.digitalWrite(dPins(4),abs(current1 - 1));
            x=1;   
        end
    end
    temp = current;
end
end