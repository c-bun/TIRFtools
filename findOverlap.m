function [overlap, counts] = findOverlap(img1, img2, view_in_IJ, overlap_percent)

if size(overlap_percent,1) == 0
    overlap_percent = 0.5;
end

ampersand = img1 & img2;

filtered_sm = ampersand;

labeled_ampersand = bwlabel(filtered_sm);
particle_count = max(max(labeled_ampersand));
labeled_img1 = bwlabel(img1);
labeled_img2 = bwlabel(img2);

count_img1 = max(labeled_img1,[],'all');
count_img2 = max(labeled_img2,[],'all');

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
    img = NaN([size(ampersand),4]);
    img(:,:,3) = ampersand;
    img(:,:,4) = ampersand_filtered;
    img(:,:,1:2) = cat(3,img1,img2);
    openInIJ(cast(img,'single'),1);
end

count_ampersand_filtered = max(bwlabel(ampersand_filtered),[],'all');

overlap = ampersand_filtered;
counts = [count_img1 count_img2 count_ampersand_filtered];
end