function [moreSegIm] = SHRINK_numOfSegments(segIm)
%SHRINK_numOfSegments Shrink feature-close segments togeather
%@brief     this function shirnks the number of segments
%           as the parameters of different segmented areas are alike
%           reindex some of groups with common color parameters to same index 
%@param[in] [im_indx] image with many indexed segments 
%           (optional?) -do not need image of segments or only segments colors?
%           [im_indx_RGB] matrix with RGB color
%@return    [moreSegIm] image with lesser count of indexed segments


moreSegIm = segIm;



% TODLE nE = vícekrát provést kmeans -> pro rùzné hodnoty nColors a ponechat tu
% která má nejmenší sumd (kdy pro každý výpoèet je kmeans(repetitive) >= 3

%  mám jiný plán







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