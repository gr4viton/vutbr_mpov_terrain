function [ ftrList ] = GET_features( imOrig, segIm, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ... delete some unused parameters

tic;
disp('  * Calculating feature list for individual segments');

%% initializations
iSegm_max =  max(labels(:));
disp(['    - Number of segments = ', num2str(iSegm_max+1)]);

% predefining the size of featureList
ftrList(iSegm_max).segmIndx = iSegm_max;

imageArea = size(segIm,1)*size(segIm,2);
        
%% first loop through - for inicializing zero values and count the one-loop countable features
for iSegm = 1:iSegm_max
% stats for segments as for a group of areas
    
% ____________________________________________________
% inicialization (in this order they will show up in the header in stats file
    ftrList(iSegm).segmIndx = iSegm; % segment index number
    ftrList(iSegm).areaSumAbs = 0; % sum of all the pixels
    ftrList(iSegm).areaSumRel = 0.0; % area sum relatively to the others - max area = [100%]
    ftrList(iSegm).areaSumRelIm = 0.0; % area sum relatively to whole image = [x%]
    ftrList(iSegm).eulerNum8 = 0; % eulers number of a segment = genus (8-neighbor)
% meanshift-end RGB color [0->1]
    ftrList(iSegm).endRed = 0;
    ftrList(iSegm).endGreen = 0;
    ftrList(iSegm).endBlue = 0;
% mean & std of this segment with original colors 
    ftrList(iSegm).meanRed = 0;
    ftrList(iSegm).meanGreen = 0;
    ftrList(iSegm).meanBlue = 0;
        ftrList(iSegm).stdRed = 0;
        ftrList(iSegm).stdGreen = 0;
        ftrList(iSegm).stdBlue = 0;
% modus & median of this segment with original colors 
    ftrList(iSegm).modusRed = 0;
    ftrList(iSegm).modusGreen = 0;
    ftrList(iSegm).modusBlue = 0;
        ftrList(iSegm).medianRed = 0;
        ftrList(iSegm).medianGreen = 0;
        ftrList(iSegm).medianBlue = 0;

    
%     ftrList(i).circumfrnc = 0; % sum of circumferences of individual areas of a segment

% ____________________________________________________
% computation
    % get individual segments of index iSegm
%     xlabels = labels; 
%     xlabels(xlabels~=iSegm) = 0;
%     xlabels = xlabels ./ iSegm; % [one] - segment | [zero] - not segment
%     
    allNonZeroIndex = find(labels==iSegm);
%     allZeroIndex = find(xlabels==0);
    if( numel(allNonZeroIndex) == 0)
        disp(['Indexation error - segment[',num2str(iSegm),'] index number has no pixels attached!']);
        break;
    end
% meanshift end color - the color to which segment iterated to
    firstNonZeroIndex = allNonZeroIndex(1); % find(xlabels, 1, 'first');
    [y, x] = ind2sub(size(labels),firstNonZeroIndex);
    ftrList(iSegm).endRed      = segIm( y, x, 1) ;
    ftrList(iSegm).endGreen    = segIm( y, x, 2) ;
    ftrList(iSegm).endBlue     = segIm( y, x, 3) ;
    
% segment of original image    
    mask = labels;
    mask3 = uint8(cat(3,labels,labels,labels));
    imOrig_segment = imOrig .* mask3; % masking of original
    % RGB of masked original
    segmR = imOrig_segment(:,:,1);
    segmG = imOrig_segment(:,:,2);
    segmB = imOrig_segment(:,:,3);
    
    d_segmR = double(segmR);
    d_segmG = double(segmG);
    d_segmB = double(segmB);
%     imshow(imOrig_segment,[]);
% mean segment color from masked original
    ftrList(iSegm).meanRed      = mean(segmR(logical(mask)));
    ftrList(iSegm).meanGreen    = mean(segmG(logical(mask)));
    ftrList(iSegm).meanBlue     = mean(segmB(logical(mask)));
% standard deviation of segment color from masked original
    ftrList(iSegm).stdRed      = std(d_segmR(logical(mask)));
    ftrList(iSegm).stdGreen    = std(d_segmG(logical(mask)));
    ftrList(iSegm).stdBlue     = std(d_segmB(logical(mask)));
% modus segment color from masked original    
    ftrList(iSegm).modusRed     = mode(segmR(logical(mask)));
    ftrList(iSegm).modusGreen	= mode(segmG(logical(mask)));
    ftrList(iSegm).modusBlue    = mode(segmB(logical(mask)));
% median segment color from masked original
    ftrList(iSegm).medianRed    = median(segmR(logical(mask)));
    ftrList(iSegm).medianGreen  = median(segmG(logical(mask)));
    ftrList(iSegm).medianBlue   = median(segmB(logical(mask)));

% absolute and relative areas
    ftrList(iSegm).areaSumAbs = regsize(iSegm); %sum(xlabels(:));
    ftrList(iSegm).areaSumRelIm =  ftrList(iSegm).areaSumAbs * 100.0 / imageArea;
    ftrList(iSegm).eulerNum8 = bweuler( uint16(labels) ,8);

    %% chce ještì!!
%     h-momenty šikmost ostrost a rozptyl barev
% ____________________________________________________

% others
%     histogram
% chist
% hlavni a vedlejší osa
% orientace
% geometric moment?

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

% display feature list fields = individual feature names
% disp(ftrList);

disp(['    - Done in ',num2str(toc),'s']);

end %function


