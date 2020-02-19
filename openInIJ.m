% array should be in [x, y, z, c, t]
% array can't have a z dimension.
function openInIJ(arr,framerange)
ImageJ;
arr = cast(arr,'single');
arr = reshape(arr, size(arr,1), size(arr,2), size(arr,4), size(arr,3), []);
imp = copytoImg(arr(:,:,:,:,framerange));
net.imglib2.img.display.imagej.ImageJFunctions.show(imp);
end