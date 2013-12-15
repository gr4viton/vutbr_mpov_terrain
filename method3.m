function [out] = method3(im, marg, stats)
%read Image file
[pathstr,name,ext] = fileparts(im);
ImageFilename=[name,ext];
I = imread(im);
% out_folder =  'out\';
%% Create the gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian',[5 5],2);
I = imfilter(I,G,'same');
%% calculate Mean Shift
[fimg, labels, modes, regsize, grad, conf] = edison_wrapper(I,@RGB2Luv,...
      'SpatialBandWidth',100,'RangeBandWidth',5,...
      'MinimumRegionArea',50);
% subplot(2,1,1), imshow(I); subplot(2,1,2), imshow(Luv2RGB(fimg));

%% calculate statistical data
% imhist(labels)
statistics=zeros(max(labels(:))+1,1);
for i=1:size(labels,1)
    for j=1:size(labels,2)
        statistics(labels(i,j)+1)=statistics(labels(i,j)+1)+1;
    end
end
percentage = 100*statistics/ (size(I,1)* size(I,2));
%% write statistical data to file
if(stats==1)
    Data = ['MPOV segmentation statiscics for file: ',ImageFilename,'\n'];
    fid = fopen(strcat('statisctics-',ImageFilename,'.txt'),'w');
    for i=1:size(statistics,1)
        Data = [Data,'Segment ',int2str(i),':','    ',sprintf('%.2f',percentage(i)),'%%\n'];
    end
    fprintf(fid,Data);
    fclose(fid);
    imwrite(Luv2RGB(fimg),['segm_',ImageFilename]);
    imwrite(imadjust(uint8(labels),stretchlim(uint8(labels)),[]),['indx_',ImageFilename]);
end
out=(Luv2RGB(fimg));
end