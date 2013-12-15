% function [ segIm, indxIm ] = ...
% map2segments( imPath, writeSegmented, writeIndexed, writeStats, doFigures )
%MAP2SEGMENTS segmentation of map-alike image based on mean-shift method
% 
% * The displayed time of mean-shift function execution are only
% empirical constants of execution on Intel Core i5 2.3GHz win7 computer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
% [imPath] - a path to the segmented to-be image file 
% [writeSegmented] - whether to write RGB segmented image to file
%           if writeSegmented == 1 - write
% [writeIndexed] - whether to write indexed segmented image to file
%           if writeIndexed == 1 - write
% [writeStats] - whether to write feature-list into stats text file
%           if writeStats == 1 - write
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
disp('> map2segments started <');

%% global plotting parameters
global FI; global SX; global SY; global SI;

 imPath='..\pic\smaller.png'
 writeSegmented=1; writeIndexed=1; writeStats=1; doFigures=1;
%  close all;
FI = 0;
SI = 0;

%% read image 
[pathstr,name,ext] = fileparts(imPath);
imFileName = [name,ext];
disp( strcat('>>> Image-name "', ' ', name, ext, '", in "', pathstr,'"') );

% imread
im_orig = imread(imPath);
im = im_orig;

%% plot image
if(doFigures == 1)
    FI=FI+1; figure(FI); SX = 3; SY = 1; SI = 0;
    % draw input image
    disp('>>> Show input image');
    DRAW_image(im, 'original');
end


%% mean shift
disp('> Mean-shift computation');

% resolution ~ execution time
numCol = '';
if size(im,3) > 1
    numCol = strcat(' × ', num2str(size(im,3)),' colors');
end
disp(strcat('>>> Resolution of image =',num2str(size(im,1)), ...
    '×',num2str(size(im,2)),'px', numCol));
numPx = size(im,1)*size(im,2);

disp(['>>> Number of pixels = ',num2str(numPx)]);
if numPx < 30000
    disp('>>>>> This can take some time (~seconds)');
elseif numPx < 75000
    disp('>>>>> This can take some time (~minutes)');
else
    disp('>>>>> This can take some time (maybe hours)');
end

% get the segmented RGB image and other variables - calculate Mean Shift
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>!!!<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>!!!<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% [segIm, labels, modes, regsize, grad, conf] = SPLIT_meanShift(im);
    disp('>>> Done');

%% draw segmented & indexed image
if max(max(labels)) > 255
    indxIm = uint16(labels);
else
    indxIm = uint8(labels);
end

% plot them
if(doFigures == 1)
    disp('>>> Show Mean-shift segmented image');
    DRAW_image(segIm, 'segmented image (meanshift)');
    disp('>>> Show Mean-shift indexed image');
    DRAW_image(indxIm, 'indexed image of segments');
end
   
%% calculate feature lists for individual segments
disp('> Statistics');
    disp('>>> Calculating feature list for individual segments');
    stats = GET_features(segIm, labels, modes, regsize, grad, conf);
    disp('>>> Done');

%% shrink feature-close segments togeather
disp('> Shrink feature-close segments togeather');
SHRINK_segmentCount(stats);

if writeSegmented==1
%% write segmented image
disp('> Write segmented images to disk');
segmentPrefix = 'segm_';
    imwrite(segIm, [segmentPrefix, imFileName]);
    disp(['>>> Segmented image written to ', segmentPrefix, imFileName]);
end

if writeIndexed==1
%% write indexed image
% adjust indexes into full gray-scale 
indxPrefix = 'indx_';
indxIm = imadjust( indxIm, stretchlim(indxIm) );
    imwrite(indxIm, [indxPrefix, imFileName]);
    disp(['>>> Segmented image written to ', segmentPrefix, imFileName]);
end
    
if writeStats==1
%% write statistical data to file
disp('> Writing feature lists data to statistics file');
    WRITE_statistics(stats, imFileName);
    disp('>>> Done');
end


disp('> End of map2segments <');

% end

