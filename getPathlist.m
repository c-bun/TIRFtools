function pathlist = getPathlist
[names, path] = uigetfile('*.nd2', 'Select some nd2 files.', 'MultiSelect', 'on');
pathlist = {};
for n=1:length(names)
    pathlist{n} = strcat(path,names{n});
end
end