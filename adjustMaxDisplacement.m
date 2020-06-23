% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxDisplacement] = adjustMaxDisplacement(MV, Pgain, Ngain, lowerBound, blockSize)
% x direction
if MV(1) < 0
    pL = abs(MV(1))*Pgain;
    pR = abs(MV(1))*Ngain;
else
    pL = abs(MV(1))*Ngain;
    pR = abs(MV(1))*Pgain;
end
% y direction
if MV(2) < 0
    pU = abs(MV(2))*Pgain;
    pD = abs(MV(2))*Ngain;
else
    pU = abs(MV(2))*Ngain;
    pD = abs(MV(2))*Pgain;
end
% maxDisplacement at least 1, at most blockSize-1
pL = boundary_check(pL, lowerBound, blockSize);
pR = boundary_check(pR, lowerBound, blockSize);
pU = boundary_check(pU, lowerBound, blockSize);
pD = boundary_check(pD, lowerBound, blockSize);

maxDisplacement = [pL, pR, pU, pD];
end

function p_out = boundary_check(p, lowerBound, upperBound)
    p_out = round(max(min(p, upperBound), lowerBound));
end