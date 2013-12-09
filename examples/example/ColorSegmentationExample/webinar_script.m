% %webinar_script.m
% 
% % Copyright 2003-2010 The MathWorks, Inc.
% 
% clear variables, close all      % clean slate
% 
% %----------------------------------------------------------------------
% % Step 1. Explore Image Acquisition hardware inside MATLAB
% %----------------------------------------------------------------------
% % If you do NOT have the Image Acquisition Toolbox, skip to step 3;
% % otherwise, the following code will mostly error.
% % See the MathWorks website to request a trial:
% % <http://www.mathworks.com/web_downloads/>
% %----------------------------------------------------------------------
% 
% % query hardware - installed adaptors?
% info = imaqhwinfo
% 
% % query adaptor - available devices?
% adaptor_info = imaqhwinfo('winvideo')
% 
% % query device - default constructor? 
% device_info = imaqhwinfo('winvideo',1)
% 
% % device info - supported formats?
% device_info.SupportedFormats'
% 
% %----------------------------------------------------------------------
% % Step 2. Acquire video/image data directly into MATLAB
% %----------------------------------------------------------------------
% 
% % connect device (default constructor)
% vid = eval(device_info.ObjectConstructor)
% 
% % configure device using property inpsector
% inspect(vid)
% 
% % examine device properties programmatically
% get(vid,'FramesPerTrigger')
% 
% % configure device properties programmatically
% set(vid,'FramesPerTrigger',4)
% 
% % configure source properties
% src = getselectedsource(vid)
% inspect(src)
% 
% % preview video (set up camera focus, lighting, etc)
% preview(vid)
% 
% % get snapshot
% frame = getsnapshot(vid);
% imshow(frame)
% 
% % start acquisition, get data & display frames
% start(vid)
% frames = getdata(vid);
% imaqmontage(frames)
% 
% % skip first frames
% set(vid,'TriggerFrameDelay',2)
% start(vid)
% frames = getdata(vid);
% imaqmontage(frames)
% 
% % save image to file
% imwrite(frames(:,:,:,end),'last_frame.png','png')
% 
% % clean up
% delete(vid)         % remove video object
% clear variables     % empty workspace of variables
% close all           % close all figure windows

%----------------------------------------------------------------------
% Step 3. Perform color based segmentation
%----------------------------------------------------------------------
% If you do NOT have version 4.0 of the Image Processing Toolbox,
% then some of the following code will not execute without errors.
% See the MathWorks website to request a trial:
% <http://www.mathworks.com/web_downloads/>
%----------------------------------------------------------------------

% load image (colorful fabric acquired with frame grabber and camera)
rgb = imread('Input.jpg');     % Matrox frame grabber + Pulnix camera
imshow(rgb)

% explore color content using image viewer
imtool(rgb)

% smooth image (reduce noise/color variation)
rgb = imfilter(rgb,ones(3,3)/9);
imtool(rgb)

% view image and RGB layers (nonuniform illumination)
figure(1), set(1,'position',[99 79 826 589])
subplot(2,2,1), subimage(rgb), title('fabric image'), axis off
subplot(2,2,2), map=gray(256); map(:,2:3)=0; subimage(rgb(:,:,1),map), title('red layer'), axis off
subplot(2,2,3), map=gray(256); map(:,[1 3])=0; subimage(rgb(:,:,2),map), title('green layer'), axis off
subplot(2,2,4), map=gray(256); map(:,1:2)=0; subimage(rgb(:,:,3),map), title('blue layer'), axis off

% RGB histograms (poor separability)
figure(1), set(1,'position',[452 68 560 420])
figure(2), set(2,'position',[16 269 560 420])
c='rgb';
for i=1:3
  n=hist(reshape(double(rgb(:,:,i)),[480*640 1]),0.5:256);
  line(0:255,n,'color',c(i))
end
axis tight, xlim([0 255]), box on
xlabel intensity, ylabel population, title histograms

% convert image to L*a*b* color space (transform)
cform = makecform('srgb2lab');
lab = applycform(rgb,cform);

% view components (note illumination free)
figure(1), figure(2)
subplot(2,2,1), subimage(rgb), title('fabric image'), axis off
subplot(2,2,2), subimage(lab(:,:,1)), title('L* layer'), axis off
subplot(2,2,3), map=gray(256); map(:,3)=0; map(:,2)=map(end:-1:1,2); subimage(lab(:,:,2),map), title('a* layer'), axis off
subplot(2,2,4), map=gray(256); map(:,3)=map(end:-1:1,3); subimage(lab(:,:,3),map), title('b* layer'), axis off

% select polygon region of interest
figure, imshow(rgb), roipoly

% predefined regions for 6 different colors present
load my_regioncoordinates
figure(3), imshow(rgb)
for i=1:6
  patch(roi(:,1,i),roi(:,2,i),'w','linestyle','none')
end

% predefined regions (everything else suppressed)
mask = false([480 640 6]);
for i=1:6
  mask(:,:,i) = roipoly(rgb,roi(:,1,i),roi(:,2,i));
end
bw=repmat(logical(sum(mask,3)),[1 1 3]);
im=rgb;  im(~bw)=nan;
figure(3), imshow(im)

% color markers (region average values of L*, a* and b*)
l=lab(:,:,1); a=lab(:,:,2); b=lab(:,:,3);
for i = 1:6
  cMark(i,1) = mean2(l(mask(:,:,i)));
  cMark(i,2) = mean2(a(mask(:,:,i)));
  cMark(i,3) = mean2(b(mask(:,:,i)));
end

% classify every pixel using nearest neighbor rule
distance = zeros([480 640 6]);
for i=1:6
  dx=double(a)-cMark(i,2);  dy=double(b)-cMark(i,3);
  distance(:,:,i) = sqrt(dx.^2 + dy.^2);
end
cLabels=0:5;  [value,index]=min(distance,[],3);
label=cLabels(index);

% display segmented image
cMap=double(applycform(uint8(cMark),makecform('lab2srgb')))/255;
figure('position',[9 344 1005 334])
subplot(121), subimage(rgb), title('Original Image'), axis off, 
subplot(122), subimage(label+1,cMap), title('Segmented Image'), axis off

%----------------------------------------------------------------------
% Step 4. Perform statistical analysis on distinct objects
%----------------------------------------------------------------------

% compute histograms & statistics
bins=0.5:20; pop=zeros(length(bins),5);
for i=1:5                               %loop thru each color
  mask = (label==i);                    %segment distinct regions
  L = bwlabel(mask);                    %label region
  stats = regionprops(L,'Area');        %extract areas of each
  A=[stats.Area]; r=sqrt(A/pi);         %convert areas to radii
  pop(:,i) = hist(r,bins)';             %generate histogram
  mu(i)=mean(r); sigma(i)=std(r);       %first order stats
end

% display histograms for each color
figure('position',[303 65 461 241]), h=plot(bins,pop);
for i=1:5, set(h(i),'color',cMap(i+1,:),'linewidth',2), end
xlabel radius, ylabel pop, title histogram
set(gca,'position',[0.13 0.2 0.775 0.65],'color',cMap(1,:)), shg

% zoom Y axis to see scarce, large contributions better
ylim([0 50])

% display first order stats for each color
[dummy,order]=sort(mu);
for index=1:5
  i=order(index);
  text(10,10+7*index,sprintf('\\mu=%.1f, \\sigma=%.1f',mu(i),sigma(i)),...
       'color',cMap(i+1,:),'fontsize',15)
end
