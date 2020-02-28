function LoGMask(processed, LoG_thresholds, LoG_sigmas,  structuring_element, signal_count_limit)
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

for f=1:size(processed,1)

% Log and find mask
log = HIP.LoG(processed{f,2}, LoG_sigmas,[]);

% mask each channel individually
mask = NaN(size(log));
for c = 1:size(log,4)
    mask(:,:,:,c,:) = log(:,:,:,c,:) < LoG_thresholds(c);
end
openInIJ(log,1:50);
openInIJ(mask,1:50);
clear('log');

% morphological opening on mask
kernel = strel("disk",1,4);
opened = HIP.Opener(mask, structuring_element,1,[]);
clear('mask');

% mip that filters for pixels with 5 or more frames
s = cast(sum(opened,5),'single');
tokeep = s > signal_count_limit;
processed{f,3} = cast(max(opened .* tokeep,[],5), 'single');
clear('opened');
end
end