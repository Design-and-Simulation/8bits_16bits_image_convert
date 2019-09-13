%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16bit转8bit代码—— gamma曲线映射
% 参数：
%   img_dir：待转换的16位图像路径
%   img_savedir：转换完成后的8位图像保存路径
% 修改：
%   zzh 20190729
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 初始化环境
clc
clear

%% 参数设置
% img_dir = '/home/f305c/Documents/dataset/denoise_dataset/DIV2K/DIV2K_EMCCD_16BIT/LQ2/1/'; 
% img_savedir = '/home/f305c/Documents/dataset/denoise_dataset/DIV2K/DIV2K_EMCCD_8BIT/LQ2/1/';

img_dir = 'C:\Users\BBNC\Desktop\trash\test_pic\16bit\';
img_savedir = 'C:\Users\BBNC\Desktop\trash\test_pic\8bit\';
RESCALE_FLAG  = 1; %


%% 加载映射表
load('map_ch1.mat');
load('map_ch2.mat');
load('map_ch3.mat');
idx = (find(~isnan(map_ch1)));
map_ch1 = spline(idx, map_ch1(idx), 1:65536);
idx = (find(~isnan(map_ch2)));
map_ch2 = spline(idx, map_ch2(idx), 1:65536);
idx = (find(~isnan(map_ch3)));
map_ch3 = spline(idx, map_ch3(idx), 1:65536);


%% 图像处理
img_list = dir([img_dir, '*.png']); %原图文件格式 .png or tif格式
img_names = {img_list.name};
img_num = length(img_names);

for k = 1:img_num
    strImgFilename = img_names{k};
    ppm_test = imread([img_dir, strImgFilename]); % original image
    
    ppm_test = ppm_test * scale_ratio;
    
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
    new_img_name = sprintf('%04d', str2double(strImgFilename(1:end-4)));
    imwrite(img_jpg, [img_savedir, new_img_name, '.png'],'png')  % 保存为png格式
%     figure(2)
%     imshow(raw_img)
    if mod(k,100)==0
        fprintf("%.f%% done!\n", 100*k/img_num)
    end 
end



