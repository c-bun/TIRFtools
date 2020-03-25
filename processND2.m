function processed = processND2(pathlist, LoG_thresholds, show_LoG, high_pass_sigmas, LoG_sigmas, structuring_element, signal_count_limit)
% set some default values
if size(high_pass_sigmas,1) == 0
    high_pass_sigmas = [10 10 0];
end
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



processed = cell(pathlist(:));
for f=1:length(pathlist)
    % import raw data
    raw = importND2(pathlist{f});
    
    % background subtract
    processed{f,2} = HIP.HighPassFilter(raw, high_pass_sigmas,[]); % This
    %is slower by a few seconds, but the below function might run out of
    %memory with larger videos. Also the output of below is untested.
    %processed{f,2} = highPassGaussian(raw, 10);
    
    clear('raw');
    
    % Log and find mask
    log = HIP.LoG(processed{f,2}, LoG_sigmas,[]);
    
    % mask each channel individually
    mask = NaN(size(log));
    for c = 1:size(log,4)
        mask(:,:,:,c,:) = log(:,:,:,c,:) < LoG_thresholds(c);
    end
    if show_LoG
        openInIJ(log,1:50);
        openInIJ(mask,1:50);
    end
    clear('log');
    
    % morphological opening on mask
    kernel = strel("disk",1,4);
    opened = HIP.Opener(mask, structuring_element,1,[]);
    clear('mask');
    
    % mip that filters for pixels with 5 or more frames
    s = cast(sum(opened,5),'single');
    tokeep = s > signal_count_limit;
    %processed{f,3} = cast(max(opened .* tokeep,[],5), 'single');
    processed{f,3} = tokeep;
    clear('opened');
    
    disp(['Done with ', pathlist{f}]);
end
end