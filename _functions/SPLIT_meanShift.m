function [segImRGB, labels, modes, regsize, grad, conf] ...
    = SPLIT_meanShift(im)

%% preprocessing - apply Gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian', [5 5], 2);
im = imfilter(im, G, 'same');

%% set parameters for mean shift
% count from image resolution etc
spatialBandWidth = 100;
rangeBandWidth = 5;
minimumRegionArea = 50;
% margin = max(size(im_orig)) * 0.01;

%% calculate Mean Shift
[fimg, labels, modes, regsize, grad, conf] = edison_wrapper(...
    im, @RGB2Luv,...
    'SpatialBandWidth',     spatialBandWidth,...
    'RangeBandWidth',       rangeBandWidth,...
    'MinimumRegionArea',    minimumRegionArea ...
    );

segImRGB = Luv2RGB(fimg);

end