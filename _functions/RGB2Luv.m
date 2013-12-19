function im_luv = RGB2Luv(im_rgb)
%RGB2LUV returns image converted from RGB to Luv color-space
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [im_rgb] - image in RGB color-space
%@return
%  [im_luv] - image in Luv color-space
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(im_rgb,3) ~= 3
    error('im must have three color channels');
end
if ~isa(im_rgb,'float')
    im_rgb = im2single(im_rgb);
end
if (max(im_rgb(:)) > 1)
    im_rgb = im_rgb./255;
end

XYZ = [.4125 .3576 .1804; .2125 .7154 .0721; .0193 .1192 .9502];
Yn = 1.0;
Lt = .008856;
Up = 0.19784977571475;
Vp = 0.46834507665248;
imsiz = size(im_rgb);
im_rgb = permute(im_rgb,[3 1 2]);
im_rgb = reshape(im_rgb,[3 prod(imsiz(1:2))]);
xyz = reshape((XYZ*im_rgb)',imsiz);
x = xyz(:,:,1);
y = xyz(:,:,2);
z = xyz(:,:,3);

l0 = y./Yn;
l = l0;
l(l0>Lt) = 116.*(l0(l0>Lt).^(1/3)) - 16;
l(l0<=Lt) = 903.3*l0(l0<=Lt);
c = x + 15*y + 3 * z;
u = 4*ones(imsiz(1:2),class(im_rgb));
v = (9/15)*ones(imsiz(1:2),class(im_rgb));
u(c~=0) = 4*x(c~=0)./c(c~=0);
v(c~=0) = 9*y(c~=0)./c(c~=0);

u = 13*l.*(u-Up);
v = 13*l.*(v-Vp);

im_luv = cat(3,l,u,v);

end %fcn