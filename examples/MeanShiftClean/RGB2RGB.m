function rgb = RGB2RGB(im)

if size(im,3) ~= 3
    error('im must have three color channels');
end
if ~isa(im,'float')
    im = im2single(im);
end
if (max(im(:)) > 1)
    im = im./255;
end

rgb =im;

