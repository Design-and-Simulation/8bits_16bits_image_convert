%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8bits to 16bits converting£º by truncate and rescale
% 
% parameters:
%   imdir: dir for original images (8bits)
%   img_savedir: dir for converted images (16bits)
%	src_datatype: src image data type
%	dst_datatype: dst image data type
% 
% modified: Zhihong Zhang 20190912
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% initialize the environment
clc
clear

%% parameters
img_dir = '..\test_data\8bit_data\'; % src dir 
img_savedir = '..\test_data\16bit_data\'; % dist dir
src_datatype = '*.png';
dst_datatype = '.tif'; % for 16bit RGB image, 'tif' is needed

%% converting
img_list = dir([img_dir, src_datatype ]); 
img_names = {img_list.name};
img_num = length(img_names);
X_LOW = 0; X_HIGH=255; Y_LOW=0; Y_HIGH = 65535;

for k = 1:img_num
    strImgFilename = img_names{k};
    origin = imread([img_dir, strImgFilename]); % original image
    
    cvt = piecewise_linear_tfrom(double(origin), X_LOW, X_HIGH, Y_LOW, Y_HIGH); % converted result
    
    cvt_8bit = uint16(cvt);
	imwrite(cvt_8bit, [img_savedir, strImgFilename(1:end-4), dst_datatype])
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

