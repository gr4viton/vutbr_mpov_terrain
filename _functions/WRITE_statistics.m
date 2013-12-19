function [] = WRITE_statistics( ftrList, imOrig, imPath, writeStatsPath )
%WRITE_STATISTICS writes segments feature-lists into stats-file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [ftrList] - array of feature-lists of individual segments
%  [imOrig] - original image
%  [imPath] - path to original image
%  [writeStatsPath] - variable for determining if and where to write stats
%           if writeStatsPath == 0 - do not write
%           elseif writeIndexedPath == 1 - create the file in directory "_stat" created in the imPath      
%           else write to path specified
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if writeStatsPath==0
    return;
end

disp('> Writing feature lists data to statistics file');

statsDirName = '\_stats\';
[imPathStr,imFileName,imExt] = fileparts(imPath);
% imFileName = [imFileName,ext];
if(writeStatsPath==1)
    writeStatsPath = [imPathStr,statsDirName];
end
[s, mess, messid] = mkdir(writeStatsPath);


%% string constants
statsPrefix = 'stats_';
statsExtension = '.csv';

% delimiters
% delimVal = ';\t'; % delimiter of values
delimVal = '; '; % delimiter of values 
% delimHead = ';\t'; % delimiter of headtitles
delimHead = '; '; % delimiter of headtitles

% other
newLine = char(10);
% first line of stats-file
valueCell_strFormat = ['%s',delimVal];
headerCell_strFormat = ['%s',delimHead];


%% name of stats-file
statsFileName = strcat(writeStatsPath,statsPrefix,imFileName,imExt,statsExtension);

%%  Extract field data
featureNames = fieldnames(ftrList)';
values = struct2cell(ftrList);

%% Convert all numerical values to strings
idx = cellfun(@isnumeric, values); 
values(idx) = cellfun(@num2str, values(idx), 'UniformOutput', 0);

features_sum = numel(featureNames);
segm_sum = size(values, 3);

%% write stats to string
width = size(imOrig,2);
height = size(imOrig,1);
firstLine = ['Feature list for individual segments of mean-shifted image: "',imFileName,imExt,...
    '" - resolution [',num2str(width),'×',num2str(height),']; nSegments=',...
    num2str(segm_sum),'; delimiter = "',delimVal,'"'];
str = sprintf('%s', [firstLine, newLine]);

% columns' headers
head_strFormat = repmat( headerCell_strFormat, 1, features_sum);
str = sprintf(['%s',head_strFormat, newLine], str, featureNames{:});
% fprintf(fid, newLine);

% one row
oneRow_strFormat = repmat(valueCell_strFormat, 1, features_sum);
for fi = 0:segm_sum-1
    pointer = fi*features_sum;
    str = sprintf(['%s',oneRow_strFormat, newLine], str, ...
        values{ pointer+1 : pointer + features_sum });
end

%% display whole message 
% disp('[FILE START]');
% disp(str)
% disp('[FILE END]');

%% Write stats from string to CSV file
fid = fopen(statsFileName, 'wt');
fprintf(fid,'%s',str);
fclose(fid);

disp(strcat('  * Statistics of segmented image "',imFileName, '"', ...
    ' > have been written to file: "',statsFileName, '"'));


end

