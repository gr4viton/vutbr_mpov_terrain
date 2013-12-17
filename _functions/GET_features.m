function [ ftrList ] = GET_features( segim, labels, modes, regsize, grad, conf )
%GET_FEATURES gets feature-lists for individual segments
%   ...

%% anonymous functions for index parameters
% featureList([ index ]) - get index of segment from labels(y,x)
fi = @(y,x) labels(y,x)+1;
iSegm_max = max(labels(:)) + 1;

disp(['    - Number of segments = ', num2str(iSegm_max+1)]);

% predefining the size of featureList
ftrList(iSegm_max+1).areaSumAbs = 0;

% [ featureList(index) ] - get featureList that corresponds to labels(y,x)
% fL = @(y,x) featureList(fi(y,x));
% fL = @(y,x) ftrList(uint16(labels(y,x)+1));
% not functional [pointer to the array of struct] ?

%% nope
% for i = 1:fi_max
%     disp([ 'featureList(',num2str(i),')=',num2str( ftrList(i).areaSumAbs ) ])
% end
% percent of image
        
%% first loop through - for inicializing zero values and count the one-loop countable features
for iSegm = 1:iSegm_max
% stats for segments as for a group of areas
    
% ____________________________________________________
% only inicialized
    ftrList(iSegm).areaSumAbs2 = 0; % sum of all the pixels
    ftrList(iSegm).areaSumRelIm = 0; % area sum relatively to whole image
    
%     ftrList(i).circumfrnc = 0; % sum of circumferences of individual areas of a segment

% ____________________________________________________
% counted here
    
    xlabels = labels; 
    xlabels(xlabels~=iSegm) = 0; % get individual segment of index i - 
    % on the pixels of segment in the picture is the index of segment
    
    % eulers number of a segment (genus) [8-neighbor]
    ftrList(iSegm).eulerNum8 = bweuler( uint16(xlabels) ,8);
    % sum of all the pixels
    ftrList(iSegm).areaSumAbs = sum(xlabels(:)) ./ iSegm;

% ____________________________________________________
% others

%     histogram
% chist
% hlavni a vedlejší osa
% orientace
% geometric moment?

% mean color RGB - of default image or segmented color => is it the same?
% stats for whole image - from meanshift & kmeans?
%%  asi ne
% vıstøednost
% podlouhlost - pomìr stran obdelníka
% pravoúhlost - maximalni pomìr velikost/plocha obdel
% convex circumference 
% boxWidth
% boxHeight
end


for y = 1:size(labels,1)
    for x = 1:size(labels,2)
        ftrList(fi(y,x)).areaSumAbs2 = ftrList(fi(y,x)).areaSumAbs2 + 1;
    end
end


%% second loop through
[areaSumAbs_minVal, areaSumAbs_minIndex]  = min([ ftrList(iSegm).areaSumAbs ]);

for iSegm = 1:iSegm_max
    % area sum relatively to the others - min area = 1
    ftrList(iSegm).areaSumRel = ftrList(iSegm).areaSumAbs / areaSumAbs_minVal; 
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


% elipsoidnost jednotlivıch? -> natoèení a tak
% 


% stats.percentage


end

