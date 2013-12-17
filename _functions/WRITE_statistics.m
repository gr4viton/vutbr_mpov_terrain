function [] = WRITE_statistics( ftrList, imFileName, writeStatsPath )
%WRITE_STATISTICS writes segments feature-lists into stats-file
%   ...

if writeStatsPath~=0
disp('> Writing feature lists data to statistics file');

% string constants
statsPrefix = 'stats_';
statsExtension = '.csv';
delimVal = ';\t\t'; % delimiter of columns
delimHead = ';\t'; % delimiter of columns
newLine = '\n';
% first line of stats-file
firstLine = ['Feature list for individual segments of image: "',imFileName,'". Row = segment. Delimiter = "',delimVal,'". Columns'' headers:\n'];
valueCell_strFormat = ['%s',delimVal];
headerCell_strFormat = ['%s',delimHead];


% %% write all stats to string
% 
% % automatical insertion of headers from [stats]-structure variable-names
% 
% iSegm_max = size(ftrList,2); % ftrList num of segments
% for i_segm = 1:iSegm_max
%     fi_max = 10; % ftrList num of variables
%     % loop for individual features of ftrList
%     for fi = 1:fi_max
%         val = 0;
%         str = [str, num2str(val), delim];
%     end
% end
% 
%% name of stats-file
statsFileName = strcat(writeStatsPath,statsPrefix,imFileName,statsExtension);
% 
% %% open, write & close stats-file 
% fid = fopen(statsFileName,'w');
% fprintf(fid, str);
% fclose(fid);

%%  Extract field data

% fields = repmat(fieldnames(ftrList), numel(ftrList), 1);
featureNames = fieldnames(ftrList)';
values = struct2cell(ftrList);

%% Convert all numerical values to strings
idx = cellfun(@isnumeric, values); 
values(idx) = cellfun(@num2str, values(idx), 'UniformOutput', 0);

%% Combine field names and values in the same array
% C = {fields{:}; values{:}};

features_sum = numel(featureNames);
segm_sum = size(values, 3);

%% Write fields to CSV file
fid = fopen(statsFileName, 'wt');
fprintf(fid, firstLine);

% columns' headers
head_strFormat = repmat( headerCell_strFormat, 1, features_sum);
fprintf(fid, [head_strFormat, newLine], featureNames{:});
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
    fprintf(fid, [oneRow_strFormat, newLine], ...
        values{ pointer+1 : pointer + features_sum });
end
fclose(fid);

disp(strcat('  * Statistics of segmented image "',imFileName, '"', ...
    ' > have been written to file: "',statsFileName, '"'));

end % writeStatsPath~=0

end

