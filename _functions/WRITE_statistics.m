function [] = WRITE_statistics( ftrList, imFileName, writeStatsPath )
%WRITE_STATISTICS writes segments feature-lists into stats-file
%   ...

if writeStatsPath~=0
disp('> Writing feature lists data to statistics file');

% string constants
statsPrefix = 'stats_';
statsExtension = '.csv';
% delimVal = ';\t\t'; % delimiter of columns
% delimHead = ';\t'; % delimiter of columns
delimVal = '; '; % delimiter of columns
delimHead = '; '; % delimiter of columns
newLine = char(10);
% first line of stats-file
valueCell_strFormat = ['%s',delimVal];
headerCell_strFormat = ['%s',delimHead];


%% name of stats-file
statsFileName = strcat(writeStatsPath,statsPrefix,imFileName,statsExtension);

%%  Extract field data
featureNames = fieldnames(ftrList)';
values = struct2cell(ftrList);

%% Convert all numerical values to strings
idx = cellfun(@isnumeric, values); 
values(idx) = cellfun(@num2str, values(idx), 'UniformOutput', 0);

features_sum = numel(featureNames);
segm_sum = size(values, 3);

%% write stats to string
firstLine = ['Feature list for individual segments of image: "',imFileName,...
    '". nSegments[',num2str(segm_sum),']. Delimiter = "',delimVal,'". '];
str = sprintf('%s', [firstLine, newLine]);

% columns' headers
head_strFormat = repmat( headerCell_strFormat, 1, features_sum);
str = sprintf(['%s',head_strFormat, newLine], str, featureNames{:});
% fprintf(fid, newLine);

% one row
oneRow_strFormat = repmat(valueCell_strFormat, 1, features_sum)
% allValues_strFormat = repmat( [oneRow_strFormat, newLine], size(values, 3), 1)
%     fprintf(fid, allValues_strFormat, values{:});
% for i=1:17
% disp( ['values[',num2str(i),']=',values{i}]);
% end
for fi = 0:segm_sum-1
    pointer = fi*features_sum;
    str = sprintf(['%s',oneRow_strFormat, newLine], str, ...
        values{ pointer+1 : pointer + features_sum });
% disp(str)
end

disp(str)

%% Write stats from string to CSV file
fid = fopen(statsFileName, 'wt');
fprintf(fid,'%s',str);
fclose(fid);

disp(strcat('  * Statistics of segmented image "',imFileName, '"', ...
    ' > have been written to file: "',statsFileName, '"'));

end % writeStatsPath~=0

end

