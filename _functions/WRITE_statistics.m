function [] = WRITE_statistics( stats, imFileName, writeStatsPath )
%WRITE_STATISTICS writes segments feature-lists into stats-file
%   ...

if writeStatsPath~=0
disp('> Writing feature lists data to statistics file');

statsPrefix = 'stats_';
statsFileName = strcat(writeStatsPath,statsPrefix,imFileName,'.txt');

% open file
fid = fopen(statsFileName,'w');

% write all stats
str = ['MPOV segmentation statiscics for file: ',imFileName,'\n'];
for i = 1:size(stats,1)
%     debug as stats is not counted yet
    percentage(i) = 42;
    str = [str,'Segment ',int2str(i),':','    ',sprintf('%.2f', percentage(i)),'%%\n'];
end

%write to file
fprintf(fid, str);
fclose(fid);

disp(strcat('  * Statistics of segmented image "',imFileName, '"', ...
    ' > has been written to file: "',statsFileName, '"'));

end % writeStatsPath~=0

end

