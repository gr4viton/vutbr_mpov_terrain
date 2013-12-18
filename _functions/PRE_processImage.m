function [ prepIm ] = PRE_processImage( im )
%PRE_PROCEESSIMAGE Summary of this function goes here
%   Detailed explanation goes here

% debug
global SI;
global SX;
global SY;
SI= 0; SX = 2;SY = 3;
imMax = imread(im);

% for sc=logspace( 0, -1, 4);
% for sc=linspace( 0.1, 1, 8);
for sc=linspace( 1, 2, 2);
    
im = imresize( imMax, sc );
% im = imresize(im, 0.2);
tit = ['scaled image; scale=',num2str(sc),'']
DRAW_image(im, tit);
nummm = size(im,1)*size(im,2)



%% preprocessing - apply Gaussian filter with hsize = [5 5] and sigma = 2
% for image resolutions which are higher then
% [5 5], 2


rng_min = 1; sgm_min = 1.5;
rng_max = 4; sgm_max = 2;

% "empirical"
allPx = size(im,1)*size(im,2);
if( allPx >= 10^6 )
% for images larger than 1MPx use always gauss with rng_max, sgm_max
    rng = rng_max;
    sgm = sgm_max;
else
% for smaller images use interpolation between [rng_max, sgm_max] and [rng_min, sgm_min]
    rng = rng_min +  (rng_max-rng_min) * (allPx/10^6)^1; %
%     range = floor(range);
    sgm = sgm_min + (sgm_max-sgm_min) * (allPx/10^6)^1; % quadratic
end

G = fspecial('gaussian', round(rng), sgm);
prepIm = imfilter(im, G, 'same');


tit = ['resolution =',num2str(nummm),';range=',num2str(rng),'; sigma=',num2str(sgm),'']
im = prepIm;
DRAW_image(im,  tit);
end %for

% debug end


end

