function [testerror] = getClassifyError(gt, pred)
accuracy = 0;
for i = 1: length(gt)
    
    if gt(i) >= 0 && gt(i) < 1000000 && pred(i) > 0 && pred(i) < 1000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 1000000  && gt(i) < 10000000 && pred(i) >= 1000000 && pred(i) < 10000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 10000000 && gt(i) < 20000000 && pred(i) >= 10000000 && pred(i) < 20000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 20000000 && gt(i) < 40000000 && pred(i) >= 20000000 && pred(i) < 40000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 40000000 && gt(i) < 65000000 && pred(i) >= 40000000 && pred(i) < 65000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 65000000 && gt(i) < 100000000 && pred(i) >= 65000000 && pred(i) < 100000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 100000000 && gt(i) < 150000000 && pred(i) >= 100000000 && pred(i) < 150000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 150000000 && gt(i) < 200000000 && pred(i) >= 150000000 && pred(i) < 200000000
        accuracy = accuracy + 1;

    elseif gt(i) >= 200000000 && pred(i) >= 200000000 
        accuracy = accuracy + 1;

    end
end
    
testerror = 1-accuracy/length(gt);

