% residual
% to evaluate the difference between original and predicted
% 
% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [abs_diff_pic, difference] = residual(originalImg, predictedImg)
abs_diff_pic = abs(originalImg-predictedImg);

% difference = sum(sum(residual_pic)); %L1 norm
% difference = norm(residual_pic,'fro'); %L2 norm

PSNR = diff_psnr(originalImg, predictedImg);

difference = PSNR;
end

function PSNR = diff_psnr(originalImg, predictedImg)
% originalImg: double
% predictedImg: double
if (size(originalImg, 1)~=size(predictedImg, 1))||(size(originalImg, 2)~=size(predictedImg, 2))
    disp('dimension of pictures is not consistent')
end
height = size(originalImg, 1);
width = size(originalImg, 2);

abs_diff_pic = abs(originalImg-predictedImg);

MSE = sum(sum(abs_diff_pic.^2))/(height*width);
PSNR = 10*log10(1/MSE);
end