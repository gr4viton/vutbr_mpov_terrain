function [ segIm, indxIm ]  = map2segments_defArgs( imPath )
%MAP2SEGMENTS_DEFARGS calls map2segments function with default arguments
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@param[in]
%  [imPath] - path to original image  
%@return
% [segIm] - segmented image (RGB)
% [indxIm] - indexed image (0-numOfSegments)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ segIm, indxIm ] = map2segments(imPath,1,1,1,1,-1,[-1,-1]);

end

