function [matrix] = getConfusionMat(gt, pred)

gtc = getClass(gt);
predc = getClass(pred)

matrix = zeros(9,9);
for i = 1: length(gt)
    matrix(gtc(i), predc(i)) =  matrix(gtc(i), predc(i)) + 1;
   
end
    