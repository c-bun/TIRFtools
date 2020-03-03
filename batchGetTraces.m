function combined_traces = batchGetTraces(processed, smoothing_range, use_max)
combined_traces = NaN(1000,size(processed{1,2},4),size(processed{1,2},5));
c = 1;
for p = 1:size(processed,1)
    if use_max
        traces = getTracesMax(processed{p,2},processed{p,4});
    else
        traces = getTraces(processed{p,2},processed{p,4});
    end
    
    n = size(traces,1);
    combined_traces(c:c+n-1,:,:) = traces;
    c = c+n;
end
combined_traces = combined_traces(1:c-1,:,:);
combined_traces = smoothdata(combined_traces,2,'movmedian',smoothing_range);
end