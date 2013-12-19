function [fusedSegImLUV,fusedSegImRGB,fusedSegImIndx, shrinkedSegmentCount] = ...
    SHRINK_numOfSegments(labels, segImLUV, doFigures, treshold, iShrink)
%SHRINK_numOfSegments Shrink feature-close segments togeather
%@brief     this function shirnks the number of segments
%           as the parameters of different segmented areas are alike
%           reindex some of groups with common color parameters to same index 
%@param[in] [im_indx] image with many indexed segments 
%           (optional?) -do not need image of segments or only segments colors?
%           [im_indx_RGB] matrix with RGB color
%@return    [fusedSegIm] image with lesser count of indexed segments

% plotting
global FI;
plotIndividualClusters = 0;

%% initializations

% treshold distance - could get it from mean/median/modus of distances
% but implicite value is good enaugh
if(treshold(1) < 0)
    lumTreshold = 5;
end
if(treshold(2) < 0)
    colTreshold = 5;
end
if(treshold(1) == 0 && treshold(2) == 0)
% do not shrink
    disp('  * tresholds are zero -> do not shrink!');
    fusedSegImLUV = segImLUV;
    fusedSegImRGB = Luv2RGB(segImLUV);
    fusedSegImIndx = labels;
    shrinkedSegmentCount = 0;
    return;
end    
lumTreshold = treshold(1);
colTreshold = treshold(2);
%% do shrink
disp(['  * ',num2str(iShrink),' iteration of shrink (stops when indempotent)']);
disp(['  * Starting to fuse close segments with tresholds[',...
    num2str(treshold(1)),',',num2str(treshold(1)),']=[light,color]']);
tstart = tic;

% min index
% for indexing from 1 to nSegm
iLabels = labels;
if(min(iLabels(:)) == 0)
    iLabels = iLabels+1;
end

% max inndex
iSegm_max =  max(iLabels(:));
nSegm = iSegm_max;
nSegm_before = nSegm;


% resolution
sizeLab = size(labels);
disp(['  * nSegments before shrink = ',num2str(nSegm_before ),'']);

% initialize triangle matrix of color-differences (= distances)
mDist = zeros(nSegm);
% initialize color vector for all segments
col = zeros(nSegm,3);
% which vector indicies represent the color value in Luv space
lightVect = 1;
colVect = 2:3;

    
%% anonymous function for distance squared - for not counting square root
distLight = @(a,b) abs(a-b);
distCol2 = @(a,b) (a(1)-b(1))^2 + (a(2)-b(2))^2;
col2Treshold = colTreshold^2;

disp('  * Get LUV colors of individual segments');
% DRAW_image(uint8(iLabels),'iLabels');

% get color of all segments in LUV space and write close segments to diagonal
for iSegm=1:nSegm
    % get color of this segment in LUV space 
    firstNonZeroIndex = find(iLabels==iSegm,1);
    
    [y, x] = ind2sub(size(labels),firstNonZeroIndex);
    if(isempty(y))
        disp('error');
    end
    col(iSegm,:) = segImLUV( y, x, :);
    
    %% get matrix of distances between individual segment colors
    % in upper triangle there are distances of color
    % in bottom triangle there are distances of lightness
    for jSegm=iSegm:-1:1
        % skip main diagonal
        if(iSegm == jSegm), continue; end;
        % get the distance if this segment was not reindexed jet
        if( mDist(jSegm,jSegm)==0 )
            mDist(iSegm, jSegm) = distCol2(col(iSegm,colVect),col(jSegm,colVect));
            mDist(jSegm, iSegm) = distLight(col(iSegm,lightVect),col(jSegm,lightVect));
            % iSegm & jSegm are close together enaugh with color & light parameters
            if( mDist(iSegm, jSegm) < col2Treshold && ...
                mDist(jSegm, iSegm) < lumTreshold )
                % mark that iSegm & jSegm will be together
                if( mDist(iSegm,iSegm)==0 ) 
                    % iSegment did not matched any other yet - this is the
                    % first cluster
                    mDist(iSegm,iSegm) = iSegm;
                    mDist(jSegm,jSegm) = iSegm;
                else
                    % iSegment already has a companion 
                    % -> jSegment will have the same index as iSegment & its companion(s)
%                     mDist(jSegm,jSegm) = mDist(iSegm,iSegm);
                    mDist(iSegm,iSegm) = mDist(jSegm,jSegm);
                end
            end
        end
    end %for jSegm
end %for iSegm

dia = diag(mDist);
% dia(i) = companion-segment index - first-cluster-segment index
% so every segment (i) will be re-labeled to index dia(i)
% with a mean color of all of them

% if newIndexes(i) == 
% 0 -> this iSegm was not reindexed yet
% x -> in newIndexes there is new index of iSegm
newIndexes = zeros(nSegm,1);


disp('  * Reindex and get mean colros for individual segment clusters');
% get mean color for each segment cluster & fill segmIm
freeIndex0 = 0;
freeIndex = freeIndex0;
xLabels = zeros(sizeLab);
for iSegm=1:nSegm
%% this iSegm segment has no companion = not a part of any cluster     
    if(dia(iSegm) == 0) 
        % just reindex this segment
        disp(['    - Segment[',num2str(iSegm),'/',num2str(nSegm),...
            '] is not clustered; newIndx=',num2str(freeIndex),''])
        
        % write the new index value to the old coordinates of a segment
%         xLabels(iLabels==iSegm) = freeIndex; %not functional
        [y, x] = ind2sub(sizeLab, find(iLabels==iSegm));
        nPx = numel(y);
        for iPx=1:nPx
            xLabels(y(iPx), x(iPx),1) = freeIndex;
        end
        % do not change the segmented image 

        newIndexes(iSegm) = freeIndex;
        freeIndex = freeIndex+1;
        if(nPx < 1)
            % this can not happen -> iSegm has no values in ilabels
            disp(['Indexing error - segment[',num2str(iSegm),'] has no pixels']);
        end
if plotIndividualClusters==1
    figure(FI);tit=['freeIndx=',num2str(freeIndex),''];imshow(uint16(xLabels),[]); title(tit);
end
        continue;
    end
%% this segment has its companions = is part of a cluster
%     dia(iSegm)
    if(newIndexes(dia(iSegm)) ~= 0)
        % these iSegm cluster segments were already reindexed
        continue;
    end
    % mark that we will reindex this iSegm cluster segments -> for not doing it multiple times
    newIndexes(dia(iSegm)) = freeIndex;

    clusterIndexes = find(dia==dia(iSegm)); % get indexes of this iSegm cluster
    nCluster = numel(clusterIndexes); % number of segments in this cluster
    
    disp(['    - Segment[',num2str(iSegm),'/',num2str(nSegm),...
        '] newIndx=[',num2str(freeIndex),...
        '] is in cluster with ',num2str(nCluster),' segments']);
        %[',num2str(dia(iSegm)),']; '])
    % add individual colors
    clusterColor = zeros(1,3);
    for i=1:nCluster
        clusterColor(1,:) = clusterColor(1,:) + col( clusterIndexes(i), : );
    end
    % count the mean color value ->
    clusterColor = clusterColor / nCluster;
    
    %% give all segments from this cluster - mean color in LUV image
    % mask together individual segments of this iSegm cluster
    clusterImageIndxes = [];
    for i=1:nCluster
        clusterImageIndxes = [clusterImageIndxes; find(iLabels==clusterIndexes(i))];
    end
    % now there are all indexes (of position space in image) of all
    % segments of this cluster in the variable [clusterLabelIndx]
    
    % so fill segImLUV image in the area of this cluster with its mean color
    [y, x] = ind2sub(sizeLab, clusterImageIndxes);
    nPx = numel(y);
    b = zeros(size(segImLUV,1),size(segImLUV,2));
    a = cat(3,b,b,b);
    for iPx=1:nPx
        segImLUV(y(iPx), x(iPx), :) = single(clusterColor(1,:));
        xLabels(y(iPx), x(iPx)) = newIndexes(dia(iSegm));
% show "pixel painting" of flooded clusters
%   figure(1);imshow(uint16(xLabels),[]); 
    end
    freeIndex = freeIndex+1;
if plotIndividualClusters==1
    figure(FI); tit=['CLUST freeIndx=',num2str(freeIndex),'']; imshow(uint16(xLabels),[]); title(tit);
end
end % for every iSegm cluster 

% in newIndexes there are new indexes 
% newindex of iSegm = newIndexes(iSegm)
% newIndexes'

%% output
fusedSegImLUV = segImLUV;
fusedSegImRGB = Luv2RGB(fusedSegImLUV);
fusedSegImIndx = xLabels - freeIndex0;

nSegm = max(fusedSegImIndx(:))+1;
shrinkedSegmentCount = nSegm_before - nSegm;

% time measuring
telapsed = toc(tstart);
disp(['    - Done in ',num2str(telapsed),'s']);


disp(['  * nSegments after shrink = ',num2str(nSegm),'']);
disp(['  * Total fused segments = ',num2str(shrinkedSegmentCount),'']);

%% draw segmented & indexed image
if(doFigures == 1)
    disp('  * Show shrinked segmented image');
  tit = ['[',num2str(lumTreshold),';',num2str(colTreshold),...
        ']=[lum;col]treshold'];
    DRAW_image(fusedSegImRGB, ['Shrinked ',tit]);
    disp('  * Show shrinked indexed image');
    tit = [num2str(size(xLabels,1)),'×',num2str(size(xLabels,2)),...
        ']px; nSegm=',num2str(nSegm),...
        '; iter=',num2str(iShrink),''];
    DRAW_image(fusedSegImIndx, ['Shrinked Indx[', tit]);
end

end %fcn


