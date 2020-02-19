function traces = getTraces(vid_to_use, mask_to_use)
% get traces for each channel from a specified mask.
% Get trace information for each particle found
% this is not written scalably. will probably break with larger files.
% Also only implemented for 3 channels currently.

labeled = bwlabel(mask_to_use);
num_particles = max(max(labeled));
labeled_gpu = gpuArray(labeled);
gpu_vid = gpuArray(vid_to_use);
traces = zeros(num_particles,size(vid_to_use,4),size(vid_to_use,5),'single');
for i = 1:num_particles
    [row,col] = find(labeled_gpu==i);
    to_avg = NaN(length(row),size(vid_to_use,4),size(vid_to_use,5),'single');
    for c = 1:length(row)
        pixel_trace = gpu_vid(row(c),col(c),:,:,:);
        to_avg(c,:,:) = gather(pixel_trace);
    end

    intensity = mean(to_avg,1);
    traces(i,:,:) = intensity;
end

% median smoothing here?

clear vid_to_use
end