function p = batchFindOverlap(processed, chA, chB, view_in_IJ, overlap_percent)
for i = 1:size(processed,1)
    img1 = processed{i,3}(:,:,:,chA);
    img2 = processed{i,3}(:,:,:,chB);
   [processed{i,4}, counts] = findOverlap(img1,img2,view_in_IJ, overlap_percent);
   processed{i,5} = counts;
end
p = processed;
end