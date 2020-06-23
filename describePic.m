% Use two index to represent the image

% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [value_avg, MV_avg] = describePic(value_pic, MV_pic)
% use the avg
value_avg = mean(abs(value_pic(2:size(value_pic,1)-1, 2:size(value_pic,2)-1)), 'all');
%
MV_pic = MV_pic(2:size(MV_pic,1)-1, 2:size(MV_pic,2)-1);
for i=1:size(MV_pic,1)
    for j=1:size(MV_pic,2)
        MV_pic_x(i,j) = MV_pic{i,j}(1);
        MV_pic_y(i,j) = MV_pic{i,j}(2);
    end
end
MV_avg = [mean(MV_pic_x, 'all'), mean(MV_pic_y, 'all')];
end