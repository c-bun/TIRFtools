function batchFindOverlap(processed, chA, chB, view_in_IJ, size_range, overlap_percent)
for i = 1:size(processed,1)
    img1 = processed{i,3}(:,:,:,chA);
    img2 = processed{i,3}(:,:,:,chB);
   processed{i,4} = findOverlap(img1,img2,view_in_IJ, size_range, overlap_percent);
end
end