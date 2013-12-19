function [segImRGB, segImLUV, indxIm, ...
    labels, modes, regsize, grad, conf] ...
    = SPLIT_meanShift(im, speedUp, doFigures)
%SPLIT_MEANSHIFT gets individual segments through mean-shift method using edison_wrapper
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [im] - preprocessed image
%  [speedUp] - speed optimalization edison-wrapper parameterf 
%  [doFigures] - whether to plot images
%@return
%  [segImRGB] - segmented image in RGB color-space
%  [segImLUV] - segmented image in Luv color-space
%  [indxIm] - uint8 / uint16 indexed image 
%  [labels] - indexed image
%  [regsize] - number of pixels in individual segments
% @unused-returns
% - some of mean-shift edison_wrapper return parameters:
%   modes, grad, conf
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% resolution ~ execution time message
numCol = '';
if size(im,3) > 1
    numCol = strcat(' × ', num2str(size(im,3)),' colors');
end
disp(strcat('  * Resolution of image =',num2str(size(im,1)), ...
    '×',num2str(size(im,2)),'px', numCol));
numPx = size(im,1)*size(im,2);

disp(['  * Number of pixels = ',num2str(numPx)]);
if numPx < 24300
    disp('    - This can take some time (~seconds)');
elseif numPx < 35000
    disp('    - This can take some time (~minutes)');
else
    disp('    - This can take some time (maybe hours)');
end

%% set parameters for mean shift
steps       = 2; % filtering and region fusion [default]
% speedUp     = 2; % empiricaly best on map type of images

%% new set of input parameters
% the empirical relation between image resolution and main mean-shift parameters
allPx_const = 1468*805; % the empirical map-set resolution with good results

spt_min = 10;   spt_max = 100;  spt_pow = 1;
rng_min = 3;    rng_max = 5;    rng_pow = 1;
reg_min = 30;   reg_min = 50;   reg_pow = 1;

% all pixels of this image 
allPx = size(im,1)*size(im,2);
            rng = rng_min + (rng_max-rng_min) * (allPx/allPx_const)^1; %

relation = allPx/allPx_const;
spatialBandWidth = spt_min + (spt_max-spt_min) * (relation)^spt_pow; %
rangeBandWidth   = rng_min + (rng_max-rng_min) * (relation)^rng_pow; %
minimumRegionArea= reg_min + (rng_max-reg_min) * (relation)^reg_pow; %


%% calculate Mean Shift
disp(['  * Executing meanshift','']);
tic; % measure the time of execution for meanShift
[fimg, labels, modes, regsize, grad, conf] = edison_wrapper(...
    im, @RGB2Luv,...
    'steps',    steps, ...
    'SpeedUp',  speedUp, ...
    'SpatialBandWidth',     round(spatialBandWidth), ...
    'RangeBandWidth',       rangeBandWidth, ...
    'MinimumRegionArea',    round(minimumRegionArea) ...
    );

disp(['    - Done in ',num2str(toc),'s']);

% DRAW_image(im,  tit);
% DRAW_image(Luv2RGB(fimg), tit);

%% output
segImLUV = fimg;
segImRGB = Luv2RGB(segImLUV);

if max(labels(:)) > 255
    indxIm = uint16(labels);
else
    indxIm = uint8(labels);
end

%% draw segmented & indexed image
nSegm = max(labels(:))+1;
if(doFigures == 1)
    disp('  * Show Mean-shift segmented image');
    DRAW_image(segImRGB, ['Segmented(meanshift); nSegm=',num2str(nSegm),'']);
    disp('  * Show Mean-shift indexed image');
    DRAW_image(indxIm, ['Indexed['...
        ,num2str(size(im,1)),'×',num2str(size(im,2)),...
        ']px; nSegm=',num2str(nSegm),'']);
end
   


end %fcn