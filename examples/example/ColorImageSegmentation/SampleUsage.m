
%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Clear Memory & Command Window
clc;
clear all;
close all;


%Parameters for the Segmentation
nBins=5;
winSize=7;
nClass=6;

%Read Input Image
inImg = imread('Input.jpg');
imshow(inImg);title('Input Image');

%Segmentation
outImg = colImgSeg(inImg, nBins, winSize, nClass);

%Displaying Output
figure;imshow(outImg);title('Segmentation Maps');
colormap('default');

