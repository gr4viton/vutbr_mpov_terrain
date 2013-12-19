function [fusedSegImLUV,fusedSegImRGB,fusedSegImIndx] = SHRINK_numOfSegments(labels, segImLUV, doFigures)
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
% initialize triangle matrix of color-differences (= distances)
mDist = zeros(iSegm_max);
% initialize color vector for all segments
col = zeros(iSegm_max,3);
% which vector indicies represent the color value in Luv space
colVect = 1:2;

%% anonymous function for distance squared - for not counting square root
dist2 = @(a,b) (a(1)-b(1))^2 + (a(2)-b(2))^2;

% get color of all segments in LUV space 
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

    % treshold distance - could get it from mean/median/modus of distances
    % but implicite value is good enaugh
    distTreshold = 5;
    dist2Treshold = distTreshold^2;
    
    %% for each get the 
    % get triangle matrix of distances between individual segment colors
    for jSegm=iSegm:-1:1
        % skip main diagonal
        if(iSegm == jSegm), continue; end;
        % get the distance if this segment was not reindexed jet
        if( mDist(jSegm,jSegm)==0 )
            mDist(iSegm, jSegm) = dist2(col(iSegm,colVect),col(jSegm,colVect));
            % iSegm & jSegm are close together enaugh
            if( mDist(iSegm, jSegm) < dist2Treshold )
                % mark that iSegm & jSegm will be together
                if( mDist(iSegm,iSegm)==0 ) 
                    % iSegment did not matched any other yet
                    mDist(iSegm,iSegm) = iSegm;
                    mDist(jSegm,jSegm) = iSegm;
                    % not needed 
                    mDist(jSegm,iSegm) = iSegm;
                else
                    % iSegment already has a companion 
                    % -> jSegment will be the same as iSegment companion(s)
                    mDist(jSegm,jSegm) = mDist(iSegm,iSegm);
                    % not needed
                    mDist(jSegm,iSegm) = mDist(iSegm,iSegm);
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

% get mean color for each segment cluster
for iSegm=1:iSegm_max
    clusterIndexes = find(dia==iSegm); % get indexes of this iSegm cluster
    nCluster = numel(clusterIndexes); % number of segments in this cluster
    if(nCluster == 0) 
        % this iSegm segment has no companion = not a part of any cluster
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
    clusterLabelIndx = 0;
    for i=1:nCluster
        clusterLabelIndx = [clusterLabelIndx; find(labels==clusterIndexes(i))];
    end
    % now there are all indexes (of position space in image) of all
    % segments of this cluster in the variable [clusterLabelIndx]
    
    % so fill segImLUV image in the area of this cluster with its mean color
    [y, x] = ind2sub(size(labels), clusterLabelIndx);
    nPx = numel(y);
    for iPx=1:nPx
        segImLUV(y(iPx)+1, x(iPx)+1, :) = single(clusterColor(1,:));
    end
end % for every iSegm cluster 

% time measuring
disp(['    - Done in ',num2str(toc),'s']);
fusedSegImLUV = segImLUV;
fusedSegImRGB = Luv2RGB(fusedSegImLUV);
fusedSegImIndx = 0;

%% draw segmented & indexed image
nSegm = max(labels(:))+1;
if(doFigures == 1)
    disp('  * Show shrinked segmented image');
    DRAW_image(fusedSegImRGB, ['segmented image (meanshift); nSegm=',num2str(nSegm),'']);
%     disp('  * Show shrinked indexed image');
%     DRAW_image(indxIm, ['indexed image of segments; nSegm=',num2str(nSegm),'']);
end

end %fcn



























