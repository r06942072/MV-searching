% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MV] = getMV(video_diff, threshold_PSNR, video_MV)
% I/O relationship:
% video_diff, threshold -> video valid
% video_valid, video_MV -> MV
video_valid = find(video_diff>threshold_PSNR);  % the valid index of frame
if size(video_valid, 1) == 0
    MV = [];
    disp('No valid frame. Check the threshold');
elseif size(video_valid, 1) == 1
    MV = cell2mat(video_MV(video_valid));
    disp('Only one valid frame. Maybe the threshold is too tight');
else
    MV = mean(cell2mat(video_MV(video_valid)));
end
end
