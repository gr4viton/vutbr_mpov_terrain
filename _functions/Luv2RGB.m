function im_rgb = Luv2RGB(im_luv)
%LUV2RGB returns image converted from Luv to RGB color-space
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [im_luv] - image in Luv color-space
%@return
%  [im_rgb] - image in RGB color-space
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(im_luv,3) ~= 3
    error('im must have three color channels');
end
if ~isa(im_luv,'float')
    im_luv = im2single(im_luv);
end
imsiz = size(im_luv);

RGB = [ 3.2405, -1.5371, -0.4985 ; ...
    -0.9693,  1.8760,  0.0416 ; ...
    0.0556, -0.2040,  1.0573 ];
Up = 0.19784977571475;
Vp = 0.46834507665248;
Yn = 1.00000;

l = im_luv(:,:,1);

y = Yn*l./903.3;
y(l>.8) = (l(l>.8)+16)/116;
y(l>.8) = Yn*(y(l>.8)).^3;

u = Up+im_luv(:,:,2)./(13*l);
v = Vp+im_luv(:,:,3)./(13*l);

x = 9*u.*y./(4*v);
z = (12-3*u-20*v).*y./(4*v);

im_rgb = RGB*reshape(permute(cat(3, x, y, z),[3 1 2]),[3 prod(imsiz(1:2))]);
im_rgb = reshape(im_rgb',imsiz);

zr = find(l < .1);
im_rgb([zr zr+prod(imsiz(1:2)) zr+2*prod(imsiz(1:2))]) = 0;
im_rgb = min(im_rgb,1);
im_rgb = max(im_rgb,0);

end %fcn