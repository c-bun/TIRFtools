function tracesHist(traces, nbins)
ttraces = NaN(size(traces));
for r=1:size(traces,1)
    ttraces(r,:) = 1:size(traces,2);
end
histogram2(ttraces,traces,nbins, 'DisplayStyle',"tile");
end