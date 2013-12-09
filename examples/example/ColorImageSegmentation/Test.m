clc

clear all

close all

warning off




% 
% [filename, pathname] = uigetfile( {'*.jpg',  'Jpg Image File (*.JPG)'}, ...
% 
%    'Read a file'); 

file = 'Input.jpg'; 

IM = im2double(rgb2gray(imread(file)));



figure;imshow(IM,[]);



% load IM



[r c] = size(IM);



data = IM(:);

[center,U,obj_fcn] = fcm(data,6); % Fuzzy C-means classification with 4 classes

         

% Finding the pixels for each class

maxU = max(U);

index1 = find(U(1,:) == maxU);

index2 = find(U(2,:) == maxU);

index3 = find(U(3,:) == maxU);

index4 = find(U(4,:) == maxU);



% Assigning pixel to each class by giving them a specific value

fcmImage(1:length(data))=0;       

fcmImage(index1)= 1;

fcmImage(index2)= 0.66;

fcmImage(index3)= 0.33;

fcmImage(index4)= 0.0;





% Reshapeing the array to a image

imagNew = reshape(fcmImage,r,c);

figure;imshow(imagNew,[]);



gradmag = imagNew;

g = gradmag - min(gradmag(:));

g = g / max(g(:));



th = graythresh(g); %# Otsu's method.

a = imhmax(g,th/2); %# Conservatively remove local maxima.

th = graythresh(a);

b = a > th/4; %# Conservative global threshold.

c = imclose(b,ones(8)); %# Try to close contours.

d = imfill(c,'holes'); %# Not a bad segmentation by itself.

%# Use the rough segmentation to define markers.

g2 = imimposemin(g, ~ imdilate( bwperim(a), ones(4) ));

L = watershed(g2);

Lrgb = label2rgb(L);

figure;imshow(Lrgb,[]);
