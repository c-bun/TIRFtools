function p = LoGMask(processed, LoG_sigmas, LoG_thresholds, structuring_element, signal_count_limit, size_range, framerange, display_in_IJ)
% LoGMask applies a Laplacian of Gaussian filter to the inputted videos and
%   thresholds the result. Further filtering narrows particles by the
%   number of frames they appear in and size.
%
%   PARAMETERS:
%
%   processed: cell array of videos produced from processND2 function.
%
%   LoG_sigmas: sigma to use for LoG filter. Expects an array for each
%   element, [x, y, z]
%
%   LoG_thresholds: value for thresholding LoGed result. Probably will have
%   to tweak this a few times to find the correct value. This is usually
%   around -100 to -300. Provide one per channel in the video as an array.
%
%   structuring element: structuring element for gaussian filter. Use '[]'
%   for matlab's default "disk".
%
%   signal_count_limit: threshold for number of times that a pixel must
%   appear in the masked video (across time) to remain in the final
%   projection. This gets rid of pixels that blink once or twice but do not
%   give sustained (real) signal.
%
%   size_range: area range of pixels to be counted as a "real" spot. Set as
%   an array of two values. Default is [5 30] or areas ranging from 5 to 30
%   pixels.

%store the first two columns in the answer
p(:,1:2) = processed(:,1:2);

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

% if running on a subset of frames, trim videos first
if size(framerange,1) ~= 0
    for v=1:size(processed,1)
        processed{v,2} = processed{v,2}(:,:,:,:,framerange);
    end
end

for f=1:size(processed,1)
    
    % LoG filter
    [x, y, z, c, t] = size(processed{f,2});
    rs = reshape(processed{f,2}, x, y, c, z, t);
    log = HIP.LoG(rs,LoG_sigmas,[]);
    log = reshape(log, x, y, z, c, t);
    
    % mask each channel individually
    mask = NaN(size(log),'single');
    for c = 1:size(log,4)
        mask(:,:,:,c,:) = log(:,:,:,c,:) < LoG_thresholds(c);
    end
    if display_in_IJ
        openInIJ(log,1:50);
    end
    
    clear('log', 'rs');
    
    % morphological opening on mask
    opened = HIP.Opener(mask, structuring_element,1,[]);
    clear('mask');
    
    % mip that filters for pixels with x or more frames
    s = sum(opened,5);
    tokeep = s > signal_count_limit;
    
    % filter by size
    img_sf = NaN(size(tokeep), 'single');
    for c = 1:size(tokeep, 4)
        sf = bwpropfilt(squeeze(tokeep(:,:,1,c)),'area',size_range);
        img_sf(:,:,:,c) = sf;
    end
    
    processed{f,3} = img_sf;
    clear('opened');
    
    if display_in_IJ
        openInIJ(cast(processed{f,3}, 'single'),1:1);
    end
end
p(:,3) = processed(:,3);
end