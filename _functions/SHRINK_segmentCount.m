function [fusedSegIndx] = SHRINK_numOfSegments(labels,segImLUV)
%SHRINK_numOfSegments Shrink feature-close segments togeather
%@brief     this function shirnks the number of segments
%           as the parameters of different segmented areas are alike
%           reindex some of groups with common color parameters to same index 
%@param[in] [im_indx] image with many indexed segments 
%           (optional?) -do not need image of segments or only segments colors?
%           [im_indx_RGB] matrix with RGB color
%@return    [fusedSegIm] image with lesser count of indexed segments

% if(segIm

iSegm_max =  max(labels(:));

% initialize triangle matrix of color-differences (= distances)
mDist = zeros(iSegm_max);
% initialize color vector for all segments
col = zeros(iSegm_max,3);
% which vector indicies represent the color value in Luv space
colVect = 1:2;

%     figure
%     imshow(Luv2RGB(segImLUV),[]);
    
%% anonymous function for distance squared
dist2 = @(a,b) (a(1)-b(1))^2 + (a(2)-b(2))^2

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
            if( mDist(iSegm, jSegm) < distTreshold )
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
    aaa = find(labels==clusterIndexes(i))
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
    end
end % for every iSegm cluster 

% % for every segment that has a close-enaugh compenion
% % allNonZeroColumn = find( diag(mDist) );
% siz = size(mDist,2);
% dia = diag(mDist);
% for jSegm = 1:siz
%     if(dia(jSegm)==0), continue; end;
% %   we are in column of a segment(jSegm) which has a companion segment
% %     for iSegm = jSegm+1:iSegm_max
%     % for every non zero
%     allNonZeroIndex = find( mDist(:,jSegm) );
%     
%     [y, x] = ind2sub(size(mDist), allNonZeroIndex);
%     for i=1:size(y,2)
%         mDist(y(i), x(i)) = jSegm;
%     end
%     mDist
% %     end
%     nSegm = 1;
%     
%     col_mean = col_mean + col(iSegm);
%     col_mean = col_mean / nSegm ;
% end




% indxFree = iSegm_max+1;

% 
%                 % reindex jSegm in labels to iSegm 
%                 labels(labels==jSegm)=iSegm;    
%                 
%                 % calculate the mean color of these two segments
%                 for i=1:3
%                     col_mean(i) = mean( [col(iSegm,i), col(jSegm,i)] );
%                 end
%                 
%                 % give both segments(i,j) mean color in image
%                 xlabels = labels; 
%                 xlabels(xlabels~=iSegm) = 0;
%                 allNonZeroIndex = find(xlabels);
%                 [y, x] = ind2sub(size(xlabels),allNonZeroIndex);
% %                 segImLUV( y, x, :) = col_mean(:);
%                 segImLUV( y, x, :) = mean( [col(iSegm,:), col(jSegm,:)] );

                
                
                
% meanshift end color - the color to which segment iterated to
%     firstNonZeroIndex = allNonZeroIndex(1); % find(xlabels, 1, 'first'); 


% permute
% fusedSegIndx = segImLUV;


end %fcn


% ____________________________________________________
% TODLE nE = v�cekr�t prov�st kmeans -> pro r�zn� hodnoty nColors a ponechat tu
% kter� m� nejmen�� sumd (kdy pro ka�d� v�po�et je kmeans(repetitive) >= 3

%  m�m jin� pl�n







%% probably not used - delete in last version
% % %% original
% % im = im_prep;
% %     SI=SI+1; subplot2(y,x,SI);
% %     imshow(im,[]); title(strcat('preprocessed = original')); axis tight;
% %     
% % %% convert preprocessed image [im_prep] to LABspace
% % cform = makecform('srgb2lab');
% % im1_lab = applycform(im_prep,cform);
% % im = im1_lab;
% %     SI=SI+1; subplot2(y,x,SI);
% %     imshow(im,[]); title(strcat('preporig in labspace')); axis tight
% % 
% % %% classify colors
% % % get color information vectors (2:3) from image converted to lab space 
% % ab = double(im1_lab(:,:,2:3));
% % nrows = size(ab,1);
% % ncols = size(ab,2);
% % % make it a two row vector for easy inputting into kmeans
% % ab = reshape(ab,nrows*ncols,2);
% % 
% % % nColors = 3;
% % %% find which number of clusters has lowest error [ERROR(nColors) = sum(sumd)]
% % nColors_space = 3:6;
% % ERROR = zeros(size(nColors_space,2),2);
% % first_run = 1;
% % for nColors=nColors_space
% %     % kmeans with repetition on the color vectors
% % 
% %     kmeans_repetitions = 4;
% %     [cluster_idx, cluster_center, sumd] = kmeans( ...
% %         ab, nColors,'distance','sqEuclidean', ...
% %         'replicates', kmeans_repetitions); %, ...
% %     %     'start', 'cluster');
% % 
% %     % reshape it back to image dimensions
% %     pixel_labels = reshape(cluster_idx,nrows,ncols);
% % 
% %     %% show rgb_colors of center of clusters 
% %     % cform2rgb = makecform('lab2srgb');
% %     % 
% %     % bright_space = 0:16:255;
% %     % bright_rows = size(bright_space,2);
% %     % brightness = repmat(bright_space, size(cluster_center, 1), 1);
% %     % % x = repmat(cluster_center(:,1), 1, bright_rows);
% %     % cluster_center3(:,:,:) = cat(3,  ...
% %     %     brightness, ...
% %     %     repmat(cluster_center(:,1), 1, bright_rows), ...
% %     %     repmat(cluster_center(:,2), 1, bright_rows) ...
% %     %     );
% %     % 
% %     % % im = uint8(cluster_center3(:,127,:));
% %     % % im = uint8(cluster_center3);
% %     % %     SI=SI+1; subplot2(y,x,SI);
% %     % %     imshow(im,[]); title(strcat('cluster centers lab')); axis tight; 
% %     % 
% %     % %% get centers of kmeans color clusters to rgb
% %     % cluster_center_rgb = applycform(uint8(cluster_center3), cform2rgb);
% %     % 
% %     % % cluster_center_image = uint8(cluster_center);
% %     % % cluster_center_image3 = cat(3, cluster_center_image, cluster_center_image, cluster_center_image );
% %     % 
% %     % im = cluster_center_rgb;
% %     %     SI=SI+1; subplot2(y,x,SI);
% %     %     imshow(im,[]); title(strcat('cluster centers rgb')); axis tight; 
% % 
% % 
% %     %% colorize pixel labels
% %     colored_labels = label2rgb(pixel_labels, @hsv, 'c', 'shuffle');
% %     
% %     ERROR(nColors) = sum(sumd);
% %     if first_run == 1
% %         ERROR_1 = ERROR(nColors);
% %         first_run = 0;
% %     end
% %     
% %     im = colored_labels;
% %         SI=SI+1; subplot2(y,x,SI);
% %         imshow(im,[]); title(strcat('kmeans colored labels nColor=', ...
% %         num2str(nColors),';E=', ...
% %         num2str(ERROR(nColors)/ERROR_1),'')); axis tight; 
% % 
% %     im_gray = rgb2gray(im_orig);
% %     im_gray3 = cat(3, im_gray, im_gray, im_gray );
% %     a = 0.3;
% %     % for a = 1-(0.65:0.05:0.9)
% %         colored_image = imlincomb(a, colored_labels, 1-a, im_gray3);
% %         im = colored_image;
% %             SI=SI+1; subplot2(y,x,SI);
% %             imshow(im,[]); title(strcat('grayed preorig[', ...
% %                 num2str(1-a),'] + colorlabels [',num2str(a),']')); axis tight
% %     % end
% %     
% % end % kmeans with different nColors
% % 
% % I = im_orig;
% % [fimg labels modes regsize grad conf] = edison_wrapper(I,@RGB2Luv);
% % imshow(Luv2RGB(fimg));


% MeanShiftCluster
% change

%% write normalized ERRORS
% minERROR = min(ERROR);
% if(minERROR == 0) 
%     minERROR = 1;
% end
% ERROR = ERROR / minERROR;
% SI2 = SI;
% for nColors=fliplr(nColors_space)
%     SI2=SI2-2; subplot2(y,x,SI2);
%     title(strcat('kmeans colored labels nColor=',num2str(nColors),';sumd=',num2str(ERROR(nColors)),''));
% end

 %% segment images
 
% segmented_images = cell(1,nColors);
% rgb_label = repmat(pixel_labels,[1 1 3]);
% 
% for k = 1:nColors
%     color = a_im;
%     color(rgb_label ~= k) = 0;
%     segmented_images{k} = color;
% end

% for i=1:nColors
%     im = segmented_images{i};
%         SI=SI+1; subplot2(y,x,SI);
%         imshow(im,[]); title(strcat('objects in cluster ',num2str(i))); axis tight
% end


































%% code which can be used if the functions arent in the school matlab
%% label2rgb
% cols = hsv(nColors);
% image_cols(1,:,:) = cols(:,:);
% im = uint8(image_cols*255);
%     SI=SI+1; subplot2(y,x,SI);
%     imshow(im,[]); title(strcat('colored_labels')); axis tight
% 
% colored_labels = cat(3, pixel_labels, pixel_labels, pixel_labels);
% im = uint8(colored_labels*255/nColors);
%     SI=SI+1; subplot2(y,x,SI);
%     imshow(im,[]); title(strcat('colored_labels')); axis tight
    
    
%     collabs = repmat(colored_labels, 1, nColors);
% cc(:,:,:,1:nColors) = colored_labels(:,:,:).*0;

% for i=1:nColors
%     b = (colored_labels==i);
%     for col=1:3
%         cc(:,:,col,i) = colored_labels(:,:,col).*b(:,:,col).*cols(i,col);
%     end
%    
% %     im = cc(:,:,:,i);
% %         SI=SI+1; subplot2(y,x,SI);
% %         imshow(im,[]); title(strcat('imaex')); axis tight 
%     
% %     a = colored_labels(colored_labels==i); % = cols(i);
% %     colored_labels = uint8(colored_labels);
% end
% colored_labels = uint8(sum(cc,4)/nColors*255);