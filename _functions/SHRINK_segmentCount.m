function [fusedSegImLUV,fusedSegImRGB,fusedSegImIndx] = ...
    SHRINK_numOfSegments(labels, segImLUV, doFigures, lightTreshold, colTreshold)
%SHRINK_numOfSegments Shrink feature-close segments togeather
%@brief     this function shirnks the number of segments
%           as the parameters of different segmented areas are alike
%           reindex some of groups with common color parameters to same index 
%@param[in] [im_indx] image with many indexed segments 
%           (optional?) -do not need image of segments or only segments colors?
%           [im_indx_RGB] matrix with RGB color
%@return    [fusedSegIm] image with lesser count of indexed segments


%% initializations
tic;
iSegm_max =  max(labels(:));
nSegm = iSegm_max+1;
nSegm_before = nSegm;
sizeLab = size(labels);
disp(['  * nSegments before shrink = ',num2str(nSegm_before ),'']);

% initialize triangle matrix of color-differences (= distances)
mDist = zeros(nSegm);
% initialize color vector for all segments
col = zeros(nSegm,3);
% which vector indicies represent the color value in Luv space
lightVect = 1;
colVect = 2:3;

% treshold distance - could get it from mean/median/modus of distances
% but implicite value is good enaugh
% lightTreshold = 2;
% colTreshold = 4;
    
    
%% anonymous function for distance squared - for not counting square root
distLight = @(a,b) abs(a-b);
distCol2 = @(a,b) (a(1)-b(1))^2 + (a(2)-b(2))^2;
col2Treshold = colTreshold^2;

disp('  * Get LUV colors of individual segments');
% for indexing from 1 to nSegm
iLabels(:,:) = labels(:,:)+1;
% DRAW_image(uint8(iLabels),'iLabels');

% get color of all segments in LUV space and write close segments to diagonal
for iSegm=1:nSegm
    % get color of this segment in LUV space 
    firstNonZeroIndex = find(iLabels==iSegm,1);
    [y, x] = ind2sub(size(labels),firstNonZeroIndex);
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
                mDist(jSegm, iSegm) < lightTreshold )
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
% dia(i) = companion-segment index
% so every segment (i) will be re-labeled to index dia(i)
% with a mean color of all of them

% if alreadyReindexed(i) == 
% 0 -> this iSegm was not reindexed yet
% 1 -> this iSegm cluster segments were already reindexed 
% 2 -> this iSegm is not part of a cluster and was reindexed
alreadyReindexed = zeros(nSegm,1);


disp('  * Get mean colros for individual segment clusters');
% get mean color for each segment cluster & fill segmIm
freeIndx = 1;
xLabels = zeros(sizeLab);
for iSegm=1:nSegm
    if(alreadyReindexed(iSegm) ~= 0)
        % these iSegm cluster segments were already reindexed
        continue;
    end
    clusterIndexes = find(dia==iSegm); % get indexes of this iSegm cluster
    nCluster = numel(clusterIndexes); % number of segments in this cluster
%% this iSegm segment has no companion = not a part of any cluster        
    if(nCluster == 0) 
        disp(['    - Segment[',num2str(iSegm),'/',num2str(nSegm),...
            '] is not clustered; newIndx=',num2str(freeIndx),''])
        
        % write the new index value to the old coordinates of a segment
        [y, x] = ind2sub(sizeLab, find(iLabels==iSegm));
        nPx = numel(y);
        for iPx=1:nPx
            xLabels(y(iPx), x(iPx),1) = freeIndx;
        end
figure(1)
    tit=['freeIndx=',num2str(freeIndx),'']
    imshow(uint16(xLabels),[]); title(tit);
        freeIndx=freeIndx+1;
        alreadyReindexed(iSegm) = 2;
        % do not change the segmented image
        if(nPx > 1)
            % this can not happen -> iSegm has no values in ilabels
            disp(['Indexing error - segment',num2str(iSegm),' has no pixels']);
        end
        continue;
    end
%% this segment has its companions = is part of a cluster
    % mark that we will reindex this iSegm cluster segments -> for not doing it multiple times
    alreadyReindexed(iSegm) = 1;
    disp(['    - Segment[',num2str(iSegm),'/',num2str(nSegm),...
        '] is in cluster; newIndx=',num2str(freeIndx),''])
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
        a(y(iPx), x(iPx), :) = single(clusterColor(1,:));
        xLabels(y(iPx), x(iPx)) = freeIndx;
% show "pixel painting" of flooded clusters
figure(1);imshow(uint16(xLabels),[]); 
    end
%     imshow(Luv2RGB(a),[]); title(tit);
figure(1);
    tit=['freeIndx=',num2str(freeIndx),'']
    imshow(uint16(xLabels),[]); title(tit);
    freeIndx=freeIndx+1;
end % for every iSegm cluster 

alreadyReindexed'

%% output
fusedSegImLUV = segImLUV;
fusedSegImRGB = Luv2RGB(fusedSegImLUV);
% indexed from 0 to nSegm-1
fusedSegImIndx = xLabels - 1;
% time measuring
disp(['    - Done in ',num2str(toc),'s']);


%% draw segmented & indexed image
nSegm = max(fusedSegImIndx(:))+1;
disp(['  * nSegments after shrink = ',num2str(nSegm),'']);
disp(['  * Total fused segments = ',num2str(nSegm_before - nSegm),'']);
if(doFigures == 1)
    disp('  * Show shrinked segmented image');
    DRAW_image(fusedSegImRGB, ['shrinked segmented image; nSegm=',num2str(nSegm),'']);
    disp('  * Show shrinked indexed image');
    DRAW_image(fusedSegImIndx, ['shrinked indexes image; nSegm=',num2str(nSegm),'']);
end

end %fcn


