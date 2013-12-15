% WINDOW = CUTOUT(DATA, POS, HR, HS, D);
%
%   Function returns all elements of M x N x Dim1 x .. x DimD matrix
%   DATA, that lie inside elipsoid with radius HR, HR, HS, .. , HS with
%   center POS.
%
function window = cutout(data, pos, hr, hs, d)

if nargin<5
   d = size(data,3);
end;

% find spatial window boundaries
tlx = max(1, floor(pos(1)-hr)); brx = min(size(data,2), ceil(pos(1)+hr));
tly = max(1, floor(pos(2)-hr)); bry = min(size(data,1), ceil(pos(2)+hr));

% prepare spatial window ranges
[gx gy] = meshgrid(tlx:brx, tly:bry);

% gather window data by reshaping spatial coordinates and reshaping the
% rest of dimensions, also normalise coordinates using hr and hs
window = [double(gx(:))/hr double(gy(:))/hr double(reshape(data(tly:bry, tlx:brx, :), [], d))/hs];

% normalise
middle = [pos(1:2)/hr, pos(3:end)/hs]; pos = repmat(middle(:)', size(window, 1), 1);

% find indexes inside unit circle
idxs = sum((window - pos).^2,2)<1.0;

% rescale relevant data back, can be replaced by scaling the mean
% apropriately 
window = [window(idxs,1:2)*hr, window(idxs,3:end)*hs];