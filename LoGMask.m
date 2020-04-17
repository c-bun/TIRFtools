function p = LoGMask(processed, LoG_thresholds, LoG_sigmas,  structuring_element, signal_count_limit, size_range)
% Function for testing various LoG parameters without having to import ND2
% files each time.

if size(LoG_sigmas,1) == 0
    LoG_sigmas = [2 2 0];
end
if size(structuring_element,1) == 0
    kernel = strel("disk",1,4);
    structuring_element = kernel.Neighborhood;
end
if size(signal_count_limit,1) == 0
    signal_count_limit = 5;
end
if size(size_range,1) == 0
    size_range = [5 30];
end

for f=1:size(processed,1)

% This doesn't really need to run every time, but I'm doing it because I'm
% not storing the log in the previous processND2 function
% Log
% log = HIP.LoG(processed{f,2}, LoG_sigmas,[]);
[x, y, z, c, t] = size(processed{f,2});
rs = reshape(processed{f,2}, x, y, c, z, t);
log = HIP.LoG(rs,LoG_sigmas,[]);
log = reshape(log, x, y, z, c, t);

% mask each channel individually
mask = NaN(size(log),'single');
for c = 1:size(log,4)
    mask(:,:,:,c,:) = log(:,:,:,c,:) < LoG_thresholds(c);
end
openInIJ(log,1:50);
%openInIJ(mask,1:50); %changed this to open the final video
clear('log', 'rs');

% morphological opening on mask
kernel = strel("disk",1,4);
opened = HIP.Opener(mask, structuring_element,1,[]);
clear('mask');

% mip that filters for pixels with x or more frames
s = sum(opened,5);
tokeep = s > signal_count_limit;

% I'm not sure why I had this line...
%processed{f,3} = cast(max(opened .* tokeep,[],5), 'single');
% Just use toKeep as the processed image?

%do size filtration here (moved from findOverlap function)
img_sf = NaN(size(tokeep), 'single');
for c = 1:size(tokeep, 4)
    sf = bwpropfilt(squeeze(tokeep(:,:,1,c)),'area',size_range);
    img_sf(:,:,:,c) = sf;
end
%img1_sf = bwpropfilt(squeeze(tokeep(:,:,1,1)),'area',size_range);
%img2_sf = bwpropfilt(squeeze(tokeep(:,:,1,2)),'area',size_range);

%processed{f,3} = cat(4,img1_sf,img2_sf);
processed{f,3} = img_sf;
clear('opened');


openInIJ(cast(processed{f,3}, 'single'),1:1);
end
p = processed;
end