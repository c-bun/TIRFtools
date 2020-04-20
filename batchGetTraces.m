function traces_out = batchGetTraces(processed, smoothing)
% batchGetTraces finds the intensity traces across each spot as specified in the
% mask.
%
%   PARAMETERS:
%
%   processed: cell array of background subtracted video with associated
%   masks.
%
%   smoothing: smoothing window width to use on traces via a moving mean.
%

traces = NaN(1000,size(processed{1,2},4),1000);
first = true;
t=0;
t2=0;
for i = 1:size(processed,1)
    img_sf = processed{i,4};
    trace = getTracesSum(processed{i,2},img_sf);
    l = size(trace,3);
    if size(trace,1) > 0
        if first % for proper dumb indexing
            t2 = size(trace,1);
            traces(1:t2,:,1:l) = squeeze(trace(:,:,:));
            first = false;
        else
            t2 = t + size(trace,1)-1;
            traces(t:t2,:,1:l) = squeeze(trace(:,:,:));
        end
        t = t2+1;
    end
end

traces = traces(1:t2,:,:);
traces_out = smoothdata(traces,3,'movmean',smoothing);
end