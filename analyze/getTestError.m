function [testerror] = getTestError(gt, pred)

testerror = sqrt(sum((gt - pred).^2)/length(gt));

