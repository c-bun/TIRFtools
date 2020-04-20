function processed = processND2(pathlist, high_pass_sigmas)
% processND2  Load ND2 files into memory and apply background correction to each frame.
%   R = processND2(pathlist, sigmas) will apply 2D gaussian blurring of width
%   sigma to each ND2 file in pathlist. The result is stored in R as a cell
%   array.
%
%   The video is read in as a 5D array: [x, y, z, c, t]
%
%   Requires HIP from Janielia AIC. This also uses bfopen from the
%   bioformat reader.


if size(high_pass_sigmas,1) == 0
    high_pass_sigmas = [10 10 0];
end

processed = cell(pathlist(:));
for f=1:length(pathlist)
    % import raw data
    raw = importND2(pathlist{f});
    
    % background subtract
    processed{f,2} = HIP.HighPassFilter(raw, high_pass_sigmas,[]); 
    
    clear('raw');
    
    disp(['Done with ', pathlist{f}]);
end
end