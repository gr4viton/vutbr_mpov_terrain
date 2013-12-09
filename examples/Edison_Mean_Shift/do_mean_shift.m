%do_meanshift
clear all
I = imread('map1.png');
[fimg labels modes regsize grad conf] = edison_wrapper(I,@RGB2Luv);
imshow(Luv2RGB(fimg)); 
%% Modes in Luv to RGB
% Modes are saved in Luv format because the input was given as RGB2Luv
% Now if we want to know the mode in RGB we have to use Luv2RGB. Before
% that convert 3xN mode into 1xPx3 format so that we can call Luv2RGB
number_of_clusters=size(modes,2);
modes_1xPx3 = reshape(modes,[1 number_of_clusters 3]);
% The following (modes_RGB) are the representative colors
modes_RGB=Luv2RGB(modes_1xPx3);
modes_RGB_uint8=im2uint8(modes_RGB);
imshow(modes_RGB_uint8);

% find the location (corrdinate) with biggest to bigger regions and pick
% some colors from there! those are representative colors!