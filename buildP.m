% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [imgP, value_pic, MV_pic, computations_pic] = buildP(img1, img2, blockSize, maxDisplacement, criterion)
height = size(img2, 1);
width = size(img2, 2);

imgP = zeros(height, width);
value_pic = zeros(height/blockSize, width/blockSize); % minMAD or maxCorr
MV_pic = cell(height/blockSize, width/blockSize);  %create emptyCell 
computations_pic = 0;

for i=1:1:height/blockSize
    for j=1:1:width/blockSize
        % top-left pixel of the block = (pos_i, pos_j)
        pos_i = (i-1)*blockSize + 1;
        pos_j = (j-1)*blockSize + 1;
        % The boundary blocks around an image
        if ((i==1)||(i==height/blockSize)||(j==1)||(j==width/blockSize))
            imgP(pos_i:pos_i+blockSize-1, pos_j:pos_j+blockSize-1) = img2(pos_i:pos_i+blockSize-1, pos_j:pos_j+blockSize-1);
            continue;
        end
        currentBlock = img2(pos_i:pos_i+blockSize-1, pos_j:pos_j+blockSize-1);
        % searchWindow is the corresponding area on img1
        % maxDisplacement = [pL, pR, pU, pD];
        i_min = pos_i - maxDisplacement(3);
        i_max = pos_i + blockSize-1 + maxDisplacement(4);
        j_min = pos_j - maxDisplacement(1);
        j_max = pos_j + blockSize-1 + maxDisplacement(2);       
        searchWindow = img1(i_min:i_max, j_min:j_max);

        [value, MV, computations] = motionEst(currentBlock, searchWindow, maxDisplacement, criterion);
        computations_pic = computations_pic + computations;
        value_pic(i,j) = value;
        MV_pic{i,j} = MV;
        % patch the imgP
        final_pos_i = pos_i - MV(2);
        final_pos_j = pos_j + MV(1);
        imgP(pos_i:pos_i+blockSize-1, pos_j:pos_j+blockSize-1) = img1(final_pos_i:final_pos_i+blockSize-1, final_pos_j:final_pos_j+blockSize-1);
    end
end
end