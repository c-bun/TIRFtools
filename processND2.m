function processed = processND2(pathlist, LoG_threshold, show_LoG, high_pass_sigmas, LoG_sigmas, structuring_element, signal_count_limit)
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
    %import raw data
    raw = importND2(pathlist{f});
    
    % background subtract
    processed{f,2} = HIP.HighPassFilter(raw, high_pass_sigmas,[]);
    clear('raw');
    
    % Log and find mask
    log = HIP.LoG(processed{f,2}, LoG_sigmas,[]);
    if show_LoG
        openInIJ(log,1:50,size(log,4));
    end
    mask = log < LoG_threshold;
    clear('log');
    
    % morphological opening on mask
    kernel = strel("disk",1,4);
    opened = HIP.Opener(mask, structuring_element,1,[]);
    clear('mask');
    
    % mip that filters for pixels with 5 or more frames
    s = cast(sum(opened,5),'single');
    tokeep = s > signal_count_limit;
    processed{f,3} = max(opened .* tokeep,[],5);
    clear('opened');
    
    disp(['Done with ', pathlist{f}]);
end
end