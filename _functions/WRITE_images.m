function [ ] = WRITE_images( ...
segIm, indxIm, writeSegmentedPath, writeIndexedPath, imPath )
%WRITE_IMAGES if paths are specified and not zero write segmented and indexed image
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
segmImDirName = '\_segm\';
[imPathStr,imFileName,imExt] = fileparts(imPath);


if writeSegmentedPath~=0
    %% write segmented image
    if(writeSegmentedPath==1)
        writeSegmentedPath = [imPathStr,segmImDirName];
    end    
[s, mess, messid] = mkdir(writeSegmentedPath);

    disp('> Write segmented images to disk');
    segmentPrefix = 'segm_';
        imwrite(segIm, [writeSegmentedPath, segmentPrefix, imFileName, imExt]);
        disp(['  * Segmented image written to "', ...
            writeSegmentedPath, segmentPrefix, imFileName, '"']);
end

if writeIndexedPath~=0
    %% write indexed image
    if(writeIndexedPath==1)
        writeIndexedPath = [imPathStr,segmImDirName];
    end
[s, mess, messid] = mkdir(writeIndexedPath);
    
    % adjust indexes into full gray-scale 
    indxPrefix = 'indx_';
    indxIm = imadjust( indxIm, stretchlim(indxIm) );
        imwrite(indxIm, [writeIndexedPath, indxPrefix, imFileName, imExt]);
        disp(['  * Indexed image written to "', ...
            writeIndexedPath, indxPrefix, imFileName, '"']);
end

end

