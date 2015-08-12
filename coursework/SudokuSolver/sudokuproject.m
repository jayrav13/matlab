function [newP] = sudokuproject(newP)
tic
%jayrav
%eschbach
%Sources: We briefly talked to Professor Ur about our code.
%The code is based on the email with hints from Professor Ur.
position = 0;
zeros = zeroList(newP);
[r c] = size(zeros);
done = false;
while(done == false)
    position = position + 1;
    rV = zeros(position,1);
    cV = zeros(position,2);
    newP(rV,cV) = newP(rV,cV) + 1; 
    rVect = newP(rV,:);
    cVect = newP(:,cV);
    while(contains(rVect,newP(rV,cV)) | contains(cVect,newP(rV,cV)) | matrixloc(newP,zeros(position,:)))
        newP(rV,cV) = newP(rV,cV) + 1;
        rVect = newP(rV,:);
        cVect = newP(:,cV);
       %pause(0.01)
        %disp(newP);
    end
    if(newP(rV,cV) > 9)
        newP(rV,cV) = 0;
        position = position - 2;
    end
    if(position == r)
        done = true;
    end
end
toc
