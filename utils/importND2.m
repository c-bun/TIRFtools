% Imports ND2 files with the bioformat reader.
% returns a 5-D array: [x, y, z, c, t]
function vid = importND2(path)
bf = bfopen(path);
meta_string = bf{1,1}{1,2};
meta_string = strsplit(meta_string);
channel_number = str2double(meta_string{4}(5));

aspect = size(bf{1,1}{1},1);

as_mat = cell2mat(bf{1,1}(:,1));

vid = reshape(as_mat.', aspect, aspect, 1, channel_number, []);
vid = permute(vid, [2, 1, 3, 4, 5]);
vid = cast(vid, 'single');
end