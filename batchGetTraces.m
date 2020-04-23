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

%figure out how big the matrix will need to be for the traces
maxw = 0;
height = 0;
for c = 1:size(processed,1)
    w = size(processed{c,2}, 5);
    spots = processed{c,5}(3);
    height = height+spots;
    if w > maxw
        maxw = w;
    end
end

traces = NaN(height,size(processed{1,2},4),maxw);
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

traces_out = smoothdata(traces,3,'movmean',smoothing);
end