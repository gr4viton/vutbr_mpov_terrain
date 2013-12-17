function [ ftrList ] = GET_features( segIm, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ...

%% anonymous functions for index parameters
% featureList([ index ]) - get index of segment from labels(y,x)
fi = @(y,x) labels(y,x)+1;

iSegm_max =  max(labels(:));
% iSegm_sum = iSegm_max - 1;

disp(['    - Number of segments = ', num2str(iSegm_max+1)]);

% predefining the size of featureList
ftrList(iSegm_max).segmentIndex = iSegm_max;

% [ featureList(index) ] - get featureList that corresponds to labels(y,x)
% fL = @(y,x) featureList(fi(y,x));
% fL = @(y,x) ftrList(uint16(labels(y,x)+1));
% not functional [pointer to the array of struct] ?

%% nope
% for i = 1:fi_max
%     disp([ 'featureList(',num2str(i),')=',num2str( ftrList(i).areaSumAbs ) ])
% end
    imageArea = size(segIm,1)*size(segIm,2);
    
        
%% first loop through - for inicializing zero values and count the one-loop countable features
for iSegm = 1:iSegm_max
% stats for segments as for a group of areas
    
% ____________________________________________________
% inicialization
    ftrList(iSegm).segmentIndex = iSegm; % segment index number
    ftrList(iSegm).areaSumAbs = 0; % sum of all the pixels
    ftrList(iSegm).areaSumRel = 0.0; % area sum relatively to the others - max area = [100%]
    ftrList(iSegm).areaSumRelIm = 0.0; % area sum relatively to whole image = [x%]
    ftrList(iSegm).eulerNum8 = 0; % eulers number of a segment = genus (8-neighbor)
    ftrList(iSegm).red = 0; % segment meanshift red color [0->1]
    ftrList(iSegm).green = 0; % segment meanshift green color [0->1]
    ftrList(iSegm).blue = 0; % segment meanshift blue color [0->1]
    
%     ftrList(i).circumfrnc = 0; % sum of circumferences of individual areas of a segment

% ____________________________________________________
% computation
    xlabels = labels; 
    xlabels(xlabels~=iSegm) = 0; % get individual segment of index i - 
    % on the pixels of segment in the picture is the index of segment
    
    firstNonZeroIndex = find(xlabels, 1, 'first');
    [y, x] = ind2sub(size(xlabels),firstNonZeroIndex)
    ftrList(iSegm).red      = segIm( y, x, 1) ;
    ftrList(iSegm).green    = segIm( y, x, 2) ;
    ftrList(iSegm).blue     = segIm( y, x, 3) ;
    
    ftrList(iSegm).areaSumAbs = sum(xlabels(:)) ./ iSegm;
    ftrList(iSegm).areaSumRelIm =  ftrList(iSegm).areaSumAbs * 100.0 / imageArea;
    ftrList(iSegm).eulerNum8 = bweuler( uint16(xlabels) ,8);

% ____________________________________________________
% others

%     histogram
% chist
% hlavni a vedlejší osa
% orientace
% geometric moment?

% mean color RGB - of default image or segmented color => is it the same?
% stats for whole image - from meanshift & kmeans?
% elipsoidnost jednotlivých? -> natoèení a tak

%%  asi ne
% výstøednost
% podlouhlost - pomìr stran obdelníka
% pravoúhlost - maximalni pomìr velikost/plocha obdel
% convex circumference 
% boxWidth
% boxHeight
end

%% second loop through
% [areaSumAbs_maxVal, areaSumAbs_maxIndex]  = max([ ftrList(iSegm).areaSumAbs ]);
areaSumAbs_maxVal  = max([ ftrList.areaSumAbs ]);

for iSegm = 1:iSegm_max
    % area sum relatively to the others - min area = 1
    ftrList(iSegm).areaSumRel = ftrList(iSegm).areaSumAbs * 100.0 / areaSumAbs_maxVal; 
end

%% euler number testing
% figure(51);
% SI = 0;
% SX=4;SY=3;
% for i = 1:fi_max
%     xlabels = labels;
%     xlabels(xlabels~=i) = 0;
%     eul1 = bweuler( uint16(xlabels) ,8);
%     im = uint16(xlabels);
%         SI=SI+1; subplot(SY,SX,SI);
%         imshow(im,[]); 
%         title(strcat('i[',num2str(i),'] eul = ',num2str(eul1),'')); axis tight
% end


% eulerNum - genus

% all_areaSumAbs_values = [featureList.areaSumAbs]
% bar([ftrList.eulerNum]); 
% bar(all_areaSumAbs_values);

disp(ftrList);
end

