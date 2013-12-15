function [ ] = WRITE_images( ...
segIm, indxIm, writeSegmentedPath, writeIndexedPath, imFileName )
%WRITE_IMAGES if paths are specified and not zero write segmented and indexed image
%   ...

if writeSegmentedPath~=0
%% write segmented image
disp('> Write segmented images to disk');
segmentPrefix = 'segm_';
    imwrite(segIm, [writeSegmentedPath, segmentPrefix, imFileName]);
    disp(['>>> Segmented image written to "', ...
        writeSegmentedPath, segmentPrefix, imFileName, '"']);
end

if writeIndexedPath~=0
%% write indexed image
% adjust indexes into full gray-scale 
indxPrefix = 'indx_';
indxIm = imadjust( indxIm, stretchlim(indxIm) );
    imwrite(indxIm, [writeIndexedPath, indxPrefix, imFileName]);
    disp(['>>> Indexed image written to "', ...
        writeIndexedPath, indxPrefix, imFileName, '"']);
end

end

