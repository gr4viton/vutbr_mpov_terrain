function [] = WRITE_statistics( ftrList, imFileName, writeStatsPath )
%WRITE_STATISTICS writes segments feature-lists into stats-file
%   ...

if writeStatsPath~=0
disp('> Writing feature lists data to statistics file');

% string constants
delim = ';'; % delimiter of columns
statsPrefix = 'stats_';
statsExtension = '.csv';

%% write all stats to string
% header
str = ['Feature list for individual segments of image: "',imFileName,'". Row = segment. Delimiter = "',delim,'". Columns'' headers:\n'];
str = [str, 'Segment index; '];

% automatical insertion of headers from [stats]-structure variable-names

fnam = 'foo.mat';
save(fnam,'-struct','ftrList');

iSegm_max = size(ftrList,2); % ftrList num of segments
for i_segm = 1:iSegm_max

%     str = [str,'Segment ',int2str(i),':','    ',sprintf('%.2f', percentage(i)),'%%\n'];

    fi_max = 10; % ftrList num of variables
    % loop for individual features of ftrList
    for fi = 1:fi_max
        val = 0;
        str = [str, num2str(val), delim];
    end
end

%% name of stats-file
statsFileName = strcat(writeStatsPath,statsPrefix,imFileName,statsExtension);

%% open, write & close stats-file 
fid = fopen(statsFileName,'w');
fprintf(fid, str);
fclose(fid);

disp(strcat('  * Statistics of segmented image "',imFileName, '"', ...
    ' > have been written to file: "',statsFileName, '"'));

end % writeStatsPath~=0

end

