function [] = DRAW_image( im, title_str )
%DRAW_IMAGE Summary of this function goes here
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @param[in]  im | image to subplot imshow
% @param[in]  title_str | title to show
% optional global parameters global SX; global SY; global SI;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SX; global SY; global SI;
if SX <= 0
    SX = 1;
end
if SY <= 0
    SY = 1;
end
if SI < 0
    SI = 1;
end
%% subtightplot2
% make_it_tight = true;
addpath(genpath('.\subtightplot'));
subplot2 = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.02 0.05], [0.01 0.01]);
% if ~make_it_tight,  clear subplot;  end

%% draw
    SI=SI+1; subplot2(SY,SX,SI);
    imshow(im,[]); title(title_str); axis tight
end %fcn
