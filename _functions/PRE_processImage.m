function [ prepIm ] = PRE_processImage( im, doFigures )
%PRE_PROCEESSIMAGE apply Gaussian filter with parameters derived from resolution
%   ...

%% "empirical" parameters to filter
rng_min = 1; sgm_min = 1.5;
rng_max = 4; sgm_max = 2;


allPx = size(im,1)*size(im,2);

if( allPx >= 10^6 )
% for images larger than 1MPx use always gauss with rng_max, sgm_max
    rng = rng_max;
    sgm = sgm_max;
else
% for smaller images use interpolation between [rng_max, sgm_max] and [rng_min, sgm_min]
    rng = rng_min +  (rng_max-rng_min) * (allPx/10^6)^1; %
    sgm = sgm_min + (sgm_max-sgm_min) * (allPx/10^6)^1; % quadratic
end

%% apply Gaussian filter
G = fspecial('gaussian', round(rng), sgm);
prepIm = imfilter(im, G, 'same');


%% draw preprocessed image
if(doFigures==1)
    tit = ['Preprocessed image [r=',num2str(rng),';s=',num2str(sgm),']'];
    DRAW_image(prepIm,  tit);
end

end %fce

