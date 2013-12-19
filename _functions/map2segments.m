function [ segIm, indxIm ] = ...
    map2segments( imPath, ...
    writeSegmentedPath, writeIndexedPath, writeStatsPath, doFigures, ...
    speedUp, tresholds)
%MAP2SEGMENTS segmentation of map-alike image based on mean-shift method
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
% [imPath] - a path to the segmented to-be image file 
%____________________________________________________ 
%ordered optional parameters
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
% [speedUp] - to give to edison_wrapper of meanshift function
%           -1 -> to use default
%           [1:3] -> default 2
% [tresholds] - array of two shrinking parameters [lum, col] viz. SHRINK_segmentCount
%           [-1,-1] -> to use defaults
%           [0:20] -> typical lum 
%           [0:5] -> typical col
%@return
% [segIm] - segmented image (RGB)
% [indxIm] - indexed image (0-numOfSegments)
% @etc
% * The displayed time of mean-shift function execution are only
% empirical constants of execution on Intel Core i5 2.3GHz win7 computer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@function      map2segments
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('map2segments started');

%% constants & global plotting parameters
global FI; global SX; global SY; global SI;
% speedUp = 2; % [default]

%% read image 
% default arguments
argMax = 7;
defarg = cell(argMax-1);
defarg = {1,1,1,1,2,[-1,-1]};

i = 0;
if nargin < 1
    disp('You must input at least imagefile name!');
    if(narign <= argMax)
        tresholds = defarg(argMax); end;
    if(narign <= argMax-1)
        speedUp = defarg(argMax-1); end;
    if(narign <= argMax-2)
        doFigures = defarg(argMax-2); end;
    if(narign <= argMax-3)
        writeStatsPath = defarg(argMax-3); end;
    if(narign <= argMax-4)
        writeIndexedPath = defarg(argMax-4); end;
    if(narign <= argMax-5)
        writeSegmentedPath = defarg(argMax-5); end;
end
if(speedUp <0), speedUp = defarg(5); end;
    
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
disp('> Shrink feature-close segments togeather till indempotention');
tic;
% shrink till indempotent
iShrink = 1; % which shrink iteration
shrinkedSegmentCount = 1; % number of segments shrinked
while(shrinkedSegmentCount~=0)
    [segImLUV,segIm,labels, shrinkedSegmentCount] = ...
        SHRINK_segmentCount(labels,segImLUV,doFigures, tresholds, iShrink );
    iShrink = iShrink +1; % next iteration
    SI = SI -2; % re-plot images to the last iteration shrink
end
SI = SI +2;
disp(['  * Segments are indempotent to shrinking afer ',...
    num2str(iShrink),' iterations']);
disp(['    - Done all iterations in ',num2str(toc),'s']);



%% calculate feature lists for individual segments
disp('> Statistics');
    ftrList = GET_features(imOrig, segIm, labels, modes, regsize, grad, conf);
    
%% write segmented images - if specified
WRITE_images(segIm, indxIm, writeSegmentedPath, writeIndexedPath, imPath);
    
%% write statistical data to file - if specified
WRITE_statistics(ftrList, imOrig, imPath, writeStatsPath);


disp('map2segments - ended');

end % fcn

