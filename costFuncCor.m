% Computes the correlation for the given two blocks
% output:
%   -1 < value < 1
% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function value = costFuncCor(currentBlock, refBlock)
numerator = sum(sum(currentBlock.*refBlock));
denominator = sqrt(sum(sum((abs(currentBlock)).^2)))*sqrt(sum(sum((abs(refBlock)).^2)));
value = numerator/denominator;

if denominator == 0
    error('denominator=0');
end
end