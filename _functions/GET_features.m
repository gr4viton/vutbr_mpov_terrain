function [ ftrList ] = GET_features( segim, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ...

%% anonymous functions for index parameters
% featureList([ index ]) - get index of segment from labels(y,x)
fi = @(y,x) labels(y,x)+1;
fi_max = max(labels(:)) + 1;

disp(['>>>>> Number of segments = ', num2str(fi_max+1)]);

% predefining the size of featureList
ftrList(fi_max+1).areaSumAbs = 0;

% [ featureList(index) ] - get featureList that corresponds to labels(y,x)
% fL = @(y,x) featureList(fi(y,x));
% fL = @(y,x) ftrList(uint16(labels(y,x)+1));
% not functional [pointer to the array of struct] ?

for i = 1:fi_max
    % stats for segments as for a group of areas
    ftrList(i).areaSumAbs = 0; % sum of all the pixels
    ftrList(1).areaSumRelIm = 0; % area sum relatively to whole image
    ftrList(1).areaSumRelIm = 0; % area sum relatively to the others - min area = 1
    ftrList(1).circumfrnc = 0; % sum of circumferences of individual areas of a segment
    ftrList(1).eulerNum = 0; % eulers number of a segment
%     histogram
% chist
    % convex circumference ? 
    % count num of pixels in area
    % boxWidth
    % boxHeight
    % geometric moment?
    % mean color RGB - of default image or segmented color => is it the same?
    % stats for whole image - from meanshift & kmeans?
end

for y = 1:size(labels,1)
    for x = 1:size(labels,2)
        ftrList(fi(y,x)).areaSumAbs = ftrList(fi(y,x)).areaSumAbs + 1;
    end
end

% all_areaSumAbs_values = [featureList.areaSumAbs]
% bar([ftrList.areaSumAbs]); 
% bar(all_areaSumAbs_values);

disp(ftrList);

% for i = 1:fi_max
%     disp([ 'featureList(',num2str(i),')=',num2str( featureList(i).areaSumAbs ) ])
% end
% percent of image
        
% stat_i.areaSumRel = 100*stats/ (size(segim,1) * size(segim,2));

% elipsoidnost jednotlivých? -> natoèení a tak
% 


% mi je to jedno, øekni kdy a kde a já tam dojedu pokud nebudu zrovna na zkoušce ;)



% stats.percentage


end

