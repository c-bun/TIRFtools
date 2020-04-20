function pathlist = getFileList
% getFileList Opens a dialog to select files of type .nd2. Can select
% multiple files using shift or command.
[names, path] = uigetfile('*.nd2', 'Select some nd2 files.', 'MultiSelect', 'on');
if ischar(names)
    names = {names};
end
pathlist = {};
for n=1:length(names)
    pathlist{n} = strcat(path,names{n});
end
end