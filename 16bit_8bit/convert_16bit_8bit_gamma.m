%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16 bits to 8bits converting£º by gamma transformation
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

%% params
img_dir = '..\test_data\16bit_noise_data\';
img_savedir = '..\test_data\8bit_noise_data\';
% img_dir = '..\test_data\16bit_data\';
% img_savedir = '..\test_data\test\';
src_datatype = '*.tif';
dst_datatype = '.png';
% dst_datatype = '.tif';

%% load mapping table
load('map_ch1.mat');
load('map_ch2.mat');
load('map_ch3.mat');
idx = (find(~isnan(map_ch1)));
map_ch1 = spline(idx, map_ch1(idx), 1:65536);
idx = (find(~isnan(map_ch2)));
map_ch2 = spline(idx, map_ch2(idx), 1:65536);
idx = (find(~isnan(map_ch3)));
map_ch3 = spline(idx, map_ch3(idx), 1:65536);


%% convert
img_list = dir([img_dir, src_datatype]); 
img_names = {img_list.name};
img_num = length(img_names);

for k = 1:img_num
    strImgFilename = img_names{k};
    ppm_test = imread([img_dir, strImgFilename]); % original image
    
    
    [h,w,c]=size(ppm_test);
    img_jpg=zeros(h,w,c);
    for i=1:h
        for j=1:w
            for ch = 1 : c
                temp=ppm_test(i,j,ch);
                switch ch
                    case {1}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch1(temp));
                        end
                    case {2}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch2(temp));
                        end
                    case {3}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch3(temp));
                        end
                end
            end
        end
    end
    img_jpg = uint8(img_jpg);
	
	% convert to gray
% 	if ~ismatrix(img_jpg)
% 		img_jpg = rgb2gray(img_jpg);
% 	end

	% save data
% 	save_name = [img_savedir, sprintf('%04d', k), dst_datatype];
	save_name = [img_savedir, strImgFilename(1:end-4), dst_datatype];
    imwrite(img_jpg, save_name)

    if mod(k,100)==0
        fprintf("%.f%% done!\n", 100*k/img_num)
    end 
end



