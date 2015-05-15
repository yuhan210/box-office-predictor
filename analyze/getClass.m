function [cc] = getClass(gt)
cc = zeros(length(gt), 1);
for i = 1: length(gt)
    
    if gt(i) < 1000000;
        cc(i) = 1;
    elseif gt(i) >= 1000000  && gt(i) < 10000000   
        cc(i) = 2;

    elseif gt(i) >= 10000000 && gt(i) < 20000000 
        cc(i) = 3;
    elseif gt(i) >= 20000000 && gt(i) < 40000000 
        cc(i) = 4;
    elseif gt(i) >= 40000000 && gt(i) < 65000000
        cc(i) = 5;

    elseif gt(i) >= 65000000 && gt(i) < 100000000 
        cc(i) = 6;
    elseif gt(i) >= 100000000 && gt(i) < 150000000 
        cc(i) = 7;

    elseif gt(i) >= 150000000 && gt(i) < 200000000 
        cc(i) = 8;

    elseif gt(i) >= 200000000 
        cc(i) = 9;
    end
end
    

