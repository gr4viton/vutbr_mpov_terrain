function [ featureList ] = GET_features( segim, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ...

featureList = struct( ...
    'areaSumRel', 1,...
    'areaSumAbs', 1,...
    'circumfrnc', 1,...
    'eulerNum', 1 ...
);

% imhist(labels)
% percent of image
stats = zeros(max(labels(:))+1,1);
% count num of pixels in area
% boxWidth
% boxHeight
% geometric moment?
% mean color RGB - of default image or segmented color => is it the same?
% 
for i = 1:size(labels,1)
    for j = 1:size(labels,2)
        stats(labels(i,j)+1)=stats(labels(i,j)+1)+1;
    end
end
% 
% stats for whole image - from meanshift & kmeans?

stat_i.areaSumRel = 100*stats/ (size(segim,1) * size(segim,2));

% stats for individual segments


% mi je to jedno, øekni kdy a kde a já tam dojedu pokud nebudu zrovna na zkoušce ;)



% stats.percentage
end

