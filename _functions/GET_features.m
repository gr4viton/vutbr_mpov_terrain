function [ ftrList ] = GET_features( imOrig, segIm, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ...

%% anonymous functions for index parameters
% featureList([ index ]) - get index of segment from labels(y,x)
fi = @(y,x) labels(y,x)+1;

iSegm_max =  max(labels(:));
% iSegm_sum = iSegm_max - 1;

disp(['    - Number of segments = ', num2str(iSegm_max+1)]);

% predefining the size of featureList
ftrList(iSegm_max).segmIndx = iSegm_max;

% [ featureList(index) ] - get featureList that corresponds to labels(y,x)
% fL = @(y,x) featureList(fi(y,x));
% fL = @(y,x) ftrList(uint16(labels(y,x)+1));
% not functional [pointer to the array of struct] ?

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
% median modus mean from original image segments RGB color
    ftrList(iSegm).meanRed = 0;
    ftrList(iSegm).meanGreen = 0;
    ftrList(iSegm).meanBlue = 0;
        ftrList(iSegm).modusRed = 0;
        ftrList(iSegm).modusGreen = 0;
        ftrList(iSegm).modusBlue = 0;
    ftrList(iSegm).medianRed = 0;
    ftrList(iSegm).medianGreen = 0;
    ftrList(iSegm).medianBlue = 0;

    
%     ftrList(i).circumfrnc = 0; % sum of circumferences of individual areas of a segment

% ____________________________________________________
% computation
    xlabels = labels; 
    xlabels(xlabels~=iSegm) = 0; % get individual segment of index i 
    xlabels = xlabels ./ iSegm; % [one] - segment | [zero] - not segment
    
    allNonZeroIndex = find(xlabels);
%     allZeroIndex = find(xlabels==0);
    
% meanshift end color - the color to which segment iterated to
    firstNonZeroIndex = allNonZeroIndex(1); % find(xlabels, 1, 'first');
    [y, x] = ind2sub(size(xlabels),firstNonZeroIndex);
    ftrList(iSegm).endRed      = segIm( y, x, 1) ;
    ftrList(iSegm).endGreen    = segIm( y, x, 2) ;
    ftrList(iSegm).endBlue     = segIm( y, x, 3) ;
    
% segment of original image    
    mask = xlabels;
    mask3 = uint8(cat(3,xlabels,xlabels,xlabels));
    imOrig_segment = imOrig .* mask3; % masking of original
    % RGB of masked original
    segmR = imOrig_segment(:,:,1);
    segmG = imOrig_segment(:,:,2);
    segmB = imOrig_segment(:,:,3);
%     imshow(imOrig_segment,[]);
% mean segment color from masked original
    ftrList(iSegm).meanRed      = mean(segmR(logical(mask)));
    ftrList(iSegm).meanGreen    = mean(segmG(logical(mask)));
    ftrList(iSegm).meanBlue     = mean(segmB(logical(mask)));
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
    ftrList(iSegm).eulerNum8 = bweuler( uint16(xlabels) ,8);

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

end %function



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
