function [segImRGB, labels, modes, regsize, grad, conf] ...
    = SPLIT_meanShift(im)

%% resolution ~ execution time
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