% function [ segIm, indxIm ] = ...
% map2segments( imPath, writeSegmented, writeIndexed, writeStats, doFigures )
%MAP2SEGMENTS segmentation of map-alike image based on mean-shift method
% 
% * The displayed time of mean-shift function execution are only
% empirical constants of execution on Intel Core i5 2.3GHz win7 computer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
% [imPath] - a path to the segmented to-be image file 
% [writeSegmentedPath] - whether to write RGB segmented image to file & where
%           if writeSegmentedPath == 0 - do not write
%           else write to path specified
% [writeIndexedPath] - whether to write indexed segmented image to file & where
%           if writeIndexedPath == 0 - do not write
%           else write to path specified
% [writeStatsPath] - whether to write feature-list into stats text file & where
%           if writeStatsPath == 0 - do not write
%           else write to path specified
% [doFigures] - whether to imshow images through the process
%           if doFigures == 1 - show
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@return
% [segIm] - segmented image (RGB)
% [indxIm] - indexed image (0-numOfSegments)
% 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@function      map2segments
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('map2segments started');

%% global plotting parameters
global FI; global SX; global SY; global SI;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% debug
 imPath='..\pic\smaller5.png';
 writeSegmentedPath='..\out\'; 
 writeIndexedPath='..\out\'; 
 writeStatsPath='..\out\'; 
 doFigures=1;
%  close all;
FI = 0;
SI = 0;
% debug - end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read image 
[pathstr,name,ext] = fileparts(imPath);
imFileName = [name,ext];
disp( strcat('  * Image-name "', ' ', name, ext, '", in "', pathstr,'"') );

% imread
im_orig = imread(imPath);
im = im_orig;

%% plot image
if(doFigures == 1)
    FI=FI+1; figure(FI); SX = 3; SY = 1; SI = 0;
    % draw input image
    disp('  * Show input image');
    DRAW_image(im, 'original');
end


%% mean shift
disp('> Mean-shift computation');

% measure the time of execution for meanShift
tic;
% get the segmented RGB image and other variables - calculate Mean Shift
% [segIm, labels, modes, regsize, grad, conf] = SPLIT_meanShift(im);
    disp(['  * Done in ',num2str(toc),'s']);

%% draw segmented & indexed image
if max(max(labels)) > 255
    indxIm = uint16(labels);
else
    indxIm = uint8(labels);
end

% plot them
if(doFigures == 1)
    disp('  * Show Mean-shift segmented image');
    DRAW_image(segIm, 'segmented image (meanshift)');
    disp('  * Show Mean-shift indexed image');
    DRAW_image(indxIm, 'indexed image of segments');
end
   
%% calculate feature lists for individual segments
disp('> Statistics');
    disp('  * Calculating feature list for individual segments');
    ftrList = GET_features(segIm, labels, modes, regsize, grad, conf);
    disp('  * Done');

%% shrink feature-close segments togeather
disp('> Shrink feature-close segments togeather');
SHRINK_segmentCount(ftrList);

%% write segmented images - if specified
WRITE_images(segIm, indxIm, writeSegmentedPath, writeIndexedPath, imFileName);
    
%% write statistical data to file - if specified
WRITE_statistics(ftrList, imFileName, writeStatsPath);

disp('map2segments - ended');

% end

