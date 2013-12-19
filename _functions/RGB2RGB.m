function im_rgbFloat = RGB2RGB(im_rgbNotFloat)
%RGB2LUV returns image converted from its bounds to new bounds (0:1)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [im_rgbNotFloat] - image in RGB color-space with values 0:(not-zero)
%@return
%  [im_rgbFloat] - image in RGB color-space with values 0:1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(im_rgbNotFloat,3) ~= 3
    error('im must have three color channels');
end
if ~isa(im_rgbNotFloat,'float')
    im_rgbNotFloat = im2single(im_rgbNotFloat);
end
max_im = max(im_rgbNotFloat(:));
if (max_im > 1)
    im_rgbNotFloat = im_rgbNotFloat./max_im;
end

im_rgbFloat =im_rgbNotFloat;

