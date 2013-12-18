function [segImRGB, segImLUV, labels, modes, regsize, grad, conf] ...
    = SPLIT_meanShift(im, speedUp)

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
etalon_allPix= 1468*805; % the empirical map-set resolution with good results

eSpatialPower = 1;
etalon_spatialConstant = 100 / etalon_allPix^eSpatialPower;

eRangePower = 1;
etalon_rangeConstant = 5 / etalon_allPix^eRangePower;

eRegionPower = 1;
etalon_regionConstant = 50 / etalon_allPix^eRegionPower;

% all pixels of this image 
im_allPix = size(im,1)*size(im,2);

spatialBandWidth    = uint16(im_allPix^eSpatialPower * etalon_spatialConstant);
rangeBandWidth      = im_allPix^eRangePower * etalon_rangeConstant;
minimumRegionArea   = uint16(im_allPix^eRegionPower * etalon_regionConstant)  ;   

% spatialBandWidth    = 100
% rangeBandWidth      = 5
% minimumRegionArea   = 50


%% calculate Mean Shift
disp(['  * Executing meanshift','']);
tic; % measure the time of execution for meanShift
[fimg, labels, modes, regsize, grad, conf] = edison_wrapper(...
    im, @RGB2Luv,...
    'steps',    steps, ...
    'SpeedUp',  speedUp, ...
    'SpatialBandWidth',     spatialBandWidth, ...
    'RangeBandWidth',       rangeBandWidth, ...
    'MinimumRegionArea',    minimumRegionArea ...
    );

disp(['    - Done in ',num2str(toc),'s']);

% DRAW_image(im,  tit);
% DRAW_image(Luv2RGB(fimg), tit);

segImLUV = fimg;
segImRGB = Luv2RGB(segImLUV);



end %fcn



%% DEFAULT parameters
% % count from image resolution etc
% spatialBandWidth = 100;
% rangeBandWidth = 5;
% minimumRegionArea = 50;
% % margin = max(size(im_orig)) * 0.01;
% 
% %% calculate Mean Shift
% [fimg, labels, modes, regsize, grad, conf] = edison_wrapper(...
%     im, @RGB2Luv,...
%     'SpatialBandWidth',     spatialBandWidth,...
%     'RangeBandWidth',       rangeBandWidth,...
%     'MinimumRegionArea',    minimumRegionArea ...
%     );
