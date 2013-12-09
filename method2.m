% function [out] = method2(a_im)
close all; clear; clc;
% global FI;
i = 1; 
sob1 = imread(strcat('pic\smap',num2str(i),'.png')); i=i+1;
% sob1 = imresize(sob1, 0.42);
a_im = sob1;

addpath(genpath('..\subtightplot'));
subplot2 = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.05 0.01], [0.01 0.01]);

%% printing
global FI;

%% original
FI=FI+1; figure(FI);  x = 3; y = 3; SI = 0;

im = a_im;
    SI=SI+1; subplot2(y,x,SI);
    imshow(im,[]); title(strcat('original')); axis tight

%% labspace
cform = makecform('srgb2lab');
im1_lab = applycform(im,cform);
im = im1_lab;
    SI=SI+1; subplot2(y,x,SI);
    imshow(im,[]); title(strcat('original')); axis tight

%% classify colors
ab = double(im1_lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 6;
kmeans_repetitions = 4;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center, sumd] = kmeans( ...
    ab,nColors,'distance','sqEuclidean', ...
    'replicates',kmeans_repetitions); %, ...
%     'start', 'cluster');

pixel_labels = reshape(cluster_idx,nrows,ncols);

%% colorize pixel labels
cols = hot(nColors);

colored_labels = cat(3, pixel_labels, pixel_labels, pixel_labels);
im = uint8(colored_labels*255/nColors);
    SI=SI+1; subplot2(y,x,SI);
    imshow(im,[]); title(strcat('colored_labels')); axis tight
    
    
%     collabs = repmat(colored_labels, 1, nColors);
% cc(:,:,:,1:nColors) = colored_labels(:,:,:).*0;

for i=1:nColors
    b = (colored_labels==i);
    for col=1:3
        cc(:,:,col,i) = colored_labels(:,:,col).*b(:,:,col).*cols(i,col);
    end
   
%     im = cc(:,:,:,i);
%         SI=SI+1; subplot2(y,x,SI);
%         imshow(im,[]); title(strcat('imaex')); axis tight 
    
%     a = colored_labels(colored_labels==i); % = cols(i);
%     colored_labels = uint8(colored_labels);
end
colored_labels = uint8(sum(cc,4)/nColors*255);

im = colored_labels;
    SI=SI+1; subplot2(y,x,SI);
    imshow(im,[]); title(strcat('colored labels')); axis tight; 

%     a = 0.9;
for a= 0.1:0.2:0.9
    colored_image = imlincomb(a, colored_labels, 1-a, uint8(a_im));
    im = colored_image;
        SI=SI+1; subplot2(y,x,SI);
        imshow(im,[]); title(strcat('linear combination of original image [', ...
            num2str(1-a),'] and colored labels [',num2str(a),']')); axis tight
end
    
 %% segment images
 
% segmented_images = cell(1,nColors);
% rgb_label = repmat(pixel_labels,[1 1 3]);
% 
% for k = 1:nColors
%     color = a_im;
%     color(rgb_label ~= k) = 0;
%     segmented_images{k} = color;
% end

% for i=1:nColors
%     im = segmented_images{i};
%         SI=SI+1; subplot2(y,x,SI);
%         imshow(im,[]); title(strcat('objects in cluster ',num2str(i))); axis tight
% end