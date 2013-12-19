function [ prepIm ] = PRE_processImage( im, doFigures )
%PRE_PROCEESSIMAGE apply Gaussian filter with parameters derived from resolution
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @param[in]  
%   [im] | image to preprocess
%   [doFigures] | whether to plot images
% @return
%   prepIm | preprocessed image
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% "empirical" parameters to filter
rng_min = 2; sgm_min = 1.5;
rng_max = 4; sgm_max = 2;


allPx = size(im,1)*size(im,2);

if( allPx >= 10^6 )
% for images larger than 1MPx use always gauss with rng_max, sgm_max
    rng = rng_max;
    sgm = sgm_max;
else
% for smaller images use interpolation between [rng_max, sgm_max] and [rng_min, sgm_min]
    rng = rng_min + (rng_max-rng_min) * (allPx/10^6)^1; %
    sgm = sgm_min + (sgm_max-sgm_min) * (allPx/10^6)^1; % quadratic
end

%% apply Gaussian filter
G = fspecial('gaussian', round(rng), sgm);
prepIm = imfilter(im, G, 'replicate', 'same');


%% draw preprocessed image
if(doFigures==1)
    tit = ['Preprocessed[',num2str(size(im,1)),'×',num2str(size(im,2)),...
        ']px;[r=',num2str(round(rng)),';s=',num2str(sgm),']'];
    DRAW_image(prepIm,  tit);
end

end %fce

