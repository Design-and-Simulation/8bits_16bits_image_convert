%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16 bits to 8bits converting£º by truncate and rescale
% 
% parameters:
%   imdir: dir for original images(16bits)
%   img_savedir: dir for converted images(8bits)
%	src_datatype: src image data type
%	dst_datatype: dst image data type
% 
% modified: Zhihong Zhang 20190912
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% initialize the environment
clc
clear

%% parameters
img_dir = '..\test_data\16bit_noise_data\';
img_savedir = '..\test_data\8bit_noise_data\';
% img_dir = '..\test_data\16bit_data\';
% img_savedir = '..\test_data\test\';
src_datatype = '*.tif';
dst_datatype = '.tif';

%% converting
img_list = dir([img_dir, src_datatype]); 
img_names = {img_list.name};
img_num = length(img_names);
X_LOW = 0; X_HIGH=65535; Y_LOW=0; Y_HIGH = 255;

for k = 1:img_num
    strImgFilename = img_names{k};
    origin = imread([img_dir, strImgFilename]); % original image
    
    cvt = piecewise_linear_tfrom(double(origin), X_LOW, X_HIGH, Y_LOW, Y_HIGH); % converted result
    
    cvt_8bit = uint8(cvt);
	
	% save data
% 	save_name = [img_savedir, sprintf('%04d', k), dst_datatype];
	save_name = [img_savedir, strImgFilename(1:end-4), dst_datatype];
    imwrite(cvt_8bit, save_name)

    if mod(k,100)==0
        fprintf("%.f%% done!\n", 100*k/img_num)
    end 
end

function y = piecewise_linear_tfrom(x, x_low, x_high, y_low, y_high)
% truncate x to limit it into [x_low, x_high] and then rescale it to [y_low,
% y_high], the y-x function's shape is like "_/-"
% input: 
%       x: input self-variable
%       [x_low, x_high]: the lower inflection point
%       [y_low, y_higt]: the higher inflection point
% output:
%       y: converted result
% 

% truncation
x = min(x, x_high);
x = max(x, x_low);

% linear transformation
y = (x-x_low)./(x_high-x_low).*(y_high-y_low)+y_low;
end

