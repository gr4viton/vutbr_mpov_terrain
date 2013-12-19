function [ segIm, indxIm ] = ...
    map2segments( imPath, speedUp, lightTreshold, colTreshold, ...
    writeSegmentedPath, writeIndexedPath, writeStatsPath, doFigures )
%MAP2SEGMENTS segmentation of map-alike image based on mean-shift method
% 
% * The displayed time of mean-shift function execution are only
% empirical constants of execution on Intel Core i5 2.3GHz win7 computer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
% [imPath] - a path to the segmented to-be image file 
% [writeSegmentedPath] - whether to write RGB segmented image to file & where
%           if writeSegmentedPath == 0 - do not write
%           elseif writeIndexedPath == 1 - create the file in directory "_segm" created in the imPath      
%           else write to path specified
% [writeIndexedPath] - whether to write indexed segmented image to file & where
%           if writeIndexedPath == 0 - do not write
%           elseif writeIndexedPath == 1 - create the file in directory "_segm" created in the imPath      
%           else write to path specified
% [writeStatsPath] - whether to write feature-list into stats text file & where
%           if writeStatsPath == 0 - do not write
%           elseif writeIndexedPath == 1 - create the file in directory "_stat" created in the imPath      
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

%% constants & global plotting parameters
global FI; global SX; global SY; global SI;
% speedUp = 2; % [default]

%% read image 

[pathstr,name,ext] = fileparts(imPath);
disp( strcat('  * Image-name "', ' ', name, ext, '", in "', pathstr,'"') );

% imread
imOrig = imread(imPath);
im = imOrig;

%% plot original image
if(doFigures == 1)
    figure(FI); SX = 2; SY = 3; SI = 0;
    % draw input image
    disp('  * Show input image');
    tit=['Original[',num2str(size(im,1)),'×',num2str(size(im,2)),']px'];
    DRAW_image(im, tit);
end

%% preprocessing filtering
im = PRE_processImage(im, doFigures);

%% mean shift
disp('> Mean-shift computation');
% get the segmented RGB image and other variables - calculate Mean Shift
[segIm, segImLUV, indxIm, labels, modes, regsize, grad, conf] ...
    = SPLIT_meanShift(im, speedUp, doFigures);

%% shrink feature-close segments togeather
disp('> Shrink feature-close segments togeather');
[segImLUV,segIm,labels] = ...
    SHRINK_segmentCount(labels,segImLUV,doFigures,lightTreshold, colTreshold);

%% calculate feature lists for individual segments
disp('> Statistics');
    ftrList = GET_features(imOrig, segIm, labels, modes, regsize, grad, conf);
    
%% write segmented images - if specified
WRITE_images(segIm, indxIm, writeSegmentedPath, writeIndexedPath, imPath);
    
%% write statistical data to file - if specified
WRITE_statistics(ftrList, imOrig, imPath, writeStatsPath);


disp('map2segments - ended');

end % fcn

