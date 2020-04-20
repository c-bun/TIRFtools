% will not work with 3D data. Use HIP.HighPass for 3D
% Expects vid to be [x,y,z,c,t]
% This is a bit untested, and gives a little different looking images than
% HIP.
function vid_out = highPassGaussian(vid, sigma)
vid = gpuArray(cast(vid,'single'));
g = gpuArray(NaN(size(vid),'single'));

for c = 1:size(vid,4)
    for f = 1:size(vid,5)
        g(:,:,1,c,f) = imgaussfilt(vid(:,:,1,c,f),sigma);
    end
end

b = vid - g;

vid_out = gather(b);
end