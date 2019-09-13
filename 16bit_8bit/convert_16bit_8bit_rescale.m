%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16 bits to 8bits converting£º by truncate and rescale
% parameters:
%   imdir: dir for original images(16bits)
%   img_savedir: dir for converted images(8bits)
% modified: zzh_20190912
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% initialize the environment
clc
clear

%% parameters
img_dir = 'C:\Users\BBNC\Desktop\trash\test_pic\HQ_16bit/';
img_savedir = 'C:\Users\BBNC\Desktop\trash\test_pic\HQ_8bit/';


%% converting
img_list = dir([img_dir, '*.png']); 
img_names = {img_list.name};
img_num = length(img_names);
X_LOW = 0; X_HIGH=21800; Y_LOW=0; Y_HIGH = 255;

for k = 1:img_num
    strImgFilename = img_names{k};
    origin = imread([img_dir, strImgFilename]); % original image
    
    cvt = piecewise_linear_tfrom(double(origin), X_LOW, X_HIGH, Y_LOW, Y_HIGH); % converted result
    
    cvt_8bit = uint8(cvt);
    imwrite(cvt_8bit, [img_savedir, strImgFilename(1:end-4), '.png'],'png')
%     figure(2)
%     imshow(raw_img)
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

