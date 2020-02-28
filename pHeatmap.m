function h = pHeatmap(data)
data = squeeze(data);
h = heatmap(data,'Colormap',parula);
end