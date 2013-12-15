% I = imread('map1.png');
% [fimg labels modes regsize grad conf] = edison_wrapper(I,@RGB2Luv);
% imshow(Luv2RGB(fimg))

%% This sets some specific parameters and segments the gantrycrane image
I = imread('../../pic/small.png');
% [fimg labels modes regsize grad conf] = edison_wrapper(I,@RGB2Luv,...
%       'SpatialBandWidth',8,'RangeBandWidth',4,...
%       'MinimumRegionArea',200);
% subplot(2,1,1), imshow(I); subplot(2,1,2), imshow(Luv2RGB(fimg));

%# Create the gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian',[5 5],2);
I = imfilter(I,G,'same');

[fimg, labels, modes, regsize, grad, conf] = edison_wrapper(I,@RGB2Luv,...
      'SpatialBandWidth',400,'RangeBandWidth',5,...
      'MinimumRegionArea',100);
subplot(2,1,1), imshow(I); subplot(2,1,2), imshow(Luv2RGB(fimg));

%% calculate statistical data
imhist(labels)
statistics=zeros(max(labels(:))+1,1)
for i=1:size(labels,1)
    for j=1:size(labels,2)
        statistics(labels(i,j)+1)=statistics(labels(i,j)+1)+1;
    end
end

%% print statistical data
percentage = 100*statistics/ (size(I,1)* size(I,2))