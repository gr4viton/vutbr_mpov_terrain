function [ ftrList ] = GET_features( imOrig, segIm, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [imOrig] - original image
%  [segIm] - segmented image
%  [labels] - indexed image
%  [regsize] - number of pixels in individual segments
%  [imPath] - path to original image
%@return
%  [ftrList] - array of feature-lists of individual segments
% @unused
% - some of mean-shift edison_wrapper input parameters:
%   modes, grad, conf
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%     ftrList(iSegm).modusRed = 0;
%     ftrList(iSegm).modusGreen = 0;
%     ftrList(iSegm).modusBlue = 0;
        ftrList(iSegm).medianRed = 0;
        ftrList(iSegm).medianGreen = 0;
        ftrList(iSegm).medianBlue = 0;
% bounding box features of this cluster        
    ftrList(iSegm).BBwidth = 0; % boundingBox width
    ftrList(iSegm).BBheight = 0; % boundingBox height
    ftrList(iSegm).kurtosis2 = 0; % kurtosis (�ikmost)
    ftrList(iSegm).skewness2 = 0; % skewness (�pi�atost)
    ftrList(iSegm).moment2 = 0; % centr�ln� moment druh�ho ��du
    ftrList(iSegm).moment3 = 0; % centr�ln� moment t�et�ho ��du
    
%     ftrList(i).circumfrnc = 0; % sum of circumferences of individual areas of a segment

% ____________________________________________________
% computation
    % get individual segments of index iSegm
    xlabels = labels; 
    xlabels(xlabels~=iSegm) = 0;
    xlabels = xlabels ./ iSegm; % [one] - segment | [zero] - not segment
%     
    allNonZeroIndex = find(labels==iSegm);
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
%     mask_struct = regionprops(xlabels,'Image');
%     mask = mask_struct.Image;
%     mask = xlabels.Image;
    mask = xlabels;
    mask3 = uint8(cat(3,mask,mask,mask));
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
%     ftrList(iSegm).modusRed     = mode(segmR(logical(mask)));
%     ftrList(iSegm).modusGreen	= mode(segmG(logical(mask)));
%     ftrList(iSegm).modusBlue    = mode(segmB(logical(mask)));
% median segment color from masked original
    ftrList(iSegm).medianRed    = median(segmR(logical(mask)));
    ftrList(iSegm).medianGreen  = median(segmG(logical(mask)));
    ftrList(iSegm).medianBlue   = median(segmB(logical(mask)));

% absolute and relative areas
    ftrList(iSegm).areaSumAbs = regsize(iSegm); %sum(xlabels(:));
    ftrList(iSegm).areaSumRelIm =  ftrList(iSegm).areaSumAbs * 100.0 / imageArea;
    ftrList(iSegm).eulerNum8 = bweuler( uint16(labels) ,8);
    
%% not sure if these are exactly declarative

% get bounding box of this cluster
    xlabels_regprops = regionprops(xlabels,'Image');
    bbox = xlabels_regprops.Image;
    ftrList(iSegm).BBwidth = size(bbox,2);
    ftrList(iSegm).BBheight = size(bbox,1);
% kurtosis
    ftrList(iSegm).kurtosis2 = kurtosis(kurtosis(bbox));
% skewness
    ftrList(iSegm).skewness2 = skewness(skewness(bbox));
% 2 a 3 moment
    ftrList(iSegm).moment2 = moment(moment(bbox,2),2);
    ftrList(iSegm).moment3 = moment(moment(bbox,3),3);
    
    
    %% chce je�t�!!
%     
% dod�l�no: rozptyl barev h-momenty �ikmost ostrost 
% ____________________________________________________

% others
%     histogram
% chist
% hlavni a vedlej�� osa
% orientace
% geometric moment?

% stats for whole image - from meanshift & kmeans?
% elipsoidnost jednotliv�ch? -> nato�en� a tak

%%  asi ne
% v�st�ednost
% podlouhlost - pom�r stran obdeln�ka
% pravo�hlost - maximalni pom�r velikost/plocha obdel
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

end %fcn