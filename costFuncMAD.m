% Computes the MAD for the given two blocks
% Output
%       cost : The MAD for the two blocks
%
% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost = costFuncMAD(currentBlock, refBlock)
blockSize = size(currentBlock, 1);
err = 0;
for i = 1:blockSize
    for j = 1:blockSize
        err = err + abs((currentBlock(i,j) - refBlock(i,j)));
    end
end
cost = err/(blockSize*blockSize);
end
