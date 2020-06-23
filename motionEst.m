% motion estimation
% use full search now, can extend to ARPS in the future
% output:
%     a value and a motion vector
%
% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [value, MV, computations] = motionEst(currentBlock, searchWindow, maxDisplacement, criterion)
% function handle
if (criterion == 'MAD')
    costFunc = @costFuncMAD;
elseif (criterion == 'Cor')
    costFunc = @costFuncCor;
else
    error('Not found');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(currentBlock, 1)~=size(currentBlock, 2)
    error('Not a squared block');
end
% squared block size
blockSize = size(currentBlock, 1);
% maxDisplacement = [pL, pR, pU, pD];
% row*col = nums of candidates
row = maxDisplacement(3) + maxDisplacement(4) + 1;
col = maxDisplacement(1) + maxDisplacement(2) + 1;

computations = 0;
for i=1:1:row
    for j=1:1:col
        refBlock = searchWindow(i:i+blockSize-1, j:j+blockSize-1);
        valueMatrix(i,j) = costFunc(currentBlock, refBlock);
        computations = computations + 1;
    end
end
% output value
if (criterion == 'MAD')
    value = min(min(valueMatrix));
elseif (criterion == 'Cor')
    value = max(max(valueMatrix));
else
    error('Not found');
end
% output MV
% for example
% [pos_i, pos_j] = [maxDisplacement(3)+1, maxDisplacement(1)+1] -> MV = [0,0]
[pos_i, pos_j] = find(valueMatrix==value, 1);    %only find one result even if more than one matches exist
MV = [pos_j-maxDisplacement(1)-1, maxDisplacement(3)+1-pos_i];
% boundary check, pL, pR, pU, pD
if (MV(1)<-maxDisplacement(1)) || (MV(1)>maxDisplacement(2)) || (MV(2)>maxDisplacement(3)) || (MV(2)<-maxDisplacement(4))   
    disp('maxDisplacement = ');
    disp(maxDisplacement);
    disp('MV = ');
    disp(MV);
    error('In MotionEst, MV is not valid!');
end
end
