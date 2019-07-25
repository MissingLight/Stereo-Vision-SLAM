%   frameLeft = readerLeft.step();
%     frameRight = readerRight.step();
%     
%     % Rectify the frames.
%     [frameLeftRect, frameRightRect] = ...
%         rectifyStereoImages(frameLeft, frameRight, stereoParams);

load('StereoParams.mat');



    frameLeft=imread('0.png');
    frameRight=imread('00.png');
    
 [frameLeftRect, frameRightRect] = ...
    rectifyStereoImages(frameLeft, frameRight, stereoParams); 
% frameLeftRect=imread('0.png');
% frameRightRect=imread('00.png');

    % Convert to grayscale.
    frameLeftGray  = rgb2gray(frameLeftRect);
    frameRightGray = rgb2gray(frameRightRect);
    
    % Compute disparity. 
    disparityMap = disparity(frameLeftGray, frameRightGray);
   
    figure;
%     imshow(disparityMap, [0, 64]);
%     title('Disparity Map');
%     colormap jet
%     colorbar
    
    
 %%
    % Reconstruct 3-D scene.
    points3D = reconstructScene(disparityMap, stereoParams);
     points3D = points3D ./ 1000;
    
    figure;
    imshow(points3D(:,:,3));
    
    ptCloud = pointCloud(points3D, 'Color', frameLeftRect);
    player3D = pcplayer([-2, 2.5], [-2, 2], [-2, 10], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');
    view(player3D, ptCloud);