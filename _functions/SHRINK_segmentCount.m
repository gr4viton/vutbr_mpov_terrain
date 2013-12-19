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
nSegm_before = iSegm_max+1;
disp(['  * nSegments before shrink = ',num2str(nSegm_before ),'']);
% initialize triangle matrix of color-differences (= distances)
mDist = zeros(iSegm_max);
% initialize color vector for all segments
col = zeros(iSegm_max,3);
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
% get color of all segments in LUV space and write close segments to diagonal
for iSegm=1:iSegm_max
    % get individual segments of index iSegm
    xlabels = labels; 
    xlabels(xlabels~=iSegm) = 0;
    xlabels = xlabels ./ iSegm; % [one] - segment | [zero] - not segment
    
    % get color of this segment in LUV space 
    firstNonZeroIndex = find(xlabels,1);
    [y, x] = ind2sub(size(xlabels),firstNonZeroIndex);
    col(iSegm,:) = segImLUV( y, x, :);
%     allNonZeroIndex = find(xlabels);
%     allZeroIndex = find(xlabels==0);

    
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
                    % iSegment did not matched any other yet
                    mDist(iSegm,iSegm) = iSegm;
                    mDist(jSegm,jSegm) = iSegm;
                    
%                     mDist(jSegm,iSegm) = iSegm; % not needed 
                else
                    % iSegment already has a companion 
                    % -> jSegment will be the same as iSegment companion(s)
                    mDist(jSegm,jSegm) = mDist(iSegm,iSegm);
                    
%                     mDist(jSegm,iSegm) = mDist(iSegm,iSegm); % not needed 
                end
            end
        end
    end %for jSegm
end %for iSegm

dia = diag(mDist);
% dia(i) = companion-segment index
% so every segment (i) will be re-labeled to index dia(i)
% with a mean color of all of them

% if alreadyClustered(i) == 1 -> this iSegm cluster segments were already reindexed
alreadyClustered = zeros(iSegm_max,1);


disp('  * Get mean colros for individual segment clusters');
% get mean color for each segment cluster & fill segmIm
freeIndx = 0;
xlabels = zeros(size(segImLUV,1),size(segImLUV,2));
% xlabels = labels;
for iSegm=1:iSegm_max
    clusterIndexes = find(dia==iSegm); % get indexes of this iSegm cluster
    nCluster = numel(clusterIndexes); % number of segments in this cluster
    if(nCluster == 0) 
        % this iSegm segment has no companion = not a part of any cluster
        % write the new index value to the old coordinates of a segment
        [y, x] = ind2sub(size(xlabels), find(labels==iSegm));
        nPx = numel(y);
        for iPx=1:nPx
            xlabels(y(iPx), x(iPx),1) = freeIndx;
        end
        freeIndx=freeIndx+1;
        % do not change the segmented image
        continue;
    end
    if(alreadyClustered(iSegm) == 1)
        % these iSegm cluster segments were already reindexed
        continue;
    end
    % mark that we will reinde this iSegm cluster segments -> for not doing it multiple times
    alreadyClustered(iSegm) = 1;
    
    % add individual colors
    clusterColor = zeros(1,3);
    for i=1:nCluster
        clusterColor(1,:) = clusterColor(1,:) + col( clusterIndexes(i), : );
    end
    % count the mean color value ->
    clusterColor = clusterColor / nCluster;
    
    %% give all segments from this cluster - mean color in LUV image
    % mask together individual segments of this iSegm cluster
    clusterLabelIndx = [];
    for i=1:nCluster
        clusterLabelIndx = [clusterLabelIndx; find(labels==clusterIndexes(i))];
    end
    % now there are all indexes (of position space in image) of all
    % segments of this cluster in the variable [clusterLabelIndx]
    
    % so fill segImLUV image in the area of this cluster with its mean color
    [y, x] = ind2sub(size(labels), clusterLabelIndx);
    nPx = numel(y);
    for iPx=1:nPx
        segImLUV(y(iPx), x(iPx), :) = single(clusterColor(1,:));
        xlabels(y(iPx), x(iPx),1) = freeIndx;
    end
    freeIndx=freeIndx+1;
end % for every iSegm cluster 


%% output
fusedSegImLUV = segImLUV;
fusedSegImRGB = Luv2RGB(fusedSegImLUV);
fusedSegImIndx = xlabels;
% time measuring
disp(['    - Done in ',num2str(toc),'s']);


%% draw segmented & indexed image
nSegm = max(fusedSegImIndx(:))+1;
disp(['  * nSegments after shrink = ',num2str(nSegm),'']);
disp(['  * Total fused segments = ',num2str(nSegm_before - nSegm),'']);
if(doFigures == 1)
    disp('  * Show shrinked segmented image');
    DRAW_image(fusedSegImRGB, ['segmented image (meanshift); nSegm=',num2str(nSegm),'']);
    disp('  * Show shrinked indexed image');
    DRAW_image(fusedSegImIndx, ['indexed image of segments; nSegm=',num2str(nSegm),'']);
end

end %fcn



























