function p = batchFindOverlap(processed, chA, chB, view_in_IJ, overlap_ratio)
% batchFindOverlap takes processed videos with accompanying masks and
% determined overlap in signal between the two specified channels. Also
% outputs counts of spots in each inputted channel (A and B respectively),
% as well as the number of spots that overlap. This can be used as a crude
% way to estimate occupancy when comparing to a negative control.
%
%   PARAMETERS:
%
%   processed: cell array of processed videos
%
%   chA: first channel to compare. Provide index as an integer.
%
%   chB: second channel to compare.
%
%   view_in_IJ: specify true or false if want to open the result in imageJ.
%
%   overlap_percent: percent overlap to require for spots to count as
%   overlapping.
%
for i = 1:size(processed,1)
    img1 = processed{i,3}(:,:,:,chA);
    img2 = processed{i,3}(:,:,:,chB);
   [processed{i,4}, counts] = findOverlap(img1,img2,view_in_IJ, overlap_ratio);
   processed{i,5} = counts;
end
p = processed;
end