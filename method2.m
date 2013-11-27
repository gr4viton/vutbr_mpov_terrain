function [out] = method2(im, marg)

addpath(genpath('..\subtightplot'));
subplot2 = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.05 0.01], [0.01 0.01]);

%labspace
cform = makecform('srgb2lab');
im1 = applycform(im,cform);
 
%classifie colors
ab = double(im1(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);

im2 = reshape(cluster_idx,nrows,ncols);
% imshow(im3,[]), title('image labeled by cluster index');

% im_bw6 = uint8(im_bw6.*255);
% cc = uint8(cc.*255);
out(:,:) = im1(:,:);

%% printing
global FI;

FI=FI+1; figure(FI);  x = 2; y = 3; SI = 0;
% imshow(im,[]); title(strcat('original')); axis tight

SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('original')); axis tight

im = im1;
SI=SI+1; subplot2(y,x,SI);
imshow(im1,[]); title(strcat('1')); axis tight

im = im2;
SI=SI+1; subplot2(y,x,SI);
imshow(im2,[]); title(strcat('2')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('3')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw2')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw3')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw4')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw5')); axis tight

im = im;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw6')); axis tight


% im = cc;
% SI=SI+1; subplot2(y,x,SI);
% imshow(im,[]); title(strcat('cc')); axis tight


im = imrgb;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('irgb')); axis tight

% FI=FI+1; figure(FI);  x = 1; y = 2; SI = 0;
% SI=SI+1; subplot2(y,x,SI);
% pcolor(double(bg(1:8:end,1:8:end))),zlim([0 255]);
% set(gca,'ydir','reverse');
% 
% SI=SI+1; subplot2(y,x,SI);
% pcolor(double(bg2(1:8:end,1:8:end))),zlim([0 255]);
% set(gca,'ydir','reverse');





% out = 1

