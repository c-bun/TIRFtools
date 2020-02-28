function overlap = findOverlap(img1, img2, view_in_IJ, size_range, overlap_percent)
if size(size_range,1) == 0
    size_range = [5 30];
end
if size(overlap_percent,1) == 0
    overlap_percent = 0.5;
end

% filter by size first
img1_sf = bwpropfilt(cast(img1,'logical'),'area',size_range);
img2_sf = bwpropfilt(cast(img2,'logical'),'area',size_range);

ampersand = img1_sf & img2_sf;

%filtered_sm = bwpropfilt(ampersand,'area',size_range);
filtered_sm = ampersand;

labeled_ampersand = bwlabel(filtered_sm);
particle_count = max(max(labeled_ampersand));
labeled_img1 = bwlabel(img1);
labeled_img2 = bwlabel(img2);

ampersand_filtered = filtered_sm;

for p=1:particle_count
    inds = find(labeled_ampersand==p);
    overlap_count = length(inds);
    
    img2_l = labeled_img2(inds(1));
    img2_count = length(find(labeled_img2==img2_l));
    
    img1_l = labeled_img1(inds(1));
    img1_count = length(find(labeled_img1==img1_l));
    
    if img2_count > img1_count
        percent = overlap_count/img1_count;
    else
        percent = overlap_count/img2_count;
    end
    
    if percent < overlap_percent
        ampersand_filtered(inds) = 0;
    end
    
end

if view_in_IJ
    img = NaN([size(ampersand),6]);
    img(:,:,5) = ampersand;
    img(:,:,6) = ampersand_filtered;
    img(:,:,1:4) = cat(3,img1,img1_sf,img2,img2_sf);
    openInIJ(cast(img,'single'),1);
end

overlap = ampersand_filtered;
end