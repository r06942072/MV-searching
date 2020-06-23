% Purpose: Adjust maxDisplacement based on coded motion vectors
%
% written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options:
%   plot frame by frame
%   output video
%   plot final report
clc;
clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%
filename = {'Akiyo','Bus','City','Cheerleaders','Container','FlowerGarden','Football'...
    'Foreman','Hall','Highway','Waterfall'};
final_result = [];

% video frame by frame properties
firstFrame = 1;
lastFrame = 5;
gapOfFrames = 1;

% System parameters, fixed search range p =6
blockSize = 16;  % the size of a square block
criterion = 'Cor';
px = 6;
py = 6;

theta_k = 2;
theta_Pgain = 10;
theta_Ngain = 0.01;
theta_lowerBound = 2;
threshold_PSNR = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% video_MV_avg = cell(numOfFrames-1, 1);  % global motion vector to represent a frame

for i=1:length(filename)
    file_current = filename{i};
    disp('*');
    disp(file_current);
    filepath = strcat('..\rawPic\', file_current, '_CIF');
    imds_org = imageDatastore(filepath);
    % height and width is determined by the first image in datastore
    height = size(im2double(rgb2gray(readimage(imds_org, 1))), 1);
    width = size(im2double(rgb2gray(readimage(imds_org, 1))), 2);
    maxDisplacement = [px, px, py, py];
    videoIndex = 1;
    %
    numOfFrames = floor((lastFrame - firstFrame)/gapOfFrames) + 1;
    video_MV_avg = cell(numOfFrames-1, 1);
    video_diff = zeros(numOfFrames-1, 1);
    video_computations = zeros(numOfFrames-1, 1);
    %
    for frameIndex = firstFrame:gapOfFrames:lastFrame-1
        disp('*');
        disp(strcat('Reference frame = ', num2str(frameIndex), ', Current frame = ', num2str(frameIndex+gapOfFrames)));
        
        img1 = im2double(rgb2gray(readimage(imds_org, frameIndex)));
        img2 = im2double(rgb2gray(readimage(imds_org, frameIndex+gapOfFrames)));
        
        imgP = zeros(height, width);
        value_pic = zeros(height/blockSize, width/blockSize);
        MV_pic = cell(height/blockSize, width/blockSize);
        
        [imgP, value_pic, MV_pic, computations_pic] = buildP(img1, img2, blockSize, maxDisplacement, criterion);
        [value_avg, MV_avg] = describePic(value_pic, MV_pic);
        [residual_pic, diff] = residual(img2, imgP);       
        %
        video_MV_avg{videoIndex} = MV_avg;
        video_diff(videoIndex, 1) = diff;
        video_computations(videoIndex, 1) = computations_pic;
        
        % adjust maxDisplacement every k frames based on MV
        % notice that we only take the MV data, which reconstructed image quality better than threshold_PSNR
        if mod(videoIndex, theta_k) == 0
            [local_video_MV_avg] = getMV(video_diff(videoIndex-theta_k+1:videoIndex), threshold_PSNR, video_MV_avg(videoIndex-theta_k+1:videoIndex));
            disp('local_video_MV_avg');
            disp(local_video_MV_avg);
            if ~isempty(local_video_MV_avg)
                disp('maxDisplacement update from = ');
                disp(maxDisplacement);
                maxDisplacement = adjustMaxDisplacement(local_video_MV_avg, theta_Pgain, theta_Ngain, theta_lowerBound, blockSize);
                disp('maxDisplacement update to = ');
                disp(maxDisplacement);
            end
        end
        %
        videoIndex = videoIndex + 1;
    end
    %
    final_result = [final_result; [mean(video_diff), mean(video_computations)]];
end

% final report, tweaking parameter
% theta = [];
% for i=1:numOftest
%     local = "(k,P,N,lower) = " + num2str(theta_k(i)) + "," + num2str(theta_Pgain(i)) + "," + num2str(theta_Ngain(i)) + "," + num2str(theta_lowerBound(i));
%     theta = [theta, local];
% end
% plotFrameByFrame(filename, 'PSNR', theta, video_diff);
% plotFrameByFrame(filename, 'Computations', theta, video_computations);
% video_diff_avg = mean(video_diff);
% video_computations_avg = mean(video_computations);
% plotTweakParameter(filename, theta ,video_diff_avg, video_computations_avg);

disp('Finish');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bBox = plotRect(imgX, imgY, width, height, color, line)
bBox = rectangle('Position',[imgX, imgY, width, height],'EdgeColor', color, 'LineStyle', line);
end