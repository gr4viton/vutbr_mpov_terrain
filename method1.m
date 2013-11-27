function [out] = method1(im, marg)

addpath(genpath('..\subtightplot'));
subplot2 = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.05 0.01], [0.01 0.01]);


bg = imopen(im,strel('disk',15));
bg2 = imfilter(bg, fspecial('gaussian',30,30) );
im_wo_bg = im - bg2;
for i=1:3
    im_adj(:,:,i) = imadjust(im_wo_bg(:,:,i));
    level(i) = graythresh(im_adj(:,:,i));
    im_bw(:,:,i) = im2bw(im_adj(:,:,i),level(i));
    im_bw2(:,:,i) = bwareaopen(im_bw(:,:,i), 50);
end

im_bw = uint8(im_bw*255);
im_bw2 = uint8(im_bw2*255);

im_bw3 = rgb2gray(im_bw2);
im_bw4 = imclose(im_bw3,strel('disk',2));

level = graythresh(im_bw4);
im_bw5 = im2bw(im_bw4,level);
im_bw6 = bwareaopen(im_bw5, 50);

im_bw6 = im_bw6(marg:end-marg, marg:end-marg,:);
im_bw6 = imclose(im_bw6,strel('disk',10));

cc = bwconncomp(im_bw6, 4);
labeled = labelmatrix(cc);
imrgb = label2rgb(labeled, @spring, 'c', 'shuffle');


im_bw4 = uint8(im_bw4.*255);
im_bw5 = uint8(im_bw5.*255);
im_bw6 = uint8(im_bw6.*255);
% cc = uint8(cc.*255);
out(:,:) = imrgb(:,:);

%% printing
global FI;

FI=FI+1; figure(FI);  x = 4; y = 3; SI = 0;
% imshow(im,[]); title(strcat('original')); axis tight

SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('original')); axis tight

im = bg;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('bg')); axis tight

im = im_wo_bg;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_wo_bg')); axis tight

im = im_adj;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_adj')); axis tight

im = im_bw;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw2')); axis tight

im = im_bw2;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw2')); axis tight

im = im_bw3;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw3')); axis tight

im = im_bw4;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw4')); axis tight

im = im_bw5;
SI=SI+1; subplot2(y,x,SI);
imshow(im,[]); title(strcat('im_bw5')); axis tight

im = im_bw6;
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

