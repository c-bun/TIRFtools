function openInIJ(arr,framerange)
% openInIJ opens a matlab array in imageJ as a hyperstack.
%
%   PARAMETERS:
%
%   arr: array to open. Dimensions should be [x y z c t].
%
%   framerange: specify a range of frames (in time) to display. E.g. 1:50.
%   this is mostly to save RAM as opening an entire video will likely crash
%   things.
%
% This function requires adding ImageJ-MATLAB to your FIJI installation.
% Under "add update sites" tick the box next to ImageJ-MATLAB. You may also
% have to add Fiji.app to your matlab path.
%
ImageJ;
arr = cast(arr,'single');
arr = reshape(arr, size(arr,1), size(arr,2), size(arr,4), size(arr,3), []);
imp = copytoImg(arr(:,:,:,:,framerange));
net.imglib2.img.display.imagej.ImageJFunctions.show(imp);
end